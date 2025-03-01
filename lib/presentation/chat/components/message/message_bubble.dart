// lib/presentation/chat/components/message_bubble.dart
import 'dart:io';

import 'package:fara_chat/app/theme/colors.dart';
import 'package:fara_chat/app/theme/icons.dart';
import 'package:fara_chat/app/theme/text_styles.dart';
import 'package:fara_chat/app/theme/theme.dart';
import 'package:fara_chat/core/constants/ui_constants.dart';
import 'package:fara_chat/core/supabase/supabase_service.dart';
import 'package:fara_chat/data/database/database.dart';
import 'package:fara_chat/data/models/message_type.dart';
import 'package:fara_chat/presentation/chat/components/message/audio_message.dart';
import 'package:fara_chat/presentation/chat/components/message/file_message.dart';
import 'package:fara_chat/presentation/chat/components/message/video_message.dart';
import 'package:flutter/material.dart';

//todo: message bubbles with custom paint, audio bubble, file bubble
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    super.key,
    this.showTail = true,
  });
  final Message message;
  final bool showTail;

  Widget _buildTextWithWidth(
    String text,
    TextStyle style, {
    double maxWidth = 250.0,
    double minWidth = 50.0,
    double padding = 32.0,
  }) {
    // Calculate text width using TextPainter
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    // Layout with constraint
    textPainter.layout(maxWidth: maxWidth - padding);

    // Get the width (clamped between min and max)
    final textWidth = textPainter.width;
    final calculatedWidth = textWidth + padding; // Add padding for bubble
    final finalWidth = calculatedWidth.clamp(minWidth, maxWidth);

    // Return SizedBox with calculated width
    return SizedBox(
      width: finalWidth,
      child: Text(
        text,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bubbleTheme = AppTheme.messageBubbleTheme;
    final userId = supabase.auth.currentUser?.id;
    final isMe = message.userId == userId;
    final messageType = MessageType.values.byName(message.type);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 60 : 12,
          right: isMe ? 12 : 60,
          top: 4,
          bottom: 4,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isMe ? bubbleTheme.myMessageColor : bubbleTheme.otherMessageColor,
          borderRadius: showTail
              ? (isMe
                  ? bubbleTheme.myBorderRadius
                  : bubbleTheme.otherBorderRadius)
              : BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          //mainAxisSize: MainAxisSize.min,
          children: [
            switch (messageType) {
              MessageType.text =>
                message.content != null && message.content!.isNotEmpty
                    ? _buildTextWithWidth(
                        message.content ?? ', ',
                        AppTextStyles.small.copyWith(
                          color: isMe
                              ? bubbleTheme.myMessageTextColor
                              : bubbleTheme.otherMessageTextColor,
                        ),
                      )
                    : kNothing,
              MessageType.image => message.fileUrl != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(message.fileUrl!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    )
                  : kNothing,
              MessageType.video => message.fileUrl != null
                  ? 

                  TelegramStyleVideoPlayer(
  videoUrl: message.fileUrl!,
)
                  
                 
                  : kNothing,
              MessageType.file => message.fileUrl != null
                  ? TelegramStyleFileWidget(
  fileUrl: message.fileUrl!,
  fileName: 'файл',
)

                  : kNothing,
              MessageType.audio => message.fileUrl != null
                  ? 
TelegramStyleAudioPlayer(
  audioUrl: message.fileUrl!,
)
                  : kNothing,
            },

            // Time and read status
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 50),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // const Spacer(),
                    Text(
                      _formatTime(message.createdAt),
                      style: AppTextStyles.extraSmall.copyWith(
                        color: isMe ? AppColors.darkGreen : AppColors.darkGray,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        message.isRead ?? false ? Icomoon.read : Icomoon.unread,
                        size: 14,
                        color: AppColors.darkGreen,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) =>
      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
}
