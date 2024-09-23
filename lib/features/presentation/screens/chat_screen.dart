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
  bool _initialLoadComplete = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _jumpToBottom() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      _scrollController.jumpTo(maxScroll);
    }
  }

  void _scrollIfNecessary() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      final distanceFromBottom = maxScroll - currentScroll;

      if (distanceFromBottom > 100) {
        _scrollController.animateTo(
          maxScroll,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider);
    final chatNotifier = ref.read(chatNotifierProvider.notifier);
    final isSendingMessage = chatNotifier.isSendingMessage;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('AI Chatbot')),
        body: Column(
          children: [
            if (isSendingMessage) const LinearProgressIndicator(),
            Expanded(
              child: chatState.when(
                data: (messages) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!_initialLoadComplete) {
                      _jumpToBottom();
                      _initialLoadComplete = true;
                    } else {
                      _scrollIfNecessary();
                    }
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

                      final error = await chatNotifier
                          .sendMessageAndFetchResponse(question);

                      if (error != null) {
                        _showErrorDialog(error);
                      } else {
                        _scrollIfNecessary();
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
