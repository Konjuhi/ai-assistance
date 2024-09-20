import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/ai_service.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/get_chat_messages.dart';
import '../../domain/usecases/send_chat_messages.dart';

class ChatNotifier extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final GetChatMessages getChatMessagesUseCase;
  final SendChatMessage sendChatMessageUseCase;
  final String userId;
  bool isSendingMessage = false; // Add this

  ChatNotifier({
    required this.getChatMessagesUseCase,
    required this.sendChatMessageUseCase,
    required this.userId,
  }) : super(const AsyncLoading()) {
    _loadMessages();
  }

  // Add clearState to reset the state
  void clearState() {
    state = const AsyncData([]);
  }

  void _loadMessages() {
    if (userId.isEmpty) {
      state = const AsyncData([]);
      return;
    }

    getChatMessagesUseCase(userId).listen((result) {
      result.fold(
        (failure) {
          state = AsyncError(failure.message, StackTrace.current);
        },
        (messages) {
          state = AsyncData(messages);
        },
      );
    }, onError: (e, stack) {
      state = AsyncError(e, stack);
    });
  }

  Future<void> sendMessageAndFetchResponse(String question) async {
    if (userId.isEmpty) return;

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
    } catch (e, stack) {
      state = AsyncError(e, stack);
    } finally {
      isSendingMessage = false;
    }
  }
}
