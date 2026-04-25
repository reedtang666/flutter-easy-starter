import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListingHeaderWidget extends StatelessWidget {
  const ListingHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.w,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 62.w,
            height: 62.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(55.r),
            ),
            child: Icon(
              Icons.menu_rounded,
              size: 30,
              color: AppColors.white,
            ),
          ),
          Spacer(),
          Container(
            width: 62.w,
            height: 62.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(55.r),
            ),
            child: Icon(
              Icons.search_rounded,
              size: 30,
              color: AppColors.white,
            ),
          ),
          SizedBox(width: 5.w),
          Container(
            width: 62.w,
            height: 62.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(55.r),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 30,
              color: AppColors.white,
            ),
          ),
          SizedBox(width: 5.w),
          Container(
            width: 62.w,
            height: 62.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(55.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(55.r),
              child: Image.asset(
                'assets/images/travel/profile/profile_4.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
