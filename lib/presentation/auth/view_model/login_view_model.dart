// lib/features/auth/presentation/viewmodel/login_viewmodel.dart
import 'dart:developer';

import 'package:fara_chat/presentation/splash/splash_view.dart';
import 'package:fara_chat/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_view_model.g.dart';

/// ViewModel for the Login screen following MVVM architecture
@riverpod
class LoginViewModel extends _$LoginViewModel {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  LoginState build() {
    ref.onDispose(() {
      emailController.dispose();
      passwordController.dispose();
    });

    return const LoginState();
  }

  /// Toggles password visibility
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// Handles the login process
  Future<void> login(BuildContext context) async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Set loading state
    state = state.copyWith(isLoading: true);

    try {
      // Get form values
      final email = emailController.text.trim();
      final password = passwordController.text;

      // Attempt to sign in
      await ref
          .read(authStateProvider.notifier)
          .signIn(
            email: email,
            password: password,
          )
          .whenComplete(() {
        if (context.mounted) {
          log('go splash');
          context.go('/${SplashView.routePath}');
        }
      });
    } catch (e) {
      log('login error:$e');
      // Set error state
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Ошибка входа: $e',
      );
    }
  }

  /// Resets the error message
  void resetError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  /// Initiates password reset process
  Future<void> resetPassword(String email) async {
    state = state.copyWith(isPasswordResetLoading: true);

    try {
      await ref.read(authStateProvider.notifier).resetPassword(email);
      state = state.copyWith(
        isPasswordResetLoading: false,
        passwordResetSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isPasswordResetLoading: false,
        passwordResetError: 'Ошибка отправки сброса пароля: $e',
      );
    }
  }

  /// Clears password reset status
  void clearPasswordResetStatus() {
    state = state.copyWith(
      passwordResetSuccess: false,
      passwordResetError: null,
    );
  }
}

/// Immutable state class for LoginViewModel
class LoginState {
  const LoginState({
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.errorMessage,
    this.isPasswordResetLoading = false,
    this.passwordResetSuccess = false,
    this.passwordResetError,
  });
  final bool isLoading;
  final bool isPasswordVisible;
  final String? errorMessage;
  final bool isPasswordResetLoading;
  final bool passwordResetSuccess;
  final String? passwordResetError;

  LoginState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    String? errorMessage,
    bool? isPasswordResetLoading,
    bool? passwordResetSuccess,
    String? passwordResetError,
  }) =>
      LoginState(
        isLoading: isLoading ?? this.isLoading,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        errorMessage: errorMessage,
        isPasswordResetLoading:
            isPasswordResetLoading ?? this.isPasswordResetLoading,
        passwordResetSuccess: passwordResetSuccess ?? this.passwordResetSuccess,
        passwordResetError: passwordResetError,
      );
}
