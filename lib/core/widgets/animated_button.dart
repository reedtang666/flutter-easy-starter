import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 带动画的按钮基类 - 支持点击缩放、涟漪效果、触觉反馈
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Duration duration;
  final double scaleDown;
  final bool enableHaptic;
  final HapticFeedbackType hapticType;
  final bool enableRipple;
  final Color? rippleColor;
  final BorderRadius? borderRadius;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.duration = AppDurations.fast,
    this.scaleDown = 0.95,
    this.enableHaptic = true,
    this.hapticType = HapticFeedbackType.light,
    this.enableRipple = true,
    this.rippleColor,
    this.borderRadius,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap == null) return;
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  void _handleTap() {
    if (widget.onTap == null) return;

    if (widget.enableHaptic) {
      switch (widget.hapticType) {
        case HapticFeedbackType.light:
          HapticFeedback.lightImpact();
        case HapticFeedbackType.medium:
          HapticFeedback.mediumImpact();
        case HapticFeedbackType.heavy:
          HapticFeedback.heavyImpact();
        case HapticFeedbackType.selection:
          HapticFeedback.selectionClick();
      }
    }

    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    Widget button = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: widget.child,
    );

    if (widget.enableRipple && widget.onTap != null) {
      button = Material(
        color: Colors.transparent,
        borderRadius: widget.borderRadius,
        child: InkWell(
          onTap: _handleTap,
          onLongPress: widget.onLongPress,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          borderRadius: widget.borderRadius,
          splashColor: widget.rippleColor ?? AppColors.primary.withValues(alpha: 0.2),
          highlightColor: widget.rippleColor?.withValues(alpha: 0.1) ??
              AppColors.primary.withValues(alpha: 0.1),
          child: button,
        ),
      );
    } else if (widget.onTap != null) {
      button = GestureDetector(
        onTap: _handleTap,
        onLongPress: widget.onLongPress,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: button,
      );
    }

    return button;
  }
}

/// 触觉反馈类型
enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
}

/// 带发光效果的动画卡片
class AnimatedGlowCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isSelected;
  final Color glowColor;
  final double glowIntensity;
  final Duration duration;

  const AnimatedGlowCard({
    super.key,
    required this.child,
    this.onTap,
    this.isSelected = false,
    this.glowColor = AppColors.primary,
    this.glowIntensity = 0.4,
    this.duration = AppDurations.normal,
  });

  @override
  State<AnimatedGlowCard> createState() => _AnimatedGlowCardState();
}

class _AnimatedGlowCardState extends State<AnimatedGlowCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool showGlow = widget.isSelected || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedButton(
        onTap: widget.onTap,
        scaleDown: 0.97,
        enableHaptic: true,
        hapticType: HapticFeedbackType.light,
        enableRipple: false,
        child: AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.glowColor.withValues(alpha: 0.15)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: showGlow
                  ? widget.glowColor
                  : Colors.white.withValues(alpha: 0.05),
              width: showGlow ? 2.w : 1.w,
            ),
            boxShadow: showGlow
                ? [
                    BoxShadow(
                      color: widget.glowColor.withValues(alpha: 
                          widget.isSelected ? widget.glowIntensity : 0.2),
                      blurRadius: widget.isSelected ? 16 : 8,
                      spreadRadius: widget.isSelected ? 2 : 0,
                    ),
                  ]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// 脉冲动画容器 - 用于吸引注意力
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool autoPlay;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.minScale = 1.0,
    this.maxScale = 1.05,
    this.autoPlay = true,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: widget.minScale, end: widget.maxScale)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.maxScale, end: widget.minScale)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
    ]).animate(_controller);

    if (widget.autoPlay) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// 交错入场动画容器
class StaggeredAnimation extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final AnimationType type;

  const StaggeredAnimation({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 50),
    this.duration = AppDurations.normal,
    this.type = AnimationType.slideUp,
  });

  @override
  State<StaggeredAnimation> createState() => _StaggeredAnimationState();
}

class _StaggeredAnimationState extends State<StaggeredAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    final delay = widget.delay * widget.index;

    Future.delayed(delay, () {
      if (mounted) {
        _controller.forward();
      }
    });

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case AnimationType.fade:
        return FadeTransition(
          opacity: _animation,
          child: widget.child,
        );
      case AnimationType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(_animation),
          child: FadeTransition(
            opacity: _animation,
            child: widget.child,
          ),
        );
      case AnimationType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.3, 0),
            end: Offset.zero,
          ).animate(_animation),
          child: FadeTransition(
            opacity: _animation,
            child: widget.child,
          ),
        );
      case AnimationType.scale:
        return ScaleTransition(
          scale: _animation,
          child: widget.child,
        );
    }
  }
}

enum AnimationType {
  fade,
  slideUp,
  slideLeft,
  scale,
}
