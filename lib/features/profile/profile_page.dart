import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/constants/app_constants.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/utils/device_utils.dart';
import 'package:flutter_easy_starter/core/utils/dialog_utils.dart';
import 'package:flutter_easy_starter/models/user_model.dart';
import 'package:flutter_easy_starter/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 设置页面 - Dark Social 风格
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 用户信息头部
            SliverToBoxAdapter(
              child: _buildUserHeader(context, user),
            ),

            // 账户管理
            SliverToBoxAdapter(
              child: _buildSection(
                title: '账户',
                items: [
                  _MenuItem(
                    icon: Icons.person_outline,
                    title: '个人信息',
                    onTap: () => context.push(RouteNames.userInfo),
                  ),
                  _MenuItem(
                    icon: Icons.photo_library_outlined,
                    title: '我的照片',
                    onTap: () => context.push(RouteNames.myPhotos),
                  ),
                  _MenuItem(
                    icon: Icons.verified_outlined,
                    title: '实名认证',
                    trailing: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        '已认证',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                    onTap: () => context.push(RouteNames.realNameAuth),
                  ),
                ],
              ),
            ),

            // 偏好设置
            SliverToBoxAdapter(
              child: _buildSection(
                title: '偏好',
                items: [
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    title: '消息通知',
                    trailing: _CustomSwitch(
                      value: _notificationsEnabled,
                      activeColor: AppColors.primary,
                      onChanged: (value) => setState(() => _notificationsEnabled = value),
                    ),
                    onTap: () => setState(() => _notificationsEnabled = !_notificationsEnabled),
                  ),
                  _MenuItem(
                    icon: Icons.location_on_outlined,
                    title: '位置服务',
                    subtitle: '开启位置发现附近的人',
                    trailing: _CustomSwitch(
                      value: _locationEnabled,
                      activeColor: AppColors.primary,
                      onChanged: (value) => setState(() => _locationEnabled = value),
                    ),
                    onTap: () => setState(() => _locationEnabled = !_locationEnabled),
                  ),
                  _MenuItem(
                    icon: Icons.visibility_outlined,
                    title: '隐私设置',
                    onTap: () => context.push(RouteNames.privacySettings),
                  ),
                ],
              ),
            ),

            // 商城
            SliverToBoxAdapter(
              child: _buildSection(
                title: '商城',
                items: [
                  _MenuItem(
                    icon: Icons.card_giftcard_outlined,
                    title: '礼物商城',
                    subtitle: '用金币兑换精美礼物',
                    trailing: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: Colors.amber,
                            size: 16,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '1250',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => context.push(RouteNames.giftShop),
                  ),
                  _MenuItem(
                    icon: Icons.workspace_premium_outlined,
                    title: 'VIP会员',
                    subtitle: '解锁更多特权',
                    trailing: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        '升级',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    onTap: () => context.push(RouteNames.vip),
                  ),
                ],
              ),
            ),

            // 关于
            SliverToBoxAdapter(
              child: _buildSection(
                title: '关于',
                items: [
                  _MenuItem(
                    icon: Icons.info_outline,
                    title: '关于我们',
                    subtitle: 'v${AppConstants.appVersion}',
                    onTap: () => _showAboutDialog(context),
                  ),
                  _MenuItem(
                    icon: Icons.phone_android_outlined,
                    title: '设备信息',
                    onTap: () => DeviceInfoDisplay.showDeviceInfoDialog(context),
                  ),
                  _MenuItem(
                    icon: Icons.description_outlined,
                    title: '隐私政策',
                    onTap: () => context.push(RouteNames.privacy),
                  ),
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: '帮助与反馈',
                    onTap: () => context.push(RouteNames.helpFeedback),
                  ),
                ],
              ),
            ),

            // 退出登录
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xxl),
                child: OutlinedButton(
                  onPressed: () => _showLogoutConfirm(context, ref),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.red,
                    side: const BorderSide(color: AppColors.red),
                  ),
                  child: Text('退出登录'),
                ),
              ),
            ),

            // 底部间距
            SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xxxl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, UserModel? user) {
    return Container(
      margin: EdgeInsets.all(AppSpacing.xxl),
      padding: EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          // 头像
          Stack(
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: AppColors.tertiaryGrey,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: user?.avatar != null && user!.avatar!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        child: user.avatar!.startsWith('http')
                            ? Image.network(
                                user.avatar!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                user.avatar!,
                                fit: BoxFit.cover,
                              ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        child: Image.asset(
                          'assets/images/avatar_default.png',
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 20.w,
                  height: 20.w,
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
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? '未设置昵称',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 4.w),
                Text(
                  user?.username ?? '点击编辑个人信息',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    'VIP 会员',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 编辑按钮
          IconButton(
            icon: Icon(Icons.chevron_right),
            color: AppColors.lightGrey,
            onPressed: () => context.push(RouteNames.userInfo),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 分组标题
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            AppSpacing.lg,
            AppSpacing.xxl,
            AppSpacing.sm,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: AppTypography.caption,
              fontWeight: AppTypography.semiBold,
              color: AppColors.lightGrey,
            ),
          ),
        ),
        // 菜单列表
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return Column(
                children: [
                  GestureDetector(
                    onTap: item.onTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: isLast
                            ? null
                            : const Border(
                                bottom: BorderSide(color: AppColors.divider),
                              ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            color: AppColors.lightGrey,
                            size: 22,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyle(color: AppColors.white),
                                ),
                                if (item.subtitle != null)
                                  Text(
                                    item.subtitle!,
                                    style: const TextStyle(
                                      fontSize: AppTypography.caption,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          item.trailing ??
                              Icon(
                                Icons.chevron_right,
                                size: 20,
                                color: AppColors.lightGrey,
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirm(BuildContext context, WidgetRef ref) {
    DialogUtils.confirm(
      context: context,
      title: '确认退出？',
      message: '退出登录后将需要重新登录才能使用完整功能',
      okLabel: '退出',
      cancelLabel: '取消',
      isDestructive: true,
      onOk: () async {
        await ref.read(authProvider.notifier).logout();
        if (context.mounted) {
          context.go(RouteNames.login);
        }
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Flutter Easy Starter',
      applicationVersion: 'v${AppConstants.appVersion}',
      applicationIcon: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.glow,
        ),
        child: Icon(
          Icons.rocket_launch,
          size: 32,
          color: AppColors.white,
        ),
      ),
      applicationLegalese: '© 2024 Flutter Easy Starter. MIT License.',
      children: [
        SizedBox(height: AppSpacing.lg),
        Text(
          'Flutter Easy Starter 是一个开箱即用的 Flutter 快速开发框架，集成了路由、状态管理、网络请求等核心能力，帮助你快速构建高质量的 Flutter 应用。',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });
}

/// 自定义开关组件
class _CustomSwitch extends StatelessWidget {
  final bool value;
  final Color activeColor;
  final ValueChanged<bool> onChanged;

  const _CustomSwitch({
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: value ? activeColor : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
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
    );
  }
}
