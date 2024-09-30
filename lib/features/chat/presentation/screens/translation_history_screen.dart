import 'package:ai_assistant/features/chat/presentation/notifiers/translation_history_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TranslationHistoryScreen extends ConsumerStatefulWidget {
  const TranslationHistoryScreen({super.key});

  @override
  ConsumerState<TranslationHistoryScreen> createState() =>
      _TranslationHistoryScreenState();
}

class _TranslationHistoryScreenState
    extends ConsumerState<TranslationHistoryScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(translationHistoryNotifierProvider.notifier)
          .loadTranslationHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(translationHistoryNotifierProvider);

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
                await ref
                    .read(translationHistoryNotifierProvider.notifier)
                    .deleteAllTranslationHistory();
              }
            },
          ),
        ],
      ),
      body: historyState.when(
        data: (translations) {
          if (translations.isEmpty) {
            return const Center(
              child: Text('No translation history available.'),
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
  }
}
