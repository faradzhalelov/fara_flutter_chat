import 'package:fara_chat/providers/chats/chat_info_provider.dart';
import 'package:fara_chat/providers/messages/chat_messages_provider.dart';
import 'package:fara_chat/ui/widgets/chat/chat_bubble.dart';
import 'package:fara_chat/ui/widgets/chat/message_input.dart';
import 'package:fara_chat/ui/widgets/common/error_view.dart';
import 'package:fara_chat/ui/widgets/common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _scrollController = ScrollController();
  String _chatId = '';
  String _chatName = '';
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _chatId = args['chatId'] as String;
        _chatName = args['chatName'] as String? ?? 'chat name';
        _refreshMessages();
      }
    });
  }
  
  Future<void> _refreshMessages() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await ref.read(chatMessagesNotifierProvider(_chatId).notifier).refreshMessages();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error refreshing messages: ${e.toString()}')),
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
  
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    try {
      await ref.read(chatMessagesNotifierProvider(_chatId).notifier).sendMessage(
        content: text,
      );
      
      // Scroll to bottom after sending
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: _chatId.isEmpty
            ? Text(_chatName)
            : Consumer(
                builder: (context, ref, child) {
                  final chatInfoAsync = ref.watch(chatInfoProvider(_chatId));
                  
                  return chatInfoAsync.when(
                    data: (info) {
                      final name = info['name'] as String? ?? _chatName;
                      final isOnline = info['is_online'] as bool? ?? false;
                      
                      return Row(
                        children: [
                          Expanded(child: Text(name, overflow: TextOverflow.ellipsis)),
                          if (isOnline)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      );
                    },
                    loading: () => Text(_chatName),
                    error: (_, __) => Text(_chatName),
                  );
                },
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshMessages,
          ),
        ],
      ),
      body: _chatId.isEmpty
          ? const LoadingIndicator(message: 'Loading chat...')
          : Column(
              children: [
                Expanded(
                  child: _isLoading
                      ? const LoadingIndicator(message: 'Loading messages...')
                      : Consumer(
                          builder: (context, ref, child) {
                            final messagesAsync = ref.watch(chatMessagesNotifierProvider(_chatId));
                            
                            return messagesAsync.when(
                              data: (messages) {
                                if (messages.isEmpty) {
                                  return const Center(child: Text('No messages yet'));
                                }
                                
                                return ListView.builder(
                                  controller: _scrollController,
                                  reverse: true,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final message = messages[index];
                                    
                                    return ChatBubble(message: message);
                                  },
                                );
                              },
                              loading: () => const LoadingIndicator(),
                              error: (error, stack) => ErrorView(
                                message: 'Error loading messages: ${error.toString()}',
                                onRetry: _refreshMessages,
                              ),
                            );
                          },
                        ),
                ),
                MessageInput(
                  onSendMessage: _sendMessage,
                  onAttachFile: () {
                    // Handle file attachment
                  },
                ),
              ],
            ),
    );
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
