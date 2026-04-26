import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/widgets/animated_button.dart';
import 'package:flutter_easy_starter/features/travel/model/activity_model.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityTileListView extends StatefulWidget {
  const ActivityTileListView({super.key});

  @override
  State<ActivityTileListView> createState() => _ActivityTileListViewState();
}

class _ActivityTileListViewState extends State<ActivityTileListView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.w,
      child: ListView.builder(
        itemCount: ActivityModel.dummyList.length,
        padding: EdgeInsets.only(left: 20.w),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final model = ActivityModel.dummyList[index];
          final isSelected = _selectedIndex == index;

          return AnimatedButton(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            scaleDown: 0.95,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              height: 52.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.2),
                          AppColors.primary.withValues(alpha: 0.05),
                        ],
                      )
                    : null,
                color: isSelected ? null : AppColors.surface,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.white.withValues(alpha: 0.05),
                  width: isSelected ? 1.5.w : 1.w,
                ),
                borderRadius: BorderRadius.circular(26.r),
              ),
              padding: EdgeInsets.only(
                left: 4.w,
                right: 16.w,
                top: 4.w,
                bottom: 4.w,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    height: 44.w,
                    width: 44.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22.r),
                      child: Image.asset(
                        'assets/images/travel/activity/${model.assetName}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    model.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
