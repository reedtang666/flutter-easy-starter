import 'package:flutter/material.dart';

/// 底部操作菜单项数据类
class BottomSheetAction<T> {
  final String label;
  final T? value;
  final IconData? icon;
  final Color? iconColor;
  final bool isDestructive;
  final bool isBold;
  final bool isSelected;

  const BottomSheetAction({
    required this.label,
    this.value,
    this.icon,
    this.iconColor,
    this.isDestructive = false,
    this.isBold = false,
    this.isSelected = false,
  });
}

/// 选择弹窗项数据类
class SelectionItem<T> {
  final String label;
  final T value;
  final String? subtitle;
  final IconData? icon;

  const SelectionItem({
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
  });
}

/// 弹窗动画时长常量
class DialogDurations {
  static const Duration quick = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
}
