import 'dart:developer';

import 'package:ai_assistant/common/common.dart';
import 'package:ai_assistant/features/chat/presentation/presentation.dart';
import 'package:ai_assistant/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
            path: 'image-generation',
            builder: (context, state) => const ImageGenerationScreen(),
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => ProfileScreen(
              appBar: AppBar(
                title: const Text('Profile'),
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
