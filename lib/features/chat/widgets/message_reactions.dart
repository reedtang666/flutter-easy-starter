import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';

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
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(32),
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.darkGrey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 28),
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: hasMyReaction
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.tertiaryGrey.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: hasMyReaction
                  ? Border.all(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '$count',
                  style: TextStyle(
                    color: hasMyReaction ? AppColors.primary : AppColors.lightGrey,
                    fontSize: 12,
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
