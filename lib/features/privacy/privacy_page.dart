import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/constants/storage_keys.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/features/privacy/privacy_content.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 隐私政策页
///
/// 使用场景：
/// 1. 首次启动（从 Splash 进入）：强制同意模式，无返回按钮，不同意则退出应用
/// 2. 从设置页进入：查看模式，显示已同意状态，可返回
class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool _isLoading = false;
  bool _isFromSettings = false;
  bool _hasAccepted = false;

  @override
  void initState() {
    super.initState();
    _checkSource();
  }

  /// 检查进入来源
  Future<void> _checkSource() async {
    final prefs = await SharedPreferences.getInstance();
    _hasAccepted = prefs.getBool(StorageKeys.privacyAccepted) ?? false;

    // 如果已经同意过隐私政策，说明是从设置页进入的
    setState(() {
      _isFromSettings = _hasAccepted;
    });
  }

  /// 拒绝隐私政策
  void _onReject() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('温馨提示', style: TextStyle(color: AppColors.white)),
        content: const Text(
          '您需要同意隐私政策后才能继续使用本应用。如果不同意，我们将无法为您提供服务。',
          style: TextStyle(color: AppColors.lightGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('返回查看', style: TextStyle(color: AppColors.lightGrey)),
          ),
          TextButton(
            onPressed: () {
              // 退出应用
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
            child: Text('退出应用', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  /// 同意隐私政策
  Future<void> _onAccept() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(StorageKeys.privacyAccepted, true);

      if (mounted) {
        // 同意后跳转到引导页
        context.go(RouteNames.landing);
      }
    } catch (e) {
      debugPrint('保存失败: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _isFromSettings ? AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('隐私政策'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ) : null,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部标题（强制模式下显示）
            if (!_isFromSettings)
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.shield_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    SizedBox(height: 16.w),
                    Text(
                      '隐私政策',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 8.w),
                    Text(
                      '请仔细阅读并同意我们的隐私政策',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),

            // 已同意提示（从设置页进入时显示）
            if (_isFromSettings)
              Container(
                margin: EdgeInsets.all(16.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '您已同意隐私政策',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                            ),
                          ),
                          Text(
                            '您可以在下方查看完整的隐私政策内容',
                            style: TextStyle(
                              color: AppColors.lightGrey,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // 隐私政策内容
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.divider),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(0.w),
                    child: Html(
                      data: PrivacyContent.htmlContent,
                      style: {
                        "body": Style(
                          margin: Margins.all(0),
                          padding: HtmlPaddings.all(16),
                          color: AppColors.white,
                        ),
                        "h1": Style(color: AppColors.white),
                        "h2": Style(color: AppColors.white),
                        "h3": Style(color: AppColors.white),
                        "p": Style(color: AppColors.lightGrey),
                        "li": Style(color: AppColors.lightGrey),
                      },
                    ),
                  ),
                ),
              ),
            ),

            // 底部提示（强制模式）
            if (!_isFromSettings)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(
                  '点击"同意并继续"即表示您已阅读并同意上述隐私政策',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.lightGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // 底部按钮
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: _isFromSettings
                  // 设置页模式：只显示返回按钮
                  ? SizedBox(
                      width: double.infinity,
                      height: 56.w,
                      child: ElevatedButton(
                        onPressed: () => context.pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          '返回',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  // 强制模式：显示同意/拒绝按钮
                  : Row(
                      children: [
                        // 不同意按钮
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : _onReject,
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: AppColors.divider),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              '不同意',
                              style: TextStyle(
                                color: AppColors.lightGrey,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        // 同意按钮
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _onAccept,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text('同意并继续',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
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
}
