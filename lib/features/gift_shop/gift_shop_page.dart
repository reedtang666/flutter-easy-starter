import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/utils/dialog_utils.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

/// 礼物模型 - 使用图标和渐变代替 emoji
class GiftItem {
  final String id;
  final String name;
  final IconData icon;
  final List<Color> gradient;
  final int coins;
  final String category;

  GiftItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.gradient,
    required this.coins,
    required this.category,
  });
}

/// 礼物分类
final List<String> categories = ['全部', '鲜花', '珠宝', '浪漫', '可爱'];

/// 礼物数据 - 精美的渐变图标
final List<GiftItem> giftItems = [
  // 鲜花 - 粉色系渐变
  GiftItem(
    id: '1',
    name: '玫瑰',
    icon: LucideIcons.flower_2,
    gradient: const [Color(0xFFFF2D55), Color(0xFFFF6B6B)],
    coins: 10,
    category: '鲜花',
  ),
  GiftItem(
    id: '2',
    name: '郁金香',
    icon: LucideIcons.flower,
    gradient: const [Color(0xFFFF6B9D), Color(0xFFFF8E8E)],
    coins: 8,
    category: '鲜花',
  ),
  GiftItem(
    id: '3',
    name: '向日葵',
    icon: LucideIcons.sun,
    gradient: const [Color(0xFFFFB800), Color(0xFFFFD93D)],
    coins: 8,
    category: '鲜花',
  ),
  GiftItem(
    id: '4',
    name: '花束',
    icon: LucideIcons.sparkles,
    gradient: const [Color(0xFFE85D75), Color(0xFFF093FB)],
    coins: 50,
    category: '鲜花',
  ),
  GiftItem(
    id: '5',
    name: '樱花',
    icon: LucideIcons.cherry,
    gradient: const [Color(0xFFFFB7C5), Color(0xFFFFE4E1)],
    coins: 15,
    category: '鲜花',
  ),

  // 珠宝 - 奢华金色系
  GiftItem(
    id: '6',
    name: '钻戒',
    icon: LucideIcons.gem,
    gradient: const [Color(0xFF00D2FF), Color(0xFF3A7BD5)],
    coins: 500,
    category: '珠宝',
  ),
  GiftItem(
    id: '7',
    name: '项链',
    icon: LucideIcons.link,
    gradient: const [Color(0xFFFFD700), Color(0xFFFFAA00)],
    coins: 200,
    category: '珠宝',
  ),
  GiftItem(
    id: '8',
    name: '皇冠',
    icon: LucideIcons.crown,
    gradient: const [Color(0xFFFFD700), Color(0xFFFFB800)],
    coins: 300,
    category: '珠宝',
  ),
  GiftItem(
    id: '9',
    name: '钻石',
    icon: LucideIcons.diamond,
    gradient: const [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    coins: 400,
    category: '珠宝',
  ),
  GiftItem(
    id: '10',
    name: '珍珠',
    icon: LucideIcons.circle,
    gradient: const [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
    coins: 150,
    category: '珠宝',
  ),

  // 浪漫 - 红色爱心系
  GiftItem(
    id: '11',
    name: '爱心',
    icon: LucideIcons.heart,
    gradient: const [Color(0xFFFF2D55), Color(0xFFFF5E3A)],
    coins: 5,
    category: '浪漫',
  ),
  GiftItem(
    id: '12',
    name: '情书',
    icon: LucideIcons.mail,
    gradient: const [Color(0xFFFF6B9D), Color(0xFFFF8E72)],
    coins: 20,
    category: '浪漫',
  ),
  GiftItem(
    id: '13',
    name: '亲吻',
    icon: LucideIcons.smile,
    gradient: const [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    coins: 30,
    category: '浪漫',
  ),
  GiftItem(
    id: '14',
    name: '爱心礼盒',
    icon: LucideIcons.gift,
    gradient: const [Color(0xFFFF2D55), Color(0xFFAF52DE)],
    coins: 100,
    category: '浪漫',
  ),
  GiftItem(
    id: '15',
    name: '双人舞',
    icon: LucideIcons.users,
    gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
    coins: 80,
    category: '浪漫',
  ),

  // 可爱 - 彩色萌系
  GiftItem(
    id: '16',
    name: '小熊',
    icon: LucideIcons.paw_print,
    gradient: const [Color(0xFFFFA07A), Color(0xFFFFCBA4)],
    coins: 50,
    category: '可爱',
  ),
  GiftItem(
    id: '17',
    name: '气球',
    icon: LucideIcons.cloud,
    gradient: const [Color(0xFF00C9FF), Color(0xFF92FE9D)],
    coins: 15,
    category: '可爱',
  ),
  GiftItem(
    id: '18',
    name: '蛋糕',
    icon: LucideIcons.cake,
    gradient: const [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
    coins: 40,
    category: '可爱',
  ),
  GiftItem(
    id: '19',
    name: '星星',
    icon: LucideIcons.star,
    gradient: const [Color(0xFFFFD700), Color(0xFFFFA500)],
    coins: 10,
    category: '可爱',
  ),
  GiftItem(
    id: '20',
    name: '彩虹',
    icon: LucideIcons.rainbow,
    gradient: const [Color(0xFF00F260), Color(0xFF0575E6)],
    coins: 25,
    category: '可爱',
  ),
];

/// 礼物商城页 - 精美渐变图标 + 微交互动画
class GiftShopPage extends StatefulWidget {
  const GiftShopPage({super.key});

  @override
  State<GiftShopPage> createState() => _GiftShopPageState();
}

class _GiftShopPageState extends State<GiftShopPage>
    with TickerProviderStateMixin {
  int _selectedCategory = 0;
  int _selectedQuantity = 1;
  String? _selectedGiftId;
  int _coins = 1250;
  bool _isLoading = true;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  List<GiftItem> get filteredGifts {
    if (_selectedCategory == 0) return giftItems;
    return giftItems.where((g) => g.category == categories[_selectedCategory]).toList();
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // 模拟加载
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('礼物商城'),
        centerTitle: true,
        actions: [
          // 金币显示 - 带动画
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                margin: EdgeInsets.only(right: 16.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.yellow.withValues(alpha: 0.2),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.coins,
                      color: AppColors.yellow,
                      size: 18.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '$_coins',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 分类选择
            _buildCategorySelector(),

            // 礼物网格
            Expanded(
              child: _isLoading ? _buildSkeletonGrid() : _buildGiftGrid(),
            ),

            // 底部操作栏
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 48.w,
      margin: EdgeInsets.symmetric(vertical: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(right: 8.w),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _selectedCategory = index),
                borderRadius: BorderRadius.circular(8.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.lightGrey,
                        fontSize: 14.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.w,
        crossAxisSpacing: 8.w,
        childAspectRatio: 1.0,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.surface,
          highlightColor: AppColors.tertiaryGrey,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGiftGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.w,
        crossAxisSpacing: 8.w,
        childAspectRatio: 1.0,
      ),
      itemCount: filteredGifts.length,
      itemBuilder: (context, index) {
        final gift = filteredGifts[index];
        final isSelected = _selectedGiftId == gift.id;

        return AnimatedScale(
          scale: isSelected ? 1.0 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() => _selectedGiftId = gift.id);
                if (isSelected) {
                  _pulseController.forward().then((_) => _pulseController.reverse());
                }
              },
              borderRadius: BorderRadius.circular(12.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected ? gift.gradient[0] : Colors.transparent,
                    width: isSelected ? 2.w : 0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: gift.gradient[0].withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 礼物图标 - 渐变圆形背景
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gift.gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: gift.gradient[0].withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Icon(
                        gift.icon,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(height: 8.w),
                    // 礼物名称
                    Text(
                      gift.name,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.w),
                    // 价格
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.coins,
                          color: AppColors.yellow,
                          size: 12.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${gift.coins}',
                          style: TextStyle(
                            color: isSelected ? gift.gradient[0] : AppColors.lightGrey,
                            fontSize: 12.sp,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    final selectedGift = giftItems.firstWhere(
      (g) => g.id == _selectedGiftId,
      orElse: () => GiftItem(
        id: '',
        name: '',
        icon: LucideIcons.gift,
        gradient: [AppColors.tertiaryGrey, AppColors.tertiaryGrey],
        coins: 0,
        category: '',
      ),
    );

    final totalCost = selectedGift.coins * _selectedQuantity;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 选中礼物预览
            if (_selectedGiftId != null)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(bottom: 16.w),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: selectedGift.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        selectedGift.icon,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedGift.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '单价: ${selectedGift.coins} 金币',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // 选择数量
            if (_selectedGiftId != null)
              Container(
                margin: EdgeInsets.only(bottom: 16.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildQuantityButton(
                      icon: LucideIcons.minus,
                      onTap: _selectedQuantity > 1
                          ? () => setState(() => _selectedQuantity--)
                          : null,
                      isActive: _selectedQuantity > 1,
                    ),
                    SizedBox(width: 24.w),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        '$_selectedQuantity',
                        key: ValueKey<int>(_selectedQuantity),
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 24.w),
                    _buildQuantityButton(
                      icon: LucideIcons.plus,
                      onTap: () => setState(() => _selectedQuantity++),
                      isActive: true,
                      gradient: selectedGift.gradient,
                    ),
                  ],
                ),
              ),

            // 赠送按钮
            Row(
              children: [
                // 取消按钮
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            '取消',
                            style: TextStyle(
                              color: AppColors.lightGrey,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // 赠送按钮
                Expanded(
                  flex: 2,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _selectedGiftId == null
                            ? null
                            : () {
                                if (_coins < totalCost) {
                                  DialogUtils.showError(
                                    context,
                                    message: '金币不足，请先充值',
                                  );
                                  return;
                                }
                                setState(() {
                                  _coins -= totalCost;
                                });
                                DialogUtils.showSuccess(
                                  context,
                                  title: '赠送成功',
                                  message: '已送出 ${selectedGift.name} x$_selectedQuantity',
                                );
                                Future.delayed(const Duration(seconds: 1), () {
                                  if (mounted) context.pop();
                                });
                              },
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          height: 48.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _selectedGiftId == null
                                  ? [AppColors.tertiaryGrey, AppColors.tertiaryGrey]
                                  : selectedGift.gradient,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: _selectedGiftId == null
                                ? null
                                : [
                                    BoxShadow(
                                      color: selectedGift.gradient[0]
                                          .withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      spreadRadius: 0,
                                    ),
                                  ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_selectedGiftId != null)
                                  Icon(
                                    selectedGift.icon,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                SizedBox(width: 8.w),
                                Text(
                                  _selectedGiftId == null
                                      ? '选择礼物'
                                      : '赠送 ($totalCost)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool isActive,
    List<Color>? gradient,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            gradient: isActive && gradient != null
                ? LinearGradient(colors: gradient)
                : null,
            color: isActive && gradient == null ? AppColors.primary : AppColors.tertiaryGrey,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18.sp,
          ),
        ),
      ),
    );
  }
}
