import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/features/travel/widgets/frosted_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TravelBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TravelBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<TravelBottomNavBar> createState() => _TravelBottomNavBarState();
}

class _TravelBottomNavBarState extends State<TravelBottomNavBar> {
  static final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.favorite_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60.r),
        child: FrostedWidget(
          color: AppColors.darkGrey.withOpacity(.8),
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeIn,
                  left: widget.currentIndex * 80,
                  top: 0,
                  child: Container(
                    height: 82.w,
                    width: 82.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int index = 0; index < 4; index++)
                        Expanded(
                          child: GestureDetector(
                            onTap: () => widget.onTap(index),
                            behavior: HitTestBehavior.translucent,
                            child: Center(
                              child: Icon(
                                _icons[index],
                                size: 30,
                                color: widget.currentIndex == index
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
