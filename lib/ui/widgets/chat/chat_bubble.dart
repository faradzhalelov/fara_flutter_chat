import 'package:fara_chat/data/models/message_model.dart';
import 'package:fara_chat/data/models/message_type.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  
  const ChatBubble({
    required this.message, super.key,
  });
  final MessageModel message;

  @override
  Widget build(BuildContext context) => Align(
      alignment: message.isMine 
          ? Alignment.centerRight 
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isMine
              ? Theme.of(context).primaryColor
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: _buildMessageContent(context),
      ),
    );
  
  Widget _buildMessageContent(BuildContext context) {
    final textColor = message.isMine
        ? Colors.white
        : Theme.of(context).textTheme.bodyLarge?.color;
        
    switch (message.type) {
      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.fileUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  message.fileUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error),
                      ),
                    ),
                ),
              )
            else
              Container(
                height: 150,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image),
                ),
              ),
            if (message.content != null && message.content!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  message.content!,
                  style: TextStyle(color: textColor),
                ),
              ),
          ],
        );
      
      case MessageType.file:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.attach_file, color: textColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message.content ?? 'File',
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        );
      
      default:
        return Text(
          message.content ?? '',
          style: TextStyle(color: textColor),
        );
    }
  }
}
