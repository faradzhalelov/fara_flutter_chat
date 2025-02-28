import 'package:fara_chat/app/app.dart';
import 'package:fara_chat/core/supabase/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //todo: zoneGuard, crash analytics, error handler
  await SupabaseService.initialize();
    runApp(
      const ProviderScope(
        child:  MyApp(),
      ),
    );
}
