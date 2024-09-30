import 'package:ai_assistant/features/chat/domain/entities/translation_entity.dart';
import 'package:ai_assistant/features/chat/domain/providers/domain_providers.dart';
import 'package:ai_assistant/features/chat/domain/usecases/delete_translation_history.dart';
import 'package:ai_assistant/features/chat/domain/usecases/fetch_translation_history.dart';
import 'package:ai_assistant/features/chat/presentation/providers/presentation_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TranslationHistoryNotifier
    extends StateNotifier<AsyncValue<List<TranslationEntity>>> {
  final FetchTranslationHistory fetchTranslationHistoryUseCase;
  final DeleteTranslationHistory deleteTranslationHistoryUseCase;
  final String userId;

  TranslationHistoryNotifier({
    required this.fetchTranslationHistoryUseCase,
    required this.deleteTranslationHistoryUseCase,
    required this.userId,
  }) : super(const AsyncData([]));

  Future<void> loadTranslationHistory() async {
    state = const AsyncLoading();
    final result = await fetchTranslationHistoryUseCase.call(userId);
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (history) => state = AsyncData(history),
    );
  }

  Future<void> deleteAllTranslationHistory() async {
    state = const AsyncLoading();
    final result = await deleteTranslationHistoryUseCase.call(userId);
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (_) => state = const AsyncData([]),
    );
  }
}

final translationHistoryNotifierProvider = StateNotifierProvider<
    TranslationHistoryNotifier, AsyncValue<List<TranslationEntity>>>((ref) {
  final userId = ref.watch(userIdProvider).maybeWhen(
        data: (uid) => uid,
        orElse: () => null,
      );

  return TranslationHistoryNotifier(
    fetchTranslationHistoryUseCase:
        ref.watch(fetchTranslationHistoryUseCaseProvider),
    deleteTranslationHistoryUseCase:
        ref.watch(deleteTranslationHistoryUseCaseProvider),
    userId: userId ?? '',
  );
});
