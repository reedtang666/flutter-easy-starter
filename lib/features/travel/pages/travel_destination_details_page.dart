import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/features/travel/widgets/frosted_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TravelDestinationDetailsPage extends StatefulWidget {
  final String destinationName;

  const TravelDestinationDetailsPage({
    required this.destinationName,
    super.key,
  });

  @override
  State<TravelDestinationDetailsPage> createState() =>
      _TravelDestinationDetailsPageState();
}

class _TravelDestinationDetailsPageState
    extends State<TravelDestinationDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.only(top: 0, bottom: 150),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .72,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Hero(
                          tag: widget.destinationName,
                          child: Image.asset(
                            'assets/images/travel/destination/${widget.destinationName}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 200.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black,
                                Colors.black.withOpacity(0.67),
                                Colors.black.withOpacity(0.0),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 100,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 210.w,
                          width: 180.w,
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '罗卡角灯塔',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 35.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.1,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15.w),
                                  SizedBox(
                                    height: 100.w,
                                    width: 100.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              CupertinoIcons.star_fill,
                                              color: AppColors.yellow,
                                              size: 24,
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              '4.5',
                                              style: TextStyle(
                                                fontSize: 21.sp,
                                                color: Colors.white
                                                    .withOpacity(.8),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.w),
                                        Text(
                                          '123 条评价',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.white.withOpacity(.8),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.w),
                              SizedBox(
                                height: 40.w,
                                width: 170.w,
                                child: Stack(
                                  children: [
                                    for (int index = 0; index < 3; index++)
                                      Positioned(
                                        left: index * 28,
                                        child: Container(
                                          height: 40.w,
                                          width: 40.w,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(.3),
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                          padding: EdgeInsets.all(2.5.w),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                            child: Image.asset(
                                              'assets/images/travel/profile/profile_${(index % 6) + 1}.jpeg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    Positioned(
                                      left: 3 * 28,
                                      child: SizedBox(
                                        width: 40.w,
                                        height: 40.w,
                                        child: FrostedWidget(
                                          color: Colors.grey,
                                          child: Text(
                                            '+4',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
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
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ListViewHeader(),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100.w,
                  color: AppColors.background,
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DestinationStatsWidget(
                        title: '位置',
                        value: '葡萄牙',
                        iconData: Icons.location_on,
                      ),
                      DestinationStatsWidget(
                        title: '价格',
                        value: '80€',
                        iconData: Icons.euro,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: AppColors.background,
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    '罗卡角是辛特拉山脉的最西端，也是葡萄牙大陆、'
                    '欧洲大陆和欧亚大陆的最西端。它位于辛特拉市阿佐亚附近，'
                    '里斯本区的西南部，形成了辛特拉山脉的最西端。'
                    '该海角位于欧洲大陆的最西端，处于辛特拉-卡斯卡伊斯自然公园内，'
                    '是一个受欢迎的旅游景点，标志着欧洲大陆的最西端。',
                    maxLines: 11,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.lightGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 70,
            left: 25,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              behavior: HitTestBehavior.translucent,
              child: TweenAnimationBuilder(
                tween: Tween<double>(
                    begin: _scrollPosition >= 160 ? 1 : 0,
                    end: _scrollPosition >= 160 ? 0 : 1),
                duration: const Duration(milliseconds: 500),
                curve: _scrollPosition >= 160 ? Curves.easeOut : Curves.bounceOut,
                builder: (context, double value, child) {
                  return Container(
                    height: 65 * value,
                    width: 65 * value,
                    decoration: BoxDecoration(
                      color: AppColors.darkGrey,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 30 * value,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 140.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.background,
                    AppColors.background.withOpacity(0.67),
                    AppColors.background.withOpacity(0.0),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 28,
            left: 20,
            right: 20,
            child: Container(
              height: 54.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20.r),
              ),
              alignment: Alignment.center,
              child: Text(
                '立即预订',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DestinationStatsWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData iconData;

  const DestinationStatsWidget({
    required this.title,
    required this.value,
    required this.iconData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            height: 60.w,
            width: 60.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Icon(iconData, color: AppColors.white),
          ),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.lightGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ListViewHeader extends StatefulWidget {
  const ListViewHeader({super.key});

  @override
  State<ListViewHeader> createState() => _ListViewHeaderState();
}

class _ListViewHeaderState extends State<ListViewHeader> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['概览', '评价'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.w,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 80.w,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45.r),
                  topRight: Radius.circular(45.r),
                ),
              ),
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (int i = 0; i < _tabs.length; i++)
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = i;
                          });
                        },
                        child: SizedBox(
                          width: 100.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _tabs[i],
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: i == _selectedIndex
                                      ? AppColors.primary
                                      : AppColors.lightGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.w),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: i == _selectedIndex ? 9 : 0,
                                width: i == _selectedIndex ? 9 : 0,
                                decoration: BoxDecoration(
                                  color: i == _selectedIndex
                                      ? AppColors.primary
                                      : AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(10.r),
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
          Positioned(
            right: 25,
            top: 5,
            child: Container(
              height: 90.w,
              width: 90.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(90.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.bookmark_rounded,
                color: AppColors.primary,
                size: 35,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
