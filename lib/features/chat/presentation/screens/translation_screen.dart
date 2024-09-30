import 'package:ai_assistant/features/chat/presentation/notifiers/translation_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TranslationScreen extends ConsumerWidget {
  const TranslationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translationState = ref.watch(translateNotifierProvider);
    final translateNotifier = ref.read(translateNotifierProvider.notifier);
    final availableLanguages = translateNotifier.getAvailableLanguages();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Translation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              context.push('/translation-history');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: translateNotifier.fromLanguage,
              decoration: const InputDecoration(labelText: 'From Language'),
              items: availableLanguages.keys
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
              items: availableLanguages.keys
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
