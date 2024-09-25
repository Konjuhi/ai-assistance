import 'package:dartz/dartz.dart';

import '../../common/errors/failures.dart';
import '../entities/chat_message.dart';

abstract class ChatRepository {
  Stream<Either<Failure, List<ChatMessage>>> getChatMessages(
    String chatId,
    String userId,
  ); // Use chatId and userId

  Future<Either<Failure, void>> sendChatMessage(
    ChatMessage message,
    String chatId,
    String userId,
  );

  Stream<List<String>> getAllChats(String userId);
}
