import 'package:ai_assistant/features/chat/data/providers/data_provider.dart';
import 'package:ai_assistant/features/chat/domain/domain.dart';
import 'package:ai_assistant/features/chat/domain/usecases/delete_translation_history.dart';
import 'package:ai_assistant/features/chat/domain/usecases/fetch_translation_history.dart';
import 'package:ai_assistant/features/chat/domain/usecases/get_ai_response.dart';
import 'package:ai_assistant/features/chat/domain/usecases/search_ai_image.dart';
import 'package:ai_assistant/features/chat/domain/usecases/translate_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getChatMessagesUseCaseProvider = Provider<GetChatMessages>((ref) {
  return GetChatMessages(ref.watch(chatRepositoryProvider));
});

final sendChatMessageUseCaseProvider = Provider<SendChatMessage>((ref) {
  return SendChatMessage(ref.watch(chatRepositoryProvider));
});

final getImagesUseCaseProvider = Provider<GetImages>((ref) {
  return GetImages(ref.watch(imageRepositoryProvider));
});

final generateImageUseCaseProvider = Provider<GenerateImage>((ref) {
  return GenerateImage(ref.watch(imageRepositoryProvider));
});

final createChatUseCaseProvider = Provider<CreateChat>((ref) {
  return CreateChat(ref.watch(chatRepositoryProvider));
});
final deleteChatUseCaseProvider = Provider<DeleteChat>((ref) {
  return DeleteChat(ref.watch(chatRepositoryProvider));
});
final getAllChatsUseCaseProvider = Provider<GetAllChats>((ref) {
  return GetAllChats(ref.watch(chatRepositoryProvider));
});
final deleteImageUseCaseProvider = Provider<DeleteImage>((ref) {
  return DeleteImage(ref.watch(imageRepositoryProvider));
});
final translateTextUseCaseProvider = Provider<TranslateText>((ref) {
  return TranslateText(ref.watch(translationRepositoryProvider));
});
final getAIResponseUseCaseProvider = Provider<GetAIResponse>((ref) {
  return GetAIResponse(ref.watch(chatRepositoryProvider));
});

final searchAiImageUseCaseProvider = Provider<SearchAiImage>((ref) {
  return SearchAiImage(repository: ref.watch(imageRepositoryProvider));
});

final fetchTranslationHistoryUseCaseProvider =
    Provider<FetchTranslationHistory>((ref) {
  return FetchTranslationHistory(ref.watch(translationRepositoryProvider));
});
final deleteTranslationHistoryUseCaseProvider =
    Provider<DeleteTranslationHistory>((ref) {
  return DeleteTranslationHistory(ref.watch(translationRepositoryProvider));
});

final getLanguagesUseCaseProvider = Provider<GetLanguages>((ref) {
  final repository = ref.watch(translationRepositoryProvider);
  return GetLanguages(repository);
});
