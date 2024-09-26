import 'package:ai_assistant/common/common.dart';
import 'package:ai_assistant/features/chat/domain/domain.dart';
import 'package:dartz/dartz.dart';

class GetChatMessages {
  final ChatRepository repository;

  GetChatMessages(this.repository);

  Stream<Either<Failure, List<ChatMessage>>> call(
      String chatId, String userId) async* {
    try {
      yield* repository.getChatMessages(chatId, userId);
    } catch (e) {
      yield Left(ServerFailure(message: e.toString()));
    }
  }
}
