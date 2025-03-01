import 'package:fara_chat/core/supabase/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_)=> Future.delayed(Durations.long1, ()=> SupabaseService().updateUserStatus(isOnline:  true)));
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
          SupabaseService().updateUserStatus(isOnline:  true);
          break;
        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
        case AppLifecycleState.hidden:
          SupabaseService().updateUserStatus(isOnline:  false);
          break;
      }
    }
  }
  

  @override
  Widget build(BuildContext context) => widget.child;
}
