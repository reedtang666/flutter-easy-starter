import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 消息反应表情选择器
class MessageReactions extends StatelessWidget {
  final Function(String emoji) onReactionSelected;
  final VoidCallback onDismiss;

  const MessageReactions({
    super.key,
    required this.onReactionSelected,
    required this.onDismiss,
  });

  static final List<String> _reactions = [
    '❤️', '👍', '😂', '😮', '😢', '🎉', '🔥', '👏'
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 32),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(32.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: _reactions.map((emoji) {
                return GestureDetector(
                  onTap: () {
                    onReactionSelected(emoji);
                    onDismiss();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.darkGrey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      emoji,
                      style: TextStyle(fontSize: 28.sp),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/// 已选择的反应显示
class ReactionChips extends StatelessWidget {
  final Map<String, List<String>> reactions;
  final bool isMe;
  final Function(String emoji)? onReactionTap;

  const ReactionChips({
    super.key,
    required this.reactions,
    required this.isMe,
    this.onReactionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (reactions.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: reactions.entries.map((entry) {
        final emoji = entry.key;
        final count = entry.value.length;
        final hasMyReaction = entry.value.contains('me');

        return GestureDetector(
          onTap: () => onReactionTap?.call(emoji),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: hasMyReaction
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.tertiaryGrey.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12.r),
              border: hasMyReaction
                  ? Border.all(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      width: 1.w,
                    )
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: TextStyle(fontSize: 14.sp)),
                SizedBox(width: 4.w),
                Text(
                  '$count',
                  style: TextStyle(
                    color: hasMyReaction ? AppColors.primary : AppColors.lightGrey,
                    fontSize: 12.sp,
                    fontWeight: hasMyReaction ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
