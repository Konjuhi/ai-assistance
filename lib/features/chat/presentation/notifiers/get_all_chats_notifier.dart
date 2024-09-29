import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/chat.dart';
import '../../domain/providers/domain_providers.dart';
import '../../domain/usecases/get_all_chats.dart';

class GetAllChatsNotifier extends StateNotifier<AsyncValue<List<Chat>>> {
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
        chatList.sort((a, b) {
          final timestampA =
              a.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
          final timestampB =
              b.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
          return timestampB.compareTo(timestampA);
        });

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
    GetAllChatsNotifier, AsyncValue<List<Chat>>, String>((ref, userId) {
  return GetAllChatsNotifier(ref.watch(getAllChatsUseCaseProvider), userId);
});
