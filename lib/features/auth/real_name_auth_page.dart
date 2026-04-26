import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/core/utils/dialog_utils.dart';
import 'package:flutter_easy_starter/core/widgets/image_picker.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 实名认证步骤
enum AuthStep { input, idCard, face, success }

/// 实名认证页
class RealNameAuthPage extends StatefulWidget {
  const RealNameAuthPage({super.key});

  @override
  State<RealNameAuthPage> createState() => _RealNameAuthPageState();
}

class _RealNameAuthPageState extends State<RealNameAuthPage> {
  AuthStep _currentStep = AuthStep.input;
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _frontIdImage;
  File? _backIdImage;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('实名认证'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (_currentStep) {
      case AuthStep.input:
        return _buildInputStep();
      case AuthStep.idCard:
        return _buildIdCardStep();
      case AuthStep.face:
        return _buildFaceStep();
      case AuthStep.success:
        return _buildSuccessStep();
    }
  }

  Widget _buildInputStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // 说明卡片
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.verified_user,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                SizedBox(height: 16.w),
                Text(
                  '实名认证',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.w),
                Text(
                  '为保障社区安全，请完成实名认证',
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.w),

          // 表单
          _buildTextField(
            controller: _nameController,
            label: '真实姓名',
            hint: '请输入您的真实姓名',
            icon: Icons.person,
          ),

          SizedBox(height: 16.w),

          _buildTextField(
            controller: _idController,
            label: '身份证号',
            hint: '请输入18位身份证号码',
            icon: Icons.badge,
          ),

          SizedBox(height: 16.w),

          _buildTextField(
            controller: _phoneController,
            label: '手机号',
            hint: '请输入手机号码',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),

          SizedBox(height: 32.w),

          // 提示文字
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '温馨提示',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.w),
                Text(
                  '• 实名信息仅用于身份验证，不会对外展示\n'
                  '• 请确保信息真实准确，认证后无法修改\n'
                  '• 认证通过后将获得认证标识',
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 13.sp,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32.w),

          // 下一步按钮
          SizedBox(
            width: double.infinity,
            height: 56.w,
            child: ElevatedButton(
              onPressed: _validateAndNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                '下一步',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.w),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(color: AppColors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.tertiaryGrey),
              prefixIcon: Icon(icon, color: AppColors.lightGrey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.tertiaryGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.tertiaryGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              filled: true,
              fillColor: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdCardStep() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Text(
            '上传身份证照片',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            '请确保照片清晰、完整、无遮挡',
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 32.w),
          Row(
            children: [
              Expanded(
                child: _buildIdCardUpload(
                  title: '身份证正面',
                  icon: Icons.badge,
                  isFront: true,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildIdCardUpload(
                  title: '身份证反面',
                  icon: Icons.badge_outlined,
                  isFront: false,
                ),
              ),
            ],
          ),
          SizedBox(height: 32.w),
          SizedBox(
            width: double.infinity,
            height: 56.w,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _currentStep = AuthStep.face);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                '下一步',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdCardUpload({
    required String title,
    required IconData icon,
    required bool isFront,
  }) {
    final selectedImage = isFront ? _frontIdImage : _backIdImage;

    return GestureDetector(
      onTap: () => _pickIdCardImage(isFront),
      child: Container(
        height: 180.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selectedImage != null ? AppColors.primary : AppColors.tertiaryGrey,
            width: selectedImage != null ? 2.w : 1.w,
          ),
          image: selectedImage != null
              ? DecorationImage(
                  image: FileImage(selectedImage),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: selectedImage != null
            ? _buildImageOverlay(title)
            : _buildUploadPlaceholder(title, icon),
      ),
    );
  }

  Widget _buildUploadPlaceholder(String title, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 48,
          color: AppColors.lightGrey,
        ),
        SizedBox(height: 12.w),
        Text(
          title,
          style: TextStyle(
            color: AppColors.lightGrey,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 8.w),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 6.w,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            '点击上传',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageOverlay(String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.w),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.green,
                size: 16,
              ),
              SizedBox(width: 4.w),
              Text(
                '已上传',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickIdCardImage(bool isFront) async {
    final title = isFront ? '身份证正面' : '身份证反面';
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
                    '上传$title',
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
                    subtitle: '使用相机拍摄$title',
                    gradient: [const Color(0xFF5AC8FA), const Color(0xFF007AFF)],
                    onTap: () async {
                      Navigator.pop(context);
                      final result = await ImagePickerUtils.pickFromCamera(context);
                      if (result != null) {
                        setState(() {
                          if (isFront) {
                            _frontIdImage = result.file;
                          } else {
                            _backIdImage = result.file;
                          }
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
                          if (isFront) {
                            _frontIdImage = result.file;
                          } else {
                            _backIdImage = result.file;
                          }
                        });
                      }
                    },
                  ),
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

  Widget _buildFaceStep() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Text(
            '人脸识别',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            '请进行人脸识别验证',
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 14.sp,
            ),
          ),
          Spacer(),
          Container(
            width: 240.w,
            height: 240.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 3.w,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.face,
                  size: 80,
                  color: AppColors.primary,
                ),
                SizedBox(height: 16.w),
                Text(
                  '点击开始识别',
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56.w,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _currentStep = AuthStep.success);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                '开始识别',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(32.r),
            ),
            child: Icon(
              Icons.check_circle,
              color: AppColors.green,
              size: 60,
            ),
          ),
          SizedBox(height: 32.w),
          Text(
            '认证成功',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.w),
          Text(
            '您已获得认证标识',
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 48.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: SizedBox(
              width: double.infinity,
              height: 56.w,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  '完成',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndNext() {
    if (_nameController.text.isEmpty ||
        _idController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      DialogUtils.showError(context, message: '请填写完整信息');
      return;
    }
    setState(() => _currentStep = AuthStep.idCard);
  }
}
