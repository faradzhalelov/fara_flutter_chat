import 'package:fara_chat/data/models/chat_model.dart';
import 'package:fara_chat/providers/auth/auth_provider.dart';
import 'package:fara_chat/providers/chats/chat_info_provider.dart';
import 'package:fara_chat/providers/chats/chats_provider.dart';
import 'package:fara_chat/ui/widgets/chat/empty_chat_list.dart';
import 'package:fara_chat/ui/widgets/common/error_view.dart';
import 'package:fara_chat/ui/widgets/common/loading_indicator.dart';
import 'package:fara_chat/ui/widgets/common/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _refreshChats();
  }
  
  Future<void> _refreshChats() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await ref.read(chatsNotifierProvider.notifier).refreshChats();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error refreshing chats: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _createNewChat() async {
    // Navigate to user search screen
    final result = await context.pushNamed('user_search');
    
    if (result != null && result is Map<String, dynamic>) {
      final userId = result['user_id'] as String;
      final username = result['username'] as String? ?? '';
      
      try {
        // Create a new chat with selected user
        final chatId = await ref.read(chatsNotifierProvider.notifier)
            .createChat([userId]);
        
        if (!mounted) return;
        await context.pushNamed(
          '/chat',
          queryParameters: {
            'chatId': chatId,
            'chatName': username,
          },
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating chat: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatsAsyncValue = ref.watch(chatsNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshChats,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Loading chats...')
          : RefreshIndicator(
              onRefresh: _refreshChats,
              child: chatsAsyncValue.when(
                data: (chats) {
                  if (chats.isEmpty) {
                    return const EmptyChatList();
                  }
                  
                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      
                      return ProviderScope(
                        overrides: [
                          _currentChatProvider.overrideWithValue(chat),
                        ],
                        child: const ChatListItem(),
                      );
                    },
                  );
                },
                loading: () => const LoadingIndicator(),
                error: (error, stack) => ErrorView(
                  message: 'Error loading chats: ${error.toString()}',
                  onRetry: _refreshChats,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewChat,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Provider for the current chat in the list item
final _currentChatProvider = Provider<ChatModel>((ref) {
  throw UnimplementedError('Provider was not overridden');
});

// Chat list item separated as a component
class ChatListItem extends ConsumerWidget {
  const ChatListItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(_currentChatProvider);
    final chatInfoAsync = ref.watch(chatInfoProvider(chat.id));
    
    return chatInfoAsync.when(
      data: (chatInfo) {
        final displayName = chatInfo['name'] as String? ?? 'Chat';
        final avatarUrl = chatInfo['avatar_url'] as String?;
        final isOnline = chatInfo['is_online']  as bool? ?? false;
        
        return ListTile(
          leading: UserAvatar(
            name: displayName,
            avatarUrl: avatarUrl,
            isOnline: isOnline,
          ),
          title: Text(displayName),
          subtitle: chat.lastMessageText != null
              ? Text(
                  '${chat.isLastMessageMine ? "You: " : ""}${chat.lastMessageText}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : const Text('No messages yet'),
          trailing: chat.lastMessageAt != null
              ? Text(timeago.format(chat.lastMessageAt!))
              : null,
          onTap: () {
            Navigator.of(context).pushNamed(
              '/chat',
              arguments: {
                'chatId': chat.id,
                'chatName': displayName,
              },
            );
          },
        );
      },
      loading: () => const ListTile(
        leading: CircleAvatar(
          child: SizedBox(
            width: 20, 
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        title: Text('Loading...'),
      ),
      error: (error, stack) => ListTile(
        title: Text(chat.name ?? 'Chat'),
        subtitle: Text('Error: ${error.toString()}', maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}