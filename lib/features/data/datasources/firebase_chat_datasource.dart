import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message_model.dart';

abstract class ChatDataSource {
  Stream<List<ChatMessageModel>> getChatMessages(String userId);

  Future<void> sendChatMessage(ChatMessageModel message, String userId);
}

class FirebaseChatDataSource implements ChatDataSource {
  final FirebaseFirestore firestore;

  FirebaseChatDataSource(this.firestore);

  @override
  Stream<List<ChatMessageModel>> getChatMessages(String userId) {
    return firestore
        .collection('chat_history')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final messages = snapshot.docs.map((doc) {
        return ChatMessageModel.fromMap(doc.data());
      }).toList();

      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    });
  }

  @override
  Future<void> sendChatMessage(ChatMessageModel message, String userId) async {
    await firestore.collection('chat_history').add({
      'userId': userId,
      ...message.toMap(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
