import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';

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
  bool _isLoading = false;
  final Dio _dio = Dio();
  @override
  Widget build(BuildContext context) =>
      widget.compact ? _buildCompactImage() : _buildDetailedImage();

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
              child: InkWell(
                onTap: widget.allowFullscreen ? _openFullscreen : null,
                child: ClipRRect(
                  borderRadius: widget.borderRadius,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Main image with loading from cached network image
                      CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        placeholder: (context, url) => widget.showLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(widget.loadingColor),
                                  strokeWidth: 2,
                                ),
                              )
                            : Container(),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.red[300],
                          child: const Icon(Icons.broken_image,
                              color: Colors.grey),
                        ),
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

  // More detailed image widget with buttons
  Widget _buildDetailedImage() => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: widget.borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with tap for fullscreen
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Main image
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: widget.borderRadius.topLeft,
                      topRight: widget.borderRadius.topRight,
                    ),
                    child: GestureDetector(
                      onTap: widget.allowFullscreen ? _openFullscreen : null,
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        placeholder: (context, url) => widget.showLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      widget.loadingColor),
                                ),
                              )
                            : Container(),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image,
                                color: Colors.grey, size: 48),
                          ),
                        ),
                        fit: widget.fit,
                      ),
                    ),
                  ),

                  // Loading overlay during download
                  if (_isLoading)
                    ColoredBox(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Bottom section with caption and controls
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: widget.borderRadius.bottomLeft,
                  bottomRight: widget.borderRadius.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Caption if provided
                  if (widget.caption != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        widget.caption!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.allowFullscreen)
                        IconButton(
                          icon: const Icon(Icons.fullscreen),
                          onPressed: _openFullscreen,
                          tooltip: 'View fullscreen',
                          color: widget.loadingColor,
                          iconSize: 20,
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                      const SizedBox(width: 8),
                      if (widget.allowSave)
                        IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: _saveImage,
                          tooltip: 'Save to gallery',
                          color: widget.loadingColor,
                          iconSize: 20,
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                      const SizedBox(width: 8),
                      if (widget.allowShare)
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: _shareImage,
                          tooltip: 'Share',
                          color: widget.loadingColor,
                          iconSize: 20,
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  // Open image in fullscreen view
  void _openFullscreen() {
    context.push(
      '/fullscreen',
      extra: {
        'imageUrl': widget.imageUrl,
        'caption': widget.caption,
        'allowSave': widget.allowSave,
        'allowShare': widget.allowShare,
        'loadingColor': widget.loadingColor,
      },
    );
  }

  // Save image to device gallery
  Future<void> _saveImage() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Request storage permission
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (status != PermissionStatus.granted) {
          throw Exception('Storage permission not granted');
        }
      }

      // Create a temporary file
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/temp_image.jpg';

      // Download the image
      await _dio.download(widget.imageUrl, path);

      // Save to gallery
      await ImageGallerySaver.saveFile(path);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image saved to gallery')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Share image with other apps
  Future<void> _shareImage() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Create a temporary file
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/share_image.jpg';

      // Download the image
      await _dio.download(widget.imageUrl, path);

      // Share the file
      await Share.shareXFiles([XFile(path)]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share image: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

// Fullscreen image viewer implementation
class FullscreenImageView extends StatefulWidget {
  const FullscreenImageView({
    required this.imageUrl,
    required this.loadingColor,
    super.key,
    this.caption,
    this.allowSave = true,
    this.allowShare = true,
  });
  final String imageUrl;
  final String? caption;
  final bool allowSave;
  final bool allowShare;
  final Color loadingColor;

  @override
  FullscreenImageViewState createState() => FullscreenImageViewState();
}

class FullscreenImageViewState extends State<FullscreenImageView> {
  bool _isLoading = false;
  final Dio _dio = Dio();
  bool _showControls = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            setState(() {
              _showControls = !_showControls;
            });
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Photo view for zooming and panning
              PhotoView(
                imageProvider: CachedNetworkImageProvider(widget.imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                loadingBuilder: (context, event) => Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(widget.loadingColor),
                    value: event == null || event.expectedTotalBytes == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                  ),
                ),
                backgroundDecoration: const BoxDecoration(color: Colors.black),
              ),

              // Top bar with back button
              if (_showControls)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title:
                        widget.caption != null ? Text(widget.caption!) : null,
                  ),
                ),

              // Bottom bar with actions
              if (_showControls)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (widget.allowSave)
                          IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: _saveImage,
                            tooltip: 'Save to gallery',
                            color: Colors.white,
                            iconSize: 28,
                          ),
                        if (widget.allowShare)
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: _shareImage,
                            tooltip: 'Share',
                            color: Colors.white,
                            iconSize: 28,
                          ),
                      ],
                    ),
                  ),
                ),

              // Loading overlay
              if (_isLoading)
                ColoredBox(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

  // Save image to device gallery
  Future<void> _saveImage() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Request storage permission
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (status != PermissionStatus.granted) {
          throw Exception('Storage permission not granted');
        }
      }

      // Create a temporary file
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/temp_image.jpg';

      // Download the image
      await _dio.download(widget.imageUrl, path);

      // Save to gallery
      await ImageGallerySaver.saveFile(path);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image saved to gallery')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Share image with other apps
  Future<void> _shareImage() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Create a temporary file
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/share_image.jpg';

      // Download the image
      await _dio.download(widget.imageUrl, path);

      // Share the file
      await Share.shareXFiles([XFile(path)]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share image: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
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

// Multiple Image Grid (for handling multiple images like Telegram)
class SupabaseImageGrid extends StatelessWidget {
  const SupabaseImageGrid({
    required this.imageUrls,
    super.key,
    this.spacing = 2.0,
    this.height = 200.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.allowFullscreen = true,
  });
  final List<String> imageUrls;
  final double spacing;
  final double height;
  final BorderRadius borderRadius;
  final bool allowFullscreen;

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return Container();
    if (imageUrls.length == 1) {
      return SupabaseImageWidget(
        imageUrl: imageUrls[0],
        height: height,
        borderRadius: borderRadius,
        allowFullscreen: allowFullscreen,
      );
    }

    return SizedBox(
      height: height,
      child: _buildGrid(context),
    );
  }

  Widget _buildGrid(BuildContext context) {
    switch (imageUrls.length) {
      case 2:
        return Row(
          children: [
            Expanded(
              child: SupabaseImageWidget(
                imageUrl: imageUrls[0],
                borderRadius: BorderRadius.only(
                  topLeft: borderRadius.topLeft,
                  bottomLeft: borderRadius.bottomLeft,
                ),
                allowFullscreen: allowFullscreen,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: SupabaseImageWidget(
                imageUrl: imageUrls[1],
                borderRadius: BorderRadius.only(
                  topRight: borderRadius.topRight,
                  bottomRight: borderRadius.bottomRight,
                ),
                allowFullscreen: allowFullscreen,
              ),
            ),
          ],
        );
      case 3:
        return Row(
          children: [
            Expanded(
              child: SupabaseImageWidget(
                imageUrl: imageUrls[0],
                borderRadius: BorderRadius.only(
                  topLeft: borderRadius.topLeft,
                  bottomLeft: borderRadius.bottomLeft,
                ),
                allowFullscreen: allowFullscreen,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: SupabaseImageWidget(
                      imageUrl: imageUrls[1],
                      borderRadius: BorderRadius.only(
                        topRight: borderRadius.topRight,
                      ),
                      allowFullscreen: allowFullscreen,
                    ),
                  ),
                  SizedBox(height: spacing),
                  Expanded(
                    child: SupabaseImageWidget(
                      imageUrl: imageUrls[2],
                      borderRadius: BorderRadius.only(
                        bottomRight: borderRadius.bottomRight,
                      ),
                      allowFullscreen: allowFullscreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case 4:
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SupabaseImageWidget(
                      imageUrl: imageUrls[0],
                      borderRadius: BorderRadius.only(
                        topLeft: borderRadius.topLeft,
                      ),
                      allowFullscreen: allowFullscreen,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: SupabaseImageWidget(
                      imageUrl: imageUrls[1],
                      borderRadius: BorderRadius.only(
                        topRight: borderRadius.topRight,
                      ),
                      allowFullscreen: allowFullscreen,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SupabaseImageWidget(
                      imageUrl: imageUrls[2],
                      borderRadius: BorderRadius.only(
                        bottomLeft: borderRadius.bottomLeft,
                      ),
                      allowFullscreen: allowFullscreen,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: SupabaseImageWidget(
                      imageUrl: imageUrls[3],
                      borderRadius: BorderRadius.only(
                        bottomRight: borderRadius.bottomRight,
                      ),
                      allowFullscreen: allowFullscreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        // For more than 4 images, show the first 4 and an overlay indicating more
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SupabaseImageWidget(
                      imageUrl: imageUrls[0],
                      borderRadius: BorderRadius.only(
                        topLeft: borderRadius.topLeft,
                      ),
                      allowFullscreen: allowFullscreen,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: SupabaseImageWidget(
                      imageUrl: imageUrls[1],
                      borderRadius: BorderRadius.only(
                        topRight: borderRadius.topRight,
                      ),
                      allowFullscreen: allowFullscreen,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SupabaseImageWidget(
                      imageUrl: imageUrls[2],
                      borderRadius: BorderRadius.only(
                        bottomLeft: borderRadius.bottomLeft,
                      ),
                      allowFullscreen: allowFullscreen,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        SupabaseImageWidget(
                          imageUrl: imageUrls[3],
                          borderRadius: BorderRadius.only(
                            bottomRight: borderRadius.bottomRight,
                          ),
                          allowFullscreen: false,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomRight: borderRadius.bottomRight,
                          ),
                          child: Material(
                            color: Colors.black.withOpacity(0.5),
                            child: InkWell(
                              onTap: allowFullscreen
                                  ? () => _openGallery(context, imageUrls, 3)
                                  : null,
                              child: Center(
                                child: Text(
                                  '+${imageUrls.length - 4}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  void _openGallery(
      BuildContext context, List<String> images, int initialIndex) {
    context.push(
      '/gallery',
      extra: {
        'galleryItems': images,
        'initialIndex': initialIndex,
      },
    );
  }
}

// Fullscreen gallery for multiple images
class FullscreenGallery extends StatefulWidget {
  const FullscreenGallery({
    required this.galleryItems,
    super.key,
    this.initialIndex = 0,
  });
  final List<String> galleryItems;
  final int initialIndex;

  @override
  FullscreenGalleryState createState() => FullscreenGalleryState();
}

class FullscreenGalleryState extends State<FullscreenGallery> {
  late int currentIndex;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            setState(() {
              _showControls = !_showControls;
            });
          },
          child: Stack(
            children: [
              // Photo view gallery
              PhotoViewGallery.builder(
                itemCount: widget.galleryItems.length,
                builder: (context, index) => PhotoViewGalleryPageOptions(
                  imageProvider:
                      CachedNetworkImageProvider(widget.galleryItems[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                ),
                scrollPhysics: const BouncingScrollPhysics(),
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                pageController:
                    PageController(initialPage: widget.initialIndex),
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                loadingBuilder: (context, event) => Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    value: event == null || event.expectedTotalBytes == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                  ),
                ),
              ),

              // Controls
              if (_showControls)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: Text(
                        '${currentIndex + 1} / ${widget.galleryItems.length}'),
                  ),
                ),
            ],
          ),
        ),
      );
}
