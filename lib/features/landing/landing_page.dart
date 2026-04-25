import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
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

    if (mounted) {
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
                    AppColors.primary.withOpacity(0.2),
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
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.3),
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
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Spacer(flex: 1),

                    // Logo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.rocket_launch,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // App 名称
                    const Text(
                      'Flutter Easy Starter',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const Spacer(flex: 2),

                    // 轮播内容
                    SizedBox(
                      height: 220,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _buildGuideContent(_guides[_currentIndex]),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 指示器
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _guides.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _currentIndex == index ? 32 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? AppColors.primary
                                : AppColors.tertiaryGrey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // 按钮区域
                    GestureDetector(
                      onTap: _onStart,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '开始使用',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
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

                    const SizedBox(height: 32),

                    // 底部文字
                    Text(
                      '基于本框架，快速构建你的 Flutter 应用',
                      style: TextStyle(
                        color: AppColors.lightGrey.withOpacity(0.8),
                        fontSize: 13,
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
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            item.icon,
            size: 40,
            color: item.color,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          item.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 15,
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
