// features/chat_list/presentation/views/chat_list_view.dart

import 'package:fara_chat/app/theme/colors.dart';
import 'package:fara_chat/app/theme/icons.dart';
import 'package:fara_chat/app/theme/text_styles.dart';
import 'package:fara_chat/data/database/database.dart';
import 'package:fara_chat/presentation/chat_list/components/chat_list_item.dart';
import 'package:fara_chat/presentation/chat_list/components/create_chat_dialog.dart';
import 'package:fara_chat/presentation/chat_list/view_model/chat_list_view_model.dart';
import 'package:fara_chat/presentation/profile/view/profile_view.dart';
import 'package:fara_chat/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatListView extends ConsumerStatefulWidget {
  const ChatListView({super.key});

  @override
  ConsumerState<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends ConsumerState<ChatListView> {
  final focusNode = FocusNode();
  final searchProvider = StateProvider<String>((ref) => '');

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  AsyncValue<List<(Chat,User)>> filteredChatListState(
      String searchQuery, AsyncValue<List<(Chat,User)>> chatListState) {
    final query = searchQuery.toLowerCase();
    
    // Filter by both username and last message content
    final filteredList = chatListState.value!.where((c) {
      final chat = c.$1;
      final user = c.$2;
      final usernameMatch = user.username.toLowerCase().contains(query);
      final lastMessageMatch =
          chat.lastMessageText?.toLowerCase().contains(query) ?? false;

      return usernameMatch || lastMessageMatch;
    }).toList();
    return AsyncValue.data(filteredList);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    //
    final chatListState = ref.watch(chatListViewModelProvider);
    final viewModel = ref.watch(chatListViewModelProvider.notifier);
    //
    final searchQuery = ref.watch(searchProvider);

    // Handle search functionality with memoization to avoid unnecessary rebuilds
    // Now depends on searchQuery.value instead of searchController.text
    final filteredChats = (!chatListState.hasValue || searchQuery.isEmpty)
        ? chatListState
        : filteredChatListState(searchQuery, chatListState);

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: _buildAppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.black,
        onPressed: () async => _showCreateChatDialog(),
        tooltip: 'Создать чат',
        child: const Icon(
          Icomoon.plusS,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          const Divider(color: AppColors.divider),
          _buildChatList(filteredChats, viewModel),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
        backgroundColor: AppColors.appBackground,
        title: Text(
          'Чаты',
          style: AppTextStyles.largeTitle.copyWith(
            color: AppColors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icomoon.person,
              color: AppColors.black,
            ),
            onPressed: () => context.push('/${ProfileView.routePath}'),
            tooltip: 'Перейти в профиль',
          ),
          IconButton(
            icon: const Icon(
              Icomoon.outRight,
              color: AppColors.black,
            ),
            onPressed: () async =>
                ref.read(authStateProvider.notifier).signOut(context),
            tooltip: 'Выйти из аккаунта',
          ),
        ],
        centerTitle: false,
        elevation: 0,
        toolbarHeight: 60,
      );

  Widget _buildSearchBar() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.searchBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            focusNode: focusNode,
            style: AppTextStyles.medium,
            onChanged: (value) =>
                ref.read(searchProvider.notifier).update((state) => value),
            decoration: InputDecoration(
              filled: false,
              hintText: 'Поиск',
              hintStyle: AppTextStyles.medium.copyWith(
                color: AppColors.gray,
              ),
              prefixIcon: const Icon(
                Icomoon.searchS,
                color: AppColors.gray,
                size: 24,
              ),
              suffixIcon: ref.watch(searchProvider).isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.gray),
                      onPressed: () {
                        ref.read(searchProvider.notifier).update((state) => '');
                        focusNode.unfocus();
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 6,
              ),
              border: InputBorder.none,
            ),
            textInputAction: TextInputAction.search,
          ),
        ),
      );

  Widget _buildChatList(
    AsyncValue<List<(Chat, User)>> chatListState,
    ChatListViewModel viewModel,
  ) =>
      Expanded(
        child: chatListState.when(
          data: (chatUserList) {
            if (chatUserList.isEmpty) {
              return _buildEmptyState();
            }
            chatUserList.sort((a, b) {
              final chatA = a.$1;
              final chatB = b.$1;
              final aTime = chatA.lastMessageAt;
              final bTime = chatB.lastMessageAt;
              if (aTime != null && bTime != null) {
                return aTime.compareTo(bTime);
              } else if (aTime != null && bTime == null) {
                return 1;
              } else if (aTime == null && bTime != null) {
                return -1;
              } else {
                return chatB.createdAt.compareTo(chatA.createdAt);
              }
            });
            return _buildChatListItems( chatUserList, viewModel);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => _buildErrorState(error, viewModel),
        ),
      );

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icomoon.message,
              size: 64,
              color: AppColors.gray,
            ),
            const SizedBox(height: 16),
            Text(
              'Нет активных диалогов',
              style: AppTextStyles.medium.copyWith(
                color: AppColors.gray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Начните общение, нажав на + внизу экрана',
              style: AppTextStyles.small.copyWith(
                color: AppColors.gray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  Widget _buildChatListItems(
    List<(Chat, User)> chats,
    ChatListViewModel viewModel,
  ) =>
      RefreshIndicator(
        onRefresh: () => viewModel.refresh(),
        child: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return ChatListItem(
              chatUser: chat,
              onTap: () => context.push('/chat/${chat.$1.id}', extra:  {'otherUser' : chat.$2}),
              onDismissed: (_) =>
                  _handleChatDismissed(chat, viewModel),
            );
          },
        ),
      );

  Widget _buildErrorState(
    Object error,
    ChatListViewModel viewModel,
  ) =>
      Center(
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
                'Ошибка загрузки диалогов',
                style: AppTextStyles.medium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: AppTextStyles.small,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.refresh(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );

  void _handleChatDismissed(
    (Chat, User) chat,
    ChatListViewModel viewModel,
  ) {
    viewModel.deleteChat(chat.$1.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Чат с ${chat.$2.username} удален'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showCreateChatDialog() async => showDialog(
        context: context,
        builder: (dialogContext) => const CreateChatDialog(),
      );
}
