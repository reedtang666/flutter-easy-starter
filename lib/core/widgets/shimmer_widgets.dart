import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer 骨架屏容器
class ShimmerContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final Color? baseColor;
  final Color? highlightColor;
  final Widget? child;

  const ShimmerContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.margin,
    this.baseColor,
    this.highlightColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.surface,
      highlightColor: highlightColor ?? AppColors.surfaceVariant,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        child: child,
      ),
    );
  }
}

/// 列表骨架屏
class ShimmerList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry padding;
  final bool hasImage;
  final bool hasSubtitle;

  const ShimmerList({
    super.key,
    this.itemCount = 6,
    this.itemHeight = 80,
    this.padding = EdgeInsets.zero,
    this.hasImage = true,
    this.hasSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: List.generate(
          itemCount,
          (index) => _buildShimmerItem(),
        ),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      height: itemHeight.w,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
      child: Row(
        children: [
          if (hasImage)
            ShimmerContainer(
              width: 60.w,
              height: 60.w,
              borderRadius: 12,
            ),
          if (hasImage) SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShimmerContainer(
                  width: double.infinity,
                  height: 16.w,
                  borderRadius: 4,
                ),
                SizedBox(height: 8.w),
                if (hasSubtitle)
                  ShimmerContainer(
                    width: 120.w,
                    height: 12.w,
                    borderRadius: 4,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 网格骨架屏
class ShimmerGrid extends StatelessWidget {
  final int crossAxisCount;
  final int itemCount;
  final double childAspectRatio;
  final EdgeInsetsGeometry padding;

  const ShimmerGrid({
    super.key,
    this.crossAxisCount = 2,
    this.itemCount = 6,
    this.childAspectRatio = 1.0,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12.w,
          crossAxisSpacing: 12.w,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return ShimmerContainer(
            borderRadius: 16,
          );
        },
      ),
    );
  }
}

/// 卡片骨架屏
class ShimmerCard extends StatelessWidget {
  final double? height;
  final EdgeInsetsGeometry margin;

  const ShimmerCard({
    super.key,
    this.height,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerContainer(
      width: double.infinity,
      height: height ?? 120.w,
      borderRadius: 16,
      margin: margin,
    );
  }
}

/// 圆形骨架屏（头像等）
class ShimmerCircle extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;

  const ShimmerCircle({
    super.key,
    this.size = 60,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceVariant,
      child: Container(
        width: size.w,
        height: size.w,
        margin: margin,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// 文字骨架屏
class ShimmerText extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerText({
    super.key,
    this.width = 100,
    this.height = 16,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerContainer(
      width: width.w,
      height: height.w,
      borderRadius: borderRadius,
    );
  }
}
