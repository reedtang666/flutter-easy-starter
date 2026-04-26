import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/widgets/animated_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 通知弹窗
class NotificationDialog extends StatelessWidget {
  final String title;
  final String? content;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onAction;
  final String? actionText;

  const NotificationDialog({
    super.key,
    required this.title,
    this.content,
    required this.icon,
    required this.iconColor,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    iconColor.withValues(alpha: 0.3),
                    iconColor.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
            SizedBox(height: 20.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (content != null) ...[
              SizedBox(height: 12.w),
              Text(
                content!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.lightGrey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: 24.w),
            AnimatedButton(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
                if (onAction != null) {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    onAction!();
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryLight,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  actionText ?? '知道了',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
