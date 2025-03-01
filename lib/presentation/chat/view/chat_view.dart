import 'package:fara_chat/app/theme/colors.dart';
import 'package:fara_chat/app/theme/icons.dart';
import 'package:fara_chat/app/theme/text_styles.dart';
import 'package:fara_chat/core/supabase/supabase_service.dart';
import 'package:fara_chat/data/database/database.dart';
import 'package:fara_chat/presentation/chat/components/message/date_separator.dart';
import 'package:fara_chat/presentation/chat/components/message/message_bubble.dart';
import 'package:fara_chat/presentation/chat/components/message/message_input.dart';
import 'package:fara_chat/presentation/chat/view_model.dart/chat_view_model.dart';
import 'package:fara_chat/presentation/chat/view_model.dart/messages_view_model.dart';
import 'package:fara_chat/presentation/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_chat/features/chat/presentation/view_model/chat_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({required this.chatId, this.otherUser,super.key});
  final String chatId;
  final User? otherUser;
  static const String routePath = 'chat';

  

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final ScrollController _scrollController = ScrollController();
  late final ChatViewModel viewModel;
  String get chatId => widget.chatId;
  User? get otherUser => widget.otherUser;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(chatViewModelProvider(chatId).notifier);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesStream = ref.watch(messagesViewModelProvider(chatId));
    final userId = supabase.auth.currentUser?.id;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.appBackground,
        foregroundColor: AppColors.appBackground,
        leading: IconButton(
          icon: const Icon(Icomoon.arrowLeftS, color: AppColors.black),
          onPressed: () => context.go('/'),
        ),
        titleSpacing: 0,
        title: otherUser != null
            ? Row(
                children: [
                  UserAvatar(
                    userName: otherUser?.username ?? '',
                    avatarUrl: otherUser?.avatarUrl,
                    size: 50,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        otherUser?.username ?? '',
                        style: AppTextStyles.smallSemiBold.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        otherUser?.isOnline ?? false
                            ? 'В сети'
                            : 'Не в сети', // Online status
                        style: AppTextStyles.extraSmall.copyWith(
                          color: AppColors.darkGray,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : null,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.divider))),
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: messagesStream.when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return Center(
                      child: Text(
                        'Пока нет сообщений',
                        style: AppTextStyles.small.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    );
                  }

                  // Group messages by date
                  final groupedMessages = <DateTime, List<Message>>{};

                  for (final message in messages) {
                    final date = DateTime(
                      message.createdAt.year,
                      message.createdAt.month,
                      message.createdAt.day,
                    );

                    if (!groupedMessages.containsKey(date)) {
                      groupedMessages[date] = [];
                    }

                    groupedMessages[date]!.add(message);
                  }

                  // Flatten grouped messages with date separators
                  final flatList = <dynamic>[];

                  // Sort dates in ascending order
                  final sortedDates = groupedMessages.keys.toList()
                    ..sort((a, b) => a.compareTo(b));

                  for (final date in sortedDates) {
                    final sortedGroupMessages = groupedMessages[date]!
                      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
                    flatList.add(date); // Date separator
                    flatList.addAll(sortedGroupMessages);
                  }

                  // Scroll to bottom on new messages
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: flatList.length,
                    itemBuilder: (context, index) {
                      final item = flatList[index];

                      if (item is DateTime) {
                        return DateSeparator(date: item);
                      } else {
                        final message = item;

                        // Determine if we should show message "tail"
                        bool showTail = true;
                        if (index < flatList.length - 1 &&
                            flatList[index + 1] is! DateTime) {
                          final nextMessage = flatList[index + 1];
                          // If next message is from same sender and within 2 minutes, don't show tail
                          if ((nextMessage as Message).userId == userId &&
                                  (message as Message).userId == userId &&
                              nextMessage.createdAt
                                      .difference(message.createdAt)
                                      .inMinutes <
                                  2) {
                            showTail = false;
                          }
                        }

                        return MessageBubble(
                          message: message as Message,
                          showTail: showTail,
                        );
                      }
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icomoon.error,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ошибка загрузки сообщений',
                          style: AppTextStyles.medium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: null,
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Message input
            MessageInput(chatId: widget.chatId),
          ],
        ),
      ),
    );
  }
}
