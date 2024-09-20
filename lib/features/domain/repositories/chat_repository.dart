import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/chat_message.dart';

abstract class ChatRepository {
  Stream<Either<Failure, List<ChatMessage>>> getChatMessages(
    String userId,
  ); // Use Either<Failure, List<ChatMessage>>
  Future<Either<Failure, void>> sendChatMessage(
    ChatMessage message,
    String userId,
  );
}
