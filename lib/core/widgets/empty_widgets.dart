import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/widgets/animated_button.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'shimmer_widgets.dart';

/// 空状态组件 - Dark Social 风格
class EmptyWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onRetry;

  const EmptyWidget({
    super.key,
    this.title,
    this.subtitle,
    this.icon = LucideIcons.inbox,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: StaggeredAnimation(
          index: 0,
          type: AnimationType.scale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88.w,
                height: 88.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.surface,
                      AppColors.surfaceVariant.withValues(alpha: 0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: AppColors.lightGrey,
                ),
              ),
              SizedBox(height: 24.w),
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (subtitle != null)
                Padding(
                  padding: EdgeInsets.only(top: 8.w),
                  child: Text(
                    subtitle!,
                    style: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 15.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (onRetry != null)
                Padding(
                  padding: EdgeInsets.only(top: 24.w),
                  child: AnimatedButton(
                    onTap: onRetry,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.refresh_cw,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '重新加载',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 错误状态组件 - Dark Social 风格
class AppErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: StaggeredAnimation(
          index: 0,
          type: AnimationType.scale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88.w,
                height: 88.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.red.withValues(alpha: 0.2),
                      AppColors.red.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Icon(
                  LucideIcons.circle_alert,
                  size: 40,
                  color: AppColors.red,
                ),
              ),
              SizedBox(height: 24.w),
              Text(
                message ?? '加载失败',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.w),
              Text(
                '请检查网络连接后重试',
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 14.sp,
                ),
              ),
              if (onRetry != null)
                Padding(
                  padding: EdgeInsets.only(top: 24.w),
                  child: AnimatedButton(
                    onTap: onRetry,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.refresh_cw,
                            size: 16,
                            color: AppColors.red,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '重新加载',
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 加载状态组件 - Dark Social 风格（带动画）
class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PulseAnimation(
            duration: const Duration(milliseconds: 1500),
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    AppColors.primary.withValues(alpha: 0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (message != null)
            Padding(
              padding: EdgeInsets.only(top: 16.w),
              child: Text(
                message!,
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 14.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 骨架屏组件 - Dark Social 风格（使用 shimmer）
class SkeletonWidget extends StatelessWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  const SkeletonWidget({
    super.key,
    required this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerContainer(
      width: width,
      height: height,
      borderRadius: (borderRadius?.topLeft.y ?? 12),
    );
  }
}

/// 页面级骨架屏 - 通用列表
class PageSkeleton extends StatelessWidget {
  final int itemCount;
  final bool hasImage;
  final bool hasSubtitle;

  const PageSkeleton({
    super.key,
    this.itemCount = 6,
    this.hasImage = true,
    this.hasSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerList(
      itemCount: itemCount,
      hasImage: hasImage,
      hasSubtitle: hasSubtitle,
      padding: EdgeInsets.symmetric(vertical: 16.w),
    );
  }
}

/// 网格骨架屏
class GridSkeleton extends StatelessWidget {
  final int crossAxisCount;
  final int itemCount;

  const GridSkeleton({
    super.key,
    this.crossAxisCount = 3,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerGrid(
      crossAxisCount: crossAxisCount,
      itemCount: itemCount,
      padding: EdgeInsets.all(16.w),
    );
  }
}
