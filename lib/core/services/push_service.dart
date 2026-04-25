import 'dart:io';

import 'package:flutter/foundation.dart';

/// 极光推送服务
///
/// ⚠️ 重要提示：
/// 1. 在使用前，请先前往极光官网注册应用：https://www.jiguang.cn/
/// 2. 获取 AppKey 和 Master Secret
/// 3. 在 Android 的 AndroidManifest.xml 中配置 AppKey
/// 4. 在 iOS 的 Info.plist 中配置 AppKey
///
/// 配置示例：
/// Android (android/app/build.gradle):
/// ```
/// manifestPlaceholders = [
///     JPUSH_APPKEY: "your_app_key",
///     JPUSH_CHANNEL: "developer-default",
/// ]
/// ```
///
/// iOS (ios/Runner/Info.plist):
/// ```xml
/// <key>jiguang_appKey</key>
/// <string>your_app_key</string>
/// ```
class PushService {
  PushService._();

  static final PushService _instance = PushService._();
  static PushService get instance => _instance;

  bool _isInitialized = false;

  /// 是否已初始化
  bool get isInitialized => _isInitialized;

  /// 初始化推送服务
  ///
  /// 注意：必须在用户同意隐私政策后才能调用此方法
  /// 参考 PrivacyManager.onPrivacyAccepted()
  Future<void> init({
    required String appKey,
    String channel = 'developer-default',
  }) async {
    if (_isInitialized) {
      debugPrint('PushService: 已初始化，跳过');
      return;
    }

    try {
      // TODO: 初始化极光推送
      // final jpush = JPush();
      // await jpush.setup(
      //   appKey: appKey,
      //   channel: channel,
      //   production: !kDebugMode,
      //   debug: kDebugMode,
      // );

      // // iOS 申请推送权限
      // if (Platform.isIOS) {
      //   jpush.applyPushAuthority(
      //     const NotificationSettingsIOS(
      //       sound: true,
      //       alert: true,
      //       badge: true,
      //     ),
      //   );
      // }

      // // 添加事件监听
      // jpush.addEventHandler(
      //   onReceiveNotification: _onReceiveNotification,
      //   onOpenNotification: _onOpenNotification,
      //   onReceiveMessage: _onReceiveMessage,
      // );

      _isInitialized = true;
      debugPrint('PushService: 初始化成功');
    } catch (e) {
      debugPrint('PushService: 初始化失败 - $e');
      throw Exception('推送服务初始化失败: $e');
    }
  }

  /// 设置别名（建议在登录成功后调用）
  ///
  /// 参数：
  /// - alias: 用户唯一标识，建议使用用户ID
  Future<void> setAlias(String alias) async {
    if (!_isInitialized) {
      debugPrint('PushService: 未初始化，无法设置别名');
      return;
    }

    try {
      // TODO: 调用极光 SDK 设置别名
      // final jpush = JPush();
      // await jpush.setAlias(alias);
      debugPrint('PushService: 设置别名成功 - $alias');
    } catch (e) {
      debugPrint('PushService: 设置别名失败 - $e');
    }
  }

  /// 清除别名（建议在退出登录时调用）
  Future<void> deleteAlias() async {
    if (!_isInitialized) return;

    try {
      // TODO: 调用极光 SDK 清除别名
      // final jpush = JPush();
      // await jpush.deleteAlias();
      debugPrint('PushService: 清除别名成功');
    } catch (e) {
      debugPrint('PushService: 清除别名失败 - $e');
    }
  }

  /// 设置标签
  Future<void> setTags(List<String> tags) async {
    if (!_isInitialized) return;

    try {
      // TODO: 设置标签
      // final jpush = JPush();
      // await jpush.setTags(tags);
      debugPrint('PushService: 设置标签成功 - $tags');
    } catch (e) {
      debugPrint('PushService: 设置标签失败 - $e');
    }
  }

  /// 清除通知角标（iOS）
  Future<void> clearBadge() async {
    if (!_isInitialized) return;
    if (!Platform.isIOS) return;

    try {
      // TODO: 清除角标
      // final jpush = JPush();
      // await jpush.setBadge(0);
      debugPrint('PushService: 清除角标成功');
    } catch (e) {
      debugPrint('PushService: 清除角标失败 - $e');
    }
  }

  /// 获取 Registration ID（用于测试推送）
  Future<String?> getRegistrationId() async {
    if (!_isInitialized) return null;

    try {
      // TODO: 获取 Registration ID
      // final jpush = JPush();
      // return await jpush.getRegistrationID();
      return null;
    } catch (e) {
      debugPrint('PushService: 获取 Registration ID 失败 - $e');
      return null;
    }
  }

  /// 接收通知回调（后台或前台）
  void _onReceiveNotification(Map<String, dynamic> message) {
    debugPrint('PushService: 收到通知 - $message');
    // TODO: 处理通知，例如显示本地通知
  }

  /// 点击通知回调
  void _onOpenNotification(Map<String, dynamic> message) {
    debugPrint('PushService: 点击通知 - $message');
    // TODO: 根据通知内容跳转页面
    // 例如：
    // final route = message['route'];
    // final params = message['params'];
    // AppRouter.push(route, extra: params);
  }

  /// 接收自定义消息（透传消息）
  void _onReceiveMessage(Map<String, dynamic> message) {
    debugPrint('PushService: 收到自定义消息 - $message');
    // TODO: 处理透传消息
  }

  /// 停止推送服务（用户撤销授权时调用）
  Future<void> stop() async {
    if (!_isInitialized) return;

    await deleteAlias();
    _isInitialized = false;
    debugPrint('PushService: 已停止');
  }
}
