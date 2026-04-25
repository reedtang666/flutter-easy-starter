import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/utils/dialog_utils.dart';
import 'package:flutter_easy_starter/features/chat/models/message_model.dart';
import 'package:flutter_easy_starter/features/chat/widgets/message_bubble.dart';
import 'package:flutter_easy_starter/features/chat/widgets/message_input.dart';
import 'package:flutter_easy_starter/features/chat/widgets/message_reactions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easy_starter/features/chat/widgets/typing_indicator.dart';
import 'package:flutter_easy_starter/features/message/models/conversation_model.dart';
import 'package:flutter_easy_starter/features/message/widgets/story_ring_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// 聊天页面 - 增强版
class ChatPage extends ConsumerStatefulWidget {
  final String userId;

  const ChatPage({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;
  ChatConversation? _conversation;

  // 模拟聊天数据加载
  bool _isLoading = true;
  bool _hasMore = true;

  // 模拟聊天数据
  late List<ChatMessage> _messages;

  final List<ChatMessage> _mockMessages = [
    ChatMessage(
      id: '1',
      senderId: 'other',
      text: '你好呀 👋',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      isMe: false,
      reactions: {'👍': ['me', 'user2']},
    ),
    ChatMessage(
      id: '2',
      senderId: 'me',
      text: '嗨！很高兴认识你',
      time: DateTime.now().subtract(const Duration(minutes: 28)),
      isMe: true,
      status: MessageStatus.read,
    ),
    ChatMessage(
      id: '3',
      senderId: 'other',
      text: '看你资料喜欢旅行？',
      time: DateTime.now().subtract(const Duration(minutes: 25)),
      isMe: false,
    ),
    ChatMessage(
      id: '4',
      senderId: 'me',
      text: '对的！超爱旅行 ✈️ 你去过哪些地方呀？',
      time: DateTime.now().subtract(const Duration(minutes: 20)),
      isMe: true,
      status: MessageStatus.read,
    ),
    ChatMessage(
      id: '5',
      senderId: 'other',
      text: '我刚从云南回来，风景真的太美了！推荐你一定要去大理看看 🏔️',
      time: DateTime.now().subtract(const Duration(minutes: 15)),
      isMe: false,
      reactions: {'❤️': ['me']},
    ),
    ChatMessage(
      id: '6',
      senderId: 'me',
      text: '哇！大理我一直想去！有什么推荐的民宿吗？',
      time: DateTime.now().subtract(const Duration(minutes: 10)),
      isMe: true,
      status: MessageStatus.delivered,
    ),
    ChatMessage(
      id: '7',
      senderId: 'other',
      text: '周末有空一起去喝咖啡吗？☕',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      isMe: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _conversation = mockConversations.firstWhere(
      (c) => c.id == widget.userId,
      orElse: () => ChatConversation(
        id: widget.userId,
        name: '用户',
        isOnline: true,
      ),
    );
    _loadMessages();
  }

  void _loadMessages() {
    // 模拟加载延迟
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _messages = List.from(_mockMessages);
          _isLoading = false;
        });
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get _userName => _conversation?.name ?? '用户';
  bool get _isOnline => _conversation?.isOnline ?? false;
  bool get _hasStory => _conversation?.hasStory ?? false;

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'me',
        text: text,
        time: DateTime.now(),
        isMe: true,
        status: MessageStatus.sending,
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    // 模拟发送成功
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          final index = _messages.length - 1;
          _messages[index] = _messages[index].copyWith(
            status: MessageStatus.sent,
          );
        });
      }
    });

    // 模拟对方正在输入
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });
      }
    });

    // 模拟对方回复
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: 'other',
            text: '收到！我看看时间安排 😊',
            time: DateTime.now(),
            isMe: false,
          ));
        });
        _scrollToBottom();
      }
    });
  }

  void _sendImageMessage(String imagePath) {
    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'me',
        text: '[图片]',
        time: DateTime.now(),
        isMe: true,
        status: MessageStatus.sent,
        type: MessageType.image,
        mediaUrl: imagePath,
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // 聊天内容
            Expanded(
              child: _isLoading
                  ? _buildSkeletonList()
                  : _messages.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: _messages.length + (_isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _messages.length && _isTyping) {
                              return _buildTypingIndicator();
                            }

                            final message = _messages[index];
                            final showTime = index == 0 ||
                                _messages[index].time
                                        .difference(_messages[index - 1].time)
                                        .inMinutes >
                                    5;

                            return MessageBubble(
                              message: message,
                              showTime: showTime,
                              onLongPress: () => _showReactionPicker(message),
                              onReactionSelected: (emoji) =>
                                  _addReactionToMessage(message.id, emoji),
                            );
                          },
                        ),
            ),

            // 输入框
            MessageInput(
              controller: _messageController,
              focusNode: _focusNode,
              onSend: _sendMessage,
              onAttachmentTap: () async {
                final picker = ImagePicker();
                final images = await picker.pickMultiImage();
                if (images.isNotEmpty) {
                  for (final image in images) {
                    _sendImageMessage(image.path);
                  }
                }
              },
              onVoiceTap: () {
                DialogUtils.showInfo(context, message: '语音功能开发中...');
              },
              onCameraTap: () async {
                final picker = ImagePicker();
                final image = await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  _sendImageMessage(image.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      titleSpacing: 0,
      title: GestureDetector(
        onTap: () => context.push('/user/${widget.userId}'),
        child: Row(
          children: [
            StoryRingAvatar(
              imageUrl: _conversation?.avatar,
              size: 40,
              isOnline: _isOnline,
              hasStory: _hasStory,
              onTap: () => context.push('/user/${widget.userId}'),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userName,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _isOnline ? '在线' : '离线',
                    style: TextStyle(
                      color: _isOnline ? AppColors.green : AppColors.lightGrey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.videocam_outlined),
          onPressed: () {
            DialogUtils.showInfo(context, message: '视频通话功能开发中...');
          },
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: _showOptionsMenu,
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 8, bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: const TypingIndicator(),
      ),
    );
  }

  void _showReactionPicker(ChatMessage message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MessageReactions(
        onReactionSelected: (emoji) => _addReactionToMessage(message.id, emoji),
        onDismiss: () => Navigator.pop(context),
      ),
    );
  }

  void _addReactionToMessage(String messageId, String emoji) {
    setState(() {
      final index = _messages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        final reactions = Map<String, List<String>>.from(
          _messages[index].reactions ?? {},
        );
        final users = reactions[emoji] ?? [];
        if (users.contains('me')) {
          users.remove('me');
          if (users.isEmpty) {
            reactions.remove(emoji);
          } else {
            reactions[emoji] = users;
          }
        } else {
          users.add('me');
          reactions[emoji] = users;
        }
        _messages[index] = _messages[index].copyWith(reactions: reactions);
      }
    });
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 40.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: AppColors.tertiaryGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person, color: AppColors.white),
                title: Text('查看资料',
                  style: TextStyle(color: AppColors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/user/${widget.userId}');
                },
              ),
              ListTile(
                leading: Icon(Icons.search, color: AppColors.white),
                title: Text('搜索聊天记录',
                  style: TextStyle(color: AppColors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  DialogUtils.showInfo(context, message: '搜索功能开发中...');
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications_off, color: AppColors.lightGrey),
                title: Text(
                  '消息免打扰',
                  style: TextStyle(color: AppColors.lightGrey),
                ),
                trailing: Switch(
                  value: false,
                  onChanged: (_) {},
                  activeColor: AppColors.primary,
                ),
                onTap: () {},
              ),
              const Divider(color: AppColors.divider),
              ListTile(
                leading: Icon(Icons.block, color: AppColors.red),
                title: Text('屏蔽用户',
                  style: TextStyle(color: AppColors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showBlockConfirm();
                },
              ),
              ListTile(
                leading: Icon(Icons.report, color: AppColors.orange),
                title: const Text(
                  '举报',
                  style: TextStyle(color: AppColors.orange),
                ),
                onTap: () {
                  Navigator.pop(context);
                  DialogUtils.showInfo(context, message: '举报功能开发中...');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBlockConfirm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('屏蔽用户',
            style: TextStyle(color: AppColors.white),
          ),
          content: Text(
            '确定要屏蔽 $_userName 吗？屏蔽后你将不再收到对方的消息。',
            style: const TextStyle(color: AppColors.lightGrey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.red,
              ),
              child: Text('屏蔽'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 8,
      itemBuilder: (context, index) {
        final isMe = index % 2 == 0;
        return _buildSkeletonItem(isMe);
      },
    );
  }

  Widget _buildSkeletonItem(bool isMe) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
          if (!isMe) SizedBox(width: 8.w),
          Container(
            width: 150 + (isMe ? 50 : 0),
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(isMe ? 20 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 20),
              ),
            ),
          ),
          if (isMe) SizedBox(width: 8.w),
          if (isMe)
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(60.r),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: AppColors.lightGrey,
            ),
          ),
          SizedBox(height: 24.w),
          Text(
            '还没有消息',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            '发送一条消息开始聊天吧',
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 32.w),
          GestureDetector(
            onTap: () {
              _focusNode.requestFocus();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Text(
                '发消息',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
