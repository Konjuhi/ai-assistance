import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/providers.dart';
import '../domain/entities/chat_message.dart';
import '../domain/entities/image_entity.dart';
import '../domain/providers.dart';
import 'notifiers/chat_notifier.dart';
import 'notifiers/image_notifier.dart';

final uuidProvider = Provider<Uuid>((ref) => const Uuid());

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final userIdProvider = StreamProvider<String?>((ref) {
  return ref
      .watch(firebaseAuthProvider)
      .authStateChanges()
      .map((user) => user?.uid);
});

final chatNotifierProvider = StateNotifierProvider.family<ChatNotifier,
    AsyncValue<List<ChatMessage>>, String>((ref, chatId) {
  final userId = ref.watch(userIdProvider).maybeWhen(
        data: (uid) => uid,
        orElse: () => null,
      );

  if (userId == null) {
    return ChatNotifier(
      getChatMessagesUseCase: ref.watch(getChatMessagesUseCaseProvider),
      sendChatMessageUseCase: ref.watch(sendChatMessageUseCaseProvider),
      userId: '',
      chatId: chatId,
    )..clearState();
  }

  return ChatNotifier(
    getChatMessagesUseCase: ref.watch(getChatMessagesUseCaseProvider),
    sendChatMessageUseCase: ref.watch(sendChatMessageUseCaseProvider),
    userId: userId,
    chatId: chatId,
  );
});

final imageNotifierProvider =
    StateNotifierProvider<ImageNotifier, AsyncValue<ImageEntity?>>((ref) {
  final userId = ref.watch(userIdProvider).maybeWhen(
        data: (uid) => uid,
        orElse: () => null,
      );

  if (userId == null) {
    return ImageNotifier(
      generateImageUseCase: ref.watch(generateImageUseCaseProvider),
      getImagesUseCase: ref.watch(getImagesUseCaseProvider),
      userId: '',
    )..clearState();
  }

  return ImageNotifier(
    generateImageUseCase: ref.watch(generateImageUseCaseProvider),
    getImagesUseCase: ref.watch(getImagesUseCaseProvider),
    userId: userId,
  );
});
final chatsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final userId = ref.watch(userIdProvider).maybeWhen(
        data: (uid) => uid,
        orElse: () => null,
      );

  if (userId == null) {
    return const Stream.empty();
  }

  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.getAllChats(userId);
});
