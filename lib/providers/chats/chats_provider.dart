import 'package:fara_chat/data/repositories/chat_repository.dart';
import 'package:fara_chat/providers/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_provider.g.dart';

/// Provider for the ChatRepository
@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) {
  final database = ref.watch(databaseProvider);
  final repository = ChatRepository(database);
  
  // Initialize repository when first accessed
  repository.initialize();
  
  // Clean up resources when the provider is disposed
  ref.onDispose(() {
    repository.dispose();
  });
  
  return repository;
}