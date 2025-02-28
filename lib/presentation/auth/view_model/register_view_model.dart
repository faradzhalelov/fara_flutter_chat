// lib/features/auth/presentation/viewmodel/register_viewmodel.dart
import 'dart:developer';

import 'package:fara_chat/core/utils/validators/validators.dart';
import 'package:fara_chat/presentation/splash/splash_view.dart';
import 'package:fara_chat/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_view_model.g.dart';

/// ViewModel for the Register screen following MVVM architecture
@riverpod
class RegisterViewModel extends _$RegisterViewModel {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  RegisterState build() {
    ref.onDispose(() {
      usernameController.dispose();
      emailController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
    });

    return const RegisterState();
  }

  /// Toggles password visibility
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// Toggles confirm password visibility
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
        isConfirmPasswordVisible: !state.isConfirmPasswordVisible);
  }

  /// Validates confirm password field
  String? validateConfirmPassword(String? value) =>
      Validators.validatePasswordConfirmation(value, passwordController.text);

  /// Handles the registration process
  Future<void> register(BuildContext context) async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Set loading state
    state = state.copyWith(isLoading: true);

    try {
      // Get form values
      final username = usernameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text;

      // Attempt to sign up
      await ref.read(authStateProvider.notifier).signUp(
            email: email,
            password: password,
            username: username,
          );
      if (context.mounted) {
        context.go('/${SplashView.routePath}');
      }
    } catch (e) {
      log('register error: $e');
      // Set error state
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Ошибка регистрации: $e',
      );
    }
  }

  /// Resets the error message
  void resetError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }
}

/// Immutable state class for RegisterViewModel
class RegisterState {
  const RegisterState({
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.errorMessage,
  });
  final bool isLoading;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final String? errorMessage;

  RegisterState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    String? errorMessage,
  }) =>
      RegisterState(
        isLoading: isLoading ?? this.isLoading,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        isConfirmPasswordVisible:
            isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
        errorMessage: errorMessage,
      );
}
