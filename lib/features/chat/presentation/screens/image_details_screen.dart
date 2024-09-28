import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String prompt;

  const ImageDetailScreen({
    super.key,
    required this.imageUrl,
    required this.prompt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Details'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Hero(
                tag: imageUrl,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                prompt,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
