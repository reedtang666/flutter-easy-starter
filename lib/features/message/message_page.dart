import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/utils/dialog_utils.dart';
import 'package:flutter_easy_starter/core/widgets/animated_button.dart';
import 'package:flutter_easy_starter/core/widgets/shimmer_widgets.dart';
import 'package:flutter_easy_starter/features/message/models/conversation_model.dart';
import 'package:flutter_easy_starter/features/message/widgets/story_ring_avatar.dart';
import 'package:flutter_easy_starter/features/chat/widgets/typing_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

/// 消息页面 - 增强动画版
class MessagePage extends ConsumerStatefulWidget {
  const MessagePage({super.key});

  @override
  ConsumerState<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends ConsumerState<MessagePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String _searchQuery = '';

  List<ChatConversation> get filteredConversations {
    if (_searchQuery.isEmpty) return mockConversations;
    return mockConversations
        .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // 模拟加载
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
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
              child: _isLoading
                  ? _buildStoriesShimmer()
                  : _buildStoriesRow(),
            ),

            // 消息列表标题
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 8.w),
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
                    AnimatedButton(
                      onTap: () => _markAllAsRead(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.check_check,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '全部已读',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 消息列表
            _isLoading
                ? SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildConversationShimmer(),
                        childCount: 6,
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final conversation = filteredConversations[index];
                        return StaggeredAnimation(
                          index: index,
                          type: AnimationType.slideUp,
                          child: _buildConversationItem(context, conversation),
                        );
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      child: Row(
        children: [
          // 搜索框
          Expanded(
            child: Container(
              height: 44.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.05),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.search,
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
                        contentPadding: EdgeInsets.symmetric(vertical: 11.w),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    AnimatedButton(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      scaleDown: 0.9,
                      child: Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryGrey,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          LucideIcons.x,
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
          AnimatedButton(
            onTap: () {
              HapticFeedback.mediumImpact();
              DialogUtils.showInfo(context, message: '新消息功能开发中...');
            },
            scaleDown: 0.9,
            hapticType: HapticFeedbackType.medium,
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(22.r),
                boxShadow: AppShadows.purpleGlow(opacity: 0.4),
              ),
              child: Icon(
                LucideIcons.pen_line,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesShimmer() {
    return Container(
      height: 100.w,
      margin: EdgeInsets.symmetric(vertical: 8.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 72.w,
            margin: EdgeInsets.only(right: 12.w),
            child: Column(
              children: [
                ShimmerCircle(size: 64),
                SizedBox(height: 8.w),
                ShimmerText(width: 50, height: 12),
              ],
            ),
          );
        },
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
    return AnimatedButton(
      onTap: () {
        HapticFeedback.mediumImpact();
        DialogUtils.showInfo(context, message: '发布故事功能开发中...');
      },
      scaleDown: 0.9,
      child: Container(
        width: 72.w,
        margin: EdgeInsets.only(right: 12.w),
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
                    boxShadow: AppShadows.purpleGlow(opacity: 0.3),
                  ),
                  child: Icon(
                    LucideIcons.plus,
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
                      LucideIcons.camera,
                      color: AppColors.primary,
                      size: 12,
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
      ),
    );
  }

  Widget _buildStoryItem(ChatConversation conversation) {
    return AnimatedButton(
      onTap: () {
        HapticFeedback.lightImpact();
        _openChat(context, conversation);
      },
      scaleDown: 0.9,
      child: Container(
        width: 72.w,
        margin: EdgeInsets.only(right: 12.w),
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

  Widget _buildConversationShimmer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      child: Row(
        children: [
          ShimmerCircle(size: 56),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerText(width: 100, height: 16),
                    Spacer(),
                    ShimmerText(width: 40, height: 12),
                  ],
                ),
                SizedBox(height: 8.w),
                ShimmerText(width: double.infinity, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationItem(
      BuildContext context, ChatConversation conversation) {
    return AnimatedButton(
      onTap: () => _openChat(context, conversation),
      enableRipple: false,
      child: Dismissible(
        key: Key(conversation.id),
        direction: DismissDirection.endToStart,
        dismissThresholds: const {DismissDirection.endToStart: 0.25},
        background: Container(
          margin: EdgeInsets.symmetric(vertical: 4.w, horizontal: 12.w),
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
                margin: EdgeInsets.only(right: 20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.red, const Color(0xFFFF453A)],
                  ),
                  borderRadius: BorderRadius.circular(36.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.red.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.trash_2,
                      color: Colors.white,
                      size: 24,
                    ),
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
          HapticFeedback.heavyImpact();
          return await _showDeleteConfirmDialog(context, conversation);
        },
        onDismissed: (_) {
          HapticFeedback.lightImpact();
          _showDeleteSuccessSnackbar(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
          child: Row(
            children: [
              // 头像
              AnimatedButton(
                onTap: () => _openUserDetail(context, conversation),
                scaleDown: 0.9,
                child: conversation.type == ConversationType.group
                    ? GroupAvatar(
                        members: conversation.members ?? [],
                        size: 56,
                      )
                    : StoryRingAvatar(
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
                            margin: EdgeInsets.only(left: 8.w),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.w,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryLight,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              conversation.unreadCount > 99
                                  ? '99+'
                                  : '${conversation.unreadCount}',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else if (conversation.lastMessage != null)
                          Icon(
                            LucideIcons.check_check,
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
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.red.withValues(alpha: 0.2),
                                    AppColors.red.withValues(alpha: 0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              child: Icon(
                                LucideIcons.trash_2,
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
                      Divider(color: AppColors.divider, height: 1),
                      // 删除按钮
                      AnimatedButton(
                        onTap: () => Navigator.pop(context, true),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16.w),
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
                AnimatedButton(
                  onTap: () => Navigator.pop(context, false),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.w),
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
            Icon(
              LucideIcons.circle_check,
              color: AppColors.green,
              size: 20,
            ),
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
    HapticFeedback.mediumImpact();
    DialogUtils.showSuccess(context, message: '已全部标记为已读');
  }
}
