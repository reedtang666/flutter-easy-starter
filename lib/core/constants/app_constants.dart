/// App 常量配置
class AppConstants {
  AppConstants._();

  // App 信息
  static const String appName = 'Flutter Easy Starter';
  static const String appVersion = '1.0.0';

  // 设计稿尺寸（用于屏幕适配）
  static const double designWidth = 375;
  static const double designHeight = 667;

  // 示例账号（开发测试用）
  static const String demoAccount = 'test';
  static const String demoPassword = '123456';

  // 网络配置
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;

  // 分页配置
  static const int pageSize = 20;

  // 动画时长
  static const int splashDuration = 2; // 秒
  static const int animationDuration = 300; // 毫秒
}
