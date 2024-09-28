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
      appBar: AppBar(title: const Text('Text Translation')),
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
              data: (translation) => translation == null
                  ? const Text('No translation yet')
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        translation.translatedText,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
