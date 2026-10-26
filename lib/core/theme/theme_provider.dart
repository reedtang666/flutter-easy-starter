import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/constants/storage_keys.dart';
import 'package:flutter_easy_starter/core/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 主题模式状态 Provider（基于现代 Riverpod Notifier 范式）
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // 默认使用深色主题（Dark Social 风格），若本地有保存则读取保存值
    final mode = StorageService.instance.getInt(
      StorageKeys.themeMode,
      defaultValue: ThemeMode.dark.index,
    );
    if (mode >= 0 && mode < ThemeMode.values.length) {
      return ThemeMode.values[mode];
    }
    return ThemeMode.dark;
  }

  /// 切换主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    await StorageService.instance.setInt(StorageKeys.themeMode, mode.index);
    state = mode;
  }

  /// 切换亮/暗模式
  Future<void> toggle() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}
