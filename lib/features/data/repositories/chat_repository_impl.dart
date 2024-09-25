import 'package:dartz/dartz.dart';

import '../../common/errors/failures.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/firebase_chat_datasource.dart';
import '../models/chat_message_model.dart';

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
  Stream<List<String>> getAllChats(String userId) {
    return dataSource.getAllChats(userId);
  }
}
