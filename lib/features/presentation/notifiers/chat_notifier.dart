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

  void clearState() {
    state = const AsyncData([]);
  }

  void _loadMessages() {
    getChatMessagesUseCase(userId).listen((result) {
      if (!mounted) return;
      result.fold(
        (failure) {
          state = AsyncError(failure.message, StackTrace.current);
        },
        (messages) {
          state = AsyncData(messages);
        },
      );
    }, onError: (e, stack) {
      if (!mounted) return;
      state = AsyncError(e, stack);
    });
  }

  Future<String?> sendMessageAndFetchResponse(String message) async {
    if (isSendingMessage) return null;

    try {
      isSendingMessage = true;
      await sendChatMessageUseCase(
        ChatMessage(
          sender: 'You',
          message: message,
          timestamp: DateTime.now(),
        ),
        userId,
      );

      final response = await AIService.getAnswer(message);
      if (!mounted) return null; // Check if widget is still mounted
      await sendChatMessageUseCase(
        ChatMessage(
          sender: 'Bot',
          message: response.fold((l) => l.message, (r) => r),
          timestamp: DateTime.now(),
        ),
        userId,
      );
      _loadMessages();
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      isSendingMessage = false;
    }
  }
}
