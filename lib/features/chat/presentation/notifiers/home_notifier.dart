import 'package:flutter_riverpod/flutter_riverpod.dart';

@Deprecated(
    'Use direct navigation instead, as HomeOption is no longer needed for managing routes.')
class HomeOption {
  final String title;
  final String route;

  HomeOption({required this.title, required this.route});
}

@Deprecated(
    'Use direct navigation logic instead of managing options in HomeNotifier.')
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
