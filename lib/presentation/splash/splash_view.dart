
import 'package:fara_chat/app/theme/colors.dart';
import 'package:fara_chat/app/theme/icons.dart';
import 'package:fara_chat/app/theme/text_styles.dart';
import 'package:fara_chat/core/supabase/supabase_service.dart';
import 'package:fara_chat/presentation/auth/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static const String routePath = 'splash';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // await for for the widget to mount
    await Future.delayed(Durations.extralong1, () {});
    final session = supabase.auth.currentSession;
    if (mounted) {
      if (session == null) {
        context.go('/${LoginView.routePath}');
      } else {
        context.go('/');
      }
    }
  }

  @override
  void didUpdateWidget(covariant SplashView oldWidget) {
        _redirect();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Scaffold(
        backgroundColor: AppColors.headerBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.myMessageBubble,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icomoon.messageFill,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),

              // App name
               Text(
                'Flutter Messenger',
                style: AppTextStyles.largeTitle.copyWith(                  color: Colors.white,
),
                
               
              ),
              const SizedBox(height: 16),

              // Tagline
               Text(
                'Общайтесь без границ',
                style: AppTextStyles.medium.copyWith(                  color: Colors.white70,
),
               
              ),
              const SizedBox(height: 48),

              // Always show loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      );
}
