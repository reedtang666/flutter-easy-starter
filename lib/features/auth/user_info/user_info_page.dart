import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/models/user_model.dart';
import 'package:flutter_easy_starter/providers/auth_provider.dart';
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
                        AppColors.primary.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
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
                              : Image.asset(
                                  _avatar!,
                                  width: 120.w,
                                  height: 120.w,
                                  fit: BoxFit.cover,
                                ),
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
              color: AppColors.lightGrey.withOpacity(0.8),
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
                      ? _genderColors[i].withOpacity(0.15)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: _selectedGender == i
                        ? _genderColors[i]
                        : Colors.white.withOpacity(0.05),
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
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '更换头像',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.w),
              _buildImagePickerOption(
                icon: Icons.photo_library_outlined,
                title: '从相册选择',
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _avatar = 'https://via.placeholder.com/150';
                  });
                },
              ),
              SizedBox(height: 12.w),
              _buildImagePickerOption(
                icon: Icons.camera_alt_outlined,
                title: '拍照',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 12.w),
              _buildImagePickerOption(
                icon: Icons.delete_outline,
                title: '删除头像',
                isDestructive: true,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _avatar = null;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColors.red.withOpacity(0.1)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppColors.red : AppColors.primary,
              size: 24,
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                color: isDestructive ? AppColors.red : AppColors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
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
