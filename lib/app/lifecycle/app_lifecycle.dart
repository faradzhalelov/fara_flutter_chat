// lib/core/lifecycle/app_lifecycle_manager.dart
import 'dart:developer';

import 'package:fara_chat/core/supabase/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A widget that manages app lifecycle events and updates user status
class AppLifecycleManager extends ConsumerStatefulWidget {

  const AppLifecycleManager({
    required this.child, super.key,
  });
  final Widget child;

  @override
  ConsumerState<AppLifecycleManager> createState() => _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends ConsumerState<AppLifecycleManager> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_)=> Future.delayed(Durations.long1, ()=> _updateUserStatus(true)));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Get current authenticated user
    final user = supabase.auth.currentUser;
    
    if (user != null) {
      // Update user status based on app lifecycle
      switch (state) {
        case AppLifecycleState.resumed:
          _updateUserStatus(true);
          break;
        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
        case AppLifecycleState.hidden:
          _updateUserStatus(false);
          break;
      }
    }
  }
  
Future<void> _updateUserStatus(bool isOnline) async {
  try {
    // Get current authenticated user
    final user = supabase.auth.currentUser;
    
    if (user != null) {
      await Supabase.instance.client
        .from('users')
        .update({
          'is_online': isOnline,
        })
        .eq('id', user.id);
    }
  } catch (e) {
    // Silently handle errors
    log('Error updating user status: $e');
  }
}

  @override
  Widget build(BuildContext context) => widget.child;
}
