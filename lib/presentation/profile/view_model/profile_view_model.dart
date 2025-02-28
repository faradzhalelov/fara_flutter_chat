import 'dart:developer';

import 'package:fara_chat/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_view_model.g.dart';

//todo:
@riverpod
class ProfileViewModel extends _$ProfileViewModel {

  @override
  ProfileViewModel build() => ProfileViewModel();

  String getInitials(String name) {
    if (name.isEmpty) return '';

    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return parts.take(2).map((part) => part[0].toUpperCase()).join();
    } else if (name.length > 1) {
      return name.substring(0, 2).toUpperCase();
    } else {
      return name[0].toUpperCase();
    }
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите имя пользователя';
    }

    if (value.length < 3) {
      return 'Имя должно содержать минимум 3 символа';
    }

    return null;
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await ref.read(authStateProvider.notifier).signOut(context);
      // Router will handle navigation
    } catch (e) {
      log('_signOut error:$e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка выхода из аккаунта: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
