import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/widgets/animated_button.dart';
import 'package:flutter_easy_starter/core/widgets/dialogs/dialogs.dart';
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

        // 弹窗演示区块
        SliverToBoxAdapter(
          child: _buildSection(
            title: '弹窗组件',
            subtitle: '各种场景的弹窗交互演示',
            child: _buildDialogDemos(),
          ),
        ),

        // 按钮大全区块
        SliverToBoxAdapter(
          child: _buildSection(
            title: '按钮大全',
            subtitle: '多种样式的按钮组件',
            child: _buildButtonDemos(),
          ),
        ),

        // 开关选择器区块
        SliverToBoxAdapter(
          child: _buildSection(
            title: '开关与选择器',
            subtitle: '开关、单选、多选、分段控制',
            child: _buildToggleDemos(),
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
      enableRipple: false,
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
      enableRipple: false,
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
      enableRipple: false,
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
      enableRipple: false,
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

  // 弹窗演示区域
  Widget _buildDialogDemos() {
    final dialogs = [
      _DialogDemoItem(
        icon: LucideIcons.message_circle,
        title: '确认弹窗',
        desc: '确认、取消操作',
        color: const Color(0xFF5856D6),
        onTap: (context) => _showConfirmDemo(context),
      ),
      _DialogDemoItem(
        icon: LucideIcons.menu,
        title: '底部菜单',
        desc: '操作列表选择',
        color: const Color(0xFF0A84FF),
        onTap: (context) => _showBottomSheetDemo(context),
      ),
      _DialogDemoItem(
        icon: LucideIcons.pencil,
        title: '输入弹窗',
        desc: '表单输入交互',
        color: const Color(0xFFFF9F0A),
        onTap: (context) => _showInputDemo(context),
      ),
      _DialogDemoItem(
        icon: LucideIcons.list,
        title: '选择弹窗',
        desc: '单选列表项',
        color: const Color(0xFF30D158),
        onTap: (context) => _showSelectionDemo(context),
      ),
      _DialogDemoItem(
        icon: LucideIcons.bell,
        title: '通知弹窗',
        desc: '系统消息通知',
        color: const Color(0xFFFF375F),
        onTap: (context) => _showNotificationDemo(context),
      ),
      _DialogDemoItem(
        icon: LucideIcons.message_circle,
        title: 'Toast 提示',
        desc: '轻量级反馈',
        color: const Color(0xFF64D2FF),
        onTap: (context) => _showToastDemo(context),
      ),
    ];

    return Column(
      children: dialogs.map((dialog) => _buildDialogCard(dialog)).toList(),
    );
  }

  Widget _buildDialogCard(_DialogDemoItem dialog) {
    return AnimatedButton(
      onTap: () => dialog.onTap(context),
      scaleDown: 0.97,
      enableRipple: false,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.w),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface,
              AppColors.surfaceVariant.withValues(alpha: 0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: dialog.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                dialog.icon,
                color: dialog.color,
                size: 22,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dialog.title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2.w),
                  Text(
                    dialog.desc,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
              decoration: BoxDecoration(
                color: dialog.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                '试试',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: dialog.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 确认弹窗演示
  Future<void> _showConfirmDemo(BuildContext context) async {
    final result = await AppDialogs.showConfirm(
      context: context,
      title: '确认删除?',
      content: '删除后将无法恢复，是否继续?',
      confirmText: '删除',
      cancelText: '取消',
      isDanger: true,
    );
    if (result == true && context.mounted) {
      AppDialogs.showSuccess(context: context, message: '已删除');
    }
  }

  // 底部菜单演示
  Future<void> _showBottomSheetDemo(BuildContext context) async {
    final result = await AppDialogs.showBottomSheet<String>(
      context: context,
      title: '选择操作',
      actions: [
        const BottomSheetAction(
          label: '分享给好友',
          value: 'share',
          icon: LucideIcons.share_2,
        ),
        const BottomSheetAction(
          label: '收藏内容',
          value: 'favorite',
          icon: LucideIcons.heart,
        ),
        const BottomSheetAction(
          label: '举报违规',
          value: 'report',
          icon: LucideIcons.flag,
          iconColor: AppColors.orange,
        ),
        const BottomSheetAction(
          label: '删除项目',
          value: 'delete',
          icon: LucideIcons.trash_2,
          isDestructive: true,
          isBold: true,
        ),
      ],
    );
    if (result != null && context.mounted) {
      AppDialogs.showInfo(context: context, message: '选择了: $result');
    }
  }

  // 输入弹窗演示
  Future<void> _showInputDemo(BuildContext context) async {
    final result = await AppDialogs.showInput(
      context: context,
      title: '修改昵称',
      hint: '请输入新的昵称',
      initialValue: '当前昵称',
      confirmText: '保存',
      validator: (v) {
        if (v?.trim().isEmpty == true) return '昵称不能为空';
        if (v!.length > 20) return '昵称最多20个字符';
        return null;
      },
    );
    if (result != null && context.mounted) {
      AppDialogs.showSuccess(context: context, message: '昵称已更新为: $result');
    }
  }

  // 选择弹窗演示
  Future<void> _showSelectionDemo(BuildContext context) async {
    final languages = [
      const SelectionItem(label: '简体中文', value: 'zh', icon: LucideIcons.globe),
      const SelectionItem(label: 'English', value: 'en', icon: LucideIcons.globe),
      const SelectionItem(label: '日本語', value: 'ja', icon: LucideIcons.globe),
      const SelectionItem(label: '한국어', value: 'ko', icon: LucideIcons.globe),
    ];

    final result = await AppDialogs.showSelection<String>(
      context: context,
      title: '选择语言',
      items: languages,
      selectedValue: 'zh',
    );
    if (result != null && context.mounted) {
      final selected = languages.firstWhere((l) => l.value == result);
      AppDialogs.showSuccess(context: context, message: '已切换到: ${selected.label}');
    }
  }

  // 通知弹窗演示
  Future<void> _showNotificationDemo(BuildContext context) async {
    await AppDialogs.showNotification(
      context: context,
      title: '系统更新',
      content: '发现新版本 v2.0，包含多项功能优化和问题修复，建议立即更新。',
      icon: LucideIcons.download,
      iconColor: AppColors.blue,
      actionText: '立即更新',
      onAction: () {
        AppDialogs.showLoading(context: context, message: '下载更新中...');
        Future.delayed(const Duration(seconds: 2), () {
          AppDialogs.hide(context);
          AppDialogs.showSuccess(context: context, message: '更新完成!');
        });
      },
    );
  }

  // Toast 提示演示
  void _showToastDemo(BuildContext context) {
    AppDialogs.showBottomSheet<String>(
      context: context,
      title: '选择提示类型',
      actions: [
        BottomSheetAction(
          label: '成功提示',
          value: 'success',
          icon: LucideIcons.circle_check,
          iconColor: AppColors.green,
        ),
        BottomSheetAction(
          label: '错误提示',
          value: 'error',
          icon: LucideIcons.circle_x,
          iconColor: AppColors.red,
        ),
        BottomSheetAction(
          label: '警告提示',
          value: 'warning',
          icon: LucideIcons.triangle_alert,
          iconColor: AppColors.orange,
        ),
        BottomSheetAction(
          label: '信息提示',
          value: 'info',
          icon: LucideIcons.info,
          iconColor: AppColors.blue,
        ),
      ],
    ).then((type) {
      if (!context.mounted) return;
      switch (type) {
        case 'success':
          AppDialogs.showSuccess(context: context, message: '操作成功完成!');
        case 'error':
          AppDialogs.showError(context: context, message: '网络连接失败，请重试');
        case 'warning':
          AppDialogs.showWarning(context: context, message: '注意: 此操作不可撤销');
        case 'info':
          AppDialogs.showInfo(context: context, message: '您有一条新消息');
      }
    });
  }

  // ==================== 按钮大全演示 ====================
  Widget _buildButtonDemos() {
    return Column(
      children: [
        // 主要按钮样式
        _buildButtonCategory(
          title: '主要按钮',
          child: Wrap(
            spacing: 12.w,
            runSpacing: 12.w,
            children: [
              _buildPrimaryButton('主要按钮', AppColors.primary),
              _buildPrimaryButton('成功按钮', AppColors.green),
              _buildPrimaryButton('警告按钮', AppColors.orange),
              _buildPrimaryButton('危险按钮', AppColors.red),
            ],
          ),
        ),
        SizedBox(height: 20.w),

        // 次要按钮样式
        _buildButtonCategory(
          title: '次要按钮',
          child: Wrap(
            spacing: 12.w,
            runSpacing: 12.w,
            children: [
              _buildSecondaryButton('次要按钮'),
              _buildSecondaryButton('描边按钮', outlined: true),
              _buildGhostButton('幽灵按钮'),
            ],
          ),
        ),
        SizedBox(height: 20.w),

        // 图标按钮
        _buildButtonCategory(
          title: '图标按钮',
          child: Wrap(
            spacing: 12.w,
            runSpacing: 12.w,
            children: [
              _buildIconButton(LucideIcons.heart, AppColors.red),
              _buildIconButton(LucideIcons.star, AppColors.orange),
              _buildIconButton(LucideIcons.share, AppColors.blue),
              _buildIconButton(LucideIcons.bookmark, AppColors.green),
              _buildIconButtonWithText(LucideIcons.download, '下载', AppColors.primary),
              _buildIconButtonWithText(LucideIcons.send, '发送', AppColors.blue),
            ],
          ),
        ),
        SizedBox(height: 20.w),

        // 加载状态按钮
        _buildButtonCategory(
          title: '加载状态',
          child: Wrap(
            spacing: 12.w,
            runSpacing: 12.w,
            children: [
              _buildLoadingButton('加载中...'),
              _buildLoadingButton('提交中', small: true),
            ],
          ),
        ),
        SizedBox(height: 20.w),

        // 渐变按钮
        _buildButtonCategory(
          title: '渐变按钮',
          child: Wrap(
            spacing: 12.w,
            runSpacing: 12.w,
            children: [
              _buildGradientButton(
                '紫色渐变',
                [const Color(0xFF8B5CF6), const Color(0xFF6366F1)],
              ),
              _buildGradientButton(
                '粉色渐变',
                [const Color(0xFFFF2D55), const Color(0xFFFF6B6B)],
              ),
              _buildGradientButton(
                '蓝色渐变',
                [const Color(0xFF0A84FF), const Color(0xFF5AC8FA)],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonCategory({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.lightGrey,
            ),
          ),
          SizedBox(height: 12.w),
          child,
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(String text, Color color) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, {bool outlined = false}) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10.r),
          border: outlined
              ? Border.all(color: AppColors.white.withValues(alpha: 0.2))
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: outlined ? Colors.white : AppColors.lightGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildGhostButton(String text) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildIconButtonWithText(IconData icon, String text, Color color) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            SizedBox(width: 8.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingButton(String text, {bool small = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 16.w : 20.w,
        vertical: small ? 10.w : 12.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: small ? 14.w : 16.w,
            height: small ? 14.w : 16.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: small ? 13.sp : 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton(String text, List<Color> colors) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ==================== 开关选择器演示 ====================
  Widget _buildToggleDemos() {
    return Column(
      children: [
        // 开关 - 使用真正的状态管理
        _SwitchDemo(),
        SizedBox(height: 16.w),

        // 分段选择器
        _SegmentedControlDemo(),
        SizedBox(height: 16.w),

        // 单选按钮
        _RadioGroupDemo(),
        SizedBox(height: 16.w),

        // 多选按钮
        _CheckboxGroupDemo(),
        SizedBox(height: 16.w),

        // 步进器
        _StepperDemo(),
      ],
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

// ==================== 开关选择器状态组件 ====================

class _SwitchDemo extends StatefulWidget {
  @override
  State<_SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  final List<bool> _values = [true, false, true, true];
  final List<Color> _colors = [AppColors.primary, AppColors.primary, AppColors.green, AppColors.red];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '开关 Switch',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.lightGrey,
            ),
          ),
          SizedBox(height: 16.w),
          Row(
            children: [
              for (int i = 0; i < 4; i++) ...[
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => _values[i] = !_values[i]);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: _values[i] ? _colors[i] : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: _values[i] ? Alignment.centerRight : Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: Container(
                          width: 26.w,
                          height: 26.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (i < 3) SizedBox(width: 16.w),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SegmentedControlDemo extends StatefulWidget {
  @override
  State<_SegmentedControlDemo> createState() => _SegmentedControlDemoState();
}

class _SegmentedControlDemoState extends State<_SegmentedControlDemo> {
  int _selectedIndex = 1;
  final List<String> _options = ['日', '周', '月', '年'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '分段选择器 Segmented',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.lightGrey,
            ),
          ),
          SizedBox(height: 16.w),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _options.asMap().entries.map((entry) {
                final index = entry.key;
                final label = entry.value;
                final isSelected = index == _selectedIndex;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => _selectedIndex = index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.surface : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? Colors.white : AppColors.lightGrey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioGroupDemo extends StatefulWidget {
  @override
  State<_RadioGroupDemo> createState() => _RadioGroupDemoState();
}

class _RadioGroupDemoState extends State<_RadioGroupDemo> {
  int _selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '单选 Radio',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.lightGrey,
            ),
          ),
          SizedBox(height: 16.w),
          Row(
            children: [
              _buildRadioItem('选项一', 1),
              SizedBox(width: 20.w),
              _buildRadioItem('选项二', 2),
              SizedBox(width: 20.w),
              _buildRadioItem('选项三', 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String label, int value) {
    final isSelected = value == _selectedValue;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedValue = value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22.w,
            height: 22.w,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(11.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.lightGrey,
                width: 2,
              ),
            ),
            child: isSelected
                ? Icon(LucideIcons.check, color: Colors.white, size: 14)
                : null,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: isSelected ? Colors.white : AppColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckboxGroupDemo extends StatefulWidget {
  @override
  State<_CheckboxGroupDemo> createState() => _CheckboxGroupDemoState();
}

class _CheckboxGroupDemoState extends State<_CheckboxGroupDemo> {
  final Set<int> _checkedItems = {1, 3};

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '多选 Checkbox',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.lightGrey,
            ),
          ),
          SizedBox(height: 16.w),
          Wrap(
            spacing: 16.w,
            runSpacing: 12.w,
            children: [
              _buildCheckboxItem('选项 A', 1),
              _buildCheckboxItem('选项 B', 2),
              _buildCheckboxItem('选项 C', 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(String label, int value) {
    final isChecked = _checkedItems.contains(value);
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          if (isChecked) {
            _checkedItems.remove(value);
          } else {
            _checkedItems.add(value);
          }
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22.w,
            height: 22.w,
            decoration: BoxDecoration(
              color: isChecked ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: isChecked ? AppColors.primary : AppColors.lightGrey,
                width: 2,
              ),
            ),
            child: isChecked
                ? Icon(LucideIcons.check, color: Colors.white, size: 14)
                : null,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: isChecked ? Colors.white : AppColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperDemo extends StatefulWidget {
  @override
  State<_StepperDemo> createState() => _StepperDemoState();
}

class _StepperDemoState extends State<_StepperDemo> {
  int _count = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '步进器 Stepper',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.lightGrey,
            ),
          ),
          SizedBox(height: 16.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _count > 1
                      ? () {
                          HapticFeedback.lightImpact();
                          setState(() => _count--);
                        }
                      : null,
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: _count > 1 ? AppColors.surface : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      LucideIcons.minus,
                      color: _count > 1 ? Colors.white : AppColors.lightGrey,
                      size: 16,
                    ),
                  ),
                ),
                Container(
                  width: 48.w,
                  alignment: Alignment.center,
                  child: Text(
                    '$_count',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => _count++);
                  },
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(LucideIcons.plus, color: Colors.white, size: 16),
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

class _DialogDemoItem {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  final void Function(BuildContext context) onTap;

  _DialogDemoItem({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
    required this.onTap,
  });
}
