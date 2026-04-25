import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/widgets/toast_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

/// 图片选择结果
class ImagePickResult {
  final File file;
  final String? path;
  final String? name;
  final int? size;

  ImagePickResult({
    required this.file,
    this.path,
    this.name,
    this.size,
  });
}

/// 图片选择器
///
/// 封装了常用的图片选择功能：
/// - 相册单选/多选
/// - 拍照
/// - 图片预览
class ImagePickerUtils {
  ImagePickerUtils._();

  static final ImagePicker _picker = ImagePicker();

  /// 显示图片来源选择对话框
  static Future<ImagePickResult?> showPicker(
    BuildContext context, {
    bool allowCamera = true,
    bool allowGallery = true,
  }) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ImageSourceSheet(
        allowCamera: allowCamera,
        allowGallery: allowGallery,
      ),
    );

    if (source == null) return null;

    switch (source) {
      case ImageSource.camera:
        return await pickFromCamera();
      case ImageSource.gallery:
        return await pickFromGallery();
      default:
        return null;
    }
  }

  /// 从相册选择单张图片
  static Future<ImagePickResult?> pickFromGallery() async {
    try {
      // 使用 wechat_assets_picker 获得更好的体验
      final assets = await AssetPicker.pickAssets(
        rootNavigatorKey.currentContext!,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.image,
        ),
      );

      if (assets == null || assets.isEmpty) return null;

      final file = await assets.first.file;
      if (file == null) return null;

      return ImagePickResult(
        file: file,
        path: file.path,
        name: assets.first.title,
        size: await file.length(),
      );
    } catch (e) {
      ToastUtils.error('选择图片失败: $e');
      return null;
    }
  }

  /// 从相册选择多张图片
  static Future<List<ImagePickResult>> pickMultipleImages({
    int maxAssets = 9,
  }) async {
    try {
      final assets = await AssetPicker.pickAssets(
        rootNavigatorKey.currentContext!,
        pickerConfig: AssetPickerConfig(
          maxAssets: maxAssets,
          requestType: RequestType.image,
        ),
      );

      if (assets == null || assets.isEmpty) return [];

      final results = <ImagePickResult>[];
      for (final asset in assets) {
        final file = await asset.file;
        if (file != null) {
          results.add(ImagePickResult(
            file: file,
            path: file.path,
            name: asset.title,
            size: await file.length(),
          ));
        }
      }

      return results;
    } catch (e) {
      ToastUtils.error('选择图片失败: $e');
      return [];
    }
  }

  /// 拍照
  static Future<ImagePickResult?> pickFromCamera() async {
    try {
      // 使用 wechat_camera_picker
      final asset = await CameraPicker.pickFromCamera(
        rootNavigatorKey.currentContext!,
        pickerConfig: const CameraPickerConfig(
          enableAudio: false,
          enableRecording: false,
        ),
      );

      if (asset == null) return null;

      final file = await asset.file;
      if (file == null) return null;

      return ImagePickResult(
        file: file,
        path: file.path,
        name: asset.title,
        size: await file.length(),
      );
    } catch (e) {
      ToastUtils.error('拍照失败: $e');
      return null;
    }
  }

  /// 使用系统 ImagePicker（备选方案）
  static Future<ImagePickResult?> pickWithSystemPicker({
    required ImageSource source,
  }) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      final file = File(pickedFile.path);
      return ImagePickResult(
        file: file,
        path: file.path,
        name: pickedFile.name,
        size: await file.length(),
      );
    } catch (e) {
      ToastUtils.error('选择图片失败: $e');
      return null;
    }
  }
}

/// 图片来源选择弹窗
class _ImageSourceSheet extends StatelessWidget {
  final bool allowCamera;
  final bool allowGallery;

  const _ImageSourceSheet({
    required this.allowCamera,
    required this.allowGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '选择图片来源',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            if (allowCamera)
              _buildOption(
                icon: Icons.camera_alt,
                label: '拍照',
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            if (allowCamera && allowGallery)
              const Divider(height: 1),
            if (allowGallery)
              _buildOption(
                icon: Icons.photo_library,
                label: '从相册选择',
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(label),
      onTap: onTap,
    );
  }
}

/// 全局 NavigatorKey，用于图片选择器
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
