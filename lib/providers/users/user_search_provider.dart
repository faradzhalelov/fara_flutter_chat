import 'package:fara_chat/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_search_provider.g.dart';

@riverpod
class UserSearchNotifier extends _$UserSearchNotifier {
  @override
  FutureOr<List<UserModel>> build(String query) async {
    if (query.length < 3) {
      return [];
    }
    
    return await _searchUsers(query);
  }
  
  Future<List<UserModel>> _searchUsers(String query) async {
    final supabase = Supabase.instance.client;
    final currentUserId = supabase.auth.currentUser?.id;
    
    if (currentUserId == null) {
      return [];
    }
    
    final response = await supabase
        .from('users')
        .select()
        .neq('id', currentUserId) // exclude current user
        .or('username.ilike.%$query%,email.ilike.%$query%')
        .limit(10);
    
    return response.map<UserModel>((user) => UserModel.fromJson(user)).toList();
  }
  
  Future<void> refreshSearch() async {
    ref.invalidateSelf();
  }
}