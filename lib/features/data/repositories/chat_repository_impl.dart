import 'package:dartz/dartz.dart';

import '../../core/errors/app_exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/firebase_chat_datasource.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource dataSource;

  ChatRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> sendChatMessage(
      ChatMessage message, String userId) async {
    try {
      final messageModel = ChatMessageModel(
        sender: message.sender,
        message: message.message,
        timestamp: message.timestamp,
      );

      await dataSource.sendChatMessage(messageModel, userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, stackTrace: e.stackTrace));
    } catch (e, stackTrace) {
      return Left(ServerFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  Stream<Either<Failure, List<ChatMessage>>> getChatMessages(
      String userId) async* {
    try {
      final stream = dataSource.getChatMessages(userId);
      yield* stream.map(
        (messageModels) => Right(messageModels.map((model) {
          return ChatMessage(
            sender: model.sender,
            message: model.message,
            timestamp: model.timestamp,
          );
        }).toList()),
      );
    } on ServerException catch (e) {
      yield Left(ServerFailure(message: e.message, stackTrace: e.stackTrace));
    } catch (e, stackTrace) {
      yield Left(ServerFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }
}
