import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SupabaseFileWidget extends StatefulWidget {

  const SupabaseFileWidget({
    required this.fileUrl, required this.fileName, super.key,
    this.fileType,
    this.fileSize,
    this.compact = true,
    this.primaryColor = const Color(0xFF2AABEE), // Telegram blue
    this.secondaryColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.customIcon,
    this.onTap,
    this.onLongPress,
    this.showOpenButton = true,
    this.showDownloadButton = true,
  });
  final String fileUrl;
  final String fileName;
  final String? fileType;
  final String? fileSize;
  final bool compact;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final IconData? customIcon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showOpenButton;
  final bool showDownloadButton;

  @override
  _SupabaseFileWidgetState createState() => _SupabaseFileWidgetState();
}

class _SupabaseFileWidgetState extends State<SupabaseFileWidget> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _downloadedFilePath;
  final Dio _dio = Dio();
  bool _fileExists = false;

  @override
  void initState() {
    super.initState();
    _checkIfFileExists();
  }

  // Get the appropriate icon based on file type
  IconData _getFileIcon() {
    if (widget.customIcon != null) {
      return widget.customIcon!;
    }

    final extension = widget.fileName.split('.').last.toLowerCase();
    final mimeType = widget.fileType ?? lookupMimeType(widget.fileName) ?? '';

    if (mimeType.startsWith('image/')) {
      return Icons.image;
    } else if (mimeType.startsWith('video/')) {
      return Icons.video_file;
    } else if (mimeType.startsWith('audio/')) {
      return Icons.audio_file;
    } else if (extension == 'pdf') {
      return Icons.picture_as_pdf;
    } else if (extension == 'doc' || extension == 'docx') {
      return Icons.description;
    } else if (extension == 'xls' || extension == 'xlsx') {
      return Icons.table_chart;
    } else if (extension == 'ppt' || extension == 'pptx') {
      return Icons.slideshow;
    } else if (extension == 'zip' || extension == 'rar' || extension == '7z') {
      return Icons.archive;
    } else if (extension == 'txt' || extension == 'md') {
      return Icons.article;
    } else {
      return Icons.insert_drive_file;
    }
  }

  // Format file size for display
  String _formatFileSize(String? size) {
    if (size == null) return '';
    
    try {
      final sizeInBytes = int.parse(size);
      const kb = 1024;
      const mb = kb * 1024;
      const gb = mb * 1024;
      
      if (sizeInBytes < kb) {
        return '$sizeInBytes B';
      } else if (sizeInBytes < mb) {
        return '${(sizeInBytes / kb).toStringAsFixed(1)} KB';
      } else if (sizeInBytes < gb) {
        return '${(sizeInBytes / mb).toStringAsFixed(1)} MB';
      } else {
        return '${(sizeInBytes / gb).toStringAsFixed(1)} GB';
      }
    } catch (e) {
      // If size isn't a valid number, return as is
      return size;
    }
  }

  // Check if file already exists in downloads
  Future<void> _checkIfFileExists() async {
    try {
      final downloadsDir = await _getDownloadsDirectory();
      final filePath = '${downloadsDir.path}/${widget.fileName}';
      final file = File(filePath);
      
      setState(() {
        _fileExists = file.existsSync();
        if (_fileExists) {
          _downloadedFilePath = filePath;
        }
      });
    } catch (e) {
      debugPrint('Error checking if file exists: $e');
    }
  }

  // Get the downloads directory
  Future<Directory> _getDownloadsDirectory() async {
    Directory? directory;
    
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      // Fallback to app's documents directory if can't access downloads
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      }
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      // For desktop platforms
      directory = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
    }
    
    return directory;
  }

  // Request storage permissions (for Android)
  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // iOS doesn't need explicit permission for app documents
  }

  // Download the file
  Future<void> _downloadFile() async {
    if (_isDownloading) return;
    
    final hasPermission = await _requestPermissions();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
      return;
    }
    
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });
    
    try {
      final downloadsDir = await _getDownloadsDirectory();
      await downloadsDir.create(recursive: true);
      
      final filePath = '${downloadsDir.path}/${widget.fileName}';
      
      await _dio.download(
        widget.fileUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );
      
      setState(() {
        _isDownloading = false;
        _downloadedFilePath = filePath;
        _fileExists = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File downloaded successfully')),
      );
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: ${e.toString()}')),
      );
    }
  }

  // Open the file with native apps
  Future<void> _openFile() async {
    if (_downloadedFilePath == null) {
      // Download first if file doesn't exist locally
      await _downloadFile();
      if (_downloadedFilePath == null) return;
    }
    
    try {
      final result = await OpenFile.open(_downloadedFilePath!);
      
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open file: ${result.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening file: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.compact
        ? _buildCompactFileWidget()
        : _buildDetailedFileWidget();

  // Compact Telegram-style file widget
  Widget _buildCompactFileWidget() => DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap ?? _openFile,
          onLongPress: widget.onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // File icon with circle background
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: _isDownloading
                      ? CircularProgressIndicator(
                          value: _downloadProgress > 0 ? _downloadProgress : null,
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
                        )
                      : Icon(
                          _getFileIcon(),
                          color: widget.primaryColor,
                          size: 24,
                        ),
                ),
                
                const SizedBox(width: 12),
                
                // File name and size
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.fileName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.fileSize != null)
                        Text(
                          _formatFileSize(widget.fileSize),
                          style: TextStyle(
                            color: widget.secondaryColor,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Action buttons
                if (!_isDownloading) ...[
                  if (widget.showDownloadButton && (!_fileExists || _downloadedFilePath == null))
                    IconButton(
                      icon: Icon(Icons.download, color: widget.primaryColor, size: 22),
                      onPressed: _downloadFile,
                      tooltip: 'Download',
                      constraints: const BoxConstraints(maxWidth: 32, maxHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                  if (widget.showOpenButton && _fileExists && _downloadedFilePath != null)
                    IconButton(
                      icon: Icon(Icons.open_in_new, color: widget.primaryColor, size: 22),
                      onPressed: _openFile,
                      tooltip: 'Open',
                      constraints: const BoxConstraints(maxWidth: 32, maxHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

  // Detailed file widget with more info
  Widget _buildDetailedFileWidget() => DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with icon and file name
                Row(
                  children: [
                    // File icon with circle background
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: widget.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getFileIcon(),
                        color: widget.primaryColor,
                        size: 28,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // File name and type
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.fileName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.fileType ?? path.extension(widget.fileName).toUpperCase().replaceAll('.', ''),
                            style: TextStyle(
                              color: widget.secondaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Size if available
                if (widget.fileSize != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.data_usage,
                          color: widget.secondaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatFileSize(widget.fileSize),
                          style: TextStyle(
                            color: widget.secondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Download progress indicator
                if (_isDownloading)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: _downloadProgress > 0 ? _downloadProgress : null,
                        backgroundColor: widget.primaryColor.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Downloading: ${(_downloadProgress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: widget.secondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                
                // Action buttons
                if (!_isDownloading)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.showDownloadButton && (!_fileExists || _downloadedFilePath == null))
                        ElevatedButton.icon(
                          icon: const Icon(Icons.download),
                          label: const Text('Download'),
                          onPressed: _downloadFile,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      if (widget.showOpenButton && _fileExists && _downloadedFilePath != null) ...[
                        if (widget.showDownloadButton)
                          const SizedBox(width: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Open'),
                          onPressed: _openFile,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
}

// Telegram-style wrapper
class TelegramStyleFileWidget extends StatelessWidget {
  
  const TelegramStyleFileWidget({
    required this.fileUrl, required this.fileName, super.key,
    this.fileSize,
  });
  final String fileUrl;
  final String fileName;
  final String? fileSize;
  
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EBEE), // Light gray bubble
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: SupabaseFileWidget(
        fileUrl: fileUrl,
        fileName: fileName,
        fileSize: fileSize,
        backgroundColor: Colors.transparent,
      ),
    );
}



