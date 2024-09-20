import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class ImageGenerationScreen extends ConsumerWidget {
  const ImageGenerationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageNotifierProvider);
    final imageNotifier = ref.read(imageNotifierProvider.notifier);
    final TextEditingController controller = TextEditingController();

    return SafeArea(
      child: Scaffold(
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
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
                error: (e, stack) {
                  return Center(child: Text('Error: $e'));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Enter description',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final prompt = controller.text.trim();
                if (prompt.isEmpty) {
                  return;
                }

                await imageNotifier.generateImage(prompt);
              },
              child: const Text('Generate Image'),
            ),
          ],
        ),
      ),
    );
  }
}
