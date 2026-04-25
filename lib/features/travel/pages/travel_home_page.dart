import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/router/app_router.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/features/travel/pages/travel_destination_details_page.dart';
import 'package:flutter_easy_starter/features/travel/widgets/activity_tile_list_view_widget.dart';
import 'package:flutter_easy_starter/features/travel/widgets/s_custom_painter.dart';

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
        padding: const EdgeInsets.only(top: 20, bottom: 30),
        children: [
          // 顶部欢迎语
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '你好，开发者 👋',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '探索世界各地的精彩旅程',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.lightGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 活动分类
          const ActivityTileListView(),
          const SizedBox(height: 30),

          // 热门目的地标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '热门目的地',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AppRouter.pushNamed(RouteNames.allDestinations);
                  },
                  child: const Text(
                    '查看全部',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

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
                height: 380,
                margin: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                child: Stack(
                  children: [
                    // 主卡片
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
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
                                  height: 180,
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
                                  height: 32,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: AppColors.yellow,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '4.${Random.secure().nextInt(8) + 1}',
                                        style: const TextStyle(
                                          fontSize: 14,
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
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildDayAndPrice(),
                                    const SizedBox(height: 12),
                                    // 参与者头像
                                    SizedBox(
                                      height: 36,
                                      child: Row(
                                        children: [
                                          for (int i = 0; i < 3; i++)
                                            Container(
                                              width: 36,
                                              height: 36,
                                              margin: const EdgeInsets.only(right: 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(18),
                                                border: Border.all(
                                                  color: Colors.white.withOpacity(0.5),
                                                  width: 2,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(18),
                                                child: Image.asset(
                                                  'assets/images/travel/profile/profile_${(i % 6) + 1}.jpeg',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: AppColors.surface,
                                              borderRadius: BorderRadius.circular(18),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '+4',
                                                style: TextStyle(
                                                  fontSize: 12,
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
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius:
                              const BorderRadius.only(
                                  topLeft: Radius.circular(50)),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        width: 70,
                        height: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: const Icon(
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
      style: const TextStyle(
        fontSize: 18,
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
