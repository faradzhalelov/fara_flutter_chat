import 'dart:async';

import 'package:fara_chat/providers/auth/auth_provider.dart';
import 'package:fara_chat/ui/pages/auth/auth_page.dart';
import 'package:fara_chat/ui/pages/chats/chat_page.dart';
import 'package:fara_chat/ui/pages/chats/chats_list_page.dart';
import 'package:fara_chat/ui/pages/users/user_search_page.dart';
import 'package:fara_chat/ui/widgets/common/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

// Router configuration with GoRouter
@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Handle auth redirects
      final isLoggedIn = authState.value != null;
      final isGoingToLogin = state.matchedLocation == '/login';
      
      // If not logged in and not going to login, redirect to login
      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }
      
      // If logged in and going to login, redirect to home
      if (isLoggedIn && isGoingToLogin) {
        return '/';
      }
      
      // No redirect needed
      return null;
    },
    refreshListenable: GoRouterRefreshStream(ref.read(authNotifierProvider.notifier).authStateChanges()),
    routes: [
      // Home (Chat List)
      GoRoute(
        path: '/',
        name: Routes.home,
        builder: (context, state) => const ChatListPage(),
        routes: [
          // Chat Detail
          GoRoute(
            path: 'chat/:chatId',
            name: Routes.chat,
            builder: (context, state) {
              final chatId = state.pathParameters['chatId']!;
              final chatName = state.extra is Map ? (state.extra! as Map)['chatName'] as String? : null;
              
              return ChatPage(
                chatId: chatId,
                chatName: chatName ?? 'Chat',
              );
            },
          ),
          
          // User Search
          GoRoute(
            path: 'search',
            name: Routes.userSearch,
            builder: (context, state) => const UserSearchPage(),
          ),
        ],
      ),
      
      // Auth
      GoRoute(
        path: '/login',
        name: Routes.login,
        builder: (context, state) => const AuthPage(),
      ),
      
      // Not Found
      GoRoute(
        path: '/not-found',
        name: Routes.notFound,
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Not Found')),
          body: Center(
            child: ErrorView(
              message: 'The page you are looking for does not exist.',
              onRetry: () => context.go('/'),
            ),
          ),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: ErrorView(
          message: state.error.toString(),
          onRetry: () => context.go('/'),
        ),
      ),
    ),
  );
}

// Route names for easier reference
class Routes {
  static const String home = 'home';
  static const String login = 'login';
  static const String chat = 'chat';
  static const String userSearch = 'userSearch';
  static const String notFound = 'notFound';
  
  // Prevent instantiation
  Routes._();
}

// Extension for convenient navigation
extension GoRouterExtension on BuildContext {
  // Navigate to chat screen
  void navigateToChat(String chatId, {String? chatName}) {
    goNamed(
      Routes.chat,
      pathParameters: {'chatId': chatId},
      extra: {'chatName': chatName},
    );
  }
  
  // Navigate to user search screen and handle result
  Future<Map<String, dynamic>?> navigateToUserSearch() async => pushNamed<Map<String, dynamic>?>(Routes.userSearch);
}

// Utility class to make GoRouter listen to auth changes from Riverpod
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}