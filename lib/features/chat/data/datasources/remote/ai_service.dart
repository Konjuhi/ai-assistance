import 'dart:developer';

import 'package:ai_assistant/common/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  static Future<Either<Failure, String>> getAnswer(String question) async {
    try {
      final apiKey = dotenv.env['GOOGLE_API_KEY'];
      if (apiKey == null) {
        throw Exception('API key not found');
      }

      log('API Key: $apiKey');

      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
      );

      final content = [Content.text(question)];
      final res = await model.generateContent(
        content,
        safetySettings: [
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
        ],
      );

      String answer = res.text!;
      log('Response: $answer');

      return Right(answer);
    } catch (e, stackTrace) {
      log('getAnswer Error: $e');

      if (e.toString().contains('UnsupportedUserLocation')) {
        return Left(
          ServerFailure(
            message: "Gemini isn't available in your country",
            stackTrace: stackTrace,
          ),
        );
      } else {
        return Left(
          ServerFailure(
            message: 'Something went wrong',
            stackTrace: stackTrace,
          ),
        );
      }
    }
  }
}
