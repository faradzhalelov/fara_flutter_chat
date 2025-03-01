import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fara_chat/app/theme/colors.dart';
import 'package:fara_chat/app/theme/icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageView extends StatelessWidget {
  const FullScreenImageView({
    required this.imageUrl,
    super.key,
    this.caption,
    this.allowSave = true,
  });

  final String imageUrl;
  final String? caption;
  final bool allowSave;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Основной просмотр с масштабированием
            PhotoView(
              imageProvider: CachedNetworkImageProvider(imageUrl),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
              initialScale: PhotoViewComputedScale.contained,
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              loadingBuilder: (context, event) => Center(
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded /
                          (event.expectedTotalBytes ?? 1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              errorBuilder: (context, error, stackTrace) => const ColoredBox(
                color: Colors.black,
                child: Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 48),
                ),
              ),
            ),

            // Подпись внизу
            if (caption != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent
                      ],
                    ),
                  ),
                  child: Text(
                    caption!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    style: ButtonStyle(
                        fixedSize: const WidgetStatePropertyAll(Size(50, 50)),
                        backgroundColor: const WidgetStatePropertyAll(
                            AppColors.appBackground),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45)))),
                    icon: const Icon(
                      Icomoon.arrowLeftS,
                      color: Colors.black,
                      size: 24,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  if (allowSave)
                    IconButton(
                      style: ButtonStyle(
                          fixedSize: const WidgetStatePropertyAll(Size(50, 50)),
                          backgroundColor: const WidgetStatePropertyAll(
                              AppColors.appBackground),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45)))),
                      icon: const Icon(
                        Icomoon.dowload,
                        color: AppColors.black,
                        size: 24,
                      ),
                      onPressed: () => _saveImage(context),
                    ),
                ],
              ),
            )
          ],
        ),
      );

  // Сохранение изображения на устройство с использованием Dio
  Future<void> _saveImage(BuildContext context) async {
    try {
      // Показываем индикатор загрузки
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Сохранение изображения...'),
          duration: Duration(seconds: 1),
        ),
      );

      // Скачиваем изображение с помощью Dio
      final response = await Dio().get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      // Получаем путь к временной директории
      final tempDir = await getTemporaryDirectory();

      // Генерируем уникальное имя файла
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${tempDir.path}/$fileName';

      // Сохраняем файл
      final file = File(filePath);
      if (response.data != null) {
        await file.writeAsBytes(response.data!);
        // Уведомляем пользователя
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Изображение сохранено как $fileName'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      // Обработка ошибок при сохранении
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при сохранении: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
