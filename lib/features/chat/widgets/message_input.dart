import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';

/// 增强版消息输入栏
class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback? onAttachmentTap;
  final VoidCallback? onVoiceTap;
  final VoidCallback? onCameraTap;

  const MessageInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    this.onAttachmentTap,
    this.onVoiceTap,
    this.onCameraTap,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool _isTyping = false;
  bool _showAttachments = false;
  bool _showEmojiPicker = false;

  final List<String> _emojis = [
    '😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣',
    '😊', '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰',
    '😘', '😗', '😙', '😚', '😋', '😛', '😝', '😜',
    '🤪', '🤨', '🧐', '🤓', '😎', '🥸', '🤩', '🥳',
    '😏', '😒', '😞', '😔', '😟', '😕', '🙁', '☹️',
    '😣', '😖', '😫', '😩', '🥺', '😢', '😭', '😤',
    '😠', '😡', '🤬', '🤯', '😳', '🥵', '🥶', '😱',
    '😨', '😰', '😥', '😓', '🤗', '🤔', '🤭', '🤫',
    '👍', '👎', '👏', '🙌', '👐', '🤝', '🤲', '🤜',
    '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍',
    '🔥', '💯', '💢', '💥', '✨', '🌟', '💫', '⭐',
    '😴', '😪', '😵', '🤐', '🥴', '🤢', '🤮', '🤧',
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isTyping = widget.controller.text.isNotEmpty;
    });
  }

  void _onEmojiTap(String emoji) {
    final text = widget.controller.text;
    final selection = widget.controller.selection;
    final start = selection.start >= 0 ? selection.start : 0;
    final end = selection.end >= 0 ? selection.end : 0;
    final newText = text.substring(0, start) + emoji + text.substring(end);
    widget.controller.text = newText;
    widget.controller.selection = TextSelection.collapsed(offset: start + emoji.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 输入栏
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // 附件按钮
                  _buildIconButton(
                    icon: Icons.add_circle_outline,
                    onTap: () {
                      setState(() {
                        _showAttachments = !_showAttachments;
                      });
                      if (_showAttachments) {
                        widget.focusNode.unfocus();
                      }
                    },
                    color: _showAttachments ? AppColors.primary : null,
                  ),

                  // 输入框
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.transparent, width: 0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: widget.controller,
                              style: const TextStyle(color: AppColors.white),
                              decoration: InputDecoration(
                                hintText: '输入消息...',
                                hintStyle:
                                    TextStyle(color: AppColors.tertiaryGrey),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              maxLines: null,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => widget.onSend(),
                            ),
                          ),
                          SizedBox(width:10),
                          // 表情按钮
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showEmojiPicker = !_showEmojiPicker;
                                _showAttachments = false;
                              });
                              if (_showEmojiPicker) {
                                widget.focusNode.unfocus();
                              } else {
                                widget.focusNode.requestFocus();
                              }
                            },
                            child: Icon(
                              _showEmojiPicker
                                ? Icons.keyboard_outlined
                                : Icons.emoji_emotions_outlined,
                              color: _showEmojiPicker ? AppColors.primary : AppColors.lightGrey,
                              size: 24,
                            ),
                          ),
                          SizedBox(width:10),
                        ],
                      ),
                    ),
                  ),

                  // 发送/语音按钮
                  if (_isTyping)
                    _buildSendButton()
                  else
                    _buildIconButton(
                      icon: Icons.mic_none,
                      onTap: widget.onVoiceTap,
                    ),
                ],
              ),
            ),

            // 附件面板
            if (_showAttachments) _buildAttachmentPanel(),

            // 表情面板
            if (_showEmojiPicker) _buildEmojiPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback? onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color?.withValues(alpha: 0.1) ?? Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: color ?? AppColors.lightGrey,
          size: 26,
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: widget.onSend,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.accent],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(
          Icons.send,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildAttachmentPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildAttachmentItem(
            icon: Icons.photo_library,
            color: Colors.purple,
            label: '相册',
            onTap: widget.onAttachmentTap,
          ),
          _buildAttachmentItem(
            icon: Icons.camera_alt,
            color: Colors.red,
            label: '拍摄',
            onTap: widget.onCameraTap,
          ),
          _buildAttachmentItem(
            icon: Icons.location_on,
            color: Colors.green,
            label: '位置',
            onTap: () {},
          ),
          _buildAttachmentItem(
            icon: Icons.card_giftcard,
            color: Colors.orange,
            label: '礼物',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
        setState(() {
          _showAttachments = false;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPanel() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          childAspectRatio: 1,
        ),
        itemCount: _emojis.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _onEmojiTap(_emojis[index]),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                _emojis[index],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        },
      ),
    );
  }
}
