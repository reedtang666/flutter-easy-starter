import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/utils/dialog_utils.dart';
import 'package:flutter_easy_starter/core/widgets/animated_button.dart';
import 'package:flutter_easy_starter/core/widgets/shimmer_widgets.dart';
import 'package:flutter_easy_starter/features/travel/widgets/frosted_widget.dart' show FrostedWidget;
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// VIP会员权益
class VipBenefit {
  final IconData icon;
  final List<Color> gradient;
  final String title;
  final String subtitle;

  const VipBenefit({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
  });
}

final List<VipBenefit> benefits = [
  const VipBenefit(
    icon: LucideIcons.heart,
    gradient: [Color(0xFFFF2D55), Color(0xFFFF6B6B)],
    title: '无限喜欢',
    subtitle: '每天无限次右滑喜欢',
  ),
  const VipBenefit(
    icon: LucideIcons.message_circle,
    gradient: [Color(0xFFAF52DE), Color(0xFFBF5AF2)],
    title: '优先聊天',
    subtitle: '消息优先展示给对方',
  ),
  const VipBenefit(
    icon: LucideIcons.eye,
    gradient: [Color(0xFF5AC8FA), Color(0xFF007AFF)],
    title: '谁看过我',
    subtitle: '查看谁浏览了你的资料',
  ),
  const VipBenefit(
    icon: LucideIcons.rotate_ccw,
    gradient: [Color(0xFF34C759), Color(0xFF30D158)],
    title: '撤销操作',
    subtitle: '反悔左滑，重新选择',
  ),
  const VipBenefit(
    icon: LucideIcons.sparkles,
    gradient: [Color(0xFFFF9500), Color(0xFFFFB800)],
    title: '超级曝光',
    subtitle: '资料被更多人看到',
  ),
  const VipBenefit(
    icon: LucideIcons.crown,
    gradient: [Color(0xFFFFD700), Color(0xFFFFA500)],
    title: 'VIP标识',
    subtitle: '专属身份标识',
  ),
];

/// VIP套餐
class VipPackage {
  final String duration;
  final String price;
  final String? originalPrice;
  final bool isRecommended;
  final String dailyPrice;

  const VipPackage({
    required this.duration,
    required this.price,
    required this.dailyPrice,
    this.originalPrice,
    this.isRecommended = false,
  });
}

final List<VipPackage> packages = [
  const VipPackage(
    duration: '1个月',
    price: '¥68',
    dailyPrice: '¥2.3/天',
  ),
  const VipPackage(
    duration: '3个月',
    price: '¥168',
    originalPrice: '¥204',
    dailyPrice: '¥1.9/天',
    isRecommended: true,
  ),
  const VipPackage(
    duration: '12个月',
    price: '¥488',
    originalPrice: '¥816',
    dailyPrice: '¥1.3/天',
  ),
];

/// VIP会员页 - 完整动画增强版
class VipPage extends StatefulWidget {
  const VipPage({super.key});

  @override
  State<VipPage> createState() => _VipPageState();
}

class _VipPageState extends State<VipPage>
    with SingleTickerProviderStateMixin {
  int _selectedPackage = 1;
  bool _isLoading = true;
  bool _isPurchasing = false;

  late AnimationController _crownController;

  @override
  void initState() {
    super.initState();
    _crownController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // 模拟加载
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void dispose() {
    _crownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 顶部渐变背景
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),

          // 权益列表
          if (_isLoading)
            SliverPadding(
              padding: EdgeInsets.all(16.w),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12.w,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.9,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ShimmerContainer(
                    borderRadius: 12,
                  ),
                  childCount: 6,
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.all(16.w),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12.w,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => StaggeredAnimation(
                    index: index,
                    type: AnimationType.scale,
                    child: _buildBenefitCard(benefits[index]),
                  ),
                  childCount: benefits.length,
                ),
              ),
            ),

          // 套餐选择
          SliverToBoxAdapter(
            child: _isLoading
                ? _buildPackageShimmer()
                : StaggeredAnimation(
                    index: 6,
                    child: _buildPackages(),
                  ),
          ),

          // 底部按钮
          SliverToBoxAdapter(
            child: _isLoading
                ? _buildButtonShimmer()
                : StaggeredAnimation(
                    index: 7,
                    child: _buildBottomButton(),
                  ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: 32.w),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 50.w, 20.w, 24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.25),
            AppColors.background,
          ],
        ),
      ),
      child: Column(
        children: [
          // 返回按钮
          Align(
            alignment: Alignment.topLeft,
            child: AnimatedButton(
              onTap: () => context.pop(),
              scaleDown: 0.9,
              child: FrostedWidget(
                borderRadius: 12,
                blurSigma: 10,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    LucideIcons.arrow_left,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 24.w),

          // VIP Crown 带动画
          PulseAnimation(
            duration: const Duration(milliseconds: 2000),
            minScale: 1.0,
            maxScale: 1.05,
            child: Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFD700),
                    Color(0xFFFFA500),
                    Color(0xFFFF8C00),
                  ],
                ),
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: AppShadows.goldGlow(opacity: 0.5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 旋转光效
                  AnimatedBuilder(
                    animation: _crownController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _crownController.value * 2 * 3.14159,
                        child: Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: BoxDecoration(
                            gradient: SweepGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: 0.3),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(35.r),
                          ),
                        ),
                      );
                    },
                  ),
                  Icon(
                    LucideIcons.crown,
                    size: 44.w,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.w),

          // VIP标题
          ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ).createShader(bounds);
            },
            child: Text(
              '升级 VIP 会员',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(height: 8.w),

          Text(
            '解锁所有特权，享受尊贵体验',
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitCard(VipBenefit benefit) {
    return AnimatedGlowCard(
      onTap: () {
        HapticFeedback.selectionClick();
        DialogUtils.showInfo(
          context,
          title: benefit.title,
          message: benefit.subtitle,
        );
      },
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 渐变图标
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: benefit.gradient,
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: benefit.gradient.first.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                benefit.icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            SizedBox(height: 10.w),
            Text(
              benefit.title,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.w),
            Text(
              benefit.subtitle,
              style: TextStyle(
                color: AppColors.lightGrey,
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageShimmer() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerText(width: 80, height: 20),
          SizedBox(height: 12.w),
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: index > 0 ? 8.w : 0),
                  child: ShimmerContainer(
                    height: 120,
                    borderRadius: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonShimmer() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: ShimmerContainer(
        height: 52,
        borderRadius: 12,
      ),
    );
  }

  Widget _buildPackages() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '选择套餐',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.w),
          Row(
            children: List.generate(
              packages.length,
              (index) => Expanded(
                child: AnimatedPackageCard(
                  package: packages[index],
                  isSelected: _selectedPackage == index,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    setState(() => _selectedPackage = index);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          AnimatedButton(
            onTap: _isPurchasing ? null : _handlePurchase,
            scaleDown: 0.96,
            hapticType: HapticFeedbackType.medium,
            enableRipple: false,
            child: Container(
              height: 52.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFD700),
                    Color(0xFFFFA500),
                    Color(0xFFFF8C00),
                  ],
                ),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: AppShadows.goldGlow(opacity: 0.5),
              ),
              child: Center(
                child: _isPurchasing
                    ? SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.crown,
                            color: Colors.white,
                            size: 22,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            '立即开通 ${packages[_selectedPackage].price}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          SizedBox(height: 12.w),
          Text(
            '开通即表示同意《VIP服务协议》',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.tertiaryGrey,
            ),
          ),
          SizedBox(height: 8.w),
          // 安全支付标识
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.shield_check,
                size: 14,
                color: AppColors.green,
              ),
              SizedBox(width: 4.w),
              Text(
                '安全支付 · 随时取消',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.lightGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handlePurchase() async {
    setState(() => _isPurchasing = true);

    // 模拟购买处理
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isPurchasing = false);
      DialogUtils.showSuccess(
        context,
        message: '支付功能开发中，敬请期待！',
      );
    }
  }
}

/// 带动画的套餐卡片
class AnimatedPackageCard extends StatefulWidget {
  final VipPackage package;
  final bool isSelected;
  final VoidCallback onTap;

  const AnimatedPackageCard({
    super.key,
    required this.package,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<AnimatedPackageCard> createState() => _AnimatedPackageCardState();
}

class _AnimatedPackageCardState extends State<AnimatedPackageCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.3, end: 0.6),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.6, end: 0.3),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isSelected) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedPackageCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.repeat();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: widget.onTap,
      scaleDown: 0.95,
      enableHaptic: true,
      hapticType: HapticFeedbackType.light,
      enableRipple: false,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return AnimatedContainer(
            duration: AppDurations.normal,
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(
              left: widget.package.duration == '1个月' ? 0 : 8.w,
            ),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              gradient: widget.isSelected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0x20FFD700),
                        Color(0x10FFA500),
                      ],
                    )
                  : null,
              color: widget.isSelected ? null : AppColors.surface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: widget.isSelected
                    ? const Color(0xFFFFD700)
                    : Colors.white.withValues(alpha: 0.05),
                width: widget.isSelected ? 2.w : 1.w,
              ),
              boxShadow: widget.isSelected
                  ? [
                      BoxShadow(
                        color: Color(0xFFFFD700).withValues(alpha: 
                          widget.package.isRecommended
                              ? _glowAnimation.value
                              : 0.3,
                        ),
                        blurRadius: widget.package.isRecommended ? 16 : 10,
                        spreadRadius: widget.package.isRecommended ? 2 : 0,
                      ),
                    ]
                  : null,
            ),
            child: child,
          );
        },
        child: Column(
          children: [
            if (widget.package.isRecommended)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 3.w,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFD700),
                      Color(0xFFFFA500),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.sparkles,
                      size: 10,
                      color: Colors.white,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      '推荐',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            if (!widget.package.isRecommended) SizedBox(height: 18.w),
            SizedBox(height: 10.w),
            Text(
              widget.package.duration,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.w),
            Text(
              widget.package.price,
              style: TextStyle(
                color: widget.isSelected
                    ? const Color(0xFFFFD700)
                    : AppColors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6.w),
            Text(
              widget.package.dailyPrice,
              style: TextStyle(
                color: AppColors.lightGrey,
                fontSize: 11.sp,
              ),
            ),
            if (widget.package.originalPrice != null) ...[
              SizedBox(height: 6.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 2.w,
                ),
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '省${(int.parse(widget.package.originalPrice!.replaceAll(RegExp(r'[^0-9]'), '')) - int.parse(widget.package.price.replaceAll(RegExp(r'[^0-9]'), '')))}元',
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
