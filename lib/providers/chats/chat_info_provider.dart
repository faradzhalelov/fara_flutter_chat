import 'package:fara_chat/providers/chats/chats_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_info_provider.g.dart';

@riverpod
Future<Map<String, dynamic>> chatInfo(Ref ref, String chatId) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getChatUserInfo(chatId);
}