import 'package:fara_chat/core/supabase/supabase_service.dart';
import 'package:fara_chat/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

// Add this method to your existing AuthNotifier class in auth_provider.dart


@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<UserModel?> build() async {
    final session = supabase.auth.currentSession;
    
    if (session == null) return null;
    
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('id', session.user.id)
          .single();
      
      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // This method provides a stream of auth state changes for the router to listen to
Stream<UserModel?> authStateChanges() => supabase.auth.onAuthStateChange.map((event) {
    if (event.session == null) {
      return null;
    }
    _refreshState();
    return state.value;
  });

  
  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      await supabase.from('users').update({
        'is_online': true,
      }).eq('id', Supabase.instance.client.auth.currentUser!.id);
      
      await _refreshState();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> signUp(String email, String password, String username) async {
    state = const AsyncValue.loading();
    
    try {
      await supabase.auth.signUp(
        email: email, 
        password: password,
        data: {'username': username},
      );
      
      // Create user profile in users table
      await supabase.from('users').insert({
        'id': supabase.auth.currentUser!.id,
        'email': email,
        'username': username,
      });
      
      await _refreshState();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    
    try {
      final userId = supabase.auth.currentUser?.id;
      
      if (userId != null) {
        await supabase.from('users').update({
          'is_online': false,
        }).eq('id', userId);
      }
      
      await supabase.auth.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> _refreshState() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      
      if (userId == null) {
        state = const AsyncValue.data(null);
        return;
      }
      
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      
      state = AsyncValue.data(UserModel.fromJson(response));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}