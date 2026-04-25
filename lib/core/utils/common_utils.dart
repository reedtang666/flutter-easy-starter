import 'dart:math';

/// 通用工具类
class CommonUtils {
  CommonUtils._();

  /// 生成随机字符串
  static String randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  /// 生成随机数字验证码
  static String randomCode(int length) {
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => '0123456789'.codeUnitAt(random.nextInt(10)),
      ),
    );
  }

  /// 隐藏手机号中间四位
  static String maskPhone(String phone) {
    if (phone.length != 11) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(7)}';
  }

  /// 格式化文件大小
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// 防抖
  static Function debounce(Function func, Duration duration) {
    DateTime? lastCall;
    return () {
      final now = DateTime.now();
      if (lastCall == null || now.difference(lastCall!) > duration) {
        lastCall = now;
        func();
      }
    };
  }

  /// 节流
  static Function throttle(Function func, Duration duration) {
    bool isThrottled = false;
    return () {
      if (!isThrottled) {
        isThrottled = true;
        func();
        Future.delayed(duration, () {
          isThrottled = false;
        });
      }
    };
  }
}
