import 'package:ai_assistant/common/errors/failures.dart';
import 'package:ai_assistant/features/chat/data/datasources/remote/ai_service.dart';
import 'package:ai_assistant/features/chat/data/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class ChatDataSource {
  Stream<List<ChatMessageModel>> getChatMessages(String chatId, String userId);

  Future<void> createChatIfNotExists(
      String chatId, String userId, String chatName);

  Future<void> sendChatMessage(
      ChatMessageModel message, String chatId, String userId);

  Stream<List<ChatModel>> getAllChats(String userId);

  Future<void> deleteChat(String chatId, String userId);

  Future<Either<Failure, String>> getAIResponse(String question);
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
      final chatModel = ChatModel(
        chatId: chatId,
        chatName: chatName,
        timestamp: DateTime.now(),
      );

      await chatDoc.set({
        'createdAt': FieldValue.serverTimestamp(),
        'userId': userId,
        ...chatModel.toMap(),
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
  Stream<List<ChatModel>> getAllChats(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatModel.fromMap({
          'chatId': doc.id,
          'chatName': data['chatName'],
          'createdAt': data['createdAt'],
        });
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

  @override
  Future<Either<Failure, String>> getAIResponse(String question) {
    return AIService.getAnswer(question);
  }
}
