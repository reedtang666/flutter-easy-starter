import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 增强版毛玻璃效果组件
class FrostedWidget extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadows;
  final Border? border;

  const FrostedWidget({
    super.key,
    required this.child,
    this.borderRadius = 60,
    this.blurSigma = 15,
    this.backgroundColor,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.shadows,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
        boxShadow: shadows ?? AppShadows.glow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor ??
                  AppColors.glassWhite.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(borderRadius.r),
              border: border ??
                  Border.all(
                    color: AppColors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 高级毛玻璃卡片 - 带渐变边框和发光效果
class FrostedCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final List<Color>? gradientColors;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool enableGlow;
  final Color glowColor;
  final bool enableGradientBorder;

  const FrostedCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.blurSigma = 20,
    this.gradientColors,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.enableGlow = false,
    this.glowColor = AppColors.primary,
    this.enableGradientBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
        boxShadow: enableGlow
            ? [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
          ),
          child: Container(
            padding: padding ?? EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors ??
                    [
                      AppColors.glassWhite.withValues(alpha: 0.2),
                      AppColors.glassWhite.withValues(alpha: 0.05),
                    ],
              ),
              borderRadius: BorderRadius.circular(borderRadius.r),
              border: enableGradientBorder
                  ? _buildGradientBorder()
                  : Border.all(
                      color: AppColors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Border _buildGradientBorder() {
    return Border.all(
      color: AppColors.white.withValues(alpha: 0.2),
      width: 1.5,
    );
  }
}

/// 玻璃态底部弹窗
class FrostedBottomSheet extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurSigma;

  const FrostedBottomSheet({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.blurSigma = 25,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(borderRadius.r),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSigma,
          sigmaY: blurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(borderRadius.r),
            ),
            border: Border(
              top: BorderSide(
                color: AppColors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 玻璃态导航栏
class FrostedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final double blurSigma;
  final double height;
  final bool centerTitle;
  final Color? backgroundColor;
  final VoidCallback? onBackTap;

  const FrostedAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.blurSigma = 20,
    this.height = 56,
    this.centerTitle = true,
    this.backgroundColor,
    this.onBackTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(height.w);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSigma,
          sigmaY: blurSigma,
        ),
        child: Container(
          height: height.w + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.background.withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(
                color: AppColors.divider.withValues(alpha: 0.5),
                width: 0.5,
              ),
            ),
          ),
          child: NavigationToolbar(
            leading: leading ??
                (onBackTap != null
                    ? IconButton(
                        onPressed: onBackTap,
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.white,
                        ),
                      )
                    : null),
            middle: titleWidget ??
                (title != null
                    ? Text(
                        title!,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null),
            trailing: actions != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  )
                : null,
            centerMiddle: centerTitle,
          ),
        ),
      ),
    );
  }
}

/// 增强阴影系统 - 支持发光效果
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> none = [];

  /// 微弱发光（用于强调元素）
  static const List<BoxShadow> glow = [
    BoxShadow(
      color: Color(0x40AF52DE),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  /// 紫色发光
  static List<BoxShadow> purpleGlow({double opacity = 0.4}) {
    return [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: opacity),
        blurRadius: 20,
        spreadRadius: 2,
      ),
    ];
  }

  /// 金色发光（VIP专属）
  static List<BoxShadow> goldGlow({double opacity = 0.5}) {
    return [
      BoxShadow(
        color: const Color(0xFFFFD700).withValues(alpha: opacity),
        blurRadius: 25,
        spreadRadius: 3,
      ),
    ];
  }

  /// 卡片阴影
  static List<BoxShadow> card({Color? color}) {
    return [
      BoxShadow(
        color: (color ?? AppColors.black).withValues(alpha: 0.2),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];
  }

  /// 浮动阴影
  static List<BoxShadow> elevated({Color? color}) {
    return [
      BoxShadow(
        color: (color ?? AppColors.black).withValues(alpha: 0.3),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ];
  }
}
