import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/ai_service.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/get_chat_messages.dart';
import '../../domain/usecases/send_chat_messages.dart';

class ChatNotifier extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final GetChatMessages getChatMessagesUseCase;
  final SendChatMessage sendChatMessageUseCase;
  final String userId;
  bool isSendingMessage = false;

  ChatNotifier({
    required this.getChatMessagesUseCase,
    required this.sendChatMessageUseCase,
    required this.userId,
  }) : super(const AsyncLoading()) {
    _loadMessages();
  }

  void loadDataForUser(String userId) {
    state = const AsyncLoading();
    getChatMessagesUseCase(userId).listen((messages) {
      state = AsyncData(messages);
    }, onError: (e) {
      state = AsyncError(e, StackTrace.current);
    });
  }

  void clearState() {
    state = const AsyncData([]);
  }

  void _loadMessages() {
    getChatMessagesUseCase(userId).listen((messages) {
      state = AsyncData(messages);
    }, onError: (e, stack) {
      state = AsyncError(e, stack);
    });
  }

  Future<void> sendMessageAndFetchResponse(String question) async {
    isSendingMessage = true;
    state = const AsyncLoading();

    try {
      await sendChatMessageUseCase(
        ChatMessage(
          sender: 'You',
          message: question,
          timestamp: DateTime.now(),
        ),
        userId,
      );

      final response = await AIService.getAnswer(question);

      await sendChatMessageUseCase(
        ChatMessage(
          sender: 'Bot',
          message: response,
          timestamp: DateTime.now(),
        ),
        userId,
      );
      _loadMessages();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    } finally {
      isSendingMessage = false;
    }
  }
}
