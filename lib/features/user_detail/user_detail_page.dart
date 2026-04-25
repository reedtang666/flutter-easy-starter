import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/utils/dialog_utils.dart';
import 'package:go_router/go_router.dart';

/// 用户详情页 - 融合 justkawal ProfileDetailedPage 风格 + Dark Theme
class UserDetailPage extends StatefulWidget {
  final String userId;

  const UserDetailPage({
    super.key,
    required this.userId,
  });

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final PageController _photoController = PageController();
  double _scrollPosition = 0;
  int _selectedTab = 0;
  int _currentPhotoIndex = 0;
  final List<String> _tabs = ['动态', '相册'];

  // 模拟用户数据
  late Map<String, dynamic> _userData;
  late List<String> _photos;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _userData = _generateMockData();
    _photos = _generatePhotos();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  Map<String, dynamic> _generateMockData() {
    final random = Random();
    final names = ['小雨', 'Alex', '梦琪', 'Jack', 'Emma', 'Lucas'];
    final interests = ['旅行', '摄影', '美食', '健身', '音乐', '阅读', '电影', '游戏'];

    return {
      'id': widget.userId,
      'name': names[random.nextInt(names.length)],
      'age': 22 + random.nextInt(10),
      'bio': '热爱生活，喜欢探索新事物。希望在这里遇到志同道合的朋友。',
      'distance': (random.nextDouble() * 5 + 0.5).toStringAsFixed(1),
      'isOnline': random.nextBool(),
      'lastActive': '刚刚',
      'photos': 12,
      'followers': 1280,
      'following': 86,
      'interests': interests.sublist(0, 4 + random.nextInt(3)),
      'verified': random.nextBool(),
      'height': '168cm',
      'maritalStatus': '单身',
      'location': '北京市朝阳区',
    };
  }

  List<String> _generatePhotos() {
    // 使用本地头像图片 - 更多图片让轮播可以切换
    final photos = [
      'assets/images/profiles/profile_0.png',
      'assets/images/profiles/profile_1.png',
      'assets/images/profiles/profile_2.png',
      'assets/images/profiles/profile_3.png',
      'assets/images/profiles/profile_4.png',
      'assets/images/profiles/profile_5.png',
      'assets/images/profiles/profile_6.png',
      'assets/images/profiles/profile_7.png',
      'assets/images/profiles/profile_8.png',
      'assets/images/profiles/profile_9.png',
      'assets/images/profiles/profile_10.png',
      'assets/images/profiles/profile_11.png',
      'assets/images/profiles/profile_12.png',
    ];
    return photos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 主内容
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // 顶部照片轮播
              SliverToBoxAdapter(
                child: _buildPhotoCarousel(),
              ),

              // 用户信息卡片
              SliverToBoxAdapter(
                child: _buildUserInfoCard(),
              ),

              // 统计信息
              SliverToBoxAdapter(
                child: _buildStats(),
              ),

              // Tab栏
              SliverToBoxAdapter(
                child: _buildTabBar(),
              ),

              // Tab内容
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: _selectedTab == 0
                    ? _buildMomentsGrid()
                    : _buildPhotoGrid(),
              ),

              // 底部间距
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),

          // 顶部导航栏
          _buildTopNavigation(),

          // 底部操作栏
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildPhotoCarousel() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Stack(
        children: [
          // 照片轮播
          PageView.builder(
            controller: _photoController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPhotoIndex = index;
              });
            },
            itemCount: _photos.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  image: DecorationImage(
                    image: AssetImage(_photos[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),

          // 底部渐变
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background.withValues(alpha: 0.9),
                    AppColors.background.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 照片指示器
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_photos.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _currentPhotoIndex == index ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _currentPhotoIndex == index
                        ? AppColors.primary
                        : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),

          // 在线状态
          if (_userData['isOnline'])
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '在线',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 姓名和认证
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_userData['name']}, ${_userData['age']}',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_userData['verified'])
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // 位置
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: AppColors.lightGrey,
              ),
              const SizedBox(width: 4),
              Text(
                _userData['location'],
                style: const TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // 距离
          Row(
            children: [
              Icon(
                Icons.near_me,
                size: 16,
                color: AppColors.lightGrey,
              ),
              const SizedBox(width: 4),
              Text(
                '${_userData['distance']}km · ${_userData['lastActive']}活跃',
                style: const TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 简介
          Text(
            _userData['bio'],
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 15,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // 兴趣标签
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (_userData['interests'] as List<String>).map((interest) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  interest,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // 分割线
          Divider(
            color: AppColors.divider,
            thickness: 1,
          ),

          const SizedBox(height: 16),

          // 额外信息
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: RichText(
                  text: TextSpan(
                    text: '身高: ',
                    style: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: _userData['height'],
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: RichText(
                  text: TextSpan(
                    text: '感情状态: ',
                    style: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: _userData['maritalStatus'],
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('照片', '${_userData['photos']}'),
          _buildStatDivider(),
          _buildStatItem('关注', '${_userData['followers']}'),
          _buildStatDivider(),
          _buildStatItem('粉丝', '${_userData['following']}'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.lightGrey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.border,
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.lightGrey,
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMomentsGrid() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryGrey,
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(_photos[0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userData['name'],
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${index + 1}小时前',
                          style: const TextStyle(
                            color: AppColors.lightGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '今天心情不错，出去拍了几张照片 📸✨',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 20,
                      color: AppColors.lightGrey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${12 + index * 3}',
                      style: const TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 20,
                      color: AppColors.lightGrey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${3 + index}',
                      style: const TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        childCount: 5,
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final photoIndex = index % _photos.length;
          return GestureDetector(
            onTap: () => _showPhotoViewer(photoIndex),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(_photos[photoIndex]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        childCount: _photos.length,
      ),
    );
  }

  void _showPhotoViewer(int initialIndex) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) => PhotoViewer(
        photos: _photos,
        initialIndex: initialIndex,
      ),
    );
  }

  Widget _buildTopNavigation() {
    final showBackground = _scrollPosition > 100;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          left: 20,
          right: 20,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: showBackground
              ? AppColors.background.withValues(alpha: 0.95)
              : Colors.transparent,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 返回按钮
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.darkGrey.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),

            // 更多选项
            GestureDetector(
              onTap: _showMoreMenu,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.darkGrey.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.tertiaryGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.share, color: AppColors.white),
                title: const Text(
                  '分享资料',
                  style: TextStyle(color: AppColors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  DialogUtils.showInfo(context, message: '分享功能开发中...');
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: AppColors.red),
                title: const Text(
                  '屏蔽用户',
                  style: TextStyle(color: AppColors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showBlockConfirm();
                },
              ),
              ListTile(
                leading: const Icon(Icons.report, color: AppColors.orange),
                title: const Text(
                  '举报',
                  style: TextStyle(color: AppColors.orange),
                ),
                onTap: () {
                  Navigator.pop(context);
                  DialogUtils.showInfo(context, message: '举报功能开发中...');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBlockConfirm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            '屏蔽用户',
            style: TextStyle(color: AppColors.white),
          ),
          content: Text(
            '确定要屏蔽 ${_userData['name']} 吗？屏蔽后将不再收到对方的消息。',
            style: const TextStyle(color: AppColors.lightGrey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.pop();
                DialogUtils.showSuccess(context, message: '已屏蔽用户');
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.red),
              child: const Text('屏蔽'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomActionBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.background,
              AppColors.background.withValues(alpha: 0.9),
              AppColors.background.withValues(alpha: 0.0),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            // 不喜欢
            Expanded(
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.lightGrey,
                    size: 28,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // 发消息
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  context.push('/chat/${widget.userId}');
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '发消息',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // 超级喜欢
            Expanded(
              child: GestureDetector(
                onTap: () {
                  DialogUtils.showSuccess(
                    context,
                    message: '已发送超级喜欢 💕',
                  );
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: AppColors.pink,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 图片查看器
class PhotoViewer extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;

  const PhotoViewer({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 图片轮播
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.photos.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: Image.asset(
                    widget.photos[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          // 顶部导航
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 关闭按钮
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    // 图片计数
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentIndex + 1} / ${widget.photos.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // 更多按钮（占位）
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),

          // 底部指示器
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.photos.length > 10 ? 10 : widget.photos.length,
                  (index) {
                    return Container(
                      width: _currentIndex == index ? 20 : 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
