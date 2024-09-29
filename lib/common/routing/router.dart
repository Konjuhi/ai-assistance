import 'dart:developer';

import 'package:ai_assistant/common/common.dart';
import 'package:ai_assistant/features/chat/presentation/presentation.dart';
import 'package:ai_assistant/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/presentation/screens/translation_history_screen.dart';
import '../../features/chat/presentation/screens/translation_screen.dart';
import '../functions/show_theme_mode_dialog.dart';

class AuthStateChangeNotifier extends ChangeNotifier {
  AuthStateChangeNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      notifyListeners();
    }, onError: (error) {
      final exception = mapFirebaseAuthException(error);
      log('Auth Error: ${exception.message}');
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = AuthStateChangeNotifier();
  final themeNotifier = ref.read(themeProvider.notifier);
  final themeMode = ref.watch(themeProvider).themeMode;

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final loggingIn = state.location == '/sign-in';

      if (!isLoggedIn && !loggingIn) {
        return '/sign-in';
      }
      if (isLoggedIn && loggingIn) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'chat/:chatId',
            builder: (context, state) {
              final chatId = state.params['chatId'];
              return ChatScreen(chatId: chatId!);
            },
          ),
          GoRoute(
            path: 'translation-history',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const TranslationHistoryScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          ),
          GoRoute(
            path: 'translation',
            builder: (context, state) => const TranslationScreen(),
          ),
          GoRoute(
            path: 'images',
            builder: (context, state) => const ImageGridScreen(),
          ),
          GoRoute(
            path: 'image-generation',
            builder: (context, state) => const ImageGenerationScreen(),
          ),
          GoRoute(
            path: 'imageDetail',
            builder: (context, state) {
              final Map<String, dynamic> extras =
                  state.extra as Map<String, dynamic>;
              return ImageDetailScreen(
                imageUrl: extras['imageUrl'],
                prompt: extras['prompt'],
              );
            },
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => ProfileScreen(
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      showThemeModeDialog(context, themeNotifier, themeMode);
                    },
                  ),
                ],
                title: Text(
                  'Profile',
                  style: context.textTheme.bodyMedium,
                ),
              ),
              providers: authProviders,
              actions: [
                SignedOutAction((context) {
                  context.go('/sign-in');
                }),
              ],
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => SignInScreen(
          providers: authProviders,
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) {
              context.go('/');
            }),
          ],
        ),
      ),
    ],
  );
});
