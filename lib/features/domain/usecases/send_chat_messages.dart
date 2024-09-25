import '../../common/errors/failures.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendChatMessage {
  final ChatRepository repository;

  SendChatMessage(this.repository);

  Future<void> call(ChatMessage message, String chatId, String userId) async {
    try {
      await repository.sendChatMessage(message, chatId, userId);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
