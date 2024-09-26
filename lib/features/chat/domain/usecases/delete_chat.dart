import 'package:ai_assistant/features/chat/domain/domain.dart';

class DeleteChat {
  final ChatRepository repository;

  DeleteChat(this.repository);

  Future<void> call(String chatId, String userId) {
    return repository.deleteChat(chatId, userId);
  }
}
