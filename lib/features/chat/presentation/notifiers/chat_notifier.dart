import 'package:ai_assistant/features/chat/domain/domain.dart';
import 'package:ai_assistant/features/chat/domain/usecases/get_ai_response.dart';
import 'package:ai_assistant/features/chat/presentation/providers/presentation_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatNotifier extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final GetChatMessages getChatMessagesUseCase;
  final SendChatMessage sendChatMessageUseCase;
  final GetAIResponse getAIResponseUseCase;
  final String userId;
  final String chatId;

  bool isSendingMessage = false;

  ChatNotifier({
    required this.getChatMessagesUseCase,
    required this.sendChatMessageUseCase,
    required this.getAIResponseUseCase,
    required this.userId,
    required this.chatId,
  }) : super(const AsyncLoading()) {
    _loadMessages();
  }

  void clearState() {
    state = const AsyncData([]);
  }

  void _loadMessages() {
    getChatMessagesUseCase(chatId, userId).listen((result) {
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
        chatId,
        userId,
      );

      final response = await getAIResponseUseCase.call(message);
      if (!mounted) return null;

      final responseMessage = response.fold(
        (failure) => failure.message,
        (success) => success,
      );

      // Sending AI response message
      await sendChatMessageUseCase(
        ChatMessage(
          sender: 'Bot',
          message: responseMessage,
          timestamp: DateTime.now(),
        ),
        chatId,
        userId,
      );

      _loadMessages();

      return response.isLeft() ? responseMessage : null;
    } catch (e) {
      return e.toString();
    } finally {
      isSendingMessage = false;
    }
  }
}

final chatNotifierProvider = StateNotifierProvider.family<ChatNotifier,
    AsyncValue<List<ChatMessage>>, String>((ref, chatId) {
  final userId = ref.watch(userIdProvider).maybeWhen(
        data: (uid) => uid,
        orElse: () => null,
      );

  if (userId == null) {
    return ChatNotifier(
      getChatMessagesUseCase: ref.watch(getChatMessagesUseCaseProvider),
      sendChatMessageUseCase: ref.watch(sendChatMessageUseCaseProvider),
      getAIResponseUseCase: ref.watch(getAIResponseUseCaseProvider),
      userId: '',
      chatId: chatId,
    )..clearState();
  }

  return ChatNotifier(
    getChatMessagesUseCase: ref.watch(getChatMessagesUseCaseProvider),
    sendChatMessageUseCase: ref.watch(sendChatMessageUseCaseProvider),
    getAIResponseUseCase: ref.watch(getAIResponseUseCaseProvider),
    userId: userId,
    chatId: chatId,
  );
});
