import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/router/app_router.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/widgets/animated_button.dart';
import 'package:flutter_easy_starter/features/travel/pages/travel_destination_details_page.dart';
import 'package:flutter_easy_starter/features/travel/widgets/activity_tile_list_view_widget.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
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
        padding: EdgeInsets.only(top: 42.w, bottom: 24.w),
        children: [
          // 顶部欢迎语
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '你好，开发者 👋',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 6.w),
                Text(
                  '探索世界各地的精彩旅程',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.lightGrey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.w),

          // 活动分类
          const ActivityTileListView(),
          SizedBox(height: 24.w),

          // 热门目的地标题
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '热门目的地',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                AnimatedButton(
                  onTap: () {
                    AppRouter.pushNamed(RouteNames.allDestinations);
                  },
                  scaleDown: 0.95,
                  child: Text(
                    '查看全部',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),

          // 目的地列表
          for (int index = 0; index < 10; index++)
            AnimatedButton(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TravelDestinationDetailsPage(
                      destinationName: 'destination_$index.jpeg',
                    ),
                  ),
                );
              },
              scaleDown: 0.97,
              enableHaptic: true,
              child: Container(
                height: 320.w,
                margin: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 8.w,
                ),
                child: Stack(
                  children: [
                    // 主卡片
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
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
                                  height: 140.w,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0),
                                        Colors.black.withValues(alpha: 0.5),
                                        Colors.black.withValues(alpha: 0.85),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // 评分标签
                              Positioned(
                                top: 12.w,
                                right: 12.w,
                                child: Container(
                                  height: 28.w,
                                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        LucideIcons.star,
                                        color: AppColors.yellow,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '4.${Random.secure().nextInt(8) + 1}',
                                        style: TextStyle(
                                          fontSize: 12.sp,
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
                                left: 16.w,
                                right: 80.w,
                                bottom: 16.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getDestinationName(index),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                                    SizedBox(height: 8.w),
                                    _buildDayAndPrice(),
                                    SizedBox(height: 8.w),
                                    // 参与者头像
                                    _buildParticipants(),
                                  ],
                                ),
                              ),
                              // 收藏按钮
                              Positioned(
                                right: 16.w,
                                bottom: 16.w,
                                child: AnimatedButton(
                                  onTap: () {},
                                  scaleDown: 0.85,
                                  child: Container(
                                    width: 44.w,
                                    height: 44.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: AppColors.white.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Icon(
                                      LucideIcons.heart,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    return Row(
      children: [
        Icon(
          LucideIcons.calendar,
          color: AppColors.white.withValues(alpha: 0.8),
          size: 14,
        ),
        SizedBox(width: 6.w),
        Text(
          '${Random.secure().nextInt(5) + 3} 天',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.white.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          '¥${(Random.secure().nextInt(20) + 5) * 100}',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipants() {
    return Row(
      children: [
        // 头像堆叠
        SizedBox(
          width: 60.w,
          height: 24.w,
          child: Stack(
            children: [
              for (int i = 0; i < 3; i++)
                Positioned(
                  left: i * 16.w,
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.asset(
                        'assets/images/travel/profile/profile_${(i % 6) + 1}.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          '${Random.secure().nextInt(50) + 10} 人已参加',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  String _getDestinationName(int index) {
    final names = [
      '马尔代夫蓝色天堂',
      '瑞士阿尔卑斯山',
      '日本京都古韵',
      '希腊圣托里尼',
      '新西兰南岛探险',
      '冰岛极光之旅',
      '巴厘岛热带天堂',
      '挪威峡湾巡游',
      '摩洛哥撒哈拉',
      '秘鲁马丘比丘',
    ];
    return names[index % names.length];
  }
}
