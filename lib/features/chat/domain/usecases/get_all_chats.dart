import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetAllChats {
  final ChatRepository repository;

  GetAllChats(this.repository);

  Stream<List<Chat>> call(String userId) {
    return repository.getAllChats(userId);
  }
}
