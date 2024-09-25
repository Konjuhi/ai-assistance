import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../notifiers/chat_notifier.dart';
import '../notifiers/create_chat_notifier.dart';
import '../notifiers/delete_chat_notifier.dart';
import '../notifiers/home_notifier.dart';
import '../providers.dart';

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

    final options = ref.watch(homeProvider);
    final userIdAsyncValue = ref.watch(userIdProvider);
    final uuid = ref.read(uuidProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.push('/profile');
            },
          ),
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
                  await ref
                      .read(createChatNotifierProvider.notifier)
                      .createChat(newChatId, userId, chatName);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create chat: $e')),
                  );
                }

                context.push('/chat/$newChatId');
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(child: Text('Chat History')),
            Expanded(
              child: ref.watch(chatsProvider).when(
                    data: (chats) {
                      if (chats.isEmpty) {
                        return const Center(
                            child: Text('No chat history found'));
                      }

                      return ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          final chat = chats[index];
                          final chatId = chat['chatId'];
                          final chatName = chat['chatName'] ?? 'Chat $chatId';

                          return Dismissible(
                            key: Key(chatId),
                            direction: DismissDirection.endToStart,
                            // Swipe to delete
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) async {
                              final userId = ref.read(userIdProvider).value;
                              if (userId != null) {
                                try {
                                  // Use the deleteChatNotifier to delete the chat
                                  await ref
                                      .read(deleteChatNotifierProvider.notifier)
                                      .deleteChat(chatId, userId);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Failed to delete chat: $e')),
                                  );
                                }
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$chatName deleted'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () async {
                                      // Optional: Handle undo functionality here if required
                                    },
                                  ),
                                ),
                              );
                            },

                            child: ListTile(
                              title: Text(chatName),
                              onTap: () {
                                Navigator.of(context).pop();
                                context.push('/chat/$chatId');
                              },
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, stack) => Center(child: Text('Error: $e')),
                  ),
            ),
          ],
        ),
      ),
      body: userIdAsyncValue.when(
        data: (userId) {
          if (userId == null) {
            return const Center(child: Text('No user is logged in'));
          }

          return ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];

              return Card(
                child: ListTile(
                  title: Text(option.title),
                  onTap: () {
                    if (option.route == '/chat') {
                      context.push('/chat/$userId');
                    } else {
                      context.push(option.route);
                    }
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
