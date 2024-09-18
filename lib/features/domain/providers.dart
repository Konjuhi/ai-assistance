import 'package:ai_assistant/features/domain/usecases/generate_images.dart';
import 'package:ai_assistant/features/domain/usecases/get_images.dart';
import 'package:ai_assistant/features/domain/usecases/send_chat_messages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import 'usecases/get_chat_messages.dart';

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
