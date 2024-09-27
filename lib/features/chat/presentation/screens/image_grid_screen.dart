import 'package:ai_assistant/features/chat/presentation/notifiers/image_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ImageGridScreen extends ConsumerWidget {
  const ImageGridScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagesState = ref.watch(imageListNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Generated Images')),
      body: imagesState.when(
        data: (images) {
          if (images.isEmpty) {
            return const Center(child: Text('No images found.'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8, // Control the aspect ratio
            ),
            padding: const EdgeInsets.all(16),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index];
              return InkWell(
                onTap: () {
                  // Navigate to the detail screen using GoRouter
                  context.push(
                    '/imageDetail',
                    extra: {
                      'imageUrl': image.imageUrl,
                      'prompt': image.prompt,
                    },
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                image.prompt,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'delete') {
                                  _showDeleteConfirmationDialog(
                                      context, ref, image.id);
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                              icon: const Icon(
                                Icons.more_vert,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          child: Hero(
                            tag: image.imageUrl,
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: Image.network(
                                image.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, WidgetRef ref, String imageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this image?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without deleting
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                ref
                    .read(imageListNotifierProvider.notifier)
                    .deleteImage(imageId);
                Navigator.of(context).pop(); // Close the dialog after deleting
              },
            ),
          ],
        );
      },
    );
  }
}
