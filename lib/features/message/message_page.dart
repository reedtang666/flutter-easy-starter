import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/utils/dialog_utils.dart';
import 'package:flutter_easy_starter/features/message/models/conversation_model.dart';
import 'package:flutter_easy_starter/features/message/widgets/story_ring_avatar.dart';
import 'package:flutter_easy_starter/features/chat/widgets/typing_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 消息页面 - 增强版
class MessagePage extends ConsumerStatefulWidget {
  const MessagePage({super.key});

  @override
  ConsumerState<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends ConsumerState<MessagePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  List<ChatConversation> get filteredConversations {
    if (_searchQuery.isEmpty) return mockConversations;
    return mockConversations
        .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 头部搜索栏
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),

            // 故事环列表（顶部横向滚动）
            SliverToBoxAdapter(
              child: _buildStoriesRow(),
            ),

            // 消息列表标题
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '消息',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _markAllAsRead(),
                      icon: Icon(Icons.done_all, size: 18),
                      label: Text('全部已读'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 消息列表
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final conversation = filteredConversations[index];
                  return _buildConversationItem(context, conversation);
                },
                childCount: filteredConversations.length,
              ),
            ),

            // 底部间距
            SliverToBoxAdapter(
              child: SizedBox(height: 32.w),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 搜索框
          Expanded(
            child: Container(
              height: 44.w,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppColors.lightGrey,
                    size: 20,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: false,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 15.sp,
                        height: 1.2,
                      ),
                      cursorColor: AppColors.primary,
                      cursorHeight: 18,
                      decoration: InputDecoration(
                        hintText: '搜索',
                        hintStyle: TextStyle(
                          color: AppColors.lightGrey,
                          fontSize: 15.sp,
                        ),
                        border: InputBorder.none,
                        isDense: false,
                        contentPadding: EdgeInsets.symmetric(vertical: 11),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      child: Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryGrey,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColors.lightGrey,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // 新建消息按钮
          GestureDetector(
            onTap: () {
              DialogUtils.showInfo(context, message: '新消息功能开发中...');
            },
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesRow() {
    final stories = mockConversations.where((c) => c.hasStory).toList();

    if (stories.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 100.w,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: stories.length + 1, // +1 for "我的故事"
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildMyStoryItem();
          }

          final conversation = stories[index - 1];
          return _buildStoryItem(conversation);
        },
      ),
    );
  }

  Widget _buildMyStoryItem() {
    return Container(
      width: 72.w,
      margin: EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                  ),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: Icon(
                    Icons.add,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.w),
          Text(
            '我的故事',
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 12.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(ChatConversation conversation) {
    return GestureDetector(
      onTap: () => _openChat(context, conversation),
      child: Container(
        width: 72.w,
        margin: EdgeInsets.only(right: 12),
        child: Column(
          children: [
            StoryRingAvatar(
              imageUrl: conversation.avatar,
              size: 64,
              hasStory: conversation.hasStory,
              isOnline: conversation.isOnline,
              onTap: () => _openUserDetail(context, conversation),
            ),
            SizedBox(height: 6.w),
            Text(
              conversation.name,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationItem(
      BuildContext context, ChatConversation conversation) {
    return Dismissible(
      key: Key(conversation.id),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.endToStart: 0.25},
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.surface,
              AppColors.red.withValues(alpha: 0.8),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              margin: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(36.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.red.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_outline, color: Colors.white, size: 28),
                  SizedBox(height: 4.w),
                  Text(
                    '删除',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmDialog(context, conversation);
      },
      onDismissed: (_) {
        _showDeleteSuccessSnackbar(context);
      },
      child: InkWell(
        onTap: () => _openChat(context, conversation),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              // 头像
              conversation.type == ConversationType.group
                  ? GroupAvatar(
                      members: conversation.members ?? [],
                      size: 56,
                    )
                  : GestureDetector(
                      onTap: () => _openUserDetail(context, conversation),
                      child: StoryRingAvatar(
                        imageUrl: conversation.avatar,
                        size: 56,
                        hasStory: conversation.hasStory,
                        isOnline: conversation.isOnline,
                      ),
                    ),

              SizedBox(width: 16.w),

              // 内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 第一行：名字和时间
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.name,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16.sp,
                              fontWeight: conversation.unreadCount > 0
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _formatTime(conversation.lastTime),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: conversation.unreadCount > 0
                                ? AppColors.primary
                                : AppColors.lightGrey,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 6.w),

                    // 第二行：最后消息
                    Row(
                      children: [
                        Expanded(
                          child: conversation.isTyping
                              ? const TypingIndicator()
                              : Text(
                                  _getLastMessagePreview(conversation),
                                  style: TextStyle(
                                    color: conversation.unreadCount > 0
                                        ? AppColors.lightGrey
                                        : AppColors.tertiaryGrey,
                                    fontWeight: conversation.unreadCount > 0
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                    fontSize: 14.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                        if (conversation.unreadCount > 0)
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              conversation.unreadCount > 99
                                  ? '99+'
                                  : '${conversation.unreadCount}',
                              style: TextStyle(fontSize: 11.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else if (conversation.lastMessage != null)
                          Icon(
                            Icons.done_all,
                            size: 16,
                            color: AppColors.tertiaryGrey,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLastMessagePreview(ChatConversation conversation) {
    if (conversation.type == ConversationType.group &&
        conversation.lastMessageSender != null) {
      return '${conversation.lastMessageSender}: ${conversation.lastMessage ?? ''}';
    }
    return conversation.lastMessage ?? '';
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';

    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inDays < 1) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return '昨天';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${time.month}/${time.day}';
    }
  }

  void _openChat(BuildContext context, ChatConversation conversation) {
    context.push('/chat/${conversation.id}');
  }

  void _openUserDetail(BuildContext context, ChatConversation conversation) {
    context.push('/user/${conversation.id}');
  }

  Future<bool> _showDeleteConfirmDialog(
    BuildContext context,
    ChatConversation conversation,
  ) async {
    return await showModalBottomSheet<bool>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            margin: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 主菜单
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      // 标题
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          children: [
                            Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(
                                color: AppColors.red.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: AppColors.red,
                                size: 24,
                              ),
                            ),
                            SizedBox(height: 16.w),
                            Text(
                              '删除对话',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.w),
                            Text(
                              '确定要删除与 ${conversation.name} 的对话吗？\n删除后将无法恢复。',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.lightGrey,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.divider, height: 1),
                      // 删除按钮
                      GestureDetector(
                        onTap: () => Navigator.pop(context, true),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            '删除',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.w),
                // 取消按钮
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      '取消',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) ??
        false;
  }

  void _showDeleteSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.green, size: 20),
            SizedBox(width: 12.w),
            Text(
              '已删除对话',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _markAllAsRead() {
    DialogUtils.showSuccess(context, message: '已全部标记为已读');
  }
}
