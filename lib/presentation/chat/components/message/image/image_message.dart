import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:palette_generator/palette_generator.dart';

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
    this.adaptiveBackground = true,
    this.adaptiveSize = true,
    this.maxHeight = 400.0,
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
  final bool adaptiveBackground;
  final bool adaptiveSize;
  final double maxHeight;

  @override
  SupabaseImageWidgetState createState() => SupabaseImageWidgetState();
}

class SupabaseImageWidgetState extends State<SupabaseImageWidget> {
  Color _backgroundColor = const Color(0xFFE6EBEE); // Начальный цвет фона
  Size? _imageSize; // Размер изображения
  final GlobalKey _imageKey = GlobalKey(); // Ключ для измерения размера

  @override
  void initState() {
    super.initState();
    if (widget.adaptiveBackground) {
      _extractDominantColor();
    }
  }

  // Извлечение доминантного цвета из изображения
  Future<void> _extractDominantColor() async {
    try {
      // Используем стандартный NetworkImage вместо CachedNetworkImageProvider
      // чтобы избежать проблем с инициализацией
      final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(widget.imageUrl),
        size: const Size(100, 100), // Меньший размер для быстрого анализа
      );

      if (mounted) {
        setState(() {
          if (paletteGenerator.dominantColor != null) {
            _backgroundColor = paletteGenerator.dominantColor!.color.withOpacity(0.3);
          } else if (paletteGenerator.vibrantColor != null) {
            // Пробуем яркий цвет как запасной вариант
            _backgroundColor = paletteGenerator.vibrantColor!.color.withOpacity(0.3);
          }
        });
      }
    } catch (e) {
      debugPrint('Ошибка при получении цвета: $e');
      // Ошибка при получении цвета
      if (mounted) {
        setState(() {
        });
      }
    }
  }

  // Функция для получения размера изображения
  Future<void> _getImageSize() async {
    try {
      final image = NetworkImage(widget.imageUrl);
      final completer = Completer<ImageInfo>();
      
      final listener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          if (!completer.isCompleted) {
            completer.complete(info);
          }
        },
        onError: (dynamic exception, StackTrace? stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(exception as Object, stackTrace);
          }
        },
      );
      
      final stream = image.resolve(ImageConfiguration.empty);
      stream.addListener(listener);
      
      final imageInfo = await completer.future;
      stream.removeListener(listener);
      
      if (mounted) {
        setState(() {
          final double aspectRatio = imageInfo.image.width / imageInfo.image.height;
          
          // Получаем ширину контекста безопасно
          final double contextWidth = MediaQuery.of(context).size.width;
          
          // Определяем размер на основе соотношения сторон
          double calculatedWidth = widget.width ?? contextWidth * 0.8;
          double calculatedHeight = calculatedWidth / aspectRatio;
          
          // Ограничиваем высоту максимальным значением
          if (calculatedHeight > widget.maxHeight) {
            calculatedHeight = widget.maxHeight;
            calculatedWidth = calculatedHeight * aspectRatio;
          }
          
          _imageSize = Size(calculatedWidth, calculatedHeight);
        });
      }
    } catch (e) {
      debugPrint('Ошибка при получении размера изображения: $e');
      // В случае ошибки используем дефолтный размер
      if (mounted) {
        setState(() {
          _imageSize = Size(
            widget.width ?? MediaQuery.of(context).size.width * 0.8,
            widget.height ?? 250.0
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Запускаем получение размера изображения при первой сборке
    if (widget.adaptiveSize && _imageSize == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _getImageSize();
        }
      });
    }
    
    return _buildCompactImage();
  }

  // Открытие просмотра на весь экран
  void _openFullScreenView() {
  context.push(
    '/fullscreen',
    extra: {
      'imageUrl': widget.imageUrl,
      'caption': widget.caption,
      'allowSave': widget.allowSave,
    },
  );
}


  // Compact Telegram-style image
  Widget _buildCompactImage() {
    // Определяем размеры контейнера
    final double containerWidth = widget.adaptiveSize && _imageSize != null 
        ? _imageSize!.width 
        : (widget.width ?? 50.0); // Дефолтная ширина если нет других размеров
        
    final double containerHeight = widget.adaptiveSize && _imageSize != null 
        ? _imageSize!.height 
        : (widget.height ?? 50.0); // Дефолтная высота если нет других размеров
    
    // Высота для изображения (с учетом подписи)
    final double imageHeight = widget.caption != null 
        ? containerHeight - 20 // Вычитаем примерную высоту подписи
        : containerHeight;
        
    return Container(
      width: containerWidth,
      height: containerHeight,
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: widget.adaptiveBackground ? _backgroundColor : widget.messageColor,
        borderRadius: widget.borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Важно для предотвращения ошибки flex в неограниченном пространстве
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with tap for fullscreen (без Expanded)
          SizedBox(
            height: imageHeight,
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Main image with loading from cached network image
                  GestureDetector(
                    onTap: () => _openFullScreenView(),
                    child: CachedNetworkImage(
                      key: _imageKey,
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
                  ),
                  
                  // Tap to view overlay
                  if (widget.allowFullscreen)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _openFullScreenView(),
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
}
