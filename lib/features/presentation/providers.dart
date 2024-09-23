import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/chat_message.dart';
import '../domain/entities/image_entity.dart';
import '../domain/providers.dart';
import 'notifiers/chat_notifier.dart';
import 'notifiers/image_notifier.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final userIdProvider = StreamProvider<String?>((ref) {
  return ref
      .watch(firebaseAuthProvider)
      .authStateChanges()
      .map((user) => user?.uid);
});

final chatNotifierProvider =
    StateNotifierProvider<ChatNotifier, AsyncValue<List<ChatMessage>>>((ref) {
  final userId = ref.watch(userIdProvider).maybeWhen(
        data: (uid) => uid,
        orElse: () => null,
      );

  if (userId == null) {
    return ChatNotifier(
      getChatMessagesUseCase: ref.watch(getChatMessagesUseCaseProvider),
      sendChatMessageUseCase: ref.watch(sendChatMessageUseCaseProvider),
      userId: '',
    )..clearState(); // Call clearState() if no user ID is found
  }

  return ChatNotifier(
    getChatMessagesUseCase: ref.watch(getChatMessagesUseCaseProvider),
    sendChatMessageUseCase: ref.watch(sendChatMessageUseCaseProvider),
    userId: userId,
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
