import 'package:ai_assistant/common/errors/app_exceptions.dart';
import 'package:ai_assistant/features/chat/data/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ImageDataSource {
  Stream<List<ImageModel>> getImages(String userId);

  Future<void> addImage(ImageModel image, String userId);

  Future<void> deleteImage(String userId, String imageId);
}

class FirebaseImageDataSource implements ImageDataSource {
  final FirebaseFirestore firestore;

  FirebaseImageDataSource(this.firestore);

  @override
  Stream<List<ImageModel>> getImages(String userId) {
    try {
      return firestore
          .collection('users')
          .doc(userId)
          .collection('images')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return ImageModel.fromMap(doc.data(), doc.id); // Pass document ID
        }).toList();
      });
    } catch (e, stackTrace) {
      throw ServerException(
          message: 'Error fetching images', stackTrace: stackTrace);
    }
  }

  @override
  Future<void> addImage(ImageModel image, String userId) async {
    try {
      await firestore.collection('users').doc(userId).collection('images').add({
        'userId': userId,
        ...image.toMap(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e, stackTrace) {
      throw ServerException(
          message: 'Error adding image', stackTrace: stackTrace);
    }
  }

  @override
  Future<void> deleteImage(String imageId, String userId) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('images')
          .doc(imageId)
          .delete();
    } catch (e, stackTrace) {
      throw ServerException(
        message: 'Error deleting image',
        stackTrace: stackTrace,
      );
    }
  }
}
