import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/widgets/animated_button.dart';
import 'package:flutter_easy_starter/core/widgets/shimmer_widgets.dart';
import 'package:flutter_easy_starter/features/main/main_page.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 项目介绍页面 - 沉浸式美学设计
class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _listController;
  bool _isLoading = true;
  int _selectedDemo = -1;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 模拟加载
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _heroController.forward();
        Future.delayed(const Duration(milliseconds: 300), () {
          _listController.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading ? _buildSkeletonView() : _buildContentView(),
    );
  }

  Widget _buildSkeletonView() {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _buildHeroSkeleton(),
        ),
        SliverPadding(
          padding: EdgeInsets.all(24.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildFeatureSkeleton(),
              childCount: 6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSkeleton() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 100.w, 24.w, 40.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerCircle(size: 88),
          SizedBox(height: 32.w),
          ShimmerText(width: 280, height: 56),
          SizedBox(height: 16.w),
          ShimmerText(width: 200, height: 24),
        ],
      ),
    );
  }

  Widget _buildFeatureSkeleton() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      child: ShimmerContainer(
        height: 80,
        borderRadius: 16,
      ),
    );
  }

  Widget _buildContentView() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 顶部大标题区域
        SliverToBoxAdapter(
          child: _buildHeroSection(),
        ),

        // 快速操作卡片
        SliverToBoxAdapter(
          child: _buildQuickActions(),
        ),

        // 功能特性区块
        SliverToBoxAdapter(
          child: _buildSection(
            title: '功能特性',
            subtitle: '开箱即用，快速构建',
            child: _buildFeaturesGrid(),
          ),
        ),

        // 设计模式区块
        SliverToBoxAdapter(
          child: _buildSection(
            title: '架构设计',
            subtitle: '清晰的分层，优雅的实现',
            child: _buildPatternsSection(),
          ),
        ),

        // Demo 内容展示
        SliverToBoxAdapter(
          child: _buildSection(
            title: '快速体验',
            subtitle: '点击下方卡片跳转对应页面',
            child: _buildDemoContent(),
          ),
        ),

        // 底部说明
        SliverToBoxAdapter(
          child: _buildFooterSection(),
        ),
      ],
    );
  }

  // Hero 区域 - 视觉焦点
  Widget _buildHeroSection() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 100.w, 24.w, 40.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.background,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 项目 Logo 动画
          AnimatedBuilder(
            animation: _heroController,
            builder: (context, child) {
              final scale = Tween<double>(begin: 0.8, end: 1.0)
                  .animate(CurvedAnimation(
                    parent: _heroController,
                    curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
                  ))
                  .value;
              final opacity = Tween<double>(begin: 0.0, end: 1.0)
                  .animate(CurvedAnimation(
                    parent: _heroController,
                    curve: const Interval(0.0, 0.3),
                  ))
                  .value;

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: child,
                ),
              );
            },
            child: _buildLogoContainer(),
          ),

          SizedBox(height: 32.w),

          // 主标题动画
          AnimatedBuilder(
            animation: _heroController,
            builder: (context, child) {
              final slideY = Tween<double>(begin: 30, end: 0)
                  .animate(CurvedAnimation(
                    parent: _heroController,
                    curve: const Interval(0.2, 0.5, curve: Curves.easeOutCubic),
                  ))
                  .value;
              final opacity = Tween<double>(begin: 0.0, end: 1.0)
                  .animate(CurvedAnimation(
                    parent: _heroController,
                    curve: const Interval(0.2, 0.4),
                  ))
                  .value;

              return Transform.translate(
                offset: Offset(0, slideY),
                child: Opacity(
                  opacity: opacity,
                  child: child,
                ),
              );
            },
            child: _buildMainTitle(),
          ),

          SizedBox(height: 16.w),

          // 副标题
          AnimatedBuilder(
            animation: _heroController,
            builder: (context, child) {
              final slideY = Tween<double>(begin: 20, end: 0)
                  .animate(CurvedAnimation(
                    parent: _heroController,
                    curve: const Interval(0.3, 0.6, curve: Curves.easeOutCubic),
                  ))
                  .value;
              final opacity = Tween<double>(begin: 0.0, end: 1.0)
                  .animate(CurvedAnimation(
                    parent: _heroController,
                    curve: const Interval(0.3, 0.5),
                  ))
                  .value;

              return Transform.translate(
                offset: Offset(0, slideY),
                child: Opacity(
                  opacity: opacity,
                  child: child,
                ),
              );
            },
            child: _buildSubtitle(),
          ),

          SizedBox(height: 24.w),

          // 版本标签
          AnimatedBuilder(
            animation: _heroController,
            builder: (context, child) {
              final opacity = Tween<double>(begin: 0.0, end: 1.0)
                  .animate(CurvedAnimation(
                    parent: _heroController,
                    curve: const Interval(0.5, 0.7),
                  ))
                  .value;

              return Opacity(
                opacity: opacity,
                child: child,
              );
            },
            child: _buildVersionBadge(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoContainer() {
    return PulseAnimation(
      duration: const Duration(milliseconds: 2500),
      minScale: 1.0,
      maxScale: 1.03,
      child: Container(
        width: 88.w,
        height: 88.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryLight,
              const Color(0xFF8B5CF6),
            ],
          ),
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: AppShadows.purpleGlow(opacity: 0.5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 旋转光效
            AnimatedBuilder(
              animation: _heroController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _heroController.value * 2 * 3.14159 * 0.5,
                  child: Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      gradient: SweepGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: 0.3),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(35.r),
                    ),
                  ),
                );
              },
            ),
            Icon(
              LucideIcons.rocket,
              color: Colors.white,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainTitle() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [
            Colors.white,
            Color(0xFFE0E0E0),
          ],
        ).createShader(bounds);
      },
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Flutter\n',
              style: TextStyle(
                fontSize: 48.sp,
                height: 1.1,
                fontWeight: FontWeight.w300,
              ),
            ),
            TextSpan(
              text: 'Easy Starter',
              style: TextStyle(
                fontSize: 48.sp,
                height: 1.1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '开箱即用的 Flutter 快速开发框架',
          style: TextStyle(
            fontSize: 17.sp,
            color: AppColors.lightGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.w),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.zap,
                    color: AppColors.primary,
                    size: 14,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '30分钟搭建完整应用',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVersionBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            'v1.0.0 · Production Ready',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // 快速操作区
  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Expanded(
            child: _buildActionCard(
              icon: LucideIcons.eye,
              label: '浏览演示',
              gradient: [AppColors.primary, AppColors.primaryLight],
              onTap: () {
                HapticFeedback.mediumImpact();
                _switchToTab(1);
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildActionCard(
              icon: LucideIcons.message_circle,
              label: '消息功能',
              gradient: [const Color(0xFFFF2D55), const Color(0xFFFF6B6B)],
              onTap: () {
                HapticFeedback.mediumImpact();
                _switchToTab(2);
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildActionCard(
              icon: LucideIcons.user,
              label: '个人中心',
              gradient: [const Color(0xFF34C759), const Color(0xFF30D158)],
              onTap: () {
                HapticFeedback.mediumImpact();
                _switchToTab(3);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return AnimatedButton(
      onTap: onTap,
      scaleDown: 0.95,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gradient.first.withValues(alpha: 0.2),
              gradient.last.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: gradient.first.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: gradient.first.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            SizedBox(height: 10.w),
            Text(
              label,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 区块标题
  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 32.w, 24.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 24.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.w),
          child,
        ],
      ),
    );
  }

  // 功能特性网格
  Widget _buildFeaturesGrid() {
    final features = [
      _FeatureItem(
        icon: LucideIcons.route,
        title: '路由管理',
        desc: 'GoRouter + 自动路由守卫',
        gradient: [const Color(0xFF5856D6), const Color(0xFF7B79E0)],
      ),
      _FeatureItem(
        icon: LucideIcons.refresh_cw,
        title: '状态管理',
        desc: 'Riverpod + 代码生成',
        gradient: [const Color(0xFF30D158), const Color(0xFF5BE082)],
      ),
      _FeatureItem(
        icon: LucideIcons.cloud,
        title: '网络请求',
        desc: 'Dio + 拦截器 + WebSocket',
        gradient: [const Color(0xFF0A84FF), const Color(0xFF409CFF)],
      ),
      _FeatureItem(
        icon: LucideIcons.palette,
        title: 'UI 组件库',
        desc: '主题系统 + 屏幕适配',
        gradient: [const Color(0xFFFF375F), const Color(0xFFFF6B85)],
      ),
      _FeatureItem(
        icon: LucideIcons.hard_drive,
        title: '本地存储',
        desc: 'SharedPreferences + 缓存',
        gradient: [const Color(0xFFFF9F0A), const Color(0xFFFFB84D)],
      ),
      _FeatureItem(
        icon: LucideIcons.bell,
        title: '推送通知',
        desc: '极光 + 本地通知',
        gradient: [const Color(0xFF64D2FF), const Color(0xFF8CE2FF)],
      ),
    ];

    return Column(
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;
        return AnimatedBuilder(
          animation: _listController,
          builder: (context, child) {
            final delay = index * 0.1;
            final slideY = Tween<double>(begin: 30, end: 0)
                .animate(CurvedAnimation(
                  parent: _listController,
                  curve: Interval(delay, delay + 0.3, curve: Curves.easeOutCubic),
                ))
                .value;
            final opacity = Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(
                  parent: _listController,
                  curve: Interval(delay, delay + 0.2),
                ))
                .value;

            return Transform.translate(
              offset: Offset(0, slideY * (1 - _listController.value)),
              child: Opacity(
                opacity: opacity * _listController.value,
                child: child,
              ),
            );
          },
          child: _buildFeatureCard(feature),
        );
      }).toList(),
    );
  }

  Widget _buildFeatureCard(_FeatureItem feature) {
    return AnimatedButton(
      onTap: () {
        HapticFeedback.lightImpact();
        // 显示详情
      },
      scaleDown: 0.97,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface,
              AppColors.surfaceVariant.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: feature.gradient),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: feature.gradient.first.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(feature.icon, color: Colors.white, size: 24),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    feature.desc,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevron_right,
              color: AppColors.lightGrey.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // 设计模式区块
  Widget _buildPatternsSection() {
    final patterns = [
      _PatternDetail(
        icon: LucideIcons.layers,
        title: 'Clean Architecture',
        subtitle: '清晰的分层架构',
        desc: '将应用分为 Presentation、Domain、Data 三层，实现关注点分离，便于测试和维护。',
      ),
      _PatternDetail(
        icon: LucideIcons.database,
        title: 'Repository Pattern',
        subtitle: '统一的数据访问层',
        desc: '为数据操作提供抽象接口，屏蔽底层数据源差异，便于切换和 Mock 测试。',
      ),
      _PatternDetail(
        icon: LucideIcons.folder_tree,
        title: 'Feature-First',
        subtitle: '按功能组织代码',
        desc: '将相关文件按功能模块组织，使代码更容易定位和修改，新增功能只需关注一个目录。',
      ),
      _PatternDetail(
        icon: LucideIcons.component,
        title: 'MVVM 架构',
        subtitle: '响应式 UI 架构',
        desc: '使用 Riverpod 管理 ViewModel，UI 层监听状态变化自动刷新。',
      ),
    ];

    return Column(
      children: patterns.map((pattern) => _buildPatternCard(pattern)).toList(),
    );
  }

  Widget _buildPatternCard(_PatternDetail pattern) {
    return AnimatedButton(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      scaleDown: 0.97,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.w),
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface,
              AppColors.surfaceVariant.withValues(alpha: 0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    pattern.icon,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pattern.title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        pattern.subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.lightGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.circle_check,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
            SizedBox(height: 12.w),
            Text(
              pattern.desc,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.5,
                color: AppColors.lightGrey.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Demo 内容展示
  Widget _buildDemoContent() {
    final demos = [
      _DemoItem(
        index: 1,
        icon: LucideIcons.compass,
        title: '探索页面',
        desc: '旅游卡片、Hero 动画、下拉刷新',
        gradient: [const Color(0xFF5856D6), const Color(0xFF8B5CF6)],
      ),
      _DemoItem(
        index: 2,
        icon: LucideIcons.message_square,
        title: '消息功能',
        desc: '聊天列表、IM 功能、故事环',
        gradient: [const Color(0xFFFF2D55), const Color(0xFFFF6B6B)],
      ),
      _DemoItem(
        index: 3,
        icon: LucideIcons.user,
        title: '个人中心',
        desc: '用户资料、设置页面、VIP 特权',
        gradient: [const Color(0xFF34C759), const Color(0xFF30D158)],
      ),
    ];

    return Column(
      children: demos.map((demo) => _buildDemoCard(demo)).toList(),
    );
  }

  Widget _buildDemoCard(_DemoItem demo) {
    final isSelected = _selectedDemo == demo.index;

    return AnimatedButton(
      onTap: () {
        HapticFeedback.mediumImpact();
        setState(() => _selectedDemo = demo.index);
        Future.delayed(const Duration(milliseconds: 200), () {
          _switchToTab(demo.index);
        });
      },
      scaleDown: 0.95,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        margin: EdgeInsets.only(bottom: 12.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [
                    demo.gradient.first.withValues(alpha: 0.2),
                    demo.gradient.last.withValues(alpha: 0.05),
                  ]
                : [
                    AppColors.surface,
                    AppColors.surfaceVariant.withValues(alpha: 0.3),
                  ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? demo.gradient.first
                : AppColors.white.withValues(alpha: 0.05),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: demo.gradient.first.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: demo.gradient),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: demo.gradient.first.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(demo.icon, color: Colors.white, size: 26),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    demo.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    demo.desc,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? demo.gradient.first.withValues(alpha: 0.2)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Tab ${demo.index}',
                style: TextStyle(
                  color: isSelected ? demo.gradient.first : AppColors.lightGrey,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 底部说明区域
  Widget _buildFooterSection() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 32.w, 24.w, 48.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.surface,
                  AppColors.surfaceVariant.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.code,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '开源框架 · 自由使用',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.lightGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.w),
                Text(
                  '本 Demo 源码可直接作为项目模板使用',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.lightGrey.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _switchToTab(int index) {
    // 获取 MainPageState 并切换标签
    final mainPageState = context.findAncestorStateOfType<MainPageState>();
    if (mainPageState != null) {
      mainPageState.switchToTab(index);
    }
  }
}

// 数据类
class _FeatureItem {
  final IconData icon;
  final String title;
  final String desc;
  final List<Color> gradient;

  _FeatureItem({
    required this.icon,
    required this.title,
    required this.desc,
    required this.gradient,
  });
}

class _PatternDetail {
  final IconData icon;
  final String title;
  final String subtitle;
  final String desc;

  _PatternDetail({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.desc,
  });
}

class _DemoItem {
  final int index;
  final IconData icon;
  final String title;
  final String desc;
  final List<Color> gradient;

  _DemoItem({
    required this.index,
    required this.icon,
    required this.title,
    required this.desc,
    required this.gradient,
  });
}
