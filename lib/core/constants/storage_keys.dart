/// 本地存储 Key 常量
class StorageKeys {
  StorageKeys._();

  // 隐私政策
  static const String privacyAccepted = 'privacy_accepted';

  // 首次启动
  static const String isFirstLaunch = 'is_first_launch';

  // 用户认证
  static const String token = 'token';
  static const String refreshToken = 'refresh_token';
  static const String userInfo = 'user_info';

  // 主题设置
  static const String themeMode = 'theme_mode';

  // 语言设置
  static const String language = 'language';

  // 极光推送
  static const String jpushAlias = 'jpush_alias';
  static const String jpushRegistrationId = 'jpush_registration_id';
}
