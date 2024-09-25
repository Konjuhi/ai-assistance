import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers.dart';
import '../../domain/usecases/create_chat.dart';

class CreateChatNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateChat createChatUseCase;

  CreateChatNotifier(this.createChatUseCase) : super(const AsyncData(null));

  Future<void> createChat(String chatId, String userId, String chatName) async {
    state = const AsyncLoading();
    try {
      await createChatUseCase(chatId, userId, chatName);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final createChatNotifierProvider =
    StateNotifierProvider<CreateChatNotifier, AsyncValue<void>>((ref) {
  return CreateChatNotifier(ref.watch(createChatUseCaseProvider));
});
