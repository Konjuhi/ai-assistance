import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/translation_service.dart';
import '../notifiers/translation_notifier.dart';

class TranslationScreen extends ConsumerWidget {
  const TranslationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translationState = ref.watch(translateNotifierProvider);
    final translateNotifier = ref.read(translateNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Translation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              translateNotifier.loadTranslationHistory();
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Consumer(
                    builder: (context, ref, child) {
                      final historyState = ref.watch(translateNotifierProvider);
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('Translation History'),
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: const Text(
                                          'Are you sure you want to delete all translation history?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmDelete == true) {
                                  await translateNotifier
                                      .deleteAllTranslationHistory();
                                  Navigator.of(context)
                                      .pop(); // Close bottom sheet after deletion
                                }
                              },
                            )
                          ],
                        ),
                        body: historyState.when(
                          data: (translations) {
                            if (translations.isEmpty) {
                              return const Center(
                                child:
                                    Text('No translation history available.'),
                              );
                            }
                            return ListView.builder(
                              itemCount: translations.length,
                              itemBuilder: (context, index) {
                                final translation = translations[index];
                                return ListTile(
                                  title: Text(translation.originalText),
                                  subtitle: Text(translation.translatedText),
                                );
                              },
                            );
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (e, _) => Center(
                            child: Text('Error: $e'),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: translateNotifier.fromLanguage,
              decoration: const InputDecoration(labelText: 'From Language'),
              items: TranslationService.jsonLang.keys
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  translateNotifier.updateFromLanguage(value);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: translateNotifier.toLanguage,
              decoration: const InputDecoration(labelText: 'To Language'),
              items: TranslationService.jsonLang.keys
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  translateNotifier.updateToLanguage(value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(
                text: translateNotifier.textToTranslate,
              ),
              decoration: const InputDecoration(labelText: 'Text to Translate'),
              onChanged: (value) {
                translateNotifier.updateTextToTranslate(value);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await translateNotifier.translate();
              },
              child: const Text('Translate'),
            ),
            const SizedBox(height: 16),
            translationState.when(
              data: (translations) {
                final latestTranslation = translations.isNotEmpty
                    ? translations.last.translatedText
                    : 'No translation yet';
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    latestTranslation,
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
