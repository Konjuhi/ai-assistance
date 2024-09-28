import 'package:ai_assistant/features/chat/data/providers/data_provider.dart';
import 'package:ai_assistant/features/chat/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../usecases/delete_translation_history.dart';
import '../usecases/fetch_translation_history.dart';
import '../usecases/get_ai_response.dart';
import '../usecases/search_ai_image.dart';
import '../usecases/translate_text.dart';

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
