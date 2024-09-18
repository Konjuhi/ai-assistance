import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class ImageGenerationScreen extends ConsumerStatefulWidget {
  const ImageGenerationScreen({super.key});

  @override
  ConsumerState<ImageGenerationScreen> createState() =>
      _ImageGenerationScreenState();
}

class _ImageGenerationScreenState extends ConsumerState<ImageGenerationScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final imageState = ref.watch(imageNotifierProvider);
    final imageNotifier = ref.read(imageNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Image Generation')),
      body: Column(
        children: [
          if (imageState is AsyncLoading) const LinearProgressIndicator(),
          Expanded(
            child: imageState.when(
              data: (image) {
                if (image == null) {
                  return const Center(child: Text('No image generated yet'));
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(image.imageUrl),
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

              await imageNotifier.generateImage(prompt);
            },
            child: const Text('Generate Image'),
          ),
        ],
      ),
    );
  }
}
