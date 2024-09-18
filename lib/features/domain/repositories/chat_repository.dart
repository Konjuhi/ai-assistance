import '../entities/chat_message.dart';

abstract class ChatRepository {
  Stream<List<ChatMessage>> getChatMessages(String userId);
  Future<void> sendChatMessage(ChatMessage message, String userId);
}
