// lib/presentation/notifiers/chat_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/get_chat_messages.dart';
import '../../domain/usecases/send_chat_messages.dart';

class ChatNotifier extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final GetChatMessages getChatMessagesUseCase;
  final SendChatMessage sendChatMessageUseCase;
  final String userId;

  ChatNotifier({
    required this.getChatMessagesUseCase,
    required this.sendChatMessageUseCase,
    required this.userId,
  }) : super(const AsyncLoading()) {
    _loadMessages();
  }

  void _loadMessages() {
    getChatMessagesUseCase(userId).listen((messages) {
      state = AsyncData(messages);
    }, onError: (e, stack) {
      state = AsyncError(e, stack);
    });
  }

  Future<void> sendMessage(ChatMessage message) async {
    await sendChatMessageUseCase(message, userId);
  }
}
