import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/features/intro/intro_page.dart';
import 'package:flutter_easy_starter/features/message/message_page.dart';
import 'package:flutter_easy_starter/features/profile/profile_page.dart';
import 'package:flutter_easy_starter/features/travel/pages/travel_home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 主框架页面 - 底部导航（支持 GoRouter StatefulShellRoute.indexedStack）
class MainPage extends StatefulWidget {
  final StatefulNavigationShell? navigationShell;

  const MainPage({
    super.key,
    this.navigationShell,
  });

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _fallbackIndex = 0;

  static const List<Widget> _fallbackPages = [
    IntroPage(),
    TravelHomePage(),
    MessagePage(),
    ProfilePage(),
  ];

  int get _currentIndex =>
      widget.navigationShell?.currentIndex ?? _fallbackIndex;

  void switchToTab(int index) {
    final shell = widget.navigationShell;
    if (shell != null) {
      shell.goBranch(
        index,
        initialLocation: index == shell.currentIndex,
      );
      return;
    }
    if (index >= 0 && index < _fallbackPages.length) {
      setState(() {
        _fallbackIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: widget.navigationShell ??
          IndexedStack(
            index: _currentIndex,
            children: _fallbackPages,
          ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.info_outline, Icons.info, '介绍'),
                _buildNavItem(1, Icons.travel_explore_outlined, Icons.travel_explore, '探索'),
                _buildNavItem(2, Icons.chat_bubble_outline, Icons.chat_bubble, '消息'),
                _buildNavItem(3, Icons.person_outline, Icons.person, '我的'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => switchToTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.lightGrey,
              size: 24,
            ),
            if (isSelected) ...[
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
