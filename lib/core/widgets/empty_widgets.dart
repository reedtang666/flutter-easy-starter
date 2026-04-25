import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';

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
    this.icon = Icons.inbox_outlined,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.lightGrey,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (title != null)
              Text(
                title!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xl),
                child: TextButton(
                  onPressed: onRetry,
                  child: const Text('重新加载'),
                ),
              ),
          ],
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
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: AppColors.red,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message ?? '加载失败',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.white,
              ),
            ),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xl),
                child: ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('重新加载'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 加载状态组件 - Dark Social 风格
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
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              child: Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }
}

/// 骨架屏组件 - Dark Social 风格
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
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.md),
      ),
    );
  }
}
