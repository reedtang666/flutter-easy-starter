import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/constants/storage_keys.dart';
import 'package:flutter_easy_starter/core/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 主题模式状态
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    _loadThemeMode();
  }

  /// 加载保存的主题模式
  void _loadThemeMode() {
    final mode = StorageService.instance.getInt(StorageKeys.themeMode);
    if (mode >= 0 && mode < ThemeMode.values.length) {
      state = ThemeMode.values[mode];
    }
  }

  /// 切换主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    await StorageService.instance.setInt(StorageKeys.themeMode, mode.index);
    state = mode;
  }

  /// 切换亮/暗模式
  Future<void> toggle() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }
}
