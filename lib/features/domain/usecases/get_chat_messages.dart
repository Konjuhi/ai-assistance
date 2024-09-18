import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetChatMessages {
  final ChatRepository repository;

  GetChatMessages(this.repository);

  Stream<List<ChatMessage>> call(String userId) async* {
    try {
      yield* repository.getChatMessages(userId);
    } on ServerExceptionn catch (e) {
      // Convert the exception to a failure
      throw ServerFailure(message: e.message);
    }
  }
}
