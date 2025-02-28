import 'package:fara_chat/data/models/user_model.dart';
import 'package:fara_chat/providers/users/user_search_provider.dart';
import 'package:fara_chat/ui/widgets/common/error_view.dart';
import 'package:fara_chat/ui/widgets/common/loading_indicator.dart';
import 'package:fara_chat/ui/widgets/common/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSearchPage extends ConsumerStatefulWidget {
  const UserSearchPage({super.key});

  @override
  ConsumerState<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends ConsumerState<UserSearchPage> {
  final _searchController = TextEditingController();
  final _debounceDuration = const Duration(milliseconds: 500);
  String _currentQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = true;
    });
    
    Future.delayed(_debounceDuration, () {
      if (mounted && _searchController.text == _currentQuery) {
        setState(() {
          _currentQuery = _searchController.text;
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = _currentQuery;
    final userSearchAsync = query.length >= 3 
        ? ref.watch(userSearchNotifierProvider(query)) 
        : const AsyncValue.data(<UserModel>[]);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Users'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by username or email',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
        ),
      ),
      body: _isSearching
          ? const LoadingIndicator(message: 'Searching...')
          : query.length < 3
              ? const Center(
                  child: Text('Type at least 3 characters to search'),
                )
              : userSearchAsync.when(
                  data: (users) {
                    if (users.isEmpty) {
                      return const Center(
                        child: Text('No users found'),
                      );
                    }
                    
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        
                        return ListTile(
                          leading: UserAvatar(
                            name: user.username,
                            avatarUrl: user.avatarUrl,
                            isOnline: user.isOnline,
                          ),
                          title: Text(user.username),
                          subtitle: Text(user.email),
                          trailing: user.isOnline
                              ? const Icon(Icons.circle, color: Colors.green, size: 12)
                              : null,
                          onTap: () {
                            Navigator.of(context).pop({
                              'user_id': user.id,
                              'username': user.username,
                            });
                          },
                        );
                      },
                    );
                  },
                  loading: () => const LoadingIndicator(),
                  error: (error, stack) => ErrorView(
                    message: 'Error searching users: ${error.toString()}',
                    onRetry: () => ref.read(userSearchNotifierProvider(query).notifier).refreshSearch(),
                  ),
                ),
    );
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}