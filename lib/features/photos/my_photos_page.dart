import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/utils/dialog_utils.dart';
import 'package:flutter_easy_starter/core/widgets/animated_button.dart';
import 'package:flutter_easy_starter/core/widgets/image_picker.dart';
import 'package:flutter_easy_starter/core/widgets/shimmer_widgets.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

/// 我的相册页 - 增强版
class MyPhotosPage extends StatefulWidget {
  const MyPhotosPage({super.key});

  @override
  State<MyPhotosPage> createState() => _MyPhotosPageState();
}

class _MyPhotosPageState extends State<MyPhotosPage> {
  final List<PhotoItem> _photos = [];
  bool _isLoading = true;
  bool _isEditMode = false;
  final Set<String> _selectedPhotos = {};

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    setState(() => _isLoading = true);

    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
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
        PhotoItem(
          id: '6',
          date: DateTime.now().subtract(const Duration(days: 12)),
          likes: 56,
        ),
        PhotoItem(
          id: '7',
          date: DateTime.now().subtract(const Duration(days: 15)),
          likes: 19,
        ),
        PhotoItem(
          id: '8',
          date: DateTime.now().subtract(const Duration(days: 18)),
          likes: 33,
        ),
      ]);
      _isLoading = false;
    });
  }

  void _toggleEditMode() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _selectedPhotos.clear();
      }
    });
  }

  void _togglePhotoSelection(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedPhotos.contains(id)) {
        _selectedPhotos.remove(id);
      } else {
        _selectedPhotos.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          '我的相册',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: AnimatedButton(
          onTap: () => context.pop(),
          scaleDown: 0.85,
          child: Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              LucideIcons.arrow_left,
              color: AppColors.white,
              size: 20,
            ),
          ),
        ),
        actions: [
          AnimatedButton(
            onTap: _toggleEditMode,
            child: Container(
              margin: EdgeInsets.all(12.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
              decoration: BoxDecoration(
                color: _isEditMode
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(8.r),
                border: _isEditMode
                    ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
                    : null,
              ),
              child: Text(
                _isEditMode ? '完成' : '管理',
                style: TextStyle(
                  color: _isEditMode ? AppColors.primary : AppColors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 统计信息
          SliverToBoxAdapter(
            child: _isLoading ? _buildStatsShimmer() : _buildStats(),
          ),

          // 上传按钮
          if (!_isEditMode)
            SliverToBoxAdapter(
              child: _isLoading
                  ? _buildUploadSectionShimmer()
                  : _buildUploadSection(),
            ),

          // 相册网格
          _isLoading
              ? SliverPadding(
                  padding: EdgeInsets.all(16.w),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8.w,
                      crossAxisSpacing: 8.w,
                      childAspectRatio: 0.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ShimmerContainer(
                        borderRadius: 12,
                      ),
                      childCount: 9,
                    ),
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.all(16.w),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8.w,
                      crossAxisSpacing: 8.w,
                      childAspectRatio: 0.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => StaggeredAnimation(
                        index: index,
                        type: AnimationType.scale,
                        child: _buildPhotoItem(_photos[index]),
                      ),
                      childCount: _photos.length,
                    ),
                  ),
                ),

          // 底部提示
          if (!_isEditMode)
            SliverToBoxAdapter(
              child: _isLoading ? SizedBox(height: 20.w) : _buildBottomHint(),
            ),
        ],
      ),
      floatingActionButton: !_isEditMode
          ? AnimatedButton(
              onTap: _showAddPhotoOptions,
              scaleDown: 0.9,
              hapticType: HapticFeedbackType.medium,
              child: PulseAnimation(
                duration: const Duration(milliseconds: 2000),
                maxScale: 1.08,
                child: Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primaryLight,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.purpleGlow(opacity: 0.5),
                  ),
                  child: Icon(
                    LucideIcons.camera,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            )
          : null,
      bottomNavigationBar: _isEditMode && _selectedPhotos.isNotEmpty
          ? _buildEditActions()
          : null,
    );
  }

  Widget _buildStatsShimmer() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          for (int i = 0; i < 3; i++)
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: ShimmerContainer(
                  height: 90,
                  borderRadius: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUploadSectionShimmer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
      child: ShimmerContainer(
        height: 100,
        borderRadius: 16,
      ),
    );
  }

  Widget _buildStats() {
    final totalLikes = _photos.fold(0, (sum, p) => sum + p.likes);
    final thisMonth = _photos
        .where((p) =>
            p.date.month == DateTime.now().month &&
            p.date.year == DateTime.now().year)
        .length;

    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          _buildStatItem('总照片', '${_photos.length}', LucideIcons.images),
          _buildStatItem('获赞', '$totalLikes', LucideIcons.heart),
          _buildStatItem('本月', '$thisMonth', LucideIcons.calendar),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: AnimatedButton(
        onTap: () {
          HapticFeedback.lightImpact();
          DialogUtils.showInfo(
            context,
            title: label,
            message: '当前$value',
          );
        },
        scaleDown: 0.95,
        child: Container(
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.surfaceVariant.withValues(alpha: 0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              SizedBox(height: 12.w),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return AnimatedButton(
      onTap: _showAddPhotoOptions,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.15),
              AppColors.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: AppShadows.purpleGlow(opacity: 0.4),
              ),
              child: Icon(
                LucideIcons.upload,
                color: Colors.white,
                size: 28,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '上传照片',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    '支持上传 9 张照片，展示你的精彩生活',
                    style: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevron_right,
              color: AppColors.primary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoItem(PhotoItem photo) {
    final isSelected = _selectedPhotos.contains(photo.id);

    return AnimatedButton(
      onTap: () {
        if (_isEditMode) {
          _togglePhotoSelection(photo.id);
        } else {
          _showPhotoDetail(photo);
        }
      },
      onLongPress: () {
        if (!_isEditMode) {
          HapticFeedback.heavyImpact();
          _showPhotoOptions(photo);
        }
      },
      scaleDown: 0.95,
      enableHaptic: !_isEditMode,
      hapticType: HapticFeedbackType.light,
      enableRipple: false,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.white.withValues(alpha: 0.05),
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: isSelected
              ? AppShadows.purpleGlow(opacity: 0.4)
              : null,
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 照片占位
            Container(
              color: AppColors.tertiaryGrey,
              child: Icon(
                LucideIcons.image,
                color: AppColors.lightGrey,
                size: 32,
              ),
            ),

            // 头像标记
            if (photo.isAvatar && !_isEditMode)
              Positioned(
                top: 8.w,
                left: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.w,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primaryLight,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.user,
                        size: 10,
                        color: Colors.white,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '头像',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // 选中标记
            if (_isEditMode && isSelected)
              Positioned(
                top: 8.w,
                right: 8.w,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primaryLight,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.check,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),

            // 点赞数
            if (!_isEditMode)
              Positioned(
                bottom: 8.w,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.heart,
                        color: AppColors.pink,
                        size: 12,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${photo.likes}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // 编辑模式遮罩
            if (_isEditMode && !isSelected)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomHint() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: StaggeredAnimation(
        index: _photos.length,
        type: AnimationType.slideUp,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.surface,
                AppColors.surfaceVariant.withValues(alpha: 0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  LucideIcons.lightbulb,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  '小贴士：清晰的正面照片能让你获得更多匹配机会',
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditActions() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        border: Border(
          top: BorderSide(
            color: AppColors.white.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '已选择 ${_selectedPhotos.length} 张照片',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16.w),
            Row(
              children: [
                Expanded(
                  child: AnimatedButton(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      // 批量设为头像
                      DialogUtils.showSuccess(
                        context,
                        message: '已设为头像',
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.user,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '设为头像',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AnimatedButton(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      DialogUtils.confirm(
                        context: context,
                        title: '删除照片',
                        message: '确定要删除选中的 ${_selectedPhotos.length} 张照片吗？',
                        isDestructive: true,
                        onOk: () {
                          setState(() {
                            _photos.removeWhere(
                                (p) => _selectedPhotos.contains(p.id));
                            _selectedPhotos.clear();
                          });
                          DialogUtils.showSuccess(
                            context,
                            message: '照片已删除',
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.w),
                      decoration: BoxDecoration(
                        color: AppColors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.trash_2,
                            size: 18,
                            color: AppColors.red,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '删除',
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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

  void _showAddPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 拖动条
                  Container(
                    width: 40.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryGrey,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Text(
                    '添加照片',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20.w),
                  _buildOptionTile(
                    icon: LucideIcons.camera,
                    title: '拍照',
                    subtitle: '使用相机拍摄新照片',
                    gradient: [const Color(0xFF5AC8FA), const Color(0xFF007AFF)],
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromCamera();
                    },
                  ),
                  SizedBox(height: 12.w),
                  _buildOptionTile(
                    icon: LucideIcons.image_plus,
                    title: '从相册选择',
                    subtitle: '选择已有照片',
                    gradient: [AppColors.primary, AppColors.primaryLight],
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromGallery();
                    },
                  ),
                  SizedBox(height: 12.w),
                  AnimatedButton(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.w),
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryGrey,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '取消',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return AnimatedButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradient.first.withValues(alpha: 0.15),
              gradient.last.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: gradient.first.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevron_right,
              color: gradient.first,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoOptions(PhotoItem photo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryGrey,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Text(
                    '照片操作',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20.w),
                  if (!photo.isAvatar)
                    _buildPhotoOption(
                      icon: LucideIcons.user,
                      title: '设为头像',
                      gradient: [AppColors.primary, AppColors.primaryLight],
                      onTap: () {
                        Navigator.pop(context);
                        _setAsAvatar(photo);
                      },
                    ),
                  _buildPhotoOption(
                    icon: LucideIcons.share_2,
                    title: '分享',
                    gradient: [const Color(0xFF34C759), const Color(0xFF30D158)],
                    onTap: () {
                      Navigator.pop(context);
                      DialogUtils.showInfo(context, message: '分享功能开发中...');
                    },
                  ),
                  _buildPhotoOption(
                    icon: LucideIcons.trash_2,
                    title: '删除',
                    gradient: [AppColors.red, const Color(0xFFFF453A)],
                    isDestructive: true,
                    onTap: () {
                      Navigator.pop(context);
                      _deletePhoto(photo);
                    },
                  ),
                  SizedBox(height: 8.w),
                  AnimatedButton(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.w),
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryGrey,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '取消',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhotoOption({
    required IconData icon,
    required String title,
    required List<Color> gradient,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return AnimatedButton(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: isDestructive
              ? null
              : LinearGradient(
                  colors: [
                    gradient.first.withValues(alpha: 0.15),
                    gradient.last.withValues(alpha: 0.05),
                  ],
                ),
          color: isDestructive ? AppColors.red.withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDestructive
                ? AppColors.red.withValues(alpha: 0.2)
                : gradient.first.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDestructive ? AppColors.red : AppColors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              LucideIcons.chevron_right,
              color: isDestructive ? AppColors.red : gradient.first,
              size: 20,
            ),
          ],
        ),
      ),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryGrey,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 24.w),
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryGrey,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      LucideIcons.image,
                      size: 48,
                      color: AppColors.lightGrey,
                    ),
                  ),
                  SizedBox(height: 24.w),
                  Text(
                    '照片详情',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.w),
                  _buildDetailItem(
                    LucideIcons.calendar,
                    '拍摄时间',
                    _formatDate(photo.date),
                  ),
                  _buildDetailItem(
                    LucideIcons.heart,
                    '获得点赞',
                    '${photo.likes} 个',
                    valueColor: AppColors.pink,
                  ),
                  if (photo.isAvatar)
                    _buildDetailItem(
                      LucideIcons.user,
                      '状态',
                      '当前头像',
                      valueColor: AppColors.primary,
                    ),
                  SizedBox(height: 16.w),
                  AnimatedButton(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primaryLight,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '关闭',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.lightGrey, size: 20),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 14.sp,
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    final result = await ImagePickerUtils.pickFromCamera(context);
    if (result != null) {
      _addPhotoFromFile(result.file);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final result = await ImagePickerUtils.pickFromGallery(context);
    if (result != null) {
      _addPhotoFromFile(result.file);
    }
  }

  void _addPhotoFromFile(File file) {
    setState(() {
      _photos.insert(
        0,
        PhotoItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: DateTime.now(),
          likes: 0,
        ),
      );
    });
    DialogUtils.showSuccess(context, message: '照片添加成功');
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }
}
