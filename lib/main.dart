import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/app.dart';
import 'package:flutter_easy_starter/core/services/http_service.dart';
import 'package:flutter_easy_starter/core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 设置状态栏样式（Android）
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // 初始化本地存储服务（纯本地键值存储，不涉及敏感设备信息采集）
  await StorageService.instance.init();

  // 初始化网络请求服务
  HttpService.instance.init();

  // 注意：为满足国内应用市场隐私合规要求，DeviceUtils 及三方 SDK
  // 均延迟至用户同意隐私政策后由 PrivacyManager 统一初始化

  // 设置屏幕方向
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const AppWithProvider());
}
