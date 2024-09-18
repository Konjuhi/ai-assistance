import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/image_entity.dart';

class ImageModel extends ImageEntity {
  ImageModel({
    required super.imageUrl,
    required super.prompt,
    required super.timestamp,
  });

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
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
