import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message_model.dart';

abstract class ChatDataSource {
  Stream<List<ChatMessageModel>> getChatMessages(String chatId, String userId);

  Future<void> createChatIfNotExists(
      String chatId, String userId, String chatName);

  Future<void> sendChatMessage(
      ChatMessageModel message, String chatId, String userId);

  Stream<List<Map<String, dynamic>>> getAllChats(String userId);

  Future<void> deleteChat(String chatId, String userId);
}

class FirebaseChatDataSource implements ChatDataSource {
  final FirebaseFirestore firestore;

  FirebaseChatDataSource(this.firestore);

  @override
  Future<void> createChatIfNotExists(
      String chatId, String userId, String chatName) async {
    final chatDoc = firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId);
    final chatExists = await chatDoc.get();

    if (!chatExists.exists) {
      await chatDoc.set({
        'createdAt': FieldValue.serverTimestamp(),
        'chatId': chatId,
        'userId': userId,
        'chatName': chatName,
      });
    }
  }

  @override
  Stream<List<ChatMessageModel>> getChatMessages(String chatId, String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatMessageModel.fromMap(doc.data());
      }).toList();
    });
  }

  @override
  Future<void> sendChatMessage(
      ChatMessageModel message, String chatId, String userId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'userId': userId,
      ...message.toMap(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> getAllChats(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'chatId': doc.id,
          'chatName': doc['chatName'],
        };
      }).toList();
    });
  }

  @override
  Future<void> deleteChat(String chatId, String userId) async {
    final chatDoc = firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId);

    final messages = await chatDoc.collection('messages').get();
    for (var doc in messages.docs) {
      await doc.reference.delete();
    }

    await chatDoc.delete();
  }
}
