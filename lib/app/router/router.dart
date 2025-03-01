// lib/core/router/app_router.dart
import 'dart:developer';

import 'package:fara_chat/app/theme/icons.dart';
import 'package:fara_chat/app/theme/text_styles.dart';
import 'package:fara_chat/core/utils/extensions/database_extensions.dart';
import 'package:fara_chat/presentation/auth/view/login_view.dart';
import 'package:fara_chat/presentation/auth/view/register_view.dart';
import 'package:fara_chat/presentation/chat/components/message/image/fullscreen_image.dart';
import 'package:fara_chat/presentation/chat/view/chat_view.dart';
import 'package:fara_chat/presentation/chat_list/view/chat_list_view.dart';
import 'package:fara_chat/presentation/profile/view/profile_view.dart';
import 'package:fara_chat/presentation/splash/splash_view.dart';
// Import your fullscreen view widget file. Adjust the path as needed.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

final navigatorKey = GlobalKey<NavigatorState>();

/// Router configuration for the app using GoRouter
@riverpod
GoRouter appRouter(Ref ref) => GoRouter(
      initialLocation: '/${SplashView.routePath}',
      debugLogDiagnostics: true,
      navigatorKey: navigatorKey,
      observers: [
        MyNavigatorObserver(),
      ],
      // Error handling
      errorBuilder: (context, state) => ErrorView(state),
      // Define routes
      routes: [
        // Splash screen route - always accessible
        GoRoute(
          path: '/${SplashView.routePath}',
          builder: (context, state) => const SplashView(),
        ),

        // Authentication routes
        GoRoute(
          path: '/${LoginView.routePath}',
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          path: '/${RegisterView.routePath}',
          builder: (context, state) => const RegisterView(),
        ),

        // Main app routes
        GoRoute(
          path: '/',
          builder: (context, state) => const ChatListView(),
        ),
        GoRoute(
          path: '/${ChatView.routePath}/:chatId',
          builder: (context, state) {
            final pathParameters = state.pathParameters;
            final extra = state.extra as Map<String, dynamic>?;
            final chatId = pathParameters['chatId']!;
            final otherUser = extra?['otherUser'] as Map<String, dynamic>?;
            return ChatView(
              chatId: chatId,
              otherUser: otherUser?.toUser(),
            );
          },
        ),
        GoRoute(
          path: '/${ProfileView.routePath}',
          builder: (context, state) => const ProfileView(),
        ),

          // Fullscreen Image View route
        GoRoute(
          path: '/fullscreen',
          builder: (context, state) {
            final args = state.extra! as Map<String, dynamic>;
            return FullScreenImageView(
              imageUrl: args['imageUrl'] as String,
              caption: args['caption'] as String?,
              allowSave: args['allowSave'] as bool,
            );
          },
        ),
      ],
    );

/// Provider for router key to force rebuild when needed
@riverpod
GlobalKey<NavigatorState> routerKey(Ref ref) => GlobalKey<NavigatorState>();

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    log('Pushed route: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    log('Popped route: ${route.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    log('Removed route: ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    log('Replaced route: ${newRoute?.settings.name}');
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView(this.state, {super.key});
  final GoRouterState state;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icomoon.error,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Страница не найдена: ${state.uri.path}',
                style: AppTextStyles.medium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => GoRouter.of(context).go('/'),
                child: const Text('Вернуться на главную'),
              ),
            ],
          ),
        ),
      );
}
