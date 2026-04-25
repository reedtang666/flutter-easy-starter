import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';

/// Dark Social 主题配置
///
/// 特点：
/// - 纯黑背景
/// - 高对比度白色文字
/// - 紫色强调色
/// - 半透明玻璃效果
/// - iOS 风格
class AppTheme {
  AppTheme._();

  static ThemeData get dark => _darkTheme;

  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // === 颜色方案 ===
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.pink,
      onSecondary: AppColors.white,
      surface: AppColors.surface,
      onSurface: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      outline: AppColors.border,
      background: AppColors.background,
    ),

    // === 页面背景 ===
    scaffoldBackgroundColor: AppColors.background,

    // === AppBar ===
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        color: AppColors.white,
        fontSize: AppTypography.subtitle,
        fontWeight: AppTypography.semiBold,
        letterSpacing: -0.5,
      ),
      toolbarHeight: 56,
    ),

    // === 底部导航 ===
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.lightGrey,
      selectedLabelStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 11,
        fontWeight: AppTypography.medium,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 11,
        fontWeight: AppTypography.regular,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),

    // === 卡片 ===
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      margin: EdgeInsets.zero,
    ),

    // === ElevatedButton - 玻璃效果 ===
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.tertiaryGrey,
        disabledForegroundColor: AppColors.lightGrey,
        textStyle: const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: AppTypography.body,
          fontWeight: AppTypography.semiBold,
          letterSpacing: -0.2,
        ),
      ),
    ),

    // === OutlinedButton - 透明边框 ===
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        side: const BorderSide(color: AppColors.border, width: 1),
        foregroundColor: AppColors.white,
        textStyle: const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: AppTypography.body,
          fontWeight: AppTypography.semiBold,
          letterSpacing: -0.2,
        ),
      ),
    ),

    // === TextButton ===
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: AppTypography.body,
          fontWeight: AppTypography.medium,
        ),
      ),
    ),

    // === 输入框 - 半透明玻璃效果 ===
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.glassWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      hintStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        color: AppColors.lightGrey,
        fontSize: AppTypography.body,
        fontWeight: AppTypography.regular,
      ),
      labelStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        color: AppColors.lightGrey,
        fontSize: AppTypography.body,
        fontWeight: AppTypography.medium,
      ),
      errorStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        color: AppColors.error,
        fontSize: AppTypography.caption,
        fontWeight: AppTypography.medium,
      ),
      prefixIconColor: AppColors.lightGrey,
      suffixIconColor: AppColors.lightGrey,
    ),

    // === 文字主题 - 高对比度 ===
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 34,
        fontWeight: AppTypography.bold,
        color: AppColors.white,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 28,
        fontWeight: AppTypography.bold,
        color: AppColors.white,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 22,
        fontWeight: AppTypography.bold,
        color: AppColors.white,
        letterSpacing: -0.5,
      ),
      headlineLarge: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 28,
        fontWeight: AppTypography.bold,
        color: AppColors.white,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 22,
        fontWeight: AppTypography.bold,
        color: AppColors.white,
        letterSpacing: -0.5,
      ),
      headlineSmall: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 19,
        fontWeight: AppTypography.semiBold,
        color: AppColors.white,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 19,
        fontWeight: AppTypography.semiBold,
        color: AppColors.white,
        letterSpacing: -0.5,
      ),
      titleMedium: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 17,
        fontWeight: AppTypography.semiBold,
        color: AppColors.white,
        letterSpacing: -0.5,
      ),
      titleSmall: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 15,
        fontWeight: AppTypography.semiBold,
        color: AppColors.white,
        letterSpacing: -0.3,
      ),
      bodyLarge: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 17,
        fontWeight: AppTypography.regular,
        color: AppColors.white,
        letterSpacing: -0.3,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 15,
        fontWeight: AppTypography.regular,
        color: AppColors.lightGrey,
        letterSpacing: -0.2,
      ),
      bodySmall: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 13,
        fontWeight: AppTypography.regular,
        color: AppColors.lightGrey,
        letterSpacing: -0.1,
      ),
      labelLarge: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 15,
        fontWeight: AppTypography.medium,
        color: AppColors.white,
        letterSpacing: -0.2,
      ),
      labelMedium: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 13,
        fontWeight: AppTypography.medium,
        color: AppColors.lightGrey,
        letterSpacing: -0.1,
      ),
      labelSmall: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 11,
        fontWeight: AppTypography.medium,
        color: AppColors.lightGrey,
        letterSpacing: 0,
      ),
    ),

    // === 分隔线 ===
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 0.5,
      space: 1,
    ),

    // === 列表项 ===
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      minLeadingWidth: 40,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      iconColor: AppColors.lightGrey,
      textColor: AppColors.white,
      titleTextStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.bodyLarge,
        fontWeight: AppTypography.regular,
        color: AppColors.white,
        letterSpacing: -0.3,
      ),
      subtitleTextStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.body,
        fontWeight: AppTypography.regular,
        color: AppColors.lightGrey,
        letterSpacing: -0.2,
      ),
    ),

    // === 开关 - iOS 风格 ===
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.white;
        }
        return AppColors.lightGrey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.tertiaryGrey;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),

    // === 复选框 ===
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.white),
      side: const BorderSide(color: AppColors.border, width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    ),

    // === 单选框 ===
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.border;
      }),
    ),

    // === 底部弹窗 - 深灰背景 ===
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // === 对话框 - 深灰背景 ===
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      titleTextStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.headline,
        fontWeight: AppTypography.bold,
        color: AppColors.white,
        letterSpacing: -0.5,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.body,
        fontWeight: AppTypography.regular,
        color: AppColors.lightGrey,
        letterSpacing: -0.2,
      ),
    ),

    // === 浮动按钮 ===
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      extendedPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),

    // === TabBar ===
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.white,
      unselectedLabelColor: AppColors.lightGrey,
      labelStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.body,
        fontWeight: AppTypography.semiBold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.body,
        fontWeight: AppTypography.regular,
      ),
      indicatorColor: AppColors.white,
      dividerColor: AppColors.divider,
    ),

    // === Chip - 半透明 ===
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.primary,
      labelStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.body,
        fontWeight: AppTypography.medium,
        color: AppColors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        side: BorderSide.none,
      ),
    ),

    // === 进度指示器 ===
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearMinHeight: 3,
      linearTrackColor: AppColors.tertiaryGrey,
    ),

    // === 滚动条 ===
    scrollbarTheme: ScrollbarThemeData(
      thickness: WidgetStateProperty.all(3),
      thumbColor: WidgetStateProperty.all(AppColors.mediumGrey),
      radius: const Radius.circular(AppRadius.sm),
      minThumbLength: 40,
    ),

    // === SnackBar - 深灰 ===
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surface,
      contentTextStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.body,
        fontWeight: AppTypography.medium,
        color: AppColors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),

    // === 工具提示 ===
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      textStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: AppTypography.caption,
        fontWeight: AppTypography.medium,
        color: AppColors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // === 底部导航栏 ===
    bottomAppBarTheme: BottomAppBarThemeData(
      color: AppColors.background,
      elevation: 0,
    ),
  );
}
