import 'package:dartz/dartz.dart';

import '../../common/errors/failures.dart';
import '../entities/chat_message.dart';

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

  Stream<List<Map<String, dynamic>>> getAllChats(String userId);

  Future<void> createChatIfNotExists(
      String chatId, String userId, String chatName);

  Future<void> deleteChat(String chatId, String userId);
}
