import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
