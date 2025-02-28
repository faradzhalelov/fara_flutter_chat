// features/chat_list/presentation/components/create_chat_dialog.dart
import 'dart:developer';

import 'package:fara_chat/app/theme/colors.dart';
import 'package:fara_chat/app/theme/icons.dart';
import 'package:fara_chat/app/theme/text_styles.dart';
import 'package:fara_chat/core/supabase/supabase_service.dart';
import 'package:fara_chat/core/utils/extensions/database_extensions.dart';
import 'package:fara_chat/data/database/database.dart';
import 'package:fara_chat/presentation/chat_list/view_model/chat_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to fetch users that don't have active chats with the current user
final availableUsersProvider =
    AutoDisposeFutureProvider<List<User>>((ref) async {
  final currentUser = supabase.auth.currentUser;
  if (currentUser == null) return [];

  try {
    // Get all users except the current one
    final response = await supabase
        .from('users')
        .select(
          'id, username, email, created_at, is_online, avatar_url',
        )
        .neq('id', currentUser.id);

    final allUsers =
        response.map((userData) => userData.toUser()).toList();

    // Get list of users who already have chats with the current user
    final existingChats =
        ref.watch(chatListViewModelProvider).asData?.value ?? [];
    final existingChatUserIds =
        existingChats.map((chat) => chat.$2.id).toSet();

    // Filter out users who already have chats
    return allUsers
        .where((user) => !existingChatUserIds.contains(user.id))
        .toList();
  } catch (e) {
    log('Error fetching available users: $e');
    return [];
  }
});

// Provider for filtering users by search query
final filteredUsersProvider =
    Provider.family<List<User>, String>((ref, query) {
  final usersAsync = ref.watch(availableUsersProvider);

  return usersAsync.when(
    data: (users) {
      if (query.isEmpty) return users;

      final lowercaseQuery = query.toLowerCase();
      return users
          .where(
            (user) =>
                user.username.toLowerCase().contains(lowercaseQuery) ||
                user.email.toLowerCase().contains(lowercaseQuery),
          )
          .toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

class CreateChatDialog extends ConsumerStatefulWidget {
  const CreateChatDialog({super.key});

  @override
  ConsumerState<CreateChatDialog> createState() => _CreateChatDialogState();
}

class _CreateChatDialogState extends ConsumerState<CreateChatDialog> {
  final StateProvider<String> searchProvider =
      StateProvider<String>((ref) => '');
  final StateProvider<User?> selectedUserProvider =
      StateProvider<User?>((ref) => null);
  final AutoDisposeStateProvider<bool> loadingProvider =
      AutoDisposeStateProvider<bool>((ref) => false);

  @override
  Widget build(
    BuildContext context,
  ) {
    final query = ref.watch(searchProvider);
    final isLoading = ref.watch(loadingProvider);
    // Get filtered users based on search query
    final filteredUsers = ref.watch(filteredUsersProvider(query));
    final textFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.divider),
    );
    final usersAsync = ref.watch(availableUsersProvider);
    final selectedUser = ref.watch(selectedUserProvider);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Создать чат',
              style: AppTextStyles.medium.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Search field
            TextField(
              onChanged: (value) =>
                  ref.read(searchProvider.notifier).update((state) => value),
              decoration: InputDecoration(
                hintText: 'Поиск пользователей',
                prefixIcon: const Icon(Icomoon.searchS),
                border: textFieldBorder,
                filled: true,
                fillColor: AppColors.searchBackground,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),

            // User list
            SizedBox(
              height: 300,
              child: usersAsync.when(
                data: (_) {
                  if (filteredUsers.isEmpty) {
                    return _buildEmptyList(query.isNotEmpty);
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      final isSelected = selectedUser?.id == user.id;

                      return _buildUserListItem(
                        user: user,
                        isSelected: isSelected,
                        onTap: () {
                          ref
                              .read(selectedUserProvider.notifier)
                              .update((state) => isSelected ? null : user);
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icomoon.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Ошибка загрузки пользователей',
                        style: AppTextStyles.medium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: AppTextStyles.small.copyWith(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      isLoading ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    'Отмена',
                    style: AppTextStyles.small
                        .copyWith(color: AppColors.attachButton),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: (selectedUser == null || isLoading)
                      ? null
                      : () async {
                          await _createChat(
                            context,
                            ref,
                            selectedUser.id,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Создать чат'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyList(bool hasSearchQuery) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasSearchQuery ? Icomoon.searchS : Icomoon.person,
              size: 48,
              color: AppColors.gray,
            ),
            const SizedBox(height: 16),
            Text(
              hasSearchQuery
                  ? 'Пользователи не найдены'
                  : 'Нет доступных пользователей',
              style: AppTextStyles.medium.copyWith(
                color: AppColors.gray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  Widget _buildUserListItem({
    required User user,
    required bool isSelected,
    required VoidCallback onTap,
  }) =>
      Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: isSelected ? AppColors.searchBackground : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? AppColors.gray : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          leading: CircleAvatar(
            backgroundColor: AppColors.avatarBackground3,
            backgroundImage:
                user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
            child: user.avatarUrl == null
                ? Text(
                    user.username.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
          ),
          title: Text(
            user.username,
            style: AppTextStyles.medium.copyWith(color: AppColors.black),
          ),
          subtitle: Text(
            user.email,
            style: AppTextStyles.small.copyWith(
              color: AppColors.gray,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: AppColors.backButton)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onTap: onTap,
        ),
      );

  Future<void> _createChat(
    BuildContext context,
    WidgetRef ref,
    String userId,
  ) async {
    ref.read(loadingProvider.notifier).update((state) => true);
    try {
      await ref.read(chatListViewModelProvider.notifier).createChat(userId);
      if (context.mounted) {
        // Close dialog
        Navigator.of(context).pop();
      }
    } catch (e) {
      log('Error creating chat: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Не удалось создать чат: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      //ref.read(loadingProvider.notifier).update((state) => false);
    }
  }
}

// Extension method to show create chat dialog
extension CreateChatDialogExtension on BuildContext {
  Future<void> showCreateChatDialog() => showDialog(
        context: this,
        builder: (context) => const CreateChatDialog(),
      );
}
