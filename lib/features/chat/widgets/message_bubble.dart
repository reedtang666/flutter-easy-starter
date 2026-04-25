import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/features/chat/models/message_model.dart';
import 'package:flutter_easy_starter/features/chat/widgets/message_reactions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 增强版消息气泡
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showTime;
  final VoidCallback? onLongPress;
  final Function(String emoji)? onReactionSelected;

  const MessageBubble({
    super.key,
    required this.message,
    this.showTime = false,
    this.onLongPress,
    this.onReactionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // 时间戳（对方消息在左边）
          if (!message.isMe)
            Padding(
              padding: EdgeInsets.only(right: 8, bottom: 4),
              child: Text(
                _formatTime(message.time),
                style: TextStyle(
                  color: AppColors.tertiaryGrey,
                  fontSize: 10.sp,
                ),
              ),
            ),

          Flexible(
            child: Column(
              crossAxisAlignment:
                  message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // 时间分隔
                if (showTime)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: _buildTimeSeparator(),
                  ),

                // 消息内容
                GestureDetector(
                  onLongPress: onLongPress,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                    ),
                    child: Column(
                      crossAxisAlignment: message.isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        // 消息气泡
                        _buildBubble(),

                        // 反应表情
                        if (message.reactions != null &&
                            message.reactions!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 4, left: 4, right: 4),
                            child: ReactionChips(
                              reactions: message.reactions!,
                              isMe: message.isMe,
                              onReactionTap: onReactionSelected,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 时间戳和状态（我的消息在右边）
          if (message.isMe)
            Padding(
              padding: EdgeInsets.only(left: 8, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTime(message.time),
                    style: TextStyle(
                      color: AppColors.tertiaryGrey,
                      fontSize: 10.sp,
                    ),
                  ),
                  _buildStatusIndicator(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeSeparator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.tertiaryGrey.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        _formatSeparatorTime(message.time),
        style: TextStyle(
          color: AppColors.lightGrey,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildBubble() {
    switch (message.type) {
      case MessageType.image:
        return _buildImageBubble();
      case MessageType.voice:
        return _buildVoiceBubble();
      case MessageType.location:
        return _buildLocationBubble();
      case MessageType.text:
      default:
        return _buildTextBubble();
    }
  }

  Widget _buildTextBubble() {
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: message.isMe
            ? const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: message.isMe ? null : AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
          bottomLeft: Radius.circular(message.isMe ? 20 : 4),
          bottomRight: Radius.circular(message.isMe ? 4 : 20),
        ),
        boxShadow: message.isMe
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        message.text ?? '',
        style: TextStyle(
          color: message.isMe ? Colors.white : AppColors.white,
          fontSize: 15.sp,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildImageBubble() {
    return Builder(
      builder: (ctx) {
        return GestureDetector(
          onTap: () {
            if (message.mediaUrl != null) {
              _showImagePreview(ctx, message.mediaUrl!);
            }
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(message.isMe ? 20 : 4),
                bottomRight: Radius.circular(message.isMe ? 4 : 20),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Container(
                  width: 200.w,
                  height: 200.w,
                  color: AppColors.tertiaryGrey,
                  child: message.mediaUrl != null
                      ? _buildImage(message.mediaUrl!, fit: BoxFit.cover)
                      : Icon(
                          Icons.image,
                          color: AppColors.lightGrey,
                          size: 48,
                        ),
                ),
                // 加载中遮罩
                if (message.status == MessageStatus.sending)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: Center(
                        child: SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showImagePreview(BuildContext ctx, String imageUrl) {
    showDialog(
      context: ctx,
      useSafeArea: false,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.95),
      builder: (dialogCtx) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // 图片
            GestureDetector(
              onTap: () => Navigator.pop(dialogCtx),
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: _buildImage(imageUrl, fit: BoxFit.contain),
                ),
              ),
            ),
            // 关闭按钮
            Positioned(
              top: MediaQuery.of(ctx).padding.top + 16,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(dialogCtx),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String url, {BoxFit fit = BoxFit.cover}) {
    if (url.startsWith('/') || url.contains('data/user')) {
      // 本地图片路径
      return Image.file(
        File(url),
        fit: fit,
        errorBuilder: (_, __, ___) => Icon(
          Icons.image,
          color: AppColors.lightGrey,
          size: 48,
        ),
      );
    } else {
      // 网络图片
      return Image.network(
        url,
        fit: fit,
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: AppColors.primary,
            ),
          );
        },
        errorBuilder: (_, __, ___) => Icon(
          Icons.image,
          color: AppColors.lightGrey,
          size: 48,
        ),
      );
    }
  }

  Widget _buildVoiceBubble() {
    final duration = message.voiceDuration ?? 0;
    final width = 80 + (duration * 3).clamp(0, 120).toDouble();

    return Container(
      margin: EdgeInsets.only(bottom: 2),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: width,
      decoration: BoxDecoration(
        gradient: message.isMe
            ? const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
              )
            : null,
        color: message.isMe ? null : AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
          bottomLeft: Radius.circular(message.isMe ? 20 : 4),
          bottomRight: Radius.circular(message.isMe ? 4 : 20),
        ),
      ),
      child: Row(
        children: [
          Icon(
            message.isMe ? Icons.play_arrow : Icons.play_arrow,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              height: 20.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(8, (index) {
                  final height = 4 + (index % 4) * 3;
                  return Container(
                    width: 2.w,
                    height: height.toDouble(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1.r),
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '${duration}"',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBubble() {
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      width: 220.w,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
          bottomLeft: Radius.circular(message.isMe ? 20 : 4),
          bottomRight: Radius.circular(message.isMe ? 4 : 20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120.w,
            color: AppColors.tertiaryGrey,
            child: Center(
              child: Icon(
                Icons.map,
                color: AppColors.primary,
                size: 48,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 16,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    message.locationName ?? '未知位置',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    IconData statusIcon;
    Color statusColor;

    switch (message.status) {
      case MessageStatus.sending:
        statusIcon = Icons.access_time;
        statusColor = AppColors.lightGrey;
        break;
      case MessageStatus.sent:
        statusIcon = Icons.check;
        statusColor = AppColors.lightGrey;
        break;
      case MessageStatus.delivered:
        statusIcon = Icons.done_all;
        statusColor = AppColors.lightGrey;
        break;
      case MessageStatus.read:
        statusIcon = Icons.done_all;
        statusColor = AppColors.primary;
        break;
      case MessageStatus.failed:
        statusIcon = Icons.error_outline;
        statusColor = AppColors.red;
        break;
      default:
        statusIcon = Icons.check;
        statusColor = AppColors.lightGrey;
    }

    return Icon(
      statusIcon,
      size: 12,
      color: statusColor,
    );
  }

  String _formatSeparatorTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return '今天 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return '昨天 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.month}月${time.day}日 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
