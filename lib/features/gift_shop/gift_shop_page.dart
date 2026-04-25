import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/utils/dialog_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 礼物模型
class GiftItem {
  final String id;
  final String name;
  final String emoji;
  final int coins;
  final String category;

  GiftItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.coins,
    required this.category,
  });
}

/// 礼物分类
final List<String> categories = ['全部', '鲜花', '珠宝', '浪漫', '可爱'];

/// 礼物数据
final List<GiftItem> giftItems = [
  // 鲜花
  GiftItem(id: '1', name: '玫瑰', emoji: '🌹', coins: 10, category: '鲜花'),
  GiftItem(id: '2', name: '郁金香', emoji: '🌷', coins: 8, category: '鲜花'),
  GiftItem(id: '3', name: '向日葵', emoji: '🌻', coins: 8, category: '鲜花'),
  GiftItem(id: '4', name: '花束', emoji: '💐', coins: 50, category: '鲜花'),
  GiftItem(id: '5', name: '樱花', emoji: '🌸', coins: 15, category: '鲜花'),

  // 珠宝
  GiftItem(id: '6', name: '钻戒', emoji: '💍', coins: 500, category: '珠宝'),
  GiftItem(id: '7', name: '项链', emoji: '📿', coins: 200, category: '珠宝'),
  GiftItem(id: '8', name: '皇冠', emoji: '👑', coins: 300, category: '珠宝'),
  GiftItem(id: '9', name: '钻石', emoji: '💎', coins: 400, category: '珠宝'),
  GiftItem(id: '10', name: '珍珠', emoji: '⚪', coins: 150, category: '珠宝'),

  // 浪漫
  GiftItem(id: '11', name: '爱心', emoji: '❤️', coins: 5, category: '浪漫'),
  GiftItem(id: '12', name: '情书', emoji: '💌', coins: 20, category: '浪漫'),
  GiftItem(id: '13', name: '亲吻', emoji: '💋', coins: 30, category: '浪漫'),
  GiftItem(id: '14', name: '爱心礼盒', emoji: '💝', coins: 100, category: '浪漫'),
  GiftItem(id: '15', name: '双人舞', emoji: '💃', coins: 80, category: '浪漫'),

  // 可爱
  GiftItem(id: '16', name: '小熊', emoji: '🧸', coins: 50, category: '可爱'),
  GiftItem(id: '17', name: '气球', emoji: '🎈', coins: 15, category: '可爱'),
  GiftItem(id: '18', name: '蛋糕', emoji: '🎂', coins: 40, category: '可爱'),
  GiftItem(id: '19', name: '星星', emoji: '⭐', coins: 10, category: '可爱'),
  GiftItem(id: '20', name: '彩虹', emoji: '🌈', coins: 25, category: '可爱'),
];

/// 礼物商城页 - 融合 sunglasses ProductDetails 风格
class GiftShopPage extends StatefulWidget {
  const GiftShopPage({super.key});

  @override
  State<GiftShopPage> createState() => _GiftShopPageState();
}

class _GiftShopPageState extends State<GiftShopPage> {
  int _selectedCategory = 0;
  int _selectedQuantity = 1;
  String? _selectedGiftId;
  int _coins = 1250; // 用户金币

  List<GiftItem> get filteredGifts {
    if (_selectedCategory == 0) return giftItems;
    return giftItems.where((g) => g.category == categories[_selectedCategory]).toList();
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
          // 金币显示
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.monetization_on,
                  color: Colors.amber,
                  size: 18,
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
              child: _buildGiftGrid(),
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
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(8.r),
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
          );
        },
      ),
    );
  }

  Widget _buildGiftGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: filteredGifts.length,
      itemBuilder: (context, index) {
        final gift = filteredGifts[index];
        final isSelected = _selectedGiftId == gift.id;

        return GestureDetector(
          onTap: () {
            setState(() => _selectedGiftId = gift.id);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: isSelected ? 2 : 0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 礼物图标 - 纯emoji无背景
                Text(
                  gift.emoji,
                  style: TextStyle(fontSize: 36.sp),
                ),
                SizedBox(height: 6.w),
                // 礼物名称
                Text(
                  gift.name,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 3.w),
                // 价格
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 12,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${gift.coins}',
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.lightGrey,
                        fontSize: 12.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    final selectedGift = giftItems.firstWhere(
      (g) => g.id == _selectedGiftId,
      orElse: () => GiftItem(id: '', name: '', emoji: '', coins: 0, category: ''),
    );

    final totalCost = selectedGift.coins * _selectedQuantity;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 选择数量
            if (_selectedGiftId != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _selectedQuantity > 1
                        ? () => setState(() => _selectedQuantity--)
                        : null,
                    icon: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    '$_selectedQuantity',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  IconButton(
                    onPressed: () => setState(() => _selectedQuantity++),
                    icon: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

            SizedBox(height: 12.w),

            // 赠送按钮
            Row(
              children: [
                // 取消按钮
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10.r),
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

                SizedBox(width: 12.w),

                // 赠送按钮
                Expanded(
                  flex: 2,
                  child: GestureDetector(
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
                    child: Container(
                      height: 48.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _selectedGiftId == null
                              ? [AppColors.tertiaryGrey, AppColors.tertiaryGrey]
                              : [
                                  AppColors.primary,
                                  AppColors.primary.withValues(alpha: 0.8),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: _selectedGiftId == null
                            ? null
                            : [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                ),
                              ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_selectedGiftId != null)
                              Text(
                                selectedGift.emoji,
                                style: TextStyle(fontSize: 20.sp),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
