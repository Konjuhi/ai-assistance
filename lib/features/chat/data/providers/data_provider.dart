import 'package:ai_assistant/features/chat/data/datasources/datasource.dart';
import 'package:ai_assistant/features/chat/data/repositories/repositories.dart';
import 'package:ai_assistant/features/chat/domain/domain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/translation_repository.dart';
import '../datasources/translation_datasource.dart';
import '../repositories/translation_repository_impl.dart';

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
final translationDataSourceProvider = Provider<TranslationDataSource>((ref) {
  return TranslatorPlusDataSource(ref.watch(firestoreProvider));
});

// Translation Repository Provider
final translationRepositoryProvider = Provider<TranslationRepository>((ref) {
  return TranslationRepositoryImpl(ref.watch(translationDataSourceProvider));
});