import 'package:ai_assistant/features/chat/presentation/notifiers/image_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageGenerationScreen extends ConsumerWidget {
  const ImageGenerationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageNotifierProvider);
    final imageNotifier = ref.read(imageNotifierProvider.notifier);
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Image Generation')),
      body: SafeArea(
        child: Column(
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
                    child: CachedNetworkImage(
                      imageUrl: image.imageUrl,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, stack) => Center(child: Text('Error: $e')),
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
                if (prompt.isEmpty) return;

                if (ref.read(imageNotifierProvider) is AsyncLoading) return;

                await imageNotifier.generateImage(prompt);
              },
              child: const Text('Generate Image'),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
