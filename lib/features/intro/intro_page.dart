import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/features/main/main_page.dart';

/// 项目介绍页面 - Apple 风格单页设计
class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 顶部大标题区域
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: child,
                  ),
                );
              },
              child: _buildHeroSection(),
            ),
          ),

          // 功能特性区块
          SliverToBoxAdapter(
            child: _buildSection(
              title: '功能特性',
              child: _buildFeaturesGrid(),
            ),
          ),

          // 设计模式区块
          SliverToBoxAdapter(
            child: _buildSection(
              title: '设计模式',
              child: _buildPatternsSection(),
            ),
          ),

          // 技术配置区块
          SliverToBoxAdapter(
            child: _buildSection(
              title: '技术配置',
              child: _buildConfigSection(),
            ),
          ),

          // Demo 内容展示
          SliverToBoxAdapter(
            child: _buildSection(
              title: 'Demo 内容',
              child: _buildDemoContent(),
            ),
          ),

          // 底部说明
          SliverToBoxAdapter(
            child: _buildFooterSection(),
          ),
        ],
      ),
    );
  }

  // Hero 区域
  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 项目 Logo 图标
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.rocket_launch,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 32),

          // 主标题 - 渐变效果
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.8),
                ],
              ).createShader(bounds);
            },
            child: const Text(
              'Flutter\nEasy Starter',
              style: TextStyle(
                fontSize: 48,
                height: 1.1,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 副标题
          Text(
            '开箱即用的 Flutter 快速开发框架',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.lightGrey,
            ),
          ),
          const SizedBox(height: 12),

          // 核心卖点强调
          Row(
            children: [
              Icon(
                Icons.bolt,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                '30分钟即可搭建完整应用',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.primary.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 版本标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Text(
              'v1.0.0 · Production Ready',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 区块标题
  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // 功能特性 - 一行一个
  Widget _buildFeaturesGrid() {
    final features = [
      _FeatureItem(
        icon: Icons.route,
        title: '路由管理',
        desc: 'GoRouter + 自动路由守卫',
        color: const Color(0xFF5856D6),
      ),
      _FeatureItem(
        icon: Icons.sync,
        title: '状态管理',
        desc: 'Riverpod + 代码生成',
        color: const Color(0xFF30D158),
      ),
      _FeatureItem(
        icon: Icons.cloud_sync,
        title: '网络请求',
        desc: 'Dio + 拦截器 + WebSocket',
        color: const Color(0xFF0A84FF),
      ),
      _FeatureItem(
        icon: Icons.palette,
        title: 'UI 组件库',
        desc: '主题系统 + 屏幕适配',
        color: const Color(0xFFFF375F),
      ),
      _FeatureItem(
        icon: Icons.storage,
        title: '本地存储',
        desc: 'SharedPreferences + 缓存',
        color: const Color(0xFFFF9F0A),
      ),
      _FeatureItem(
        icon: Icons.notifications,
        title: '推送通知',
        desc: '极光 + 本地通知',
        color: const Color(0xFF64D2FF),
      ),
    ];

    return Column(
      children: features.map((feature) => _buildFeatureCard(feature)).toList(),
    );
  }

  Widget _buildFeatureCard(_FeatureItem feature) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: feature.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature.icon,
              color: feature.color,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.desc,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.lightGrey.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 设计模式区块 - 增加详细介绍
  Widget _buildPatternsSection() {
    final patterns = [
      _PatternDetail(
        title: 'Clean Architecture',
        subtitle: '清晰的分层架构',
        desc: '将应用分为 Presentation、Domain、Data 三层，实现关注点分离，便于测试和维护。每一层都有明确的职责边界，上层依赖下层但不知道实现细节。',
      ),
      _PatternDetail(
        title: 'Repository Pattern',
        subtitle: '统一的数据访问层',
        desc: '为数据操作提供抽象接口，屏蔽底层数据源差异。无论是网络请求、本地数据库还是缓存，上层代码都以统一方式访问，便于切换和 Mock 测试。',
      ),
      _PatternDetail(
        title: 'Feature-First',
        subtitle: '按功能组织代码',
        desc: '将相关文件（页面、组件、状态、API）按功能模块组织，而非按类型。使代码更容易定位和修改，新增功能只需关注一个目录。',
      ),
      _PatternDetail(
        title: 'MVVM 架构',
        subtitle: '响应式 UI 架构',
        desc: '使用 Riverpod 管理 ViewModel，UI 层监听状态变化自动刷新。业务逻辑与界面分离，状态变更可预测，支持复杂状态的优雅管理。',
      ),
    ];

    return Column(
      children: patterns.map((pattern) => _buildPatternCard(pattern)).toList(),
    );
  }

  Widget _buildPatternCard(_PatternDetail pattern) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surface,
            AppColors.surface.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pattern.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      pattern.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.lightGrey.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            pattern.desc,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.lightGrey.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  // 技术配置 - 一行一个
  Widget _buildConfigSection() {
    final configs = [
      _ConfigItem(Icons.color_lens, '暗黑主题', '深色/亮色主题切换'),
      _ConfigItem(Icons.fit_screen, '屏幕适配', 'ScreenUtil 多端适配'),
      _ConfigItem(Icons.settings_applications, '环境配置', '开发/测试/生产多环境'),
      _ConfigItem(Icons.security, '权限管理', '统一权限申请与处理'),
    ];

    return Column(
      children: configs.map((config) => _buildConfigChip(config)).toList(),
    );
  }

  Widget _buildConfigChip(_ConfigItem config) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              config.icon,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  config.desc,
                  style: TextStyle(
                    color: AppColors.lightGrey.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Demo 内容展示
  Widget _buildDemoContent() {
    final demos = [
      _DemoItem(
        icon: Icons.travel_explore,
        title: '探索',
        desc: '旅游卡片、Hero 动画、下拉刷新',
        preview: '底部导航 Tab 2 · 复杂 UI 实现',
      ),
      _DemoItem(
        icon: Icons.chat_bubble,
        title: '消息',
        desc: '聊天列表、IM 功能、Emoji 表情',
        preview: '底部导航 Tab 3 · 状态管理演示',
      ),
      _DemoItem(
        icon: Icons.person,
        title: '我的',
        desc: '用户资料、设置页面、表单处理',
        preview: '底部导航 Tab 4 · 页面交互示例',
      ),
    ];

    return Column(
      children: demos.map((demo) => _buildDemoCard(demo)).toList(),
    );
  }

  Widget _buildDemoCard(_DemoItem demo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.3),
                  AppColors.primary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              demo.icon,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  demo.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  demo.desc,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.lightGrey.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    demo.preview,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 底部说明区域
  Widget _buildFooterSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
      child: Column(
        children: [
          Text(
            '本 Demo 源码可直接作为项目模板使用',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.lightGrey.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.code,
                color: AppColors.lightGrey.withOpacity(0.4),
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                '开源框架 · 自由使用',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.lightGrey.withOpacity(0.5),
                ),
              ),
            ],
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
  final Color color;

  _FeatureItem({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });
}

class _PatternDetail {
  final String title;
  final String subtitle;
  final String desc;

  _PatternDetail({required this.title, required this.subtitle, required this.desc});
}

class _ConfigItem {
  final IconData icon;
  final String title;
  final String desc;

  _ConfigItem(this.icon, this.title, this.desc);
}

class _DemoItem {
  final IconData icon;
  final String title;
  final String desc;
  final String preview;

  _DemoItem({
    required this.icon,
    required this.title,
    required this.desc,
    required this.preview,
  });
}
