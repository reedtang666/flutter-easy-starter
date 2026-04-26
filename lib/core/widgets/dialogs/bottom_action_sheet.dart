import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/widgets/animated_button.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dialog_models.dart';

/// 底部操作菜单
class BottomActionSheet<T> extends StatelessWidget {
  final String? title;
  final List<BottomSheetAction<T>> actions;
  final bool showCancel;

  const BottomActionSheet({
    super.key,
    this.title,
    required this.actions,
    this.showCancel = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      child: Text(
                        title!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.lightGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ...actions.map((action) => _buildActionItem(context, action)),
                ],
              ),
            ),
            if (showCancel) ...[
              SizedBox(height: 12.w),
              AnimatedButton(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    '取消',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, BottomSheetAction<T> action) {
    return AnimatedButton(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop(action.value);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 20.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.white.withValues(alpha: 0.05),
            ),
          ),
        ),
        child: Row(
          children: [
            if (action.icon != null) ...[
              Icon(
                action.icon,
                color: action.iconColor ?? AppColors.lightGrey,
                size: 22,
              ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Text(
                action.label,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: action.isBold ? FontWeight.w600 : FontWeight.w400,
                  color: action.isDestructive ? AppColors.red : Colors.white,
                ),
              ),
            ),
            if (action.isSelected)
              Icon(
                LucideIcons.check,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
