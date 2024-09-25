import '../repositories/chat_repository.dart';

class DeleteChat {
  final ChatRepository repository;

  DeleteChat(this.repository);

  Future<void> call(String chatId, String userId) {
    return repository.deleteChat(chatId, userId);
  }
}
