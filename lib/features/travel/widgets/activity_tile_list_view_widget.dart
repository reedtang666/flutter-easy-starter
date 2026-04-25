import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/features/travel/model/activity_model.dart';
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
      height: 65.w,
      child: ListView.builder(
        itemCount: ActivityModel.dummyList.length,
        padding: EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final model = ActivityModel.dummyList[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              height: 60.w,
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: _selectedIndex == index
                    ? Border.all(
                        color: AppColors.white,
                        width: 1.1,
                      )
                    : null,
                borderRadius: BorderRadius.circular(50.r),
              ),
              padding: EdgeInsets.only(left: 5, right: 22, top: 5, bottom: 5),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    height: 66.w,
                    width: 53.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: Image.asset(
                        'assets/images/travel/activity/${model.assetName}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Text(
                    model.name,
                    style: TextStyle(fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
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
