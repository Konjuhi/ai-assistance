import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/presentation/providers.dart';
import 'features/presentation/screens/chat_screen.dart';
import 'features/presentation/screens/home_screen.dart';
import 'features/presentation/screens/image_generator_screen.dart';
import 'firebase_providers.dart';

class AuthStateChangeNotifier extends ChangeNotifier {
  final ProviderRef ref; // Use ProviderRef

  AuthStateChangeNotifier(this.ref) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        // Clear state on sign out
        ref.read(imageNotifierProvider.notifier).clearState();
        ref.read(chatNotifierProvider.notifier).clearState();
      } else {
        // Reload data for the new user when signed in
        ref.read(imageNotifierProvider.notifier).loadDataForUser(user.uid);
        ref.read(chatNotifierProvider.notifier).loadDataForUser(user.uid);
      }
      notifyListeners();
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = AuthStateChangeNotifier(ref); // Pass the ref

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
