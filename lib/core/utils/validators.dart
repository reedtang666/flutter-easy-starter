/// 表单验证工具类
class Validators {
  Validators._();

  /// 验证手机号
  static bool isPhone(String value) {
    return RegExp(r'^1[3-9]\d{9}$').hasMatch(value);
  }

  /// 验证邮箱
  static bool isEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  /// 验证密码（6-20位，字母+数字）
  static bool isPassword(String value) {
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,20}$').hasMatch(value);
  }

  /// 验证验证码（6位数字）
  static bool isSmsCode(String value) {
    return RegExp(r'^\d{6}$').hasMatch(value);
  }

  /// 验证是否为空
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// 验证长度
  static bool length(String value, int min, int max) {
    return value.length >= min && value.length <= max;
  }
}
