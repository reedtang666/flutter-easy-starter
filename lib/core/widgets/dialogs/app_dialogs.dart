import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/widgets/animated_button.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'confirm_dialog.dart';
import 'bottom_action_sheet.dart';
import 'input_dialog.dart';
import 'selection_dialog.dart';
import 'loading_dialog.dart';
import 'toast_message.dart';
import 'notification_dialog.dart';
import 'dialog_models.dart';
export 'dialog_models.dart';

/// 弹窗管理器 - 统一管理和显示各类弹窗
/// 提供简洁的 API 供业务层调用
class AppDialogs {
  static final AppDialogs _instance = AppDialogs._internal();
  factory AppDialogs() => _instance;
  AppDialogs._internal();

  static AppDialogs get instance => _instance;

  /// 显示确认弹窗
  static Future<bool?> showConfirm({
    required BuildContext context,
    String? title,
    String? content,
    String? confirmText,
    String? cancelText,
    bool isDanger = false,
    Widget? customContent,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmDialog(
        title: title ?? '确认',
        content: content,
        customContent: customContent,
        confirmText: confirmText ?? '确认',
        cancelText: cancelText ?? '取消',
        isDanger: isDanger,
      ),
    );
  }

  /// 显示底部操作菜单
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    String? title,
    required List<BottomSheetAction<T>> actions,
    bool showCancel = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BottomActionSheet<T>(
        title: title,
        actions: actions,
        showCancel: showCancel,
      ),
    );
  }

  /// 显示输入弹窗
  static Future<String?> showInput({
    required BuildContext context,
    String? title,
    String? hint,
    String? initialValue,
    String? confirmText,
    String? cancelText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => InputDialog(
        title: title ?? '请输入',
        hint: hint,
        initialValue: initialValue,
        confirmText: confirmText ?? '确认',
        cancelText: cancelText ?? '取消',
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  /// 显示选择弹窗
  static Future<T?> showSelection<T>({
    required BuildContext context,
    String? title,
    required List<SelectionItem<T>> items,
    T? selectedValue,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (context) => SelectionDialog<T>(
        title: title ?? '请选择',
        items: items,
        selectedValue: selectedValue,
      ),
    );
  }

  /// 显示加载弹窗
  static void showLoading({
    required BuildContext context,
    String? message,
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => LoadingDialog(message: message ?? '加载中...'),
    );
  }

  /// 隐藏弹窗
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// 显示成功提示
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showToast(
      context: context,
      message: message,
      icon: LucideIcons.circle_check,
      color: AppColors.green,
      duration: duration,
    );
  }

  /// 显示错误提示
  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      context: context,
      message: message,
      icon: LucideIcons.circle_x,
      color: AppColors.red,
      duration: duration,
    );
  }

  /// 显示警告提示
  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showToast(
      context: context,
      message: message,
      icon: LucideIcons.circle_alert,
      color: AppColors.orange,
      duration: duration,
    );
  }

  /// 显示信息提示
  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showToast(
      context: context,
      message: message,
      icon: LucideIcons.info,
      color: AppColors.blue,
      duration: duration,
    );
  }

  /// 显示通知弹窗
  static Future<void> showNotification({
    required BuildContext context,
    String? title,
    String? content,
    IconData icon = LucideIcons.bell,
    Color iconColor = AppColors.primary,
    VoidCallback? onAction,
    String? actionText,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => NotificationDialog(
        title: title ?? '通知',
        content: content,
        icon: icon,
        iconColor: iconColor,
        onAction: onAction,
        actionText: actionText,
      ),
    );
  }

  /// 内部方法：显示 Toast
  static void _showToast({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color color,
    required Duration duration,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => ToastMessage(
        message: message,
        icon: icon,
        color: color,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
