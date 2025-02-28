import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  
  const UserAvatar({
    required this.name, super.key,
    this.avatarUrl,
    this.isOnline = false,
    this.size = 40,
  });
  final String name;
  final String? avatarUrl;
  final bool isOnline;
  final double size;

  @override
  Widget build(BuildContext context) => Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          backgroundColor: avatarUrl == null 
              ? Theme.of(context).primaryColor
              : null,
          child: avatarUrl == null
              ? Text(
                  _getInitials(name),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  
  String _getInitials(String name) {
    if (name.isEmpty) return '';
    
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    
    return name.substring(0, 1).toUpperCase();
  }
}