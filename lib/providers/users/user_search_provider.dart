import 'package:fara_chat/core/supabase/supabase_service.dart';
import 'package:fara_chat/core/utils/extensions/database_extensions.dart';
import 'package:fara_chat/data/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_search_provider.g.dart';

@riverpod
class UserSearchNotifier extends _$UserSearchNotifier {
  @override
  FutureOr<List<User>> build(String query) async {
    if (query.length < 3) {
      return [];
    }
    
    return await _searchUsers(query);
  }
  
  Future<List<User>> _searchUsers(String query) async {
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
    
    return response.map<User>((user) => user.toUser()).toList();
  }
  
  Future<void> refreshSearch() async {
    ref.invalidateSelf();
  }
}