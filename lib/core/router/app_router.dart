import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/constants/storage_keys.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/services/storage_service.dart';
import 'package:flutter_easy_starter/features/auth/login/login_page.dart';
import 'package:flutter_easy_starter/features/auth/real_name_auth_page.dart';
import 'package:flutter_easy_starter/features/auth/user_info/user_info_page.dart';
import 'package:flutter_easy_starter/features/chat/chat_page.dart';
import 'package:flutter_easy_starter/features/gift_shop/gift_detail_page.dart';
import 'package:flutter_easy_starter/features/gift_shop/gift_shop_page.dart';
import 'package:flutter_easy_starter/features/help/help_feedback_page.dart';
import 'package:flutter_easy_starter/features/intro/intro_page.dart';
import 'package:flutter_easy_starter/features/landing/landing_page.dart';
import 'package:flutter_easy_starter/features/main/main_page.dart';
import 'package:flutter_easy_starter/features/message/message_page.dart';
import 'package:flutter_easy_starter/features/photos/my_photos_page.dart';
import 'package:flutter_easy_starter/features/privacy/privacy_page.dart';
import 'package:flutter_easy_starter/features/privacy/privacy_settings_page.dart';
import 'package:flutter_easy_starter/features/profile/profile_page.dart';
import 'package:flutter_easy_starter/features/splash/splash_page.dart';
import 'package:flutter_easy_starter/features/travel/pages/all_destinations_page.dart';
import 'package:flutter_easy_starter/features/travel/pages/travel_home_page.dart';
import 'package:flutter_easy_starter/features/user_detail/user_detail_page.dart';
import 'package:flutter_easy_starter/features/vip/vip_page.dart';
import 'package:flutter_easy_starter/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

/// App 路由配置
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  /// 无需登录即可访问的公开路由白名单
  static const Set<String> _publicRoutes = {
    RouteNames.splash,
    RouteNames.privacy,
    RouteNames.landing,
    RouteNames.login,
  };

  static final GoRouter _router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    refreshListenable: authListenable,
    redirect: (context, state) {
      final location = state.matchedLocation;

      // 启动页自行控制跳转节奏
      if (location == RouteNames.splash) {
        return null;
      }

      // 1. 隐私合规守卫：未同意隐私政策时强制重定向至隐私页
      final privacyAccepted = StorageService.instance.getBool(
        StorageKeys.privacyAccepted,
      );
      if (!privacyAccepted && location != RouteNames.privacy) {
        return RouteNames.privacy;
      }

      // 2. 登录态守卫：访问受保护页面但未登录（或 401 登出）时自动重定向至登录页
      final isLoggedIn = authListenable.value ||
          StorageService.instance.getString(StorageKeys.token).isNotEmpty;
      if (!isLoggedIn && !_publicRoutes.contains(location)) {
        return RouteNames.login;
      }

      return null;
    },
    routes: [
      // 启动页
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // 引导页
      GoRoute(
        path: RouteNames.landing,
        name: RouteNames.landing,
        builder: (context, state) => const LandingPage(),
      ),

      // 隐私政策页
      GoRoute(
        path: RouteNames.privacy,
        name: RouteNames.privacy,
        builder: (context, state) => const PrivacyPage(),
      ),

      // 登录页
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),

      // 主框架页面（StatefulShellRoute.indexedStack 管理底部 4 个独立分支路由栈）
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainPage(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: 介绍页
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.main,
                name: RouteNames.main,
                builder: (context, state) => const IntroPage(),
              ),
            ],
          ),
          // Tab 1: 探索页 (Travel 旅游页面)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.discover,
                name: RouteNames.discover,
                builder: (context, state) => const TravelHomePage(),
              ),
            ],
          ),
          // Tab 2: 消息页
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.messages,
                name: RouteNames.messages,
                builder: (context, state) => const MessagePage(),
              ),
            ],
          ),
          // Tab 3: 个人中心
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                name: RouteNames.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // 用户信息补充页
      GoRoute(
        path: RouteNames.userInfo,
        name: RouteNames.userInfo,
        builder: (context, state) => const UserInfoPage(),
      ),

      // 全部热门目的地
      GoRoute(
        path: RouteNames.allDestinations,
        name: RouteNames.allDestinations,
        builder: (context, state) => const AllDestinationsPage(),
      ),

      // 用户详情页
      GoRoute(
        path: RouteNames.userDetail,
        name: RouteNames.userDetail,
        builder: (context, state) {
          final userId = state.pathParameters['id'] ?? '';
          return UserDetailPage(userId: userId);
        },
      ),

      // 聊天页
      GoRoute(
        path: RouteNames.chat,
        name: RouteNames.chat,
        builder: (context, state) {
          final userId = state.pathParameters['id'] ?? '';
          return ChatPage(userId: userId);
        },
      ),

      // 礼物商城
      GoRoute(
        path: RouteNames.giftShop,
        name: RouteNames.giftShop,
        builder: (context, state) => const GiftShopPage(),
      ),

      // 礼物详情
      GoRoute(
        path: RouteNames.giftDetail,
        name: RouteNames.giftDetail,
        builder: (context, state) {
          final giftId = state.pathParameters['id'] ?? '';
          return GiftDetailPage(giftId: giftId);
        },
      ),

      // VIP会员
      GoRoute(
        path: RouteNames.vip,
        name: RouteNames.vip,
        builder: (context, state) => const VipPage(),
      ),

      // 隐私设置
      GoRoute(
        path: RouteNames.privacySettings,
        name: RouteNames.privacySettings,
        builder: (context, state) => const PrivacySettingsPage(),
      ),

      // 实名认证
      GoRoute(
        path: RouteNames.realNameAuth,
        name: RouteNames.realNameAuth,
        builder: (context, state) => const RealNameAuthPage(),
      ),

      // 我的照片
      GoRoute(
        path: RouteNames.myPhotos,
        name: RouteNames.myPhotos,
        builder: (context, state) => const MyPhotosPage(),
      ),

      // 帮助与反馈
      GoRoute(
        path: RouteNames.helpFeedback,
        name: RouteNames.helpFeedback,
        builder: (context, state) => const HelpFeedbackPage(),
      ),
    ],
  );

  /// 导航辅助方法
  static void go(String location, {Object? extra}) {
    router.go(location, extra: extra);
  }

  static void push(String location, {Object? extra}) {
    router.push(location, extra: extra);
  }

  static void replace(String location, {Object? extra}) {
    router.replace(location, extra: extra);
  }

  static void pop<T extends Object?>([T? result]) {
    router.pop(result);
  }

  static void goNamed(String name, {Map<String, String> pathParameters = const {}, Object? extra}) {
    router.goNamed(name, pathParameters: pathParameters, extra: extra);
  }

  static void pushNamed(String name, {Map<String, String> pathParameters = const {}, Object? extra}) {
    router.pushNamed(name, pathParameters: pathParameters, extra: extra);
  }

  /// 清空导航栈并跳转到指定页面
  static void goOffAll(String location, {Object? extra}) {
    router.go(location, extra: extra);
  }
}
