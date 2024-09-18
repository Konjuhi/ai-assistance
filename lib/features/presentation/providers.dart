// lib/presentation/providers.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../domain/entities/chat_message.dart';
import '../domain/entities/image_entity.dart';
import '../domain/providers.dart'; // Import domain providers for use cases
import 'notifiers/chat_notifier.dart';
import 'notifiers/image_notifier.dart';

// Firebase Auth instance (specific to presentation layer)
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// User ID provider
final userIdProvider = Provider<String>((ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw Exception('User not authenticated');
  }
  return user.uid;
});

// Chat Notifier
final chatNotifierProvider =
    StateNotifierProvider<ChatNotifier, AsyncValue<List<ChatMessage>>>((ref) {
  return ChatNotifier(
    getChatMessagesUseCase: ref.watch(getChatMessagesUseCaseProvider),
    sendChatMessageUseCase: ref.watch(sendChatMessageUseCaseProvider),
    userId: ref.watch(userIdProvider),
  );
});

// Image Notifier
// Image Notifier
final imageNotifierProvider =
    StateNotifierProvider<ImageNotifier, AsyncValue<ImageEntity?>>((ref) {
  return ImageNotifier(
    generateImageUseCase: ref.watch(generateImageUseCaseProvider),
    imageDataSource:
        ref.watch(imageDataSourceProvider), // Add the image data source
    userId: ref.watch(userIdProvider),
  );
});
