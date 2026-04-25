import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/router/app_router.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/features/travel/pages/travel_destination_details_page.dart';
import 'package:flutter_easy_starter/features/travel/widgets/activity_tile_list_view_widget.dart';
import 'package:flutter_easy_starter/features/travel/widgets/s_custom_painter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TravelHomePage extends StatefulWidget {
  const TravelHomePage({super.key});

  @override
  State<TravelHomePage> createState() => _TravelHomePageState();
}

class _TravelHomePageState extends State<TravelHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: EdgeInsets.only(top: 20, bottom: 30),
        children: [
          // 顶部欢迎语
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '你好，开发者 👋',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 8.w),
                Text(
                  '探索世界各地的精彩旅程',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.lightGrey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.w),

          // 活动分类
          const ActivityTileListView(),
          SizedBox(height: 30.w),

          // 热门目的地标题
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '热门目的地',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AppRouter.pushNamed(RouteNames.allDestinations);
                  },
                  child: Text(
                    '查看全部',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.w),

          // 目的地列表
          for (int index = 0; index < 10; index++)
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TravelDestinationDetailsPage(
                      destinationName: 'destination_$index.jpeg',
                    ),
                  ),
                );
              },
              child: Container(
                height: 380.w,
                margin: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                child: Stack(
                  children: [
                    // 主卡片
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32.r),
                          child: Stack(
                            children: [
                              // 背景图片
                              Positioned.fill(
                                child: Hero(
                                  tag: 'destination_$index.jpeg',
                                  child: Image.asset(
                                    'assets/images/travel/destination/destination_${(index % 11)}.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // 底部渐变遮罩
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 180.w,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0),
                                        Colors.black.withOpacity(0.5),
                                        Colors.black.withOpacity(0.85),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // 评分标签
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Container(
                                  height: 32.w,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: AppColors.yellow,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '4.${Random.secure().nextInt(8) + 1}',
                                        style: TextStyle(fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // 底部信息
                              Positioned(
                                left: 24,
                                right: 100,
                                bottom: 24,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getDestinationName(index),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 28.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                                    SizedBox(height: 12.w),
                                    _buildDayAndPrice(),
                                    SizedBox(height: 12.w),
                                    // 参与者头像
                                    SizedBox(
                                      height: 36.w,
                                      child: Row(
                                        children: [
                                          for (int i = 0; i < 3; i++)
                                            Container(
                                              width: 36.w,
                                              height: 36.w,
                                              margin: EdgeInsets.only(right: 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(18.r),
                                                border: Border.all(
                                                  color: Colors.white.withOpacity(0.5),
                                                  width: 2.w,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(18.r),
                                                child: Image.asset(
                                                  'assets/images/travel/profile/profile_${(i % 6) + 1}.jpeg',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          Container(
                                            width: 36.w,
                                            height: 36.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.surface,
                                              borderRadius: BorderRadius.circular(18.r),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '+4',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 右下角弧形装饰和按钮
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 90.w,
                        height: 90.w,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius:
                              BorderRadius.only(
                                  topLeft: Radius.circular(50.r)),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        width: 70.w,
                        height: 70.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(35.r),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDayAndPrice() {
    final days = Random.secure().nextInt(4) + 1;
    return Text(
      '$days 天 • ${days * (Random.secure().nextInt(10) + 14)}€',
      style: TextStyle(fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  String _getDestinationName(int index) {
    final names = [
      '塞拉多艾拉',
      '马德拉群岛',
      '里斯本老城',
      '辛特拉宫',
      '阿尔加维海滩',
      '波尔图酒庄',
      '阿威罗水城',
      '埃武拉古城',
      '科英布拉大学',
      '布拉加大教堂',
    ];
    return names[index % names.length];
  }
}
