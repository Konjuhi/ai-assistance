import 'package:ai_assistant/common/common.dart';
import 'package:ai_assistant/features/chat/data/models/chat_model.dart';
import 'package:ai_assistant/features/chat/domain/domain.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  Stream<Either<Failure, List<ChatMessage>>> getChatMessages(
    String chatId,
    String userId,
  );

  Future<Either<Failure, void>> sendChatMessage(
    ChatMessage message,
    String chatId,
    String userId,
  );

  Stream<List<ChatModel>> getAllChats(String userId);

  Future<void> createChatIfNotExists(
      String chatId, String userId, String chatName);

  Future<void> deleteChat(String chatId, String userId);
}
