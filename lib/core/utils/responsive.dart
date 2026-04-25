import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ============================================
/// Flutter 自适应尺寸工具
/// 基于 flutter_screenutil，以 375pt 宽度为基准
///
/// 使用说明：
/// 1. 在 Widget build 中直接使用扩展方法：
///    - 100.w  → 宽度适配
///    - 100.h  → 高度适配
///    - 100.sp → 字体大小适配
///    - 100.r  → 圆角适配
///
/// 2. 使用常量类（已适配）：
///    - Dimens.md, FontSizes.body, Spacing.height16
///
/// 3. 获取屏幕信息：
///    - ScreenUtil().screenWidth
///    - ScreenUtil().screenHeight
/// ============================================

/// 屏幕信息快捷访问
class ScreenInfo {
  ScreenInfo._();

  /// 屏幕宽度
  static double get width => ScreenUtil().screenWidth;

  /// 屏幕高度
  static double get height => ScreenUtil().screenHeight;

  /// 状态栏高度
  static double get statusBar => ScreenUtil().statusBarHeight;

  /// 底部安全区高度
  static double get bottomBar => ScreenUtil().bottomBarHeight;

  /// 是否平板（宽度 > 600）
  static bool get isTablet => width > 600.w;

  /// 是否横屏
  static bool get isLandscape => width > height;

  /// 短边长度（用于适配）
  static double get shortestSide =>
      width < height ? width : height;
}

/// 尺寸常量（自适应）
///
/// 使用方式：
/// ```dart
/// SizedBox(width: Dimens.md)
/// Container(height: Dimens.buttonLg)
/// ```
class Dimens {
  Dimens._();

  // ========== 基础间距 ==========
  /// 4px 间距
  static double get xs => 4.w;

  /// 8px 间距
  static double get sm => 8.w;

  /// 12px 间距
  static double get md => 12.w;

  /// 16px 间距
  static double get lg => 16.w;

  /// 20px 间距
  static double get xl => 20.w;

  /// 24px 间距
  static double get xxl => 24.w;

  /// 32px 间距
  static double get xxxl => 32.w;

  /// 48px 间距
  static double get xxxxl => 48.w;

  // ========== 快捷访问 ==========
  static double get spacing4 => xs;
  static double get spacing8 => sm;
  static double get spacing12 => md;
  static double get spacing16 => lg;
  static double get spacing20 => xl;
  static double get spacing24 => xxl;
  static double get spacing32 => xxxl;
  static double get spacing48 => xxxxl;

  // ========== 圆角 ==========
  static double get radiusXs => 2.r;
  static double get radiusSm => 4.r;
  static double get radiusMd => 8.r;
  static double get radiusLg => 12.r;
  static double get radiusXl => 16.r;
  static double get radiusXxl => 24.r;
  static double get radiusFull => 999.r;

  // ========== 边框 ==========
  static double get borderThin => 0.5.w;
  static double get border => 1.w;
  static double get borderThick => 2.w;

  // ========== 图标大小 ==========
  static double get iconXs => 12.w;
  static double get iconSm => 16.w;
  static double get iconMd => 20.w;
  static double get iconLg => 24.w;
  static double get iconXl => 32.w;
  static double get iconXxl => 48.w;

  // ========== 按钮高度 ==========
  static double get buttonSm => 32.w;
  static double get buttonMd => 40.w;
  static double get buttonLg => 48.w;
  static double get buttonXl => 56.w;

  // ========== 输入框 ==========
  static double get inputHeight => 48.w;

  // ========== 头像大小 ==========
  static double get avatarXs => 24.w;
  static double get avatarSm => 32.w;
  static double get avatarMd => 40.w;
  static double get avatarLg => 56.w;
  static double get avatarXl => 80.w;
  static double get avatarXxl => 120.w;

  // ========== EdgeInsets 快捷方式 ==========
  static EdgeInsets get pagePadding => EdgeInsets.all(lg);
  static EdgeInsets get pagePaddingHorizontal =>
      EdgeInsets.symmetric(horizontal: lg);
  static EdgeInsets get pagePaddingVertical =>
      EdgeInsets.symmetric(vertical: lg);
  static EdgeInsets get cardPadding => EdgeInsets.all(md);
}

/// 字体大小（自适应）
///
/// 使用方式：
/// ```dart
/// TextStyle(fontSize: FontSizes.body)
/// ```
class FontSizes {
  FontSizes._();

  // ========== 显示字体 ==========
  static double get display => 32.sp;
  static double get displaySm => 28.sp;

  // ========== 标题 ==========
  static double get h1 => 24.sp;
  static double get h2 => 20.sp;
  static double get h3 => 18.sp;
  static double get h4 => 16.sp;
  static double get h5 => 14.sp;

  // ========== 正文 ==========
  static double get bodyLg => 16.sp;
  static double get body => 14.sp;
  static double get bodySm => 12.sp;
  static double get bodyXs => 10.sp;

  // ========== 特殊 ==========
  static double get caption => 11.sp;
  static double get overline => 10.sp;
  static double get button => 14.sp;
}

/// 间距 Widget 快捷方式（自适应）
///
/// 使用方式：
/// ```dart
/// Spacing.height16  // 16px 高度间距
/// Spacing.width8    // 8px 宽度间距
/// ```
class Spacing {
  Spacing._();

  // ========== 水平间距 ==========
  static Widget get width4 => SizedBox(width: Dimens.xs);
  static Widget get width8 => SizedBox(width: Dimens.sm);
  static Widget get width12 => SizedBox(width: Dimens.md);
  static Widget get width16 => SizedBox(width: Dimens.lg);
  static Widget get width20 => SizedBox(width: Dimens.xl);
  static Widget get width24 => SizedBox(width: Dimens.xxl);

  // ========== 垂直间距 ==========
  static Widget get height4 => SizedBox(height: Dimens.xs);
  static Widget get height8 => SizedBox(height: Dimens.sm);
  static Widget get height12 => SizedBox(height: Dimens.md);
  static Widget get height16 => SizedBox(height: Dimens.lg);
  static Widget get height20 => SizedBox(height: Dimens.xl);
  static Widget get height24 => SizedBox(height: Dimens.xxl);
  static Widget get height32 => SizedBox(height: Dimens.xxxl);
  static Widget get height48 => SizedBox(height: Dimens.xxxxl);

  // ========== 弹性组件 ==========
  static Widget get expand => const Expanded(child: SizedBox.shrink());
  static Widget get spacer => const Spacer();

  // ========== 自定义 ==========
  static Widget width(double value) => SizedBox(width: value.w);
  static Widget height(double value) => SizedBox(height: value.w);
  static Widget size(double value) => SizedBox(width: value.w, height: value.w);
}

/// 网格列数计算工具
///
/// 使用方式：
/// ```dart
/// crossAxisCount: GridColumns.adaptive(itemWidth: 100)
/// ```
class GridColumns {
  GridColumns._();

  /// 根据屏幕宽度自动计算列数
  static int adaptive({
    required double itemWidth,
    int minCount = 2,
    int maxCount = 6,
    double spacing = 0,
  }) {
    final availableWidth = ScreenInfo.width - (spacing * (minCount - 1));
    final count = (availableWidth / itemWidth).floor();
    return count.clamp(minCount, maxCount);
  }

  /// 固定列数（根据屏幕类型）
  static int responsive({
    int phonePortrait = 2,
    int phoneLandscape = 4,
    int tabletPortrait = 4,
    int tabletLandscape = 6,
  }) {
    if (ScreenInfo.isTablet) {
      return ScreenInfo.isLandscape ? tabletLandscape : tabletPortrait;
    }
    return ScreenInfo.isLandscape ? phoneLandscape : phonePortrait;
  }

  /// 常用配置
  static int get two => 2;
  static int get three => 3;
  static int get four => 4;
}

/// 响应式断点
class Breakpoints {
  Breakpoints._();

  /// 手机竖屏 < 600
  static bool get isPhonePortrait => ScreenInfo.width < 600;

  /// 手机横屏 600-900
  static bool get isPhoneLandscape =>
      ScreenInfo.width >= 600 && ScreenInfo.width < 900;

  /// 平板 < 1200
  static bool get isTablet =>
      ScreenInfo.width >= 600 && ScreenInfo.width < 1200;

  /// 桌面 >= 1200
  static bool get isDesktop => ScreenInfo.width >= 1200;
}
