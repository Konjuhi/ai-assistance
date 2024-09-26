import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/chat_model.dart';
import '../../domain/providers/domain_providers.dart';
import '../../domain/usecases/get_all_chats.dart';

class GetAllChatsNotifier extends StateNotifier<AsyncValue<List<ChatModel>>> {
  final GetAllChats getAllChatsUseCase;
  final String userId;

  GetAllChatsNotifier(this.getAllChatsUseCase, this.userId)
      : super(const AsyncLoading()) {
    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      final chatStream = getAllChatsUseCase(userId);
      chatStream.listen((chatList) {
        state = AsyncData(chatList);
      }).onError((error) {
        state = AsyncError(error, StackTrace.current);
      });
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final getAllChatsNotifierProvider = StateNotifierProvider.family<
    GetAllChatsNotifier, AsyncValue<List<ChatModel>>, String>((ref, userId) {
  return GetAllChatsNotifier(ref.watch(getAllChatsUseCaseProvider), userId);
});
