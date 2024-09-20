import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool smooth = false}) {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      if (maxScroll > currentScroll) {
        if (smooth) {
          _scrollController.animateTo(
            maxScroll,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(maxScroll);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider);
    final chatNotifier = ref.read(chatNotifierProvider.notifier);
    final isSendingMessage = chatNotifier.isSendingMessage;

    return Scaffold(
      appBar: AppBar(title: const Text('AI Chatbot')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: chatState.when(
                data: (messages) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                  if (messages.isEmpty) {
                    return const Center(child: Text('No chat history.'));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        leading: Icon(
                          message.sender == 'Bot' ? Icons.laptop : Icons.person,
                        ),
                        title: Text(message.message),
                        subtitle: Text(message.sender),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (e, stack) => Center(child: Text('Error: $e')),
              ),
            ),
            if (isSendingMessage) const LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(controller: _controller),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      final question = _controller.text.trim();
                      if (question.isEmpty) return;
                      _controller.clear();
                      await chatNotifier.sendMessageAndFetchResponse(question);
                      _scrollToBottom(smooth: true);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
