import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmptyChatList extends StatelessWidget {
  const EmptyChatList({super.key});

  @override
  Widget build(BuildContext context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No chats yet',
          ),
          const SizedBox(height: 8),
          const Text(
            'Start a new conversation!',
          
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Start chat'),
            onPressed: () async => context.pushNamed('/user_search'),
          ),
        ],
      ),
    );
}