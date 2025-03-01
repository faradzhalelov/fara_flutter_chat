import 'dart:developer';
import 'dart:io';

import 'package:fara_chat/data/models/message_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

final supabase = Supabase.instance.client;

class SupabaseService {
  static Future<void> initialize() async {
    await dotenv.load(fileName: "assets/supabase/.env");
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw FileNotFoundError();
    }
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: kDebugMode,
    );
  }

  // Upload file
  Future<String?> uploadFile(
    XFile xFile,
    MessageType type,
    String chatId,
  ) async {
    String? attachmentUrl;
    
    // Upload to Supabase
    try {
      final file = File(xFile.path);
      attachmentUrl = await uploadFileToSupabase(file, type, chatId);
    } catch (e) {
      log('uploadFile error:$e');
      rethrow;
    }
    return attachmentUrl;
  }

  Future<String?> uploadFileToSupabase(
    File file,
    MessageType type,
    String chatId,
  ) async {
    try {
      final String bucketName = type.name;
      final String userId = supabase.auth.currentUser?.id ?? 'anonymous';
      final String fileName =
          '${const Uuid().v4()}${path.extension(file.path)}';
      // Include userId in the path to help with RLS policies
      final String filePath = '$userId/$chatId/$fileName';
  
      // Upload to Supabase storage
      await supabase.storage.from(bucketName).upload(
            filePath,
            file,
            fileOptions: const FileOptions(
              // cacheControl: '3600',
              upsert: true,
            ),
          );

      // Get public URL
      final String publicUrl =
          supabase.storage.from(bucketName).getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      debugPrint('Error uploading file: $e');
      // Throw a more descriptive error for debugging
      throw Exception('Storage upload failed: $e');
    }
  }

  Future<void> updateUserStatus({required bool isOnline}) async {
    try {
      // Get current authenticated user
      final user = supabase.auth.currentUser;

      if (user != null) {
        await supabase.from('users').update({
          'is_online': isOnline,
        }).eq('id', user.id);
      }
    } catch (e) {
      // Silently handle errors
      log('Error updating user status: $e');
    }
  }
}
