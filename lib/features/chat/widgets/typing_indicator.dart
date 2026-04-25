import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';

/// 正在输入指示器动画
class TypingIndicator extends StatefulWidget {
  final Color dotColor;
  final double dotSize;
  final double spacing;

  const TypingIndicator({
    super.key,
    this.dotColor = AppColors.white,
    this.dotSize = 6,
    this.spacing = 3,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    _animations = _controllers
        .map((controller) =>
            Tween<double>(begin: 0.0, end: 1.0).animate(controller))
        .toList();

    _startAnimation();
  }

  void _startAnimation() async {
    while (mounted) {
      for (int i = 0; i < 3; i++) {
        await Future.delayed(Duration(milliseconds: i * 150));
        if (!mounted) return;
        _controllers[i].forward();
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        _controllers[i].reverse();
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '正在输入',
          style: TextStyle(
            color: AppColors.lightGrey,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Container(
                  width: widget.dotSize,
                  height: widget.dotSize + (_animations[index].value * 4),
                  margin: EdgeInsets.only(right: index < 2 ? widget.spacing : 0),
                  decoration: BoxDecoration(
                    color: widget.dotColor.withValues(
                      alpha: 0.5 + (_animations[index].value * 0.5),
                    ),
                    borderRadius: BorderRadius.circular(widget.dotSize / 2),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

/// 简化版打字指示器（用于列表）
class TypingBadge extends StatelessWidget {
  final bool isTyping;

  const TypingBadge({
    super.key,
    required this.isTyping,
  });

  @override
  Widget build(BuildContext context) {
    if (!isTyping) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '输入中',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 3),
          SizedBox(
            width: 12,
            height: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDot(0),
                _buildDot(1),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 3,
      height: 3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }
}
