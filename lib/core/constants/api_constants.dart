/// API 地址配置
/// ⚠️ 注意：这只是示例配置，请根据实际项目修改
class ApiConstants {
  ApiConstants._();

  // 环境切换
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  // 基础地址
  static String get baseUrl {
    if (isProduction) {
      return 'https://api.example.com';
    }
    return 'https://dev-api.example.com';
  }

  // WebSocket 地址
  static String get wsUrl {
    if (isProduction) {
      return 'wss://ws.example.com';
    }
    return 'wss://dev-ws.example.com';
  }

  // API 路径
  static const String login = '/auth/login';
  static const String loginByPhone = '/auth/login/phone';
  static const String sendSmsCode = '/auth/sms/send';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  static const String userInfo = '/user/info';
  static const String updateUserInfo = '/user/update';
  static const String uploadAvatar = '/user/avatar';

  // 示例：其他业务接口
  static const String homeData = '/home/data';
  static const String settings = '/settings';
}
