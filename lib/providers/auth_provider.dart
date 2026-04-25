import 'package:flutter_easy_starter/core/constants/app_constants.dart';
import 'package:flutter_easy_starter/core/constants/storage_keys.dart';
import 'package:flutter_easy_starter/core/services/http_service.dart';
import 'package:flutter_easy_starter/core/services/storage_service.dart';
import 'package:flutter_easy_starter/models/api_response.dart';
import 'package:flutter_easy_starter/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 认证状态
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

/// 认证状态 Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  /// 初始化：检查本地登录状态
  Future<void> _init() async {
    final token = StorageService.instance.getString(StorageKeys.token);
    if (token.isNotEmpty) {
      // 有token，尝试获取用户信息
      await _getUserInfo();
    }
  }

  /// 账号密码登录
  Future<bool> loginWithPassword({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 这里应该调用实际的登录接口
      // 模拟登录成功
      if (username == AppConstants.demoAccount &&
          password == AppConstants.demoPassword) {
        // 保存 token
        await StorageService.instance.setString(StorageKeys.token, 'demo_token');
        await StorageService.instance.setString(
          StorageKeys.refreshToken,
          'demo_refresh_token',
        );

        // 创建用户信息
        final user = UserModel(
          id: '1',
          username: username,
          nickname: '演示用户',
          avatar: 'assets/images/avatar_default.png',
        );

        await StorageService.instance.setString(
          StorageKeys.userInfo,
          user.toString(),
        );

        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: user,
        );

        return true;
      }

      // 调用实际登录接口
      /*
      final response = await HttpService.instance.post<Map<String, dynamic>>(
        ApiConstants.login,
        data: {
          'username': username,
          'password': password,
        },
        fromJsonT: (json) => json,
      );

      if (response.success && response.data != null) {
        final token = response.data!['token'];
        final refreshToken = response.data!['refreshToken'];

        await StorageService.instance.setString(StorageKeys.token, token);
        await StorageService.instance.setString(
          StorageKeys.refreshToken,
          refreshToken,
        );

        await _getUserInfo();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
        return false;
      }
      */

      // 模拟登录失败
      state = state.copyWith(
        isLoading: false,
        error: '用户名或密码错误',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '登录失败: $e',
      );
      return false;
    }
  }

  /// 手机号验证码登录
  Future<bool> loginWithPhone({
    required String phone,
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 调用实际的短信登录接口
      // 这里模拟成功
      await Future.delayed(const Duration(seconds: 1));

      // 保存 token
      await StorageService.instance.setString(StorageKeys.token, 'phone_token');

      // 创建用户信息
      final user = UserModel(
        id: '2',
        username: phone,
        nickname: '手机用户',
        phone: phone,
        avatar: 'assets/images/avatar_default.png',
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '登录失败: $e',
      );
      return false;
    }
  }

  /// 微信登录
  Future<bool> loginWithWechat() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 调用微信 SDK 登录
      // await Fluwx().authBy(which: NormalAuth);
      // 获取到 code 后传给后端

      // 模拟成功
      await Future.delayed(const Duration(seconds: 1));

      await StorageService.instance.setString(StorageKeys.token, 'wechat_token');

      final user = UserModel(
        id: '3',
        username: 'wechat_user',
        nickname: '微信用户',
        avatar: 'assets/images/avatar_default.png',
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '微信登录失败: $e',
      );
      return false;
    }
  }

  /// 发送短信验证码
  Future<bool> sendSmsCode(String phone) async {
    // TODO: 调用实际的验证码接口
    // await HttpService.instance.post(ApiConstants.sendSmsCode, data: {'phone': phone});
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// 获取用户信息
  Future<void> _getUserInfo() async {
    try {
      /*
      final response = await HttpService.instance.get<UserModel>(
        ApiConstants.userInfo,
        fromJsonT: (json) => UserModel.fromJson(json),
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          isAuthenticated: true,
          user: response.data,
        );
      }
      */

      // 模拟获取用户信息
      await Future.delayed(const Duration(milliseconds: 300));
      final user = UserModel(
        id: '1',
        username: 'test',
        nickname: '演示用户',
        avatar: 'assets/images/avatar_default.png',
      );

      state = state.copyWith(
        isAuthenticated: true,
        user: user,
      );
    } catch (e) {
      // 获取失败，清除登录状态
      await logout();
    }
  }

  /// 更新用户信息
  Future<bool> updateUserInfo(UserModel user) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      /*
      final response = await HttpService.instance.put<UserModel>(
        ApiConstants.updateUserInfo,
        data: user.toJson(),
        fromJsonT: (json) => UserModel.fromJson(json),
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          isLoading: false,
          user: response.data,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
        return false;
      }
      */

      // 模拟更新成功
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(
        isLoading: false,
        user: user,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '更新失败: $e',
      );
      return false;
    }
  }

  /// 退出登录
  Future<void> logout() async {
    // 清除本地存储
    await StorageService.instance.remove(StorageKeys.token);
    await StorageService.instance.remove(StorageKeys.refreshToken);
    await StorageService.instance.remove(StorageKeys.userInfo);

    state = const AuthState(
      isLoading: false,
      isAuthenticated: false,
      user: null,
    );
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// 认证 Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
