import 'package:ai_assistant/features/core/errors/app_exceptions.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetChatMessages {
  final ChatRepository repository;

  GetChatMessages(this.repository);

  Stream<Either<Failure, List<ChatMessage>>> call(String userId) async* {
    try {
      yield* repository.getChatMessages(userId);
    } on AppException catch (e) {
      yield Left(ServerFailure(message: e.message));
    } catch (e) {
      yield Left(ServerFailure(message: e.toString()));
    }
  }
}
