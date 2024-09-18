// lib/data/providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/repositories/chat_repository.dart';
import '../domain/repositories/image_repository.dart';
import 'datasources/firebase_chat_datasource.dart';
import 'datasources/firebase_image_datasource.dart';
import 'repositories/chat_repository_impl.dart';
import 'repositories/image_repository_impl.dart';

// Firebase Firestore instance (specific to data layer)
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Data Sources
final chatDataSourceProvider = Provider<ChatDataSource>((ref) {
  return FirebaseChatDataSource(ref.watch(firestoreProvider));
});

final imageDataSourceProvider = Provider<FirebaseImageDataSource>((ref) {
  return FirebaseImageDataSource(FirebaseFirestore.instance);
});

// Repositories Implementations
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(ref.watch(chatDataSourceProvider));
});

final imageRepositoryProvider = Provider<ImageRepository>((ref) {
  return ImageRepositoryImpl(ref.watch(imageDataSourceProvider));
});
