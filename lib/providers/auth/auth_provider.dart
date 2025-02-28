// lib/core/services/auth_service.dart
import 'dart:developer';
import 'dart:io';

import 'package:fara_chat/core/supabase/supabase_service.dart';
import 'package:fara_chat/data/database/database.dart';
import 'package:fara_chat/presentation/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

part 'auth_provider.g.dart';

/// Provider for auth state to manage authentication
@riverpod
class AuthState extends _$AuthState {
  @override
  AsyncValue<supabase_flutter.User?> build() {
    // Начинаем с попытки получить текущего пользователя
    final currentUser = supabase.auth.currentUser;

    // Если пользователь уже есть, возвращаем его немедленно
    if (currentUser != null) {
      return AsyncData(currentUser);
    }

    // Подписываемся на изменения состояния аутентификации
    supabase.auth.onAuthStateChange.listen(
      (event) {
        // Обновляем состояние только при реальных изменениях
        if (event.event == supabase_flutter.AuthChangeEvent.signedIn) {
          state = AsyncData(event.session?.user);
        } else if (event.event == supabase_flutter.AuthChangeEvent.signedOut) {
          state = const AsyncData(null);
        }
      },
      onError: (e) {
        state = AsyncError(e as Object, StackTrace.current);
      },
    );

    // Возвращаем начальное состояние
    return const AsyncLoading();
  }

  /// Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    log('signIn start');
    state = const AsyncLoading();

    try {
      final response = await supabase.auth
          .signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        state = AsyncData(response.user);
        log('signIn response success:${response.user}');
      } else {
        state = AsyncError(
          'Failed to sign in: No user returned',
          StackTrace.current,
        );
        throw const supabase_flutter.AuthException(
          'Ошибка авторизации: Пользователь не найден',
        );
      }
    } catch (e, stackTrace) {
      state = AsyncError(_handleAuthError(e), stackTrace);
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    state = const AsyncLoading();

    try {
      final response =
          await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      if (response.user != null) {
        // Create user profile in the users table
        await supabase.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'username': username,
          'created_at': DateTime.now().toIso8601String(),
        });

        state = AsyncData(response.user);
      } else {
        state = AsyncError(
          'Failed to sign up: No user returned',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncError(_handleAuthError(e), stackTrace);
      rethrow;
    }
  }

  /// Sign out the current user
  Future<void> signOut(BuildContext context) async {
    state = const AsyncLoading();
    try {
      await supabase.auth
          .signOut()
          .whenComplete(() {
        state = const AsyncData(null);
        if (context.mounted) {
          context.go('/${SplashView.routePath}');
        }
      });
    } catch (e, stackTrace) {
      state = AsyncError(_handleAuthError(e), stackTrace);
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();

    try {
      await supabase.auth
          .resetPasswordForEmail(email);
      state = state; // Keep the current state
    } catch (e, stackTrace) {
      state = AsyncError(_handleAuthError(e), stackTrace);
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    required String username,
    File? avatarFile,
  }) async {
    state = const AsyncLoading();

    try {
      final user = state.valueOrNull;
      if (user == null) {
        state = AsyncError('Not authenticated', StackTrace.current);
        return;
      }

      String? avatarUrl;

      // Upload avatar if provided
      if (avatarFile != null) {
        final fileExt = path.extension(avatarFile.path);
        final fileName = '${user.id}$fileExt';

        await supabase.storage
            .from('avatars')
            .upload(
              fileName,
              avatarFile,
              fileOptions: const supabase_flutter.FileOptions(upsert: true),
            );

        avatarUrl = supabase.storage
            .from('avatars')
            .getPublicUrl(fileName);
      }

      // Update user profile
      await supabase.from('users').update({
        'username': username,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      }).eq('id', user.id);

      // Return the current user
      state = AsyncData(user);
    } catch (e, stackTrace) {
      state = AsyncError(_handleAuthError(e), stackTrace);
    }
  }

  /// Helper method to handle auth errors
  String _handleAuthError(dynamic error) {
    if (error is supabase_flutter.AuthException) {
      return 'Authentication error: ${error.message}';
    } else {
      return 'Unexpected error: $error';
    }
  }
}

/// Provider for current user profile data
@riverpod
Future<User> userProfile(Ref ref) async {
  final user = supabase.auth.currentUser;

  if (user == null) {
    throw Exception('Not authenticated');
  }

  try {
    final response = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .single();

    return User.fromJson(response);
  } catch (e) {
    throw Exception('Failed to load user profile: $e');
  }
}
