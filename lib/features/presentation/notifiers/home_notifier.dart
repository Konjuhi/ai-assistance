import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeOption {
  final String title;
  final String route;

  HomeOption({required this.title, required this.route});
}

class HomeNotifier extends StateNotifier<List<HomeOption>> {
  HomeNotifier() : super(_initialOptions);

  static final List<HomeOption> _initialOptions = [
    HomeOption(title: 'AI Chatbot', route: '/chat'),
    HomeOption(title: 'Image Generation', route: '/image-generation'),
  ];
}

final homeProvider =
    StateNotifierProvider<HomeNotifier, List<HomeOption>>((ref) {
  return HomeNotifier();
});
