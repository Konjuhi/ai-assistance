import 'package:ai_assistant/features/chat/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteChatNotifier extends StateNotifier<AsyncValue<void>> {
  final DeleteChat deleteChatUseCase;

  DeleteChatNotifier(this.deleteChatUseCase) : super(const AsyncData(null));

  Future<void> deleteChat(String chatId, String userId) async {
    state = const AsyncLoading();
    try {
      await deleteChatUseCase(chatId, userId);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final deleteChatNotifierProvider =
    StateNotifierProvider<DeleteChatNotifier, AsyncValue<void>>((ref) {
  return DeleteChatNotifier(ref.watch(deleteChatUseCaseProvider));
});
