import 'package:ai_assistant/common/common.dart';
import 'package:ai_assistant/features/chat/domain/domain.dart';

class SendChatMessage {
  final ChatRepository repository;

  SendChatMessage(this.repository);

  Future<void> call(ChatMessage message, String chatId, String userId) async {
    try {
      await repository.sendChatMessage(message, chatId, userId);
    } catch (e) {
      throw ServerFailure(
        message: e.toString(),
      );
    }
  }
}
