import 'package:ai_assistant/features/chat/domain/entities/image_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel extends ImageEntity {
  ImageModel({
    required super.id, // Add id field
    required super.imageUrl,
    required super.prompt,
    required super.timestamp,
  });

  factory ImageModel.fromMap(Map<String, dynamic> map, String id) {
    return ImageModel(
      id: id, // Capture the document ID from Firestore
      imageUrl: map['imageUrl'] ?? '',
      prompt: map['prompt'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'prompt': prompt,
      'timestamp': timestamp,
    };
  }
}
