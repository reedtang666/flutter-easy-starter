import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/widgets/animated_button.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 确认弹窗
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? customContent;
  final String confirmText;
  final String cancelText;
  final bool isDanger;

  const ConfirmDialog({
    super.key,
    required this.title,
    this.content,
    this.customContent,
    required this.confirmText,
    required this.cancelText,
    this.isDanger = false,
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
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: isDanger
                    ? AppColors.red.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                isDanger ? LucideIcons.triangle_alert : LucideIcons.message_circle,
                color: isDanger ? AppColors.red : AppColors.primary,
                size: 28,
              ),
            ),
            SizedBox(height: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            if (content != null) ...[
              SizedBox(height: 12.w),
              Text(
                content!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.lightGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (customContent != null) ...[
              SizedBox(height: 16.w),
              customContent!,
            ],
            SizedBox(height: 24.w),
            Row(
              children: [
                Expanded(
                  child: AnimatedButton(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.w),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Text(
                        cancelText,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AnimatedButton(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).pop(true);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.w),
                      decoration: BoxDecoration(
                        color: isDanger ? AppColors.red : AppColors.primary,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: (isDanger ? AppColors.red : AppColors.primary)
                                .withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        confirmText,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
