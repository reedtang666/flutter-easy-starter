import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/utils/dialog_utils.dart';
import 'package:go_router/go_router.dart';

/// 相册照片
class PhotoItem {
  final String id;
  final String? url;
  final DateTime date;
  final int likes;
  bool isAvatar;

  PhotoItem({
    required this.id,
    this.url,
    required this.date,
    this.likes = 0,
    this.isAvatar = false,
  });
}

/// 我的相册页
class MyPhotosPage extends StatefulWidget {
  const MyPhotosPage({super.key});

  @override
  State<MyPhotosPage> createState() => _MyPhotosPageState();
}

class _MyPhotosPageState extends State<MyPhotosPage> {
  final List<PhotoItem> _photos = [];
  int _selectedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadMockPhotos();
  }

  void _loadMockPhotos() {
    // 模拟数据
    _photos.addAll([
      PhotoItem(
        id: '1',
        date: DateTime.now().subtract(const Duration(days: 1)),
        likes: 23,
        isAvatar: true,
      ),
      PhotoItem(
        id: '2',
        date: DateTime.now().subtract(const Duration(days: 3)),
        likes: 15,
      ),
      PhotoItem(
        id: '3',
        date: DateTime.now().subtract(const Duration(days: 5)),
        likes: 42,
      ),
      PhotoItem(
        id: '4',
        date: DateTime.now().subtract(const Duration(days: 7)),
        likes: 8,
      ),
      PhotoItem(
        id: '5',
        date: DateTime.now().subtract(const Duration(days: 10)),
        likes: 31,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('我的相册'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // 编辑模式
              DialogUtils.showInfo(context, message: '编辑模式开发中...');
            },
            child: const Text('管理'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 统计信息
          SliverToBoxAdapter(
            child: _buildStats(),
          ),

          // 上传按钮
          SliverToBoxAdapter(
            child: _buildUploadSection(),
          ),

          // 相册网格
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildPhotoItem(_photos[index]),
                childCount: _photos.length,
              ),
            ),
          ),

          // 底部提示
          SliverToBoxAdapter(
            child: _buildBottomHint(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPhotoOptions,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_a_photo, color: Colors.white),
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('总照片', '${_photos.length}', Icons.photo_library),
          ),
          Expanded(
            child: _buildStatItem('获赞', '119', Icons.favorite),
          ),
          Expanded(
            child: _buildStatItem('本月', '3', Icons.calendar_today),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.2),
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.cloud_upload,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '上传照片',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '支持上传 9 张照片，展示你的精彩生活',
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _showAddPhotoOptions,
            icon: const Icon(
              Icons.add_circle,
              color: AppColors.primary,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoItem(PhotoItem photo) {
    return GestureDetector(
      onTap: () {
        _showPhotoDetail(photo);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 照片占位
            Container(
              color: AppColors.tertiaryGrey,
              child: const Icon(
                Icons.image,
                color: AppColors.lightGrey,
                size: 40,
              ),
            ),

            // 头像标记
            if (photo.isAvatar)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '头像',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // 点赞数
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: AppColors.primary,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${photo.likes}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 长按菜单
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _showPhotoOptions(photo),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomHint() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '小贴士：清晰的正面照片能让你获得更多匹配机会',
                    style: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showAddPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '添加照片',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildOptionTile(
                  icon: Icons.camera_alt,
                  title: '拍照',
                  onTap: () {
                    Navigator.pop(context);
                    DialogUtils.showInfo(context, message: '相机功能开发中...');
                  },
                ),
                _buildOptionTile(
                  icon: Icons.photo_library,
                  title: '从相册选择',
                  onTap: () {
                    Navigator.pop(context);
                    DialogUtils.showInfo(context, message: '相册功能开发中...');
                  },
                ),
                _buildOptionTile(
                  icon: Icons.delete,
                  title: '取消',
                  isDestructive: true,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.red : AppColors.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppColors.red : AppColors.white,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showPhotoOptions(PhotoItem photo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '照片操作',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (!photo.isAvatar)
                  _buildOptionTile(
                    icon: Icons.account_circle,
                    title: '设为头像',
                    onTap: () {
                      Navigator.pop(context);
                      _setAsAvatar(photo);
                    },
                  ),
                _buildOptionTile(
                  icon: Icons.share,
                  title: '分享',
                  onTap: () {
                    Navigator.pop(context);
                    DialogUtils.showInfo(context, message: '分享功能开发中...');
                  },
                ),
                _buildOptionTile(
                  icon: Icons.delete,
                  title: '删除',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    _deletePhoto(photo);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _setAsAvatar(PhotoItem photo) {
    setState(() {
      for (var p in _photos) {
        p.isAvatar = false;
      }
      photo.isAvatar = true;
    });
    DialogUtils.showSuccess(context, message: '已设为头像');
  }

  void _deletePhoto(PhotoItem photo) {
    DialogUtils.confirm(
      context: context,
      title: '删除照片',
      message: '确定要删除这张照片吗？',
      isDestructive: true,
      onOk: () {
        setState(() {
          _photos.remove(photo);
        });
        DialogUtils.showSuccess(context, message: '照片已删除');
      },
    );
  }

  void _showPhotoDetail(PhotoItem photo) {
    DialogUtils.showInfo(
      context,
      title: '照片详情',
      message: '拍摄于 ${_formatDate(photo.date)}\n获得 ${photo.likes} 个赞',
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }
}
