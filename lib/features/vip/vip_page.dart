import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/utils/dialog_utils.dart';
import 'package:go_router/go_router.dart';

/// VIP会员权益
class VipBenefit {
  final IconData icon;
  final String title;
  final String subtitle;

  const VipBenefit({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

final List<VipBenefit> benefits = [
  const VipBenefit(
    icon: Icons.favorite,
    title: '无限喜欢',
    subtitle: '每天无限次右滑喜欢',
  ),
  const VipBenefit(
    icon: Icons.chat_bubble,
    title: '优先聊天',
    subtitle: '消息优先展示给对方',
  ),
  const VipBenefit(
    icon: Icons.visibility,
    title: '谁看过我',
    subtitle: '查看谁浏览了你的资料',
  ),
  const VipBenefit(
    icon: Icons.undo,
    title: '撤销操作',
    subtitle: '反悔左滑，重新选择',
  ),
  const VipBenefit(
    icon: Icons.star,
    title: '超级曝光',
    subtitle: '资料被更多人看到',
  ),
  const VipBenefit(
    icon: Icons.verified,
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

  const VipPackage({
    required this.duration,
    required this.price,
    this.originalPrice,
    this.isRecommended = false,
  });
}

final List<VipPackage> packages = [
  const VipPackage(duration: '1个月', price: '¥68'),
  const VipPackage(
    duration: '3个月',
    price: '¥168',
    originalPrice: '¥204',
    isRecommended: true,
  ),
  const VipPackage(duration: '12个月', price: '¥488', originalPrice: '¥816'),
];

/// VIP会员页
class VipPage extends StatefulWidget {
  const VipPage({super.key});

  @override
  State<VipPage> createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> {
  int _selectedPackage = 1;

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
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildBenefitCard(benefits[index]),
                childCount: benefits.length,
              ),
            ),
          ),

          // 套餐选择
          SliverToBoxAdapter(
            child: _buildPackages(),
          ),

          // 底部按钮
          SliverToBoxAdapter(
            child: _buildBottomButton(),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.background,
          ],
        ),
      ),
      child: Column(
        children: [
          // 返回按钮
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // VIP标识
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFFD700),
                  const Color(0xFFFFA500),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.workspace_premium,
              size: 40,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            '升级 VIP 会员',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '解锁所有特权，享受尊贵体验',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitCard(VipBenefit benefit) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              benefit.icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            benefit.title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            benefit.subtitle,
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPackages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '选择套餐',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              packages.length,
              (index) => Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedPackage = index),
                  child: Container(
                    margin: EdgeInsets.only(
                      left: index > 0 ? 8 : 0,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _selectedPackage == index
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _selectedPackage == index
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        if (packages[index].isRecommended)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '推荐',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          packages[index].duration,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          packages[index].price,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (packages[index].originalPrice != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            packages[index].originalPrice!,
                            style: TextStyle(
                              color: AppColors.tertiaryGrey,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
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
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              DialogUtils.showInfo(
                context,
                message: '支付功能开发中...',
              );
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFD700),
                    const Color(0xFFFFA500),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFA500).withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.workspace_premium,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '立即开通 ${packages[_selectedPackage].price}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '开通即表示同意《VIP服务协议》',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.tertiaryGrey,
            ),
          ),
        ],
      ),
    );
  }
}
