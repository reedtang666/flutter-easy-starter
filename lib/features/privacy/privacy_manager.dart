import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/constants/storage_keys.dart';
import 'package:flutter_easy_starter/core/services/push_service.dart';
import 'package:flutter_easy_starter/core/services/storage_service.dart';
import 'package:flutter_easy_starter/core/services/wechat_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 隐私合规管理器
///
/// 管理隐私政策的同意状态，控制第三方SDK的初始化
/// 这是商业App上架的强制要求
class PrivacyManager {
  PrivacyManager._();

  static final PrivacyManager _instance = PrivacyManager._();
  static PrivacyManager get instance => _instance;

  bool _isPrivacyAccepted = false;
  bool _isJPushInitialized = false;
  bool _isWechatInitialized = false;

  /// 检查用户是否已同意隐私政策
  Future<bool> checkPrivacyAccepted() async {
    _isPrivacyAccepted = StorageService.instance.getBool(
      StorageKeys.privacyAccepted,
    );
    return _isPrivacyAccepted;
  }

  /// 用户同意隐私政策
  ///
  /// 调用此方法后，才会初始化第三方SDK
  Future<void> onPrivacyAccepted() async {
    if (!_isPrivacyAccepted) {
      await StorageService.instance.setBool(StorageKeys.privacyAccepted, true);
      _isPrivacyAccepted = true;
    }

    // 初始化所有第三方SDK
    await _initAllSDKs();
  }

  /// 初始化所有第三方SDK
  ///
  /// ⚠️ 注意：只有在用户同意隐私政策后才会执行
  Future<void> _initAllSDKs() async {
    if (!_isPrivacyAccepted) {
      debugPrint('⚠️ 隐私合规: 用户未同意隐私政策，跳过SDK初始化');
      return;
    }

    debugPrint('✅ 隐私合规: 开始初始化第三方SDK');

    // 初始化极光推送
    await _initJPush();

    // 初始化微信SDK
    await _initWechat();

    debugPrint('✅ 隐私合规: 第三方SDK初始化完成');
  }

  /// 初始化极光推送
  ///
  /// ⚠️ 配置提示：
  /// 1. 前往极光官网注册应用：https://www.jiguang.cn/
  /// 2. 获取 AppKey
  /// 3. 在 Android 的 build.gradle 和 iOS 的 Info.plist 中配置 AppKey
  /// 4. 取消下方代码注释，填入你的 AppKey
  Future<void> _initJPush() async {
    if (_isJPushInitialized) {
      debugPrint('JPush: 已初始化，跳过');
      return;
    }

    try {
      // TODO: 配置极光推送 AppKey
      // await PushService.instance.init(
      //   appKey: 'YOUR_JPUSH_APPKEY',
      //   channel: 'developer-default',
      // );

      // _isJPushInitialized = true;
      // debugPrint('✅ JPush: 初始化成功');
    } catch (e) {
      debugPrint('❌ JPush: 初始化失败 - $e');
    }
  }

  /// 初始化微信SDK
  ///
  /// ⚠️ 配置提示：
  /// 1. 前往微信开放平台注册应用：https://open.weixin.qq.com/
  /// 2. 获取 AppID
  /// 3. 配置 Universal Link（iOS 必须）
  /// 4. 取消下方代码注释，填入你的 AppID
  Future<void> _initWechat() async {
    if (_isWechatInitialized) {
      debugPrint('Wechat: 已初始化，跳过');
      return;
    }

    try {
      // TODO: 配置微信 AppID
      // await WechatService.instance.register(
      //   appId: 'YOUR_WECHAT_APPID',
      //   universalLink: 'https://your-domain.com/',
      // );

      // _isWechatInitialized = true;
      // debugPrint('✅ Wechat: 初始化成功');
    } catch (e) {
      debugPrint('❌ Wechat: 初始化失败 - $e');
    }
  }

  /// 设置推送别名（登录成功后调用）
  Future<void> setPushAlias(String alias) async {
    if (!_isJPushInitialized) {
      debugPrint('JPush: 未初始化，无法设置别名');
      return;
    }
    await PushService.instance.setAlias(alias);
  }

  /// 清除推送别名（退出登录时调用）
  Future<void> clearPushAlias() async {
    if (!_isJPushInitialized) return;
    await PushService.instance.deleteAlias();
  }

  /// 重置所有SDK状态（退出登录或撤销授权时）
  Future<void> reset() async {
    await clearPushAlias();

    _isJPushInitialized = false;
    _isWechatInitialized = false;
    _isPrivacyAccepted = false;

    await StorageService.instance.setBool(StorageKeys.privacyAccepted, false);
  }
}
