import '../../domain/entities/translation_entity.dart';

class TranslationModel extends TranslationEntity {
  TranslationModel({
    required super.originalText,
    required super.translatedText,
    required super.fromLanguage,
    required super.toLanguage,
  });

  factory TranslationModel.fromMap(Map<String, dynamic> map, String id) {
    return TranslationModel(
      originalText: map['originalText'] as String,
      translatedText: map['translatedText'] as String,
      fromLanguage: map['fromLanguage'] as String,
      toLanguage: map['toLanguage'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'originalText': originalText,
      'translatedText': translatedText,
      'fromLanguage': fromLanguage,
      'toLanguage': toLanguage,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
