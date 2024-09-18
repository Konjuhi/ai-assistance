import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> options = [
      {'title': 'AI Chatbot', 'route': '/chat'},
      {'title': 'Image Generation', 'route': '/image-generation'},
    ];

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
        ],
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(options[index]['title']!),
              onTap: () {
                context.push(options[index]['route']!);
              },
            ),
          );
        },
      ),
    );
  }
}
