import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/widgets/animated_button.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dialog_models.dart';

/// 选择弹窗
class SelectionDialog<T> extends StatelessWidget {
  final String title;
  final List<SelectionItem<T>> items;
  final T? selectedValue;

  const SelectionDialog({
    super.key,
    required this.title,
    required this.items,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320.w,
        constraints: BoxConstraints(maxHeight: 480.w),
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
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Divider(
              height: 1,
              color: AppColors.white.withValues(alpha: 0.1),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item.value == selectedValue;
                  return AnimatedButton(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop(item.value);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.w,
                        horizontal: 20.w,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : null,
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.white.withValues(alpha: 0.05),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (item.icon != null) ...[
                            Container(
                              width: 36.w,
                              height: 36.w,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.2)
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                item.icon,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.lightGrey,
                                size: 18,
                              ),
                            ),
                            SizedBox(width: 12.w),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.white,
                                  ),
                                ),
                                if (item.subtitle != null) ...[
                                  SizedBox(height: 4.w),
                                  Text(
                                    item.subtitle!,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              LucideIcons.check,
                              color: AppColors.primary,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
