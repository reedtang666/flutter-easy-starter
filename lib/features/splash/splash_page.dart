import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/constants/storage_keys.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/services/storage_service.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 启动页 - Flutter Easy Starter
///
/// 启动流程：
/// 1. 检查隐私政策同意状态 → 未同意则进入隐私政策页
/// 2. 检查登录状态 → 未登录则进入登录页
/// 3. 检查是否首次启动 → 首次则进入引导页
/// 4. 否则直接进入主框架
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late Animation<double> _logoAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _pulseController.repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 300), () {
      _logoController.forward();
    });

    // 启动检查流程
    _checkAppState();
  }

  Future<void> _checkAppState() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 1. 检查隐私政策是否同意
    final privacyAccepted = StorageService.instance.getBool(StorageKeys.privacyAccepted) ?? false;
    if (!privacyAccepted) {
      context.go(RouteNames.privacy);
      return;
    }

    // 2. 检查登录状态
    final token = StorageService.instance.getString(StorageKeys.token);
    final isLoggedIn = token.isNotEmpty;
    if (!isLoggedIn) {
      // 未登录，进入登录页
      context.go(RouteNames.login);
      return;
    }

    // 3. 检查是否首次启动（已登录情况下跳过引导页）
    final isFirstLaunch = StorageService.instance.getBool(StorageKeys.isFirstLaunch) ?? true;
    if (isFirstLaunch) {
      // 首次启动，进入引导页
      context.go(RouteNames.landing);
    } else {
      // 非首次，直接进入主框架
      context.go(RouteNames.main);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 背景装饰 - 渐变光晕
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.3),
                  radius: 0.8,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 内容 - 完全居中
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo 动画
                ScaleTransition(
                  scale: _logoAnimation,
                  child: ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(32.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.rocket_launch,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40.w),

                // App 名称
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Flutter Easy Starter',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                SizedBox(height: 12.w),

                // Slogan
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    '开箱即用的快速开发框架',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.lightGrey,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                SizedBox(height: 80.w),

                // 加载指示器
                SizedBox(
                  width: 32.w,
                  height: 32.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(height: 16.w),

                // 版本号
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.tertiaryGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
