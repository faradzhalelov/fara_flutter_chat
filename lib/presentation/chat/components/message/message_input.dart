// lib/presentation/chat/components/message_input.dart
import 'package:fara_chat/app/theme/colors.dart';
import 'package:fara_chat/app/theme/icons.dart';
import 'package:fara_chat/app/theme/text_styles.dart';
import 'package:fara_chat/presentation/chat/view_model.dart/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageInput extends ConsumerStatefulWidget {
  
  const MessageInput({
    required this.chatId, super.key,
  });
  final String chatId;

  @override
  ConsumerState<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends ConsumerState<MessageInput> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  bool _isRecording = false;
  bool _isAttachmentMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final FocusNode _focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }
  
  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  
  // Toggle the attachment menu
  void _toggleAttachmentMenu() {
    setState(() {
      _isAttachmentMenuOpen = !_isAttachmentMenuOpen;
      if (_isAttachmentMenuOpen) {
        _animationController.forward();
        _focusNode.unfocus();
      } else {
        _animationController.reverse();
      }
    });
  }
  
  // Send a text message
  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    
    final viewModel = ref.read(chatViewModelProvider(widget.chatId).notifier);
    await viewModel.sendTextMessage(text);
    _textController.clear();
  }
  
  // Toggle audio recording
  Future<void> _toggleRecording() async {
    final viewModel = ref.read(chatViewModelProvider(widget.chatId).notifier);
    
    if (_isRecording) {
      await viewModel.stopRecordingAndSend();
    } else {
      await viewModel.startRecording();
    }
    
    setState(() {
      _isRecording = !_isRecording;
    });
  }
  
  // Pick and send an image
  Future<void> _pickImage() async {
    _toggleAttachmentMenu();
    final viewModel = ref.read(chatViewModelProvider(widget.chatId).notifier);
    await viewModel.sendImageMessage();
  }
  
  // Pick and send a video
  Future<void> _pickVideo() async {
    _toggleAttachmentMenu();
    final viewModel = ref.read(chatViewModelProvider(widget.chatId).notifier);
    await viewModel.sendVideoMessage();
  }
  
  // Pick and send a file
  Future<void> _pickFile() async {
    _toggleAttachmentMenu();
    final viewModel = ref.read(chatViewModelProvider(widget.chatId).notifier);
    await viewModel.sendFileMessage();
  }
  
  @override
  Widget build(BuildContext context) {
    final chatViewModel = ref.watch(chatViewModelProvider(widget.chatId));
    final isLoading = chatViewModel.isLoading;
    
    return Column(
      children: [
        // Attachment menu (slides up when opened)
        SizeTransition(
          sizeFactor: _animation,
          child: Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.searchBackground,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentButton(
                  icon: Icomoon.img,
                  label: 'Фото',
                  onTap: _pickImage,
                ),
                _buildAttachmentButton(
                  icon: Icons.videocam_outlined,
                  label: 'Видео',
                  onTap: _pickVideo,
                ),
                _buildAttachmentButton(
                  icon: Icomoon.attach,
                  label: 'Файл',
                  onTap: _pickFile,
                ),
              ],
            ),
          ),
        ),
        
        // Message input bar
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -1),
                blurRadius: 5,
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  // Attachment button
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(AppColors.searchBackground),
                      fixedSize: const WidgetStatePropertyAll(Size(42,42)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                    icon: const Icon(Icomoon.attach,size: 24, color: AppColors.black,),
                    onPressed: isLoading ? null : _toggleAttachmentMenu,
                  ),
                  
                  // Text input field
                  Expanded(
                    child: Container(
                      height: 42,
                      constraints: const BoxConstraints(maxWidth: 235),
                      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.searchBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        
                        decoration: InputDecoration(
                          filled: false,
                          fillColor: AppColors.searchBackground,
                          hintText: _isRecording ? 'Запись...' : 'Сообщение',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          enabled: !_isRecording && !isLoading,
                         
                        ),
                        onChanged: (_) => setState(() {
                            
                          }),
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        onSubmitted: isLoading || _isRecording ? null : (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  
                  // Audio recording or send button
                  if (_textController.value.text.isEmpty)
                    IconButton(
                      style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(AppColors.searchBackground),
                      fixedSize: const WidgetStatePropertyAll(Size(42,42)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                      icon: Icon(
                        _isRecording ? Icons.stop : Icomoon.audio,
                        color: _isRecording ? Colors.red : Colors.grey.shade600,
                      ),
                      onPressed: isLoading ? null : _toggleRecording,
                    )
                  else
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: AppColors.black,
                      ),
                      onPressed: isLoading ? null : _sendMessage,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildAttachmentButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) => InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 24, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.extraSmall.copyWith(              color: Colors.grey.shade700,
),
           
          ),
        ],
      ),
    );
}