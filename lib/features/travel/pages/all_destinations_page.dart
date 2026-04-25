import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/router/app_router.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/features/travel/pages/travel_destination_details_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

/// 全部热门目的地页面 - iOS风格下拉刷新 + 上拉加载
class AllDestinationsPage extends StatefulWidget {
  const AllDestinationsPage({super.key});

  @override
  State<AllDestinationsPage> createState() => _AllDestinationsPageState();
}

class _AllDestinationsPageState extends State<AllDestinationsPage> {
  final List<Map<String, dynamic>> _destinations = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  bool _hasMore = true;
  int _loadCount = 0;
  final int _maxLoadCount = 3;

  final List<String> _destinationNames = [
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
    '杜罗河谷',
    '亚速尔群岛',
    '法蒂玛圣地',
    '纳扎雷海滩',
    '奥比都斯小镇',
    '佩纳宫',
    '雷加莱拉宫',
    '热罗尼莫斯修道院',
    '贝伦塔',
    '发现者纪念碑',
    '圣乔治城堡',
    '奥古斯塔街',
    '自由大道',
    '爱德华七世公园',
    '东方火车站',
    '海洋水族馆',
    '万国公园',
    '卡斯卡伊斯',
    '埃斯托利尔',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    _destinations.addAll(_generateDestinations(10));
  }

  List<Map<String, dynamic>> _generateDestinations(int count) {
    final List<Map<String, dynamic>> list = [];
    final startIndex = _destinations.length;
    for (int i = 0; i < count; i++) {
      final index = (startIndex + i) % _destinationNames.length;
      list.add({
        'name': _destinationNames[index],
        'imageIndex': (startIndex + i) % 11,
        'rating': '4.${Random.secure().nextInt(8) + 1}',
        'days': Random.secure().nextInt(4) + 1,
        'price': (Random.secure().nextInt(10) + 14) * (Random.secure().nextInt(4) + 1),
        'reviews': Random.secure().nextInt(200) + 50,
      });
    }
    return list;
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _destinations.clear();
      _destinations.addAll(_generateDestinations(10));
      _loadCount = 0;
      _hasMore = true;
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (!_hasMore) {
      _refreshController.loadNoData();
      return;
    }

    await Future.delayed(const Duration(seconds: 1));

    _loadCount++;
    if (_loadCount >= _maxLoadCount) {
      _hasMore = false;
    }

    setState(() {
      _destinations.addAll(_generateDestinations(10));
    });

    if (_hasMore) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        header: CustomHeader(
          builder: (context, mode) {
            Widget body;
            if (mode == RefreshStatus.idle) {
              body = const Text('下拉刷新', style: TextStyle(color: Colors.grey));
            } else if (mode == RefreshStatus.refreshing || mode == RefreshStatus.canRefresh) {
              body = const CupertinoActivityIndicator(radius: 14);
            } else if (mode == RefreshStatus.completed) {
              body = const Text('刷新完成', style: TextStyle(color: Colors.grey));
            } else {
              body = const Text('下拉刷新', style: TextStyle(color: Colors.grey));
            }
            return SizedBox(
              height: 60.w,
              child: Center(child: body),
            );
          },
        ),
        footer: CustomFooter(
          builder: (context, mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text('上拉加载更多', style: TextStyle(color: Colors.grey));
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator(radius: 14);
            } else if (mode == LoadStatus.failed) {
              body = const Text('加载失败，点击重试', style: TextStyle(color: Colors.grey));
            } else if (mode == LoadStatus.canLoading) {
              body = const Text('松开加载更多', style: TextStyle(color: Colors.grey));
            } else {
              body = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: AppColors.lightGrey.withOpacity(0.5),
                    size: 32,
                  ),
                  SizedBox(height: 8.w),
                  Text(
                    '已经到底了，没有更多目的地',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.lightGrey.withOpacity(0.5),
                    ),
                  ),
                ],
              );
            }
            return SizedBox(
              height: mode == LoadStatus.noMore ? 100 : 60,
              child: Center(child: body),
            );
          },
        ),
        child: CustomScrollView(
          slivers: [
            // iOS风格导航栏
            CupertinoSliverNavigationBar(
              largeTitle: Text('热门目的地',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.background,
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
              leading: CupertinoNavigationBarBackButton(
                color: AppColors.primary,
                onPressed: () => AppRouter.pop(),
              ),
            ),

            // 内容列表
            SliverPadding(
              padding: EdgeInsets.all(16.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildDestinationCard(_destinations[index], index);
                  },
                  childCount: _destinations.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationCard(Map<String, dynamic> destination, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TravelDestinationDetailsPage(
              destinationName: 'destination_${destination['imageIndex']}.jpeg',
            ),
          ),
        );
      },
      child: Container(
        height: 280.w,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Stack(
            children: [
              // 背景图片
              Positioned.fill(
                child: Hero(
                  tag: 'all_dest_$index',
                  child: Image.asset(
                    'assets/images/travel/destination/destination_${destination['imageIndex']}.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // 渐变遮罩
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
                        Colors.black.withOpacity(0),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.9),
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
                        destination['rating'],
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
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.w),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.lightGrey,
                          size: 16,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '葡萄牙',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.lightGrey,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Icon(
                          Icons.access_time_outlined,
                          color: AppColors.lightGrey,
                          size: 16,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${destination['days']} 天',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.lightGrey,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          '${destination['price']}€',
                          style: TextStyle(fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.w),
                    Text(
                      '${destination['reviews']} 条评价',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.lightGrey.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
