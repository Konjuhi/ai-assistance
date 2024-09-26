import 'package:ai_assistant/features/chat/data/providers/data_provider.dart';
import 'package:ai_assistant/features/chat/domain/domain.dart';
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
