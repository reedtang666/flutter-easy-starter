import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/constants/storage_keys.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/services/storage_service.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// 引导页数据模型
class GuideItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const GuideItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

/// 引导页内容 - 社交主题
const List<GuideItem> guideItems = [
  GuideItem(
    title: '发现缘分',
    subtitle: '滑动卡片，发现身边的有趣灵魂\n开启你的心动之旅',
    icon: Icons.favorite,
    color: AppColors.primary,
  ),
  GuideItem(
    title: '实时聊天',
    subtitle: '匹配成功后立即开始聊天\n文字、语音、视频，随时畅聊',
    icon: Icons.chat_bubble,
    color: AppColors.pink,
  ),
  GuideItem(
    title: '真实认证',
    subtitle: '多重认证保障真实交友\n安全可靠，放心相识',
    icon: Icons.verified_user,
    color: AppColors.green,
  ),
  GuideItem(
    title: '开始探索',
    subtitle: '准备好遇见那个特别的人了吗？\n现在就开启你的旅程',
    icon: Icons.explore,
    color: AppColors.blue,
  ),
];

/// 引导页 - Dark Social 风格
class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _isLastPage = page == guideItems.length - 1;
    });
  }

  void _nextPage() {
    if (_isLastPage) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: AppDurations.slow,
        curve: AppEasings.standard,
      );
    }
  }

  void _skip() {
    _finish();
  }

  Future<void> _finish() async {
    await StorageService.instance.setBool(StorageKeys.isFirstLaunch, false);

    if (mounted) {
      final token = StorageService.instance.getString(StorageKeys.token);
      if (token.isEmpty) {
        context.go(RouteNames.login);
      } else {
        context.go(RouteNames.main);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部跳过按钮
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: _isLastPage
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: _skip,
                        child: const Text('跳过'),
                      ),
              ),
            ),

            // 页面内容
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: guideItems.length,
                itemBuilder: (context, index) {
                  final item = guideItems[index];
                  return _buildPage(item);
                },
              ),
            ),

            // 底部指示器和按钮
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                children: [
                  // 页面指示器
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: guideItems.length,
                    effect: ExpandingDotsEffect(
                      dotWidth: 8,
                      dotHeight: 8,
                      expansionFactor: 3,
                      spacing: AppSpacing.sm,
                      dotColor: AppColors.tertiaryGrey,
                      activeDotColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // 下一步/开始按钮
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      ),
                      child: Text(
                        _isLastPage ? '立即开始' : '下一步',
                        style: const TextStyle(
                          fontSize: AppTypography.body,
                          fontWeight: AppTypography.semiBold,
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
    );
  }

  Widget _buildPage(GuideItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 图标区域 - 发光效果
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.full),
              boxShadow: [
                BoxShadow(
                  color: item.color.withValues(alpha: 0.3),
                  blurRadius: 40,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Icon(
              item.icon,
              size: 60,
              color: item.color,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          // 标题
          Text(
            item.title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: AppTypography.bold,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),

          // 副标题
          Text(
            item.subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.lightGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
