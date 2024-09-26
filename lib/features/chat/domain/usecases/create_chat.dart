import 'package:ai_assistant/features/chat/domain/domain.dart';

class CreateChat {
  final ChatRepository repository;

  CreateChat(this.repository);

  Future<void> call(String chatId, String userId, String chatName) {
    return repository.createChatIfNotExists(chatId, userId, chatName);
  }
}
