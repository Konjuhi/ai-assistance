import 'package:ai_assistant/features/chat/presentation/notifiers/create_chat_notifier.dart';
import 'package:ai_assistant/features/chat/presentation/notifiers/delete_chat_notifier.dart';
import 'package:ai_assistant/features/chat/presentation/notifiers/get_all_chats_notifier.dart';
import 'package:ai_assistant/features/chat/presentation/providers/presentation_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

  Future<void> _deleteChatConfirmation(BuildContext context, WidgetRef ref,
      String chatId, String chatName) async {
    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: Text('Are you sure you want to delete "$chatName"?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;

    if (shouldDelete) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final userId = ref.read(userIdProvider).value;

      if (userId != null) {
        try {
          ref.read(deleteChatLoadingProvider.notifier).state = true;

          await ref.read(deleteChatNotifierProvider.notifier).deleteChat(
                chatId,
                userId,
              );

          if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
            _scaffoldKey.currentState?.openEndDrawer();
          }

          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('$chatName deleted successfully'),
            ),
          );
        } catch (e) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Failed to delete chat: $e'),
            ),
          );
        } finally {
          ref.read(deleteChatLoadingProvider.notifier).state = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userIdAsyncValue = ref.watch(userIdProvider);
    final uuid = ref.read(uuidProvider);
    final isLoading = ref.watch(loadingProvider);

    final isDeletingChat = ref.watch(deleteChatLoadingProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('AI Assistant App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: () {
              context.push('/images');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.push('/profile');
            },
          ),
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Chat History',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Divider(thickness: 1),
              Expanded(
                child: userIdAsyncValue.when(
                  data: (userId) {
                    if (userId == null) {
                      return Center(
                        child: Text(
                          'No user is logged in',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    }

                    return ref.watch(getAllChatsNotifierProvider(userId)).when(
                          data: (chats) {
                            if (chats.isEmpty) {
                              return Center(
                                child: Text(
                                  'No chat history found',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              );
                            }
                            if (isDeletingChat) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return ListView.builder(
                              itemCount: chats.length,
                              itemBuilder: (context, index) {
                                final chat = chats[index];
                                final chatId = chat.chatId;
                                final chatName = chat.chatName;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  child: Material(
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(12),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      leading: const CircleAvatar(
                                        child: Icon(
                                          Icons.chat,
                                        ),
                                      ),
                                      title: Text(
                                        chatName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      subtitle: Text(
                                        'Last message here...',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Colors.grey,
                                            ),
                                      ),
                                      trailing: PopupMenuButton<String>(
                                        onSelected: (value) async {
                                          if (value == 'delete') {
                                            await _deleteChatConfirmation(
                                                context, ref, chatId, chatName);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        context.push('/chat/$chatId');
                                      },
                                    ),
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
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeOut,
                      ),
                    ),
                    child: Column(
                      children: [
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            title: Text(
                              'Create New Chat',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            subtitle: const Text('Start a new conversation'),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () async {
                              final chatName =
                                  await showChatNameDialog(context, ref);

                              if (chatName != null && chatName.isNotEmpty) {
                                final userId = ref.read(userIdProvider).value;
                                if (userId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please log in to create a new chat.'),
                                    ),
                                  );
                                  return;
                                }

                                final newChatId = uuid.v4();

                                try {
                                  ref.read(loadingProvider.notifier).state =
                                      true;

                                  await ref
                                      .read(createChatNotifierProvider.notifier)
                                      .createChat(newChatId, userId, chatName);

                                  context.push('/chat/$newChatId');
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Failed to create chat: $e')),
                                  );
                                } finally {
                                  ref.read(loadingProvider.notifier).state =
                                      false;
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            title: Text(
                              'Image Generation',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            subtitle: const Text('Create AI-generated images'),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              context.push('/image-generation');
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            title: Text(
                              'Text Translation',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            subtitle:
                                const Text('Translate text between languages'),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              context.push('/translation');
                            },
                          ),
                        ),
                      ],
                    ),
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
    );
  }
}
