import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/models/user_model.dart';
import 'package:flutter_easy_starter/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: authState.isLoading ? null : _save,
            child: const Text(
              '保存',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头像区域
              _buildAvatarSection(),
              const SizedBox(height: 32),

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
              const SizedBox(height: 24),

              // 性别
              _buildSectionTitle('性别'),
              _buildGenderSelector(),
              const SizedBox(height: 24),

              // 简介
              _buildSectionTitle('个人简介'),
              _buildBioEditor(),
              const SizedBox(height: 48),
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
                  width: 120,
                  height: 120,
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
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  _avatar!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                        )
                      : ClipOval(
                          child: Image.asset(
                            'assets/images/avatar_default.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                // 编辑图标
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.background,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '点击更换头像',
            style: TextStyle(
              color: AppColors.lightGrey.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 16,
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
      style: const TextStyle(color: AppColors.white),
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
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        counterStyle: TextStyle(
          color: AppColors.tertiaryGrey,
          fontSize: 12,
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
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _selectedGender == i
                      ? _genderColors[i].withOpacity(0.15)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
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
                    const SizedBox(width: 8),
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
      style: const TextStyle(color: AppColors.white),
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
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '更换头像',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 12),
              _buildImagePickerOption(
                icon: Icons.camera_alt_outlined,
                title: '拍照',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColors.red.withOpacity(0.1)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppColors.red : AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isDestructive ? AppColors.red : AppColors.white,
                fontSize: 16,
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
