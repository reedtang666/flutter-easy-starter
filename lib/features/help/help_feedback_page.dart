import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/utils/dialog_utils.dart';
import 'package:go_router/go_router.dart';

/// 常见问题分类
class FaqCategory {
  final String title;
  final List<FaqItem> items;

  FaqCategory({required this.title, required this.items});
}

/// 常见问题项
class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}

/// 帮助与反馈页
class HelpFeedbackPage extends StatefulWidget {
  const HelpFeedbackPage({super.key});

  @override
  State<HelpFeedbackPage> createState() => _HelpFeedbackPageState();
}

class _HelpFeedbackPageState extends State<HelpFeedbackPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<FaqCategory> _faqData = [
    FaqCategory(
      title: '账号问题',
      items: [
        FaqItem(
          question: '如何修改个人信息？',
          answer: '进入"我的"页面，点击"个人信息"即可编辑你的资料，包括头像、昵称、简介等。',
        ),
        FaqItem(
          question: '忘记密码怎么办？',
          answer: '在登录页面点击"忘记密码"，按照提示通过手机验证码重置密码。',
        ),
        FaqItem(
          question: '如何注销账号？',
          answer: '进入"设置"-"隐私设置"-"注销账号"，按提示操作即可。注销后数据将无法恢复。',
        ),
      ],
    ),
    FaqCategory(
      title: '匹配问题',
      items: [
        FaqItem(
          question: '为什么匹配不到人？',
          answer: '请检查你的筛选条件是否过于严格，或尝试扩大搜索范围。完善个人资料也能提高匹配率。',
        ),
        FaqItem(
          question: '如何取消喜欢？',
          answer: '升级VIP会员可使用"撤销"功能，找回误操作的用户。',
        ),
        FaqItem(
          question: '匹配后可以撤回吗？',
          answer: '匹配成功后无法撤回，但可以进入聊天界面选择"不再联系"。',
        ),
      ],
    ),
    FaqCategory(
      title: '聊天问题',
      items: [
        FaqItem(
          question: '为什么发不了消息？',
          answer: '只有互相喜欢的用户才能聊天。如果对方取消了喜欢，你将无法继续发送消息。',
        ),
        FaqItem(
          question: '消息被屏蔽怎么办？',
          answer: '请检查是否包含敏感词。如被误判，请联系客服申诉。',
        ),
        FaqItem(
          question: '聊天记录会保存多久？',
          answer: '聊天记录永久保存，除非你主动删除。',
        ),
      ],
    ),
    FaqCategory(
      title: '隐私安全',
      items: [
        FaqItem(
          question: '如何保护个人隐私？',
          answer: '可在"隐私设置"中控制个人资料的可见范围，以及是否显示距离和在线状态。',
        ),
        FaqItem(
          question: '被骚扰怎么办？',
          answer: '长按消息选择"举报"，或进入对方资料页点击"屏蔽"。严重骚扰可向平台投诉。',
        ),
        FaqItem(
          question: '实名认证信息安全吗？',
          answer: '我们使用银行级加密技术，仅用于身份验证，绝不对外泄露。',
        ),
      ],
    ),
    FaqCategory(
      title: '会员问题',
      items: [
        FaqItem(
          question: 'VIP会员有什么特权？',
          answer: 'VIP享有无限喜欢、优先聊天、查看访客、撤销操作等20+项特权。',
        ),
        FaqItem(
          question: '如何取消自动续费？',
          answer: '前往"我的"-"VIP会员"-"管理订阅"中取消。iOS用户需在App Store中操作。',
        ),
        FaqItem(
          question: '充值未到账怎么办？',
          answer: '请检查网络连接，如仍未到账，请提供订单截图联系客服处理。',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('帮助与反馈'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // 快速入口
          _buildQuickAccess(),

          // 分类标签
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.lightGrey,
              tabs: _faqData.map((c) => Tab(text: c.title)).toList(),
            ),
          ),

          // 内容区
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _faqData.map((category) => _buildFaqList(category)).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showFeedbackDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text(
          '意见反馈',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildQuickAccess() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.background,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.headset_mic,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Hi，有什么可以帮您？',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '遇到问题可以先查看常见问题',
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildQuickButton(
                  icon: Icons.chat,
                  title: '在线客服',
                  onTap: () => DialogUtils.showInfo(context, message: '客服功能开发中...'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickButton(
                  icon: Icons.phone,
                  title: '电话联系',
                  subtitle: '400-888-8888',
                  onTap: () => DialogUtils.showInfo(context, message: '拨号功能开发中...'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickButton(
                  icon: Icons.email,
                  title: '邮件反馈',
                  onTap: () => DialogUtils.showInfo(context, message: '邮件功能开发中...'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 11,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqList(FaqCategory category) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: category.items.length,
      itemBuilder: (context, index) {
        final item = category.items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            collapsedIconColor: AppColors.lightGrey,
            iconColor: AppColors.primary,
            title: Text(
              item.question,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  item.answer,
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFeedbackDialog() {
    final controller = TextEditingController();
    final List<String> tags = [
      '功能异常',
      '界面显示',
      '匹配问题',
      '聊天问题',
      '支付问题',
      '其他建议',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: null,
      builder: (context) {
        String? selectedTag;

        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '意见反馈',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          color: AppColors.lightGrey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 多行文本输入 - 纯方形无圆角
                    TextFormField(
                      controller: controller,
                      maxLines: 5,
                      minLines: 5,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.background,
                        hintText: '请详细描述您遇到的问题或建议...',
                        hintStyle: TextStyle(
                          color: AppColors.tertiaryGrey,
                          fontSize: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '常见问题类型',
                      style: TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.map((label) {
                        final isSelected = selectedTag == label;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTag = isSelected ? null : label;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.tertiaryGrey,
                              borderRadius: BorderRadius.zero,
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.lightGrey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.text.isEmpty) {
                            DialogUtils.showError(context, message: '请输入反馈内容');
                            return;
                          }
                          Navigator.pop(context);
                          DialogUtils.showSuccess(context, message: '感谢您的反馈！');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text(
                          '提交反馈',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
