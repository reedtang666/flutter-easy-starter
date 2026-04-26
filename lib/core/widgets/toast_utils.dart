import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// Toast 工具类
class ToastUtils {
  ToastUtils._();

  /// 显示成功提示
  static void success(String message, {Duration? duration}) {
    EasyLoading.showSuccess(
      message,
      duration: duration ?? const Duration(seconds: 2),
      maskType: EasyLoadingMaskType.none,
    );
  }

  /// 显示错误提示
  static void error(String message, {Duration? duration}) {
    EasyLoading.showError(
      message,
      duration: duration ?? const Duration(seconds: 2),
      maskType: EasyLoadingMaskType.none,
    );
  }

  /// 显示信息提示
  static void info(String message, {Duration? duration}) {
    EasyLoading.showInfo(
      message,
      duration: duration ?? const Duration(seconds: 2),
      maskType: EasyLoadingMaskType.none,
    );
  }

  /// 显示加载
  static void showLoading({String? message}) {
    EasyLoading.show(
      status: message,
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: false,
    );
  }

  /// 隐藏加载
  static void hideLoading() {
    EasyLoading.dismiss();
  }

  /// 显示 Toast
  static void show(String message, {Duration? duration}) {
    EasyLoading.showToast(
      message,
      duration: duration ?? const Duration(seconds: 2),
      toastPosition: EasyLoadingToastPosition.center,
      maskType: EasyLoadingMaskType.none,
    );
  }
}

/// 初始化 EasyLoading（在 App 启动时调用）
void initEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black87
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.black.withValues(alpha: 0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
