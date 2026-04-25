import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 匹配对象模型
class MatchProfile {
  final String id;
  final String name;
  final int age;
  final String? bio;
  final String? imageUrl;
  final bool isOnline;
  final double distance;
  final List<String> interests;

  MatchProfile({
    required this.id,
    required this.name,
    required this.age,
    this.bio,
    this.imageUrl,
    this.isOnline = false,
    this.distance = 0,
    this.interests = [],
  });
}

/// 示例数据
final List<MatchProfile> nearbyProfiles = [
  MatchProfile(
    id: '1',
    name: '小雨',
    age: 24,
    bio: '喜欢旅行、摄影和美食',
    isOnline: true,
    distance: 0.5,
    interests: ['旅行', '摄影', '美食'],
  ),
  MatchProfile(
    id: '2',
    name: 'Alex',
    age: 26,
    bio: '健身爱好者，寻找一起运动的朋友',
    isOnline: true,
    distance: 1.2,
    interests: ['健身', '跑步', '音乐'],
  ),
  MatchProfile(
    id: '3',
    name: '梦琪',
    age: 23,
    bio: '猫奴一枚，喜欢阅读和咖啡',
    isOnline: false,
    distance: 2.5,
    interests: ['猫咪', '阅读', '咖啡'],
  ),
  MatchProfile(
    id: '4',
    name: 'Jack',
    age: 28,
    bio: '程序员，游戏爱好者',
    isOnline: true,
    distance: 3.0,
    interests: ['编程', '游戏', '电影'],
  ),
];

/// 最近匹配
final List<MatchProfile> recentMatches = [
  MatchProfile(id: '5', name: 'Lisa', age: 25, isOnline: true),
  MatchProfile(id: '6', name: 'Tom', age: 27, isOnline: false),
  MatchProfile(id: '7', name: '安娜', age: 24, isOnline: true),
  MatchProfile(id: '8', name: 'Mike', age: 26, isOnline: true),
];

/// 社交首页 - Dark Social 风格
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 顶部栏
            SliverToBoxAdapter(
              child: _buildAppBar(context, user?.displayName ?? '用户'),
            ),

            // 最近匹配横向滚动
            SliverToBoxAdapter(
              child: _buildRecentMatches(),
            ),

            // 搜索栏
            SliverToBoxAdapter(
              child: _buildSearchBar(),
            ),

            // 附近的人标题
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.xl,
                  AppSpacing.xxl,
                  AppSpacing.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '附近的人',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('查看全部'),
                    ),
                  ],
                ),
              ),
            ),

            // 用户列表
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final profile = nearbyProfiles[index];
                  return _buildProfileCard(context, profile);
                },
                childCount: nearbyProfiles.length,
              ),
            ),

            // 底部间距
            SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xxxl),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            // 消息
          } else if (index == 2) {
            context.push(RouteNames.profile);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: '发现',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: '消息',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, String name) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.xxl),
      child: Row(
        children: [
          // 头像
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              Icons.person,
              color: AppColors.lightGrey,
              size: 24,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          // 问候语
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '你好，$name',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 2.w),
                Text(
                  '今天想认识新朋友吗？',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightGrey,
                  ),
                ),
              ],
            ),
          ),
          // 筛选按钮
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              Icons.tune,
              color: AppColors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMatches() {
    return Container(
      height: 100.w,
      margin: EdgeInsets.only(bottom: AppSpacing.xl),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        itemCount: recentMatches.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // 查看全部按钮
            return Container(
              width: 70.w,
              margin: EdgeInsets.only(right: AppSpacing.md),
              child: Column(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Icon(
                      Icons.grid_view,
                      color: AppColors.lightGrey,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    '全部',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.lightGrey,
                    ),
                  ),
                ],
              ),
            );
          }

          final match = recentMatches[index - 1];
          return Container(
            width: 70.w,
            margin: EdgeInsets.only(right: AppSpacing.md),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                          color: match.isOnline
                              ? AppColors.green
                              : AppColors.border,
                          width: 2.w,
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        color: AppColors.lightGrey,
                        size: 28,
                      ),
                    ),
                    if (match.isOnline)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 14.w,
                          height: 14.w,
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            border: Border.all(
                              color: AppColors.background,
                              width: 2.w,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  match.name,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: AppColors.lightGrey,
            size: 22,
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              '搜索昵称、兴趣...',
              style: TextStyle(
                fontSize: AppTypography.body,
                color: AppColors.lightGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, MatchProfile profile) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        0,
        AppSpacing.xxl,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () {
          // TODO: 查看详情
        },
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              // 头像
              Stack(
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryGrey,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.lightGrey,
                      size: 32,
                    ),
                  ),
                  if (profile.isOnline)
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          border: Border.all(
                            color: AppColors.surface,
                            width: 2.w,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: AppSpacing.lg),
              // 信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          profile.name,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          '${profile.age}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.lightGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.w),
                    if (profile.bio != null)
                      Text(
                        profile.bio!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColors.lightGrey,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${profile.distance}km',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(width: AppSpacing.md),
                        // 兴趣标签
                        ...profile.interests.take(2).map((interest) {
                          return Container(
                            margin: EdgeInsets.only(right: AppSpacing.sm),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.tertiaryGrey,
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              interest,
                              style: TextStyle(fontSize: 11.sp,
                                color: AppColors.lightGrey,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              // 操作按钮
              Column(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryGrey,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.lightGrey,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      boxShadow: AppShadows.glow,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
