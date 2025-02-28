import 'package:fara_chat/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<UserModel?> build() async {
    final supabase = Supabase.instance.client;
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
  
  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      await Supabase.instance.client.from('users').update({
        'is_online': true,
      }).eq('id', Supabase.instance.client.auth.currentUser!.id);
      
      _refreshState();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> signUp(String email, String password, String username) async {
    state = const AsyncValue.loading();
    
    try {
      await Supabase.instance.client.auth.signUp(
        email: email, 
        password: password,
        data: {'username': username},
      );
      
      // Create user profile in users table
      await Supabase.instance.client.from('users').insert({
        'id': Supabase.instance.client.auth.currentUser!.id,
        'email': email,
        'username': username,
      });
      
      _refreshState();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      
      if (userId != null) {
        await Supabase.instance.client.from('users').update({
          'is_online': false,
        }).eq('id', userId);
      }
      
      await Supabase.instance.client.auth.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> _refreshState() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      
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