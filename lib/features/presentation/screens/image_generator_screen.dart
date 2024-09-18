// lib/presentation/screens/image_generation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/image_service.dart';
import '../../domain/entities/image_entity.dart';
import '../providers.dart';

class ImageGenerationScreen extends ConsumerStatefulWidget {
  const ImageGenerationScreen({super.key});

  @override
  ConsumerState<ImageGenerationScreen> createState() =>
      _ImageGenerationScreenState();
}

class _ImageGenerationScreenState extends ConsumerState<ImageGenerationScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final imageState = ref.watch(imageNotifierProvider);
    final imageNotifier = ref.read(imageNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Image Generation')),
      body: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(),
          Expanded(
            child: imageState.when(
              data: (images) {
                if (images.isEmpty) {
                  return const Center(child: Text('No images generated yet'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.network(images[index].imageUrl),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, stack) => Center(child: Text('Error: $e')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter description',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final prompt = _controller.text.trim();
              if (prompt.isEmpty) return;

              setState(() {
                _isLoading = true;
              });

              try {
                final imageUrl = await ImageService.searchAiImage(prompt);
                if (imageUrl.isNotEmpty) {
                  final image = ImageEntity(
                    imageUrl: imageUrl,
                    prompt: prompt,
                    timestamp: DateTime.now(),
                  );
                  await imageNotifier.addImage(image);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No images found')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: const Text('Generate Image'),
          ),
        ],
      ),
    );
  }
}
