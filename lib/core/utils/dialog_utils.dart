import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';

/// 对话框工具
///
/// 统一风格的 Alert、Confirm、BottomSheet
/// 参考成熟项目风格：圆角、渐变按钮、简洁布局
class DialogUtils {
  DialogUtils._();

  /// 显示 Alert 对话框（单个确认按钮）
  static void alert({
    required BuildContext context,
    String? title = '提示',
    String? message = '',
    String? okLabel = '确认',
    VoidCallback? onOk,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => _AlertDialog(
        title: title,
        message: message,
        okLabel: okLabel,
        onOk: onOk,
      ),
    );
  }

  /// 显示 Confirm 对话框（确认+取消按钮）
  static void confirm({
    required BuildContext context,
    String? title = '提示',
    String? message = '',
    String? okLabel = '确认',
    String? cancelLabel = '取消',
    VoidCallback? onOk,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => _ConfirmDialog(
        title: title,
        message: message,
        okLabel: okLabel,
        cancelLabel: cancelLabel,
        onOk: onOk,
        onCancel: onCancel,
        isDestructive: isDestructive,
      ),
    );
  }

  /// 显示底部选项菜单
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required List<BottomSheetItem<T>> items,
    String? title,
    bool showCancel = true,
    String cancelLabel = '取消',
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _BottomSheetMenu<T>(
        items: items,
        title: title,
        showCancel: showCancel,
        cancelLabel: cancelLabel,
      ),
    );
  }

  /// 显示自定义对话框
  static Future<T?> showCustom<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  /// 显示输入对话框
  static Future<String?> showInput({
    required BuildContext context,
    String? title = '请输入',
    String? hint = '请输入内容',
    String? initialValue,
    int maxLines = 1,
    int maxLength = 100,
    String? okLabel = '确定',
    String? cancelLabel = '取消',
    bool barrierDismissible = true,
  }) async {
    final controller = TextEditingController(text: initialValue);
    String? result;

    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: title != null
            ? Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
        content: TextField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(cancelLabel ?? '取消'),
          ),
          _GradientButton(
            label: okLabel ?? '确定',
            onTap: () {
              result = controller.text;
              Navigator.pop(context);
            },
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
        ],
      ),
    );

    return result;
  }

  /// 显示顶部图片弹窗（带突破效果）
  static void showTopImage({
    required BuildContext context,
    required String imagePath,
    required String message,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.7),
      builder: (context) => _TopImageDialog(
        imagePath: imagePath,
        message: message,
        buttonText: buttonText,
        onTap: onTap,
      ),
    );
  }

  /// 显示信息提示（SnackBar）
  static void showInfo(
    BuildContext context, {
    String? title,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// 显示成功提示
  static void showSuccess(
    BuildContext context, {
    String? title,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// 显示错误提示
  static void showError(
    BuildContext context, {
    String? title,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

/// Alert 对话框组件
class _AlertDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final String? okLabel;
  final VoidCallback? onOk;

  const _AlertDialog({
    this.title,
    this.message,
    this.okLabel,
    this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            if (message != null && message!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  message!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 24),
            _GradientButton(
              label: okLabel ?? '确认',
              onTap: () {
                Navigator.pop(context);
                onOk?.call();
              },
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

/// Confirm 对话框组件
class _ConfirmDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final String? okLabel;
  final String? cancelLabel;
  final VoidCallback? onOk;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const _ConfirmDialog({
    this.title,
    this.message,
    this.okLabel,
    this.cancelLabel,
    this.onOk,
    this.onCancel,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            if (message != null && message!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  message!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _OutlineButton(
                    label: cancelLabel ?? '取消',
                    onTap: () {
                      Navigator.pop(context);
                      onCancel?.call();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: isDestructive
                      ? _DestructiveButton(
                          label: okLabel ?? '确认',
                          onTap: () {
                            Navigator.pop(context);
                            onOk?.call();
                          },
                        )
                      : _GradientButton(
                          label: okLabel ?? '确认',
                          onTap: () {
                            Navigator.pop(context);
                            onOk?.call();
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 底部菜单项
class BottomSheetItem<T> {
  final String label;
  final IconData? icon;
  final T? value;
  final Color? textColor;
  final VoidCallback? onTap;

  const BottomSheetItem({
    required this.label,
    this.icon,
    this.value,
    this.textColor,
    this.onTap,
  });
}

/// 底部菜单组件
class _BottomSheetMenu<T> extends StatelessWidget {
  final List<BottomSheetItem<T>> items;
  final String? title;
  final bool showCancel;
  final String cancelLabel;

  const _BottomSheetMenu({
    required this.items,
    this.title,
    required this.showCancel,
    required this.cancelLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 菜单区域
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      title!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isLast = index == items.length - 1;

                  return Column(
                    children: [
                      ListTile(
                        leading: item.icon != null
                            ? Icon(item.icon, color: item.textColor ?? AppColors.textPrimary)
                            : null,
                        title: Text(
                          item.label,
                          style: TextStyle(
                            color: item.textColor ?? AppColors.textPrimary,
                            fontSize: 16,
                          ),
                          textAlign: item.icon != null ? TextAlign.left : TextAlign.center,
                        ),
                        onTap: () {
                          Navigator.pop(context, item.value);
                          item.onTap?.call();
                        },
                      ),
                      if (!isLast)
                        Divider(
                          height: 1,
                          indent: item.icon != null ? 56 : 16,
                          endIndent: 16,
                          color: AppColors.divider,
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
          // 取消按钮
          if (showCancel)
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  cancelLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 顶部图片弹窗组件
class _TopImageDialog extends StatelessWidget {
  final String imagePath;
  final String message;
  final String buttonText;
  final VoidCallback onTap;

  const _TopImageDialog({
    required this.imagePath,
    required this.message,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 296,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE6FFF9),
                Colors.white,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 图片区域（突破效果）
              Transform.translate(
                offset: const Offset(0, -40),
                child: Image.asset(
                  imagePath,
                  width: 158,
                  height: 105,
                  fit: BoxFit.contain,
                ),
              ),
              // 文案
              Transform.translate(
                offset: const Offset(0, -20),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
              // 按钮
              Transform.translate(
                offset: const Offset(0, 0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onTap();
                    },
                    child: Container(
                      width: 112,
                      height: 35,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6EEB7E),
                            Color(0xFF82EBCD),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          color: Color(0xFF1B1B1B),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 渐变按钮
class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double? width;
  final EdgeInsets? padding;

  const _GradientButton({
    required this.label,
    required this.onTap,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: width == double.infinity ? Alignment.center : null,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// 描边按钮
class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// 危险操作按钮
class _DestructiveButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DestructiveButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
