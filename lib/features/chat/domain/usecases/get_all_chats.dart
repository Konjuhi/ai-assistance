import '../../data/models/chat_model.dart';
import '../repositories/chat_repository.dart';

class GetAllChats {
  final ChatRepository repository;

  GetAllChats(this.repository);

  Stream<List<ChatModel>> call(String userId) {
    return repository.getAllChats(userId);
  }
}
