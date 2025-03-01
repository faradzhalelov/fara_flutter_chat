
// Telegram-style message bubble for image
import 'package:fara_chat/presentation/chat/components/message/image/image_message.dart';
import 'package:flutter/material.dart';

class TelegramStyleImageWidget extends StatelessWidget {
  const TelegramStyleImageWidget({
    required this.imageUrl,
    super.key,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.caption,
    this.adaptiveBackground = true,
    this.adaptiveSize = true,
  });
  final String imageUrl;
  final String? thumbnailUrl;
  final double? width;
  final double? height;
  final String? caption;
  final bool adaptiveBackground;
  final bool adaptiveSize;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SupabaseImageWidget(
                imageUrl: imageUrl,
                thumbnailUrl: thumbnailUrl,
                width: width ??
                    MediaQuery.of(context).size.width -
                        24, // Account for margins
                height: height,
                borderRadius: BorderRadius.zero, // Already handled by ClipRRect
                adaptiveBackground: adaptiveBackground,
                adaptiveSize: adaptiveSize,
                caption: caption,
              ),
            ),
          ],
        ),
      );
}
