class ImageEntity {
  final String id;
  final String imageUrl;
  final String prompt;
  final DateTime timestamp;

  ImageEntity({
    required this.id,
    required this.imageUrl,
    required this.prompt,
    required this.timestamp,
  });
}
