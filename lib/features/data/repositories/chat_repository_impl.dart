import '../../core/errors/exceptions.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/firebase_chat_datasource.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource dataSource;

  ChatRepositoryImpl(this.dataSource);

  @override
  Future<void> sendChatMessage(ChatMessage message, String userId) async {
    try {
      final messageModel = ChatMessageModel(
        sender: message.sender,
        message: message.message,
        timestamp: message.timestamp,
      );

      await dataSource.sendChatMessage(messageModel, userId);
    } on ServerExceptionn catch (e) {
      rethrow;
    } catch (e) {
      throw ServerExceptionn(message: e.toString());
    }
  }

  @override
  Stream<List<ChatMessage>> getChatMessages(String userId) async* {
    try {
      final stream = dataSource.getChatMessages(userId);
      yield* stream.map((messageModels) => messageModels
          .map((model) => ChatMessage(
                sender: model.sender,
                message: model.message,
                timestamp: model.timestamp,
              ))
          .toList());
    } on ServerExceptionn catch (e) {
      rethrow;
    } catch (e) {
      throw ServerExceptionn(message: e.toString());
    }
  }
}
