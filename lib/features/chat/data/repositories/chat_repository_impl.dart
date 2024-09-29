import 'package:ai_assistant/common/errors/failures.dart';
import 'package:ai_assistant/features/chat/data/datasources/datasource.dart';
import 'package:ai_assistant/features/chat/data/models/models.dart';
import 'package:ai_assistant/features/chat/domain/domain.dart';
import 'package:dartz/dartz.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource dataSource;

  ChatRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> sendChatMessage(
      ChatMessage message, String chatId, String userId) async {
    try {
      final messageModel = ChatMessageModel(
        sender: message.sender,
        message: message.message,
        timestamp: message.timestamp,
      );

      await dataSource.sendChatMessage(messageModel, chatId, userId);
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ServerFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  Stream<Either<Failure, List<ChatMessage>>> getChatMessages(
      String chatId, String userId) async* {
    try {
      final stream = dataSource.getChatMessages(chatId, userId);
      yield* stream.map(
        (messageModels) => Right(messageModels.map((model) {
          return ChatMessage(
            sender: model.sender,
            message: model.message,
            timestamp: model.timestamp,
          );
        }).toList()),
      );
    } catch (e, stackTrace) {
      yield Left(ServerFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  Stream<List<Chat>> getAllChats(String userId) {
    return dataSource.getAllChats(userId);
  }

  @override
  Future<void> createChatIfNotExists(
      String chatId, String userId, String chatName) async {
    await dataSource.createChatIfNotExists(chatId, userId, chatName);
  }

  @override
  Future<void> deleteChat(String chatId, String userId) async {
    await dataSource.deleteChat(chatId, userId);
  }

  @override
  Future<Either<Failure, String>> getAIResponse(String question) {
    return dataSource.getAIResponse(question);
  }
}
