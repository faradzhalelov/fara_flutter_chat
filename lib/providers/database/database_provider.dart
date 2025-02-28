import 'package:fara_chat/data/database/database.dart';
import 'package:fara_chat/data/database/database_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  final database = AppDatabaseImpl();
  
  // Make sure the database is closed when the app is terminated
  ref.onDispose(() {
    database.close();
  });
  
  return database;
}