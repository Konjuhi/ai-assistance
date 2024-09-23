import '../../common/errors/app_exceptions.dart';
import '../../common/errors/failures.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendChatMessage {
  final ChatRepository repository;

  SendChatMessage(this.repository);

  Future<void> call(ChatMessage message, String userId) async {
    try {
      await repository.sendChatMessage(message, userId);
    } on AppException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }
}
