import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SupabaseImageWidget extends StatefulWidget {
  const SupabaseImageWidget({
    required this.imageUrl,
    super.key,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.allowFullscreen = true,
    this.allowSave = true,
    this.allowShare = true,
    this.showLoading = true,
    this.loadingColor = const Color(0xFF2AABEE), // Telegram blue
    this.caption,
    this.compact = true,
    this.messageColor = const Color(0xFFE6EBEE), // Light gray bubble
  });
  final String imageUrl;
  final String? thumbnailUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final bool allowFullscreen;
  final bool allowSave;
  final bool allowShare;
  final bool showLoading;
  final Color loadingColor;
  final String? caption;
  final bool compact;
  final Color messageColor;

  @override
  SupabaseImageWidgetState createState() => SupabaseImageWidgetState();
}

class SupabaseImageWidgetState extends State<SupabaseImageWidget> {
  @override
  Widget build(BuildContext context) =>_buildCompactImage();

  // Compact Telegram-style image
  Widget _buildCompactImage() => Container(
        width: widget.width,
        height: widget.height,
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with tap for fullscreen
            Expanded(
              child: ClipRRect(
                borderRadius: widget.borderRadius,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Main image with loading from cached network image
                  CachedNetworkImage(
                imageUrl: widget.imageUrl,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(widget.loadingColor),
                    strokeWidth: 2,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.red[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
                fadeInDuration: const Duration(milliseconds: 300),
                fit: widget.fit,
              ),
              
              
                    // Tap to view overlay
                    if (widget.allowFullscreen)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Caption if provided
            if (widget.caption != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
                child: Text(
                  widget.caption!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      );
}

// Telegram-style message bubble for image
class TelegramStyleImageWidget extends StatelessWidget {
  const TelegramStyleImageWidget({
    required this.imageUrl,
    super.key,
    this.thumbnailUrl,
    this.width,
    this.height = 200,
    this.caption,
  });
  final String imageUrl;
  final String? thumbnailUrl;
  final double? width;
  final double? height;
  final String? caption;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE6EBEE), // Light gray bubble
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
              ),
            ),
            if (caption != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  caption!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      );
}
