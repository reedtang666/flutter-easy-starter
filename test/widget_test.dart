import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/app.dart';
import 'package:flutter_easy_starter/core/constants/app_constants.dart';
import 'package:flutter_easy_starter/core/constants/storage_keys.dart';
import 'package:flutter_easy_starter/core/services/storage_service.dart';
import 'package:flutter_easy_starter/core/theme/theme_provider.dart';
import 'package:flutter_easy_starter/features/privacy/privacy_page.dart';
import 'package:flutter_easy_starter/models/user_model.dart';
import 'package:flutter_easy_starter/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.instance.init();
  });

  group('Core Models & Providers Unit Tests', () {
    test('UserModel JSON serialization & deserialization', () {
      final user = UserModel(
        id: '100',
        username: 'reedtang',
        nickname: 'Reed',
        avatar: 'assets/images/avatar_default.png',
        isVip: true,
      );

      final json = user.toJson();
      final restored = UserModel.fromJson(json);

      expect(restored.id, '100');
      expect(restored.username, 'reedtang');
      expect(restored.displayName, 'Reed');
      expect(restored.isVip, isTrue);
    });

    test('ThemeModeNotifier defaults to dark and toggles to light', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), ThemeMode.dark);

      await container.read(themeModeProvider.notifier).toggle();
      expect(container.read(themeModeProvider), ThemeMode.light);
      expect(
        StorageService.instance.getInt(StorageKeys.themeMode),
        ThemeMode.light.index,
      );
    });

    test('AuthNotifier loginWithPassword persists JSON user and logout clears it', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(authProvider).isAuthenticated, isFalse);

      final success = await container.read(authProvider.notifier).loginWithPassword(
            username: AppConstants.demoAccount,
            password: AppConstants.demoPassword,
          );

      expect(success, isTrue);
      expect(container.read(authProvider).isAuthenticated, isTrue);
      expect(container.read(authProvider).user?.username, AppConstants.demoAccount);
      expect(
        StorageService.instance.getString(StorageKeys.userInfo),
        contains('"username":"${AppConstants.demoAccount}"'),
      );

      await container.read(authProvider.notifier).logout();
      expect(container.read(authProvider).isAuthenticated, isFalse);
      expect(StorageService.instance.getString(StorageKeys.token), isEmpty);
    });
  });

  testWidgets('App launches SplashPage and navigates to PrivacyPage on first launch',
      (WidgetTester tester) async {
    // 设置标准手机竖屏视口尺寸 (375 x 812)
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const AppWithProvider());

    // 验证 MaterialApp 正常挂载
    expect(find.byType(MaterialApp), findsOneWidget);

    // 推进 SplashPage 的 2 秒启动检查定时器并完成路由跳转
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // 首次未同意隐私政策，应自动进入 PrivacyPage
    expect(find.byType(PrivacyPage), findsOneWidget);
  });
}
