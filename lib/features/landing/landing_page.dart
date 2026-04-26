import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/constants/storage_keys.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 引导页 - 展示框架核心卖点
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;
  Timer? _timer;

  final List<_GuideItem> _guides = [
    _GuideItem(
      title: '开箱即用',
      subtitle: '集成路由、状态管理、网络请求等核心能力，无需从零配置',
      icon: Icons.auto_awesome,
      color: const Color(0xFFFF9F0A),
    ),
    _GuideItem(
      title: '功能完整',
      subtitle: '内置 IM、用户系统、权限管理等常用模块，拿来即用',
      icon: Icons.apps,
      color: const Color(0xFF30D158),
    ),
    _GuideItem(
      title: '易于扩展',
      subtitle: 'Clean Architecture 设计，分层清晰，方便二次开发和维护',
      icon: Icons.architecture,
      color: const Color(0xFF0A84FF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _guides.length;
      });
    });
  }

  Future<void> _onStart() async {
    // 标记为非首次启动
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_launch', false);

    if (!mounted) return;

    // 检查登录状态，未登录则进入登录页
    final token = prefs.getString(StorageKeys.token);
    final isLoggedIn = token?.isNotEmpty ?? false;

    if (!isLoggedIn) {
      context.go(RouteNames.login);
    } else {
      context.go(RouteNames.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 背景渐变
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.2),
                    AppColors.background,
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),

          // 装饰性圆形
          Positioned(
            top: -150,
            right: -150,
            child: Container(
              width: 400.w,
              height: 400.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 主内容
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(32.w),
                child: Column(
                  children: [
                    Spacer(flex: 1),

                    // Logo
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.rocket_launch,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 24.w),

                    // App 名称
                    Text(
                      'Flutter Easy Starter',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    Spacer(flex: 2),

                    // 轮播内容
                    SizedBox(
                      height: 220.w,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _buildGuideContent(_guides[_currentIndex]),
                      ),
                    ),

                    SizedBox(height: 40.w),

                    // 指示器
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _guides.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _currentIndex == index ? 32 : 8,
                          height: 8.w,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? AppColors.primary
                                : AppColors.tertiaryGrey,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ),

                    Spacer(flex: 2),

                    // 按钮区域
                    GestureDetector(
                      onTap: _onStart,
                      child: Container(
                        height: 56.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '开始使用',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32.w),

                    // 底部文字
                    Text(
                      '基于本框架，快速构建你的 Flutter 应用',
                      style: TextStyle(
                        color: AppColors.lightGrey.withValues(alpha: 0.8),
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideContent(_GuideItem item) {
    return Column(
      key: ValueKey(item.title),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Icon(
            item.icon,
            size: 40,
            color: item.color,
          ),
        ),
        SizedBox(height: 32.w),
        Text(
          item.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.w),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 15.sp,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _GuideItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _GuideItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
