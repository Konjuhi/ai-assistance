// domain/usecases/create_chat.dart
import '../repositories/chat_repository.dart';

class CreateChat {
  final ChatRepository repository;

  CreateChat(this.repository);

  Future<void> call(String chatId, String userId, String chatName) {
    return repository.createChatIfNotExists(chatId, userId, chatName);
  }
}
