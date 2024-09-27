import 'package:ai_assistant/common/utils/extension.dart';
import 'package:ai_assistant/features/chat/presentation/notifiers/create_chat_notifier.dart';
import 'package:ai_assistant/features/chat/presentation/notifiers/delete_chat_notifier.dart';
import 'package:ai_assistant/features/chat/presentation/notifiers/get_all_chats_notifier.dart';
import 'package:ai_assistant/features/chat/presentation/providers/presentation_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/utils/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<String?> showChatNameDialog(BuildContext context, WidgetRef ref) {
      final TextEditingController controller = TextEditingController();

      return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter Chat Name'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Chat name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              Consumer(
                builder: (context, ref, _) {
                  final isLoading = ref.watch(loadingProvider);

                  return isLoading
                      ? const CircularProgressIndicator()
                      : TextButton(
                          onPressed: () async {
                            final chatName = controller.text.trim();
                            if (chatName.isNotEmpty) {
                              ref.read(loadingProvider.notifier).state = true;

                              Navigator.of(context).pop(chatName);
                            }
                          },
                          child: const Text('Create'),
                        );
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _showThemeModeDialog(
        BuildContext context, AppTheme themeNotifier, ThemeMode currentMode) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Theme Mode'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('Light Mode'),
                  value: ThemeMode.light,
                  groupValue: currentMode,
                  onChanged: (ThemeMode? value) {
                    themeNotifier.setLightMode();
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark Mode'),
                  value: ThemeMode.dark,
                  groupValue: currentMode,
                  onChanged: (ThemeMode? value) {
                    themeNotifier.setDarkMode();
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('System Default'),
                  value: ThemeMode.system,
                  groupValue: currentMode,
                  onChanged: (ThemeMode? value) {
                    themeNotifier.setSystemMode();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    final userIdAsyncValue = ref.watch(userIdProvider);
    final uuid = ref.read(uuidProvider);
    final isLoading = ref.watch(loadingProvider);
    // Watch the theme provider to toggle between dark and light modes
    final themeNotifier = ref.read(themeProvider.notifier);
    final themeMode = ref.watch(themeProvider).themeMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Assistant App',
          style: context.textTheme.bodyMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showThemeModeDialog(context, themeNotifier, themeMode);
            },
          ),

          // IconButton(
          //   icon: Icon(themeMode == ThemeMode.dark
          //       ? Icons.dark_mode
          //       : Icons.light_mode),
          //   onPressed: () {
          //     // Toggle between light and dark mode
          //     if (themeMode == ThemeMode.dark) {
          //       themeNotifier.setLightMode();
          //     } else {
          //       themeNotifier.setDarkMode();
          //     }
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.push('/profile');
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.brightness_6),
          //   onPressed: () {
          //     //  showThemeModeDialog(context, ref);
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final chatName = await showChatNameDialog(context, ref);

              if (chatName != null && chatName.isNotEmpty) {
                final userId = ref.read(userIdProvider).value;
                if (userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please log in to create a new chat.'),
                    ),
                  );
                  return;
                }

                final newChatId = uuid.v4();

                try {
                  ref.read(loadingProvider.notifier).state = true;

                  await ref
                      .read(createChatNotifierProvider.notifier)
                      .createChat(newChatId, userId, chatName);

                  context.push('/chat/$newChatId');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create chat: $e')),
                  );
                } finally {
                  ref.read(loadingProvider.notifier).state = false;
                }
              }
            },
          )
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Flexible(
                child: Text('Chat History',
                    style: context.textTheme.headlineLarge),
              ),
              const SizedBox(
                height: 10,
              ),
              // presentation/ui/home_screen.dart
              Expanded(
                child: ref.watch(userIdProvider).when(
                      data: (userId) {
                        if (userId == null) {
                          return Center(
                            child: Text(
                              'No user is logged in',
                              style: context.textTheme.bodySmall,
                            ),
                          );
                        }

                        return ref
                            .watch(getAllChatsNotifierProvider(userId))
                            .when(
                              data: (chats) {
                                if (chats.isEmpty) {
                                  return Center(
                                    child: Text('No chat history found',
                                        style: context.textTheme.bodySmall),
                                  );
                                }
                                return ListView.builder(
                                  itemCount: chats.length,
                                  itemBuilder: (context, index) {
                                    final chat = chats[index];
                                    final chatId = chat.chatId;
                                    final chatName = chat.chatName;

                                    return Dismissible(
                                      key: Key(chatId),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                        ),
                                        child: const Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      onDismissed: (direction) async {
                                        final scaffoldMessenger =
                                            ScaffoldMessenger.of(context);

                                        try {
                                          await ref
                                              .read(deleteChatNotifierProvider
                                                  .notifier)
                                              .deleteChat(chatId, userId);
                                        } catch (e) {
                                          scaffoldMessenger.showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Failed to delete chat: $e'),
                                            ),
                                          );
                                        }
                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(
                                            content: Text('$chatName deleted'),
                                            action: SnackBarAction(
                                              label: 'Undo',
                                              onPressed: () async {
                                                // Optional undo action
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      child: ListTile(
                                        title: Text(chatName,
                                            style: context.textTheme.bodySmall),
                                        trailing:
                                            const Icon(Icons.arrow_forward),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          context.push('/chat/$chatId');
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (e, stack) => Center(
                                child: Text('Error: $e'),
                              ),
                            );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (e, stack) => Center(
                        child: Text('Error: $e'),
                      ),
                    ),
              )
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : userIdAsyncValue.when(
              data: (userId) {
                if (userId == null) {
                  return const Center(child: Text('No user is logged in'));
                }
                return Card(
                  child: ListTile(
                    title: Text(
                      'Image Generation',
                      style: context.textTheme.bodyMedium,
                    ),
                    onTap: () {
                      context.push('/image-generation');
                    },
                  ),
                )
                    .animate()
                    .slideY(
                      begin: 1.0,
                      end: 0.0,
                      duration: 500.ms,
                      curve: Curves.easeOut,
                    )
                    .fadeIn();
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, stack) => Center(
                child: Text('Error: $e'),
              ),
            ),
    );
  }
}
