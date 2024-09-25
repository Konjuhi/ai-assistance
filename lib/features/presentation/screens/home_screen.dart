import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../notifiers/home_notifier.dart';
import '../providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(homeProvider);
    final userIdAsyncValue = ref.watch(userIdProvider);
    final uuid = ref.read(uuidProvider);
    final chatDataSource = ref.read(chatDataSourceProvider);

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

              await chatDataSource.createChatIfNotExists(newChatId, userId);

              context.push('/chat/$newChatId');
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
                          final chatId = chats[index];
                          return ListTile(
                            title: Text('Chat $chatId'),
                            onTap: () {
                              Navigator.of(context)
                                  .pop(); // This closes the drawer
                              context.push('/chat/$chatId');
                            },
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
