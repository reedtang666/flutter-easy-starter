import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/constants/storage_keys.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 隐私设置项
class PrivacySetting {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSwitch;
  final bool defaultValue;

  const PrivacySetting({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isSwitch = true,
    this.defaultValue = true,
  });
}

final List<PrivacySetting> settings = [
  const PrivacySetting(
    icon: Icons.visibility,
    title: '个人资料可见',
    subtitle: '允许其他用户查看你的资料',
    defaultValue: true,
  ),
  const PrivacySetting(
    icon: Icons.location_on,
    title: '显示距离',
    subtitle: '向他人展示你与他们的距离',
    defaultValue: true,
  ),
  const PrivacySetting(
    icon: Icons.access_time,
    title: '在线状态',
    subtitle: '显示你当前是否在线',
    defaultValue: true,
  ),
  const PrivacySetting(
    icon: Icons.chat,
    title: '允许陌生人私信',
    subtitle: '未匹配用户能否给你发消息',
    defaultValue: false,
  ),
  const PrivacySetting(
    icon: Icons.photo,
    title: '相册访问权限',
    subtitle: '允许已匹配用户查看完整相册',
    defaultValue: true,
  ),
  const PrivacySetting(
    icon: Icons.phone,
    title: '通过手机号找到我',
    subtitle: '允许通讯录好友找到你',
    defaultValue: false,
  ),
];

/// 隐私设置页
class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  final Map<int, bool> _values = {};

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < settings.length; i++) {
      _values[i] = settings[i].defaultValue;
    }
  }

  /// 查看隐私政策
  void _viewPrivacyPolicy() {
    context.push(RouteNames.privacy);
  }

  /// 撤销隐私政策同意
  void _revokePrivacyConsent() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('撤销隐私政策同意',
          style: TextStyle(color: AppColors.white),
        ),
        content: const Text(
          '撤销同意后，您将无法继续使用本应用。确定要撤销吗？',
          style: TextStyle(color: AppColors.lightGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '取消',
              style: TextStyle(color: AppColors.lightGrey),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              // 清除隐私政策同意状态
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool(StorageKeys.privacyAccepted, false);
              // 重置首次启动状态
              await prefs.setBool(StorageKeys.isFirstLaunch, true);

              if (mounted) {
                // 退出到隐私政策页
                context.go(RouteNames.privacy);
              }
            },
            child: Text(
              '确定撤销',
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('隐私设置'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 说明文字
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),

          // 隐私政策入口
          SliverToBoxAdapter(
            child: _buildPrivacyPolicySection(),
          ),

          // 设置列表标题
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                '功能隐私设置',
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // 设置列表
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildSettingItem(index, settings[index]),
                childCount: settings.length,
              ),
            ),
          ),

          // 高级设置
          SliverToBoxAdapter(
            child: _buildAdvancedSettings(),
          ),

          // 底部空间
          SliverToBoxAdapter(
            child: SizedBox(height: 32.w),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              Icons.shield,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          SizedBox(height: 16.w),
          Text(
            '保护你的隐私',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            '这些设置决定其他用户能看到哪些信息',
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPolicySection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            // 查看隐私政策
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.policy,
                  color: AppColors.primary,
                ),
              ),
              title: Text('隐私政策',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text('查看完整的隐私政策内容',
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 13.sp,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: AppColors.lightGrey,
              ),
              onTap: _viewPrivacyPolicy,
            ),

            Divider(height: 1.w, indent: 72, color: AppColors.tertiaryGrey),

            // 撤销同意
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.logout,
                  color: AppColors.red,
                ),
              ),
              title: Text('撤销隐私政策同意',
                style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text('撤销后将无法继续使用应用',
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 13.sp,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: AppColors.lightGrey,
              ),
              onTap: _revokePrivacyConsent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(int index, PrivacySetting setting) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.tertiaryGrey,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              setting.icon,
              color: AppColors.white,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  setting.title,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.w),
                Text(
                  setting.subtitle,
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _values[index] ?? setting.defaultValue,
            onChanged: (value) {
              setState(() {
                _values[index] = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8, bottom: 16),
            child: Text(
              '高级设置',
              style: TextStyle(
                color: AppColors.lightGrey,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                _buildActionTile(
                  icon: Icons.block,
                  title: '黑名单',
                  subtitle: '管理已屏蔽的用户',
                  onTap: () {},
                ),
                Divider(height: 1.w, indent: 72, color: AppColors.tertiaryGrey),
                _buildActionTile(
                  icon: Icons.delete,
                  title: '清除聊天记录',
                  subtitle: '删除所有聊天历史',
                  onTap: () {},
                ),
                Divider(height: 1.w, indent: 72, color: AppColors.tertiaryGrey),
                _buildActionTile(
                  icon: Icons.delete_forever,
                  title: '注销账号',
                  subtitle: '永久删除你的账号和数据',
                  isDestructive: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColors.red.withValues(alpha: 0.2)
              : AppColors.tertiaryGrey,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          color: isDestructive ? AppColors.red : AppColors.white,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppColors.red : AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.lightGrey,
          fontSize: 13.sp,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.lightGrey,
      ),
      onTap: onTap,
    );
  }
}
