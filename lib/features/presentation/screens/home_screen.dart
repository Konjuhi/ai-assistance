import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../notifiers/home_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(homeProvider);

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
          final option = options[index];
          return Card(
            child: ListTile(
              title: Text(option.title),
              onTap: () {
                context.push(option.route);
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
      ),
    );
  }
}
