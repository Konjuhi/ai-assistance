import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/presentation/screens/chat_screen.dart';
import 'features/presentation/screens/home_screen.dart';
import 'features/presentation/screens/image_generator_screen.dart';
import 'firebase_providers.dart';

class AuthStateChangeNotifier extends ChangeNotifier {
  AuthStateChangeNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      notifyListeners();
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
            path: 'chat',
            builder: (context, state) => const ChatScreen(),
          ),
          GoRoute(
            path: 'image-generation',
            builder: (context, state) => ImageGenerationScreen(),
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
