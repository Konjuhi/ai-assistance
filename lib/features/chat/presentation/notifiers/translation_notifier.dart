import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/translation_entity.dart';
import '../../domain/providers/domain_providers.dart';
import '../../domain/usecases/delete_translation_history.dart';
import '../../domain/usecases/fetch_translation_history.dart';
import '../../domain/usecases/translate_text.dart';
import '../providers/presentation_providers.dart';

class TranslateNotifier
    extends StateNotifier<AsyncValue<List<TranslationEntity>>> {
  final TranslateText translateUseCase;
  final FetchTranslationHistory fetchTranslationHistoryUseCase;
  final DeleteTranslationHistory deleteTranslationHistoryUseCase;
  final String userId;

  String? fromLanguage;
  String? toLanguage;
  String textToTranslate = '';

  TranslateNotifier({
    required this.translateUseCase,
    required this.fetchTranslationHistoryUseCase,
    required this.deleteTranslationHistoryUseCase,
    required this.userId,
  }) : super(const AsyncData([]));

  Future<void> translate() async {
    if (fromLanguage == null || toLanguage == null || textToTranslate.isEmpty) {
      return; // Validation
    }

    state = const AsyncLoading();
    final result = await translateUseCase.call(
        fromLanguage!, toLanguage!, textToTranslate);
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (translation) {
        final currentState = state.value ?? [];
        state = AsyncData([...currentState, translation]);
        translateUseCase.saveTranslation(userId, translation);
      },
    );
  }

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

  void updateFromLanguage(String from) {
    fromLanguage = from;
  }

  void updateToLanguage(String to) {
    toLanguage = to;
  }

  void updateTextToTranslate(String text) {
    textToTranslate = text;
  }

  void clearState() {
    state = const AsyncData([]);
    fromLanguage = null;
    toLanguage = null;
    textToTranslate = '';
  }
}

final translateNotifierProvider = StateNotifierProvider<TranslateNotifier,
    AsyncValue<List<TranslationEntity>>>((ref) {
  final userId = ref.watch(userIdProvider).maybeWhen(
        data: (uid) => uid,
        orElse: () => null,
      );

  return TranslateNotifier(
    translateUseCase: ref.watch(translateTextUseCaseProvider),
    fetchTranslationHistoryUseCase:
        ref.watch(fetchTranslationHistoryUseCaseProvider),
    deleteTranslationHistoryUseCase:
        ref.watch(deleteTranslationHistoryUseCaseProvider),
    userId: userId ?? '',
  );
});
