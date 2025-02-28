// lib/presentation/common/widgets/avatar.dart
import 'package:fara_chat/app/theme/theme.dart';
import 'package:flutter/material.dart';

/// A reusable avatar widget that displays either a user's initials or image.
class UserAvatar extends StatelessWidget {

  const UserAvatar({
    required this.userName, 
    super.key,
    this.avatarUrl,
    this.size,
    this.colorIndex = 0,
  });
  final String userName;
  final String? avatarUrl;
  final double? size;
  final int colorIndex;

  @override
  Widget build(BuildContext context) {
    final avatarTheme = AppTheme.avatarTheme;
    final defaultSize = avatarTheme.size;
    final actualSize = size ?? defaultSize;
    
    // Get the background color from the theme's color list
    final backgroundColor = avatarTheme.defaultBackgroundColors[
      colorIndex % avatarTheme.defaultBackgroundColors.length
    ];
    
    // Extract initials from the username (up to 2 characters)
    final initials = _getInitials(userName);
    
    return Container(
      width: actualSize,
      height: actualSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        image: avatarUrl != null && avatarUrl!.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(avatarUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: avatarUrl == null || avatarUrl!.isEmpty
          ? Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: avatarTheme.textColor,
                  fontSize: avatarTheme.fontSize * (actualSize / defaultSize),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  /// Extracts initials from a username.
  /// Returns up to 2 uppercase characters.
  String _getInitials(String name) {
    if (name.isEmpty) return '';
    
    final nameParts = name.trim().split(' ');
    
    if (nameParts.length >= 2) {
      // Get first letters of first and last name
      return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
    } else if (name.length >= 2) {
      // Get first two letters of single name
      return name.substring(0, 2).toUpperCase();
    } else {
      // Just return the first letter
      return name[0].toUpperCase();
    }
  }
}
