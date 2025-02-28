import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  
  const MessageInput({
    required this.onSendMessage, super.key,
    this.onAttachFile,
  });
  final void Function(String) onSendMessage;
  final VoidCallback? onAttachFile;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _textController = TextEditingController();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updateSendButton);
  }

  void _updateSendButton() {
    final canSend = _textController.text.trim().isNotEmpty;
    if (canSend != _canSend) {
      setState(() {
        _canSend = canSend;
      });
    }
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (widget.onAttachFile != null)
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: widget.onAttachFile,
              ),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              color: _canSend ? Theme.of(context).primaryColor : Colors.grey,
              onPressed: _canSend ? _handleSend : null,
            ),
          ],
        ),
      ),
    );
  
  @override
  void dispose() {
    _textController.removeListener(_updateSendButton);
    _textController.dispose();
    super.dispose();
  }
}