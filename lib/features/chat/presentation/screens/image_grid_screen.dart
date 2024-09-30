import 'package:ai_assistant/features/chat/presentation/notifiers/image_list_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ImageGridScreen extends ConsumerWidget {
  const ImageGridScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagesState = ref.watch(imageListNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Generated Images')),
      body: imagesState.when(
        data: (images) {
          if (images.isEmpty) {
            return const Center(child: Text('No images found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomScrollView(
              slivers: [
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final image = images[index];
                      return GestureDetector(
                        onTap: () {
                          context.push(
                            '/imageDetail',
                            extra: <String, dynamic>{
                              'imageUrl': image.imageUrl,
                              'prompt': image.prompt,
                            },
                          );
                        },
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        image.prompt,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        _showDeleteConfirmationDialog(
                                            context, ref, image.id);
                                      },
                                      child: const Icon(Icons.close),
                                    )
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
                                    child: CachedNetworkImage(
                                      imageUrl: image.imageUrl,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: images.length,
                  ),
                ),
              ],
            ),
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
