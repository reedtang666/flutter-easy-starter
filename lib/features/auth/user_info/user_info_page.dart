import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/widgets/image_picker.dart';
import 'package:flutter_easy_starter/models/user_model.dart';
import 'package:flutter_easy_starter/providers/auth_provider.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 用户信息页 - 深色主题，与个人中心风格一致
class UserInfoPage extends ConsumerStatefulWidget {
  const UserInfoPage({super.key});

  @override
  ConsumerState<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _bioController = TextEditingController();
  int _selectedGender = 0;
  String? _avatar;

  final List<String> _genderLabels = ['保密', '男', '女'];
  final List<IconData> _genderIcons = [Icons.question_mark, Icons.male, Icons.female];
  final List<Color> _genderColors = [Colors.grey, Colors.blue, Colors.pink];

  @override
  void dispose() {
    _nicknameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('个人信息'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: authState.isLoading ? null : _save,
            child: Text(
              '保存',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头像区域
              _buildAvatarSection(),
              SizedBox(height: 32.w),

              // 昵称
              _buildSectionTitle('昵称'),
              _buildTextField(
                controller: _nicknameController,
                hintText: '请输入昵称',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入昵称';
                  }
                  if (value.length > 20) {
                    return '昵称不能超过20个字符';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.w),

              // 性别
              _buildSectionTitle('性别'),
              _buildGenderSelector(),
              SizedBox(height: 24.w),

              // 简介
              _buildSectionTitle('个人简介'),
              _buildBioEditor(),
              SizedBox(height: 48.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _showImagePicker,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: _avatar != null
                      ? ClipOval(
                          child: _avatar!.startsWith('http')
                              ? Image.network(
                                  _avatar!,
                                  width: 120.w,
                                  height: 120.w,
                                  fit: BoxFit.cover,
                                )
                              : (_avatar!.startsWith('assets')
                                  ? Image.asset(
                                      _avatar!,
                                      width: 120.w,
                                      height: 120.w,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(_avatar!),
                                      width: 120.w,
                                      height: 120.w,
                                      fit: BoxFit.cover,
                                    )),
                        )
                      : ClipOval(
                          child: Image.asset(
                            'assets/images/avatar_default.png',
                            width: 120.w,
                            height: 120.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                // 编辑图标
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.background,
                        width: 3.w,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          Text(
            '点击更换头像',
            style: TextStyle(
              color: AppColors.lightGrey.withValues(alpha: 0.8),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      style: TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.tertiaryGrey,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: AppColors.lightGrey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        counterStyle: TextStyle(
          color: AppColors.tertiaryGrey,
          fontSize: 12.sp,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        for (int i = 0; i < 3; i++)
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedGender = i),
              child: Container(
                margin: EdgeInsets.only(right: i < 2 ? 12 : 0),
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _selectedGender == i
                      ? _genderColors[i].withValues(alpha: 0.15)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: _selectedGender == i
                        ? _genderColors[i]
                        : Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _genderIcons[i],
                      size: 20,
                      color: _selectedGender == i
                          ? _genderColors[i]
                          : AppColors.lightGrey,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _genderLabels[i],
                      style: TextStyle(
                        color: _selectedGender == i
                            ? _genderColors[i]
                            : AppColors.lightGrey,
                        fontWeight: _selectedGender == i
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBioEditor() {
    return TextFormField(
      controller: _bioController,
      maxLines: 5,
      minLines: 5,
      keyboardType: TextInputType.multiline,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        hintText: '介绍一下自己...',
        hintStyle: TextStyle(
          color: AppColors.tertiaryGrey,
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
        contentPadding: EdgeInsets.all(16.w),
      ),
    );
  }

  void _showImagePicker() {
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
                    '更换头像',
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
                    subtitle: '使用相机拍摄新头像',
                    gradient: [const Color(0xFF5AC8FA), const Color(0xFF007AFF)],
                    onTap: () async {
                      Navigator.pop(context);
                      final result = await ImagePickerUtils.pickFromCamera(context);
                      if (result != null) {
                        setState(() {
                          _avatar = result.path;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 12.w),
                  _buildOptionTile(
                    icon: LucideIcons.image_plus,
                    title: '从相册选择',
                    subtitle: '选择已有照片',
                    gradient: [AppColors.primary, AppColors.primaryLight],
                    onTap: () async {
                      Navigator.pop(context);
                      final result = await ImagePickerUtils.pickFromGallery(context);
                      if (result != null) {
                        setState(() {
                          _avatar = result.path;
                        });
                      }
                    },
                  ),
                  if (_avatar != null) ...[
                    SizedBox(height: 12.w),
                    _buildOptionTile(
                      icon: LucideIcons.trash_2,
                      title: '删除头像',
                      subtitle: '恢复默认头像',
                      gradient: [AppColors.red, const Color(0xFFFF453A)],
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _avatar = null;
                        });
                      },
                    ),
                  ],
                  SizedBox(height: 12.w),
                  GestureDetector(
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
    return GestureDetector(
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = UserModel(
      id: ref.read(authProvider).user?.id ?? '1',
      username: ref.read(authProvider).user?.username ?? 'test',
      nickname: _nicknameController.text.trim(),
      avatar: _avatar,
      gender: _selectedGender,
      bio: _bioController.text.trim(),
    );

    final success = await ref.read(authProvider.notifier).updateUserInfo(user);

    if (success) {
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('保存成功'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } else {
      final error = ref.read(authProvider).error;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? '保存失败'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }
}
