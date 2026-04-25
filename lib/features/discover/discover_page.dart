import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

/// 用户模型
class UserProfile {
  final String id;
  final String name;
  final int age;
  final String? bio;
  final String? avatar;
  final bool isOnline;
  final double distance;
  final List<String> interests;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    this.bio,
    this.avatar,
    this.isOnline = false,
    this.distance = 0,
    this.interests = const [],
  });
}

/// 示例数据
final List<UserProfile> mockUsers = [
  UserProfile(
    id: '1',
    name: '小雨',
    age: 24,
    bio: '喜欢旅行、摄影和美食，寻找志同道合的朋友',
    isOnline: true,
    distance: 0.5,
    interests: ['旅行', '摄影', '美食'],
  ),
  UserProfile(
    id: '2',
    name: 'Alex',
    age: 26,
    bio: '健身爱好者，寻找一起运动的朋友',
    isOnline: true,
    distance: 1.2,
    interests: ['健身', '跑步', '音乐'],
  ),
  UserProfile(
    id: '3',
    name: '梦琪',
    age: 23,
    bio: '猫奴一枚，喜欢阅读和咖啡',
    isOnline: false,
    distance: 2.5,
    interests: ['猫咪', '阅读', '咖啡'],
  ),
  UserProfile(
    id: '4',
    name: 'Jack',
    age: 28,
    bio: '程序员，游戏爱好者，周末喜欢户外活动',
    isOnline: true,
    distance: 3.0,
    interests: ['编程', '游戏', '户外'],
  ),
  UserProfile(
    id: '5',
    name: 'Emma',
    age: 25,
    bio: '设计师，热爱艺术和音乐',
    isOnline: true,
    distance: 1.8,
    interests: ['设计', '艺术', '音乐'],
  ),
  UserProfile(
    id: '6',
    name: 'Lucas',
    age: 27,
    bio: '音乐制作人，喜欢分享好音乐',
    isOnline: false,
    distance: 4.2,
    interests: ['音乐', '创作', '电影'],
  ),
];

/// 最近匹配数据
final List<UserProfile> recentMatches = [
  UserProfile(id: 'm1', name: 'Lisa', age: 25, isOnline: true),
  UserProfile(id: 'm2', name: 'Tom', age: 27, isOnline: false),
  UserProfile(id: 'm3', name: '安娜', age: 24, isOnline: true),
  UserProfile(id: 'm4', name: 'Mike', age: 26, isOnline: true),
  UserProfile(id: 'm5', name: 'Sophie', age: 23, isOnline: true),
  UserProfile(id: 'm6', name: 'David', age: 29, isOnline: false),
];

/// 发现页 - 融合卡片滑动 + 最近匹配
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final CardSwiperController _swiperController = CardSwiperController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部栏
            _buildAppBar(),

            // 最近匹配
            _buildRecentMatches(),

            const SizedBox(height: 16),

            // 卡片滑动区域
            Expanded(
              child: _buildCardStack(),
            ),

            // 底部操作按钮
            _buildActionButtons(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '发现',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 筛选按钮
          GestureDetector(
            onTap: () => _showFilterDialog(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.tune,
                color: AppColors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMatches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '最近匹配',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '查看全部',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recentMatches.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // 查看全部按钮
                return Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(
                          Icons.grid_view,
                          color: AppColors.lightGrey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '全部',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.lightGrey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final user = recentMatches[index - 1];
              return GestureDetector(
                onTap: () => _openUserDetail(user),
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: user.isOnline
                                    ? AppColors.green
                                    : AppColors.border,
                                width: user.isOnline ? 2 : 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: AppColors.lightGrey,
                              size: 28,
                            ),
                          ),
                          if (user.isOnline)
                            Positioned(
                              right: 2,
                              bottom: 2,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color: AppColors.background,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCardStack() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CardSwiper(
        controller: _swiperController,
        cardsCount: mockUsers.length,
        numberOfCardsDisplayed: 2,
        backCardOffset: const Offset(0, 20),
        padding: EdgeInsets.zero,
        allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
          horizontal: true,
        ),
        onSwipe: (previousIndex, currentIndex, direction) {
          setState(() {
            _currentIndex = currentIndex ?? 0;
          });

          if (direction == CardSwiperDirection.right) {
            _showMatchAnimation(mockUsers[previousIndex]);
          }
          return true;
        },
        cardBuilder: (context, index, horizontalThreshold, verticalThreshold) {
          return _buildProfileCard(mockUsers[index]);
        },
      ),
    );
  }

  Widget _buildProfileCard(UserProfile user) {
    return GestureDetector(
      onTap: () => _openUserDetail(user),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // 背景图区域
            Positioned.fill(
              child: Container(
                color: AppColors.tertiaryGrey,
                child: const Icon(
                  Icons.person,
                  size: 120,
                  color: AppColors.lightGrey,
                ),
              ),
            ),

            // 底部渐变遮罩
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.9),
                      Colors.black.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // 在线状态
            if (user.isOnline)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '在线',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // 底部信息
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${user.name}, ${user.age}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppColors.lightGrey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${user.distance}km',
                              style: const TextStyle(
                                color: AppColors.lightGrey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (user.bio != null)
                      Text(
                        user.bio!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 12),
                    // 兴趣标签
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: user.interests.map((interest) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.glassWhite,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            interest,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 拒绝按钮
          _buildActionButton(
            icon: Icons.close,
            color: AppColors.lightGrey,
            backgroundColor: AppColors.surface,
            onTap: () => _swiperController.swipe(CardSwiperDirection.left),
          ),
          // 喜欢按钮
          _buildActionButton(
            icon: Icons.favorite,
            color: Colors.white,
            backgroundColor: AppColors.primary,
            size: 64,
            iconSize: 32,
            hasShadow: true,
            onTap: () => _swiperController.swipe(CardSwiperDirection.right),
          ),
          // 超级喜欢
          _buildActionButton(
            icon: Icons.star,
            color: AppColors.accent,
            backgroundColor: AppColors.surface,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    double size = 56,
    double iconSize = 28,
    bool hasShadow = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(size / 2),
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: color,
          size: iconSize,
        ),
      ),
    );
  }

  void _openUserDetail(UserProfile user) {
    context.push('${RouteNames.userDetail}/${user.id}');
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '筛选',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '距离范围',
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Slider(
                value: 10,
                max: 100,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.tertiaryGrey,
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              const Text(
                '年龄范围',
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              RangeSlider(
                values: const RangeValues(20, 35),
                min: 18,
                max: 60,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.tertiaryGrey,
                onChanged: (values) {},
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '应用筛选',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMatchAnimation(UserProfile user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '匹配成功！',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '你和 ${user.name} 互相喜欢了',
                  style: const TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push(RouteNames.messages);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '发消息',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
