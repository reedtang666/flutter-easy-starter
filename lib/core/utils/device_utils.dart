import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 设备信息工具
///
/// 获取设备型号、系统版本、App版本等基本信息
class DeviceUtils {
  DeviceUtils._();

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static PackageInfo? _packageInfo;

  /// 初始化
  static Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  // ==================== App 信息 ====================

  /// App 名称
  static String get appName => _packageInfo?.appName ?? '';

  /// App 包名
  static String get packageName => _packageInfo?.packageName ?? '';

  /// App 版本号
  static String get appVersion => _packageInfo?.version ?? '';

  /// App 构建号
  static String get buildNumber => _packageInfo?.buildNumber ?? '';

  /// 完整版本号 (版本号+构建号)
  static String get fullVersion => '$appVersion+$buildNumber';

  // ==================== 设备信息 ====================

  /// 设备 ID（取设备唯一标识）
  static Future<String> getDeviceId() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? '';
    }
    return '';
  }

  /// 设备型号名称
  static Future<String> getDeviceModel() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return '${androidInfo.manufacturer} ${androidInfo.model}';
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    }
    return 'Unknown';
  }

  /// 操作系统版本
  static Future<String> getOsVersion() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return 'Android ${androidInfo.version.release}';
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return 'iOS ${iosInfo.systemVersion}';
    }
    return Platform.operatingSystemVersion;
  }

  /// 获取完整的设备信息
  static Future<DeviceInfo> getFullDeviceInfo() async {
    String deviceId = '';
    String model = '';
    String osVersion = '';
    String brand = '';
    bool isPhysicalDevice = true;

    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      deviceId = androidInfo.id;
      model = androidInfo.model;
      osVersion = 'Android ${androidInfo.version.release}';
      brand = androidInfo.manufacturer;
      isPhysicalDevice = androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? '';
      model = iosInfo.utsname.machine;
      osVersion = 'iOS ${iosInfo.systemVersion}';
      brand = 'Apple';
      isPhysicalDevice = iosInfo.isPhysicalDevice;
    }

    return DeviceInfo(
      deviceId: deviceId,
      model: model,
      brand: brand,
      osVersion: osVersion,
      platform: Platform.operatingSystem,
      isPhysicalDevice: isPhysicalDevice,
      appName: appName,
      appVersion: appVersion,
      buildNumber: buildNumber,
      packageName: packageName,
    );
  }

  /// 获取设备信息摘要（用于展示）
  static Future<String> getDeviceSummary() async {
    final info = await getFullDeviceInfo();
    return '''
📱 设备信息
━━━━━━━━━━━━━━━━━━━━
设备型号: ${info.brand} ${info.model}
系统版本: ${info.osVersion}
设备ID: ${info.deviceId.substring(0, info.deviceId.length > 8 ? 8 : info.deviceId.length)}...
━━━━━━━━━━━━━━━━━━━━
📦 App 信息
━━━━━━━━━━━━━━━━━━━━
应用名称: ${info.appName}
包名: ${info.packageName}
版本: ${info.appVersion}
构建号: ${info.buildNumber}
━━━━━━━━━━━━━━━━━━━━
    '''.trim();
  }

  /// 判断是否为 iOS
  static bool get isIOS => Platform.isIOS;

  /// 判断是否为 Android
  static bool get isAndroid => Platform.isAndroid;

  /// 判断是否为模拟器
  static Future<bool> isEmulator() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return !androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return !iosInfo.isPhysicalDevice;
    }
    return false;
  }

  /// 获取用户代理字符串（用于网络请求）
  static Future<String> getUserAgent() async {
    final model = await getDeviceModel();
    final osVersion = await getOsVersion();
    return 'FlutterApp/$appVersion ($model; $osVersion)';
  }
}

/// 设备信息数据类
class DeviceInfo {
  final String deviceId;
  final String model;
  final String brand;
  final String osVersion;
  final String platform;
  final bool isPhysicalDevice;
  final String appName;
  final String appVersion;
  final String buildNumber;
  final String packageName;

  const DeviceInfo({
    required this.deviceId,
    required this.model,
    required this.brand,
    required this.osVersion,
    required this.platform,
    required this.isPhysicalDevice,
    required this.appName,
    required this.appVersion,
    required this.buildNumber,
    required this.packageName,
  });

  /// 转换为 Map（可用于上报）
  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'model': model,
      'brand': brand,
      'osVersion': osVersion,
      'platform': platform,
      'isPhysicalDevice': isPhysicalDevice,
      'appName': appName,
      'appVersion': appVersion,
      'buildNumber': buildNumber,
      'packageName': packageName,
    };
  }

  @override
  String toString() {
    return 'DeviceInfo{model: $model, os: $osVersion, app: $appVersion}';
  }
}

/// 简化的设备信息显示组件
class DeviceInfoDisplay {
  /// 显示设备信息对话框
  static void showDeviceInfoDialog(BuildContext context) {
    DeviceUtils.getFullDeviceInfo().then((info) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 360),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 顶部装饰区域
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.3),
                        AppColors.primary.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // 设备图标
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          info.platform == 'ios' ? Icons.apple : Icons.android,
                          size: 32,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${info.brand} ${info.model}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        info.osVersion,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.lightGrey.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // 内容区域
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 设备信息组
                      _buildSectionTitle(Icons.phone_android_outlined, '设备'),
                      const SizedBox(height: 12),
                      _buildInfoItem('设备ID', '${info.deviceId.substring(0, info.deviceId.length > 8 ? 8 : info.deviceId.length)}...'),
                      _buildInfoItem('设备类型', info.isPhysicalDevice ? '真机' : '模拟器'),
                      _buildInfoItem('平台', info.platform.toUpperCase()),

                      const SizedBox(height: 20),

                      // App信息组
                      _buildSectionTitle(Icons.apps_outlined, '应用'),
                      const SizedBox(height: 12),
                      _buildInfoItem('应用名称', info.appName),
                      _buildInfoItem('包名', info.packageName),
                      _buildInfoItem('版本', '${info.appVersion} (${info.buildNumber})'),
                    ],
                  ),
                ),

                // 底部按钮
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '知道了',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  static Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  static Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.lightGrey.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
