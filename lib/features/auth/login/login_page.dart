import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/constants/app_constants.dart';
import 'package:flutter_easy_starter/core/constants/storage_keys.dart';
import 'package:flutter_easy_starter/core/router/route_names.dart';
import 'package:flutter_easy_starter/core/services/storage_service.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_easy_starter/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 登录页面 - Flutter Easy Starter 风格
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) async {
      if (previous?.isAuthenticated == false && next.isAuthenticated) {
        // 登录成功后检查是否是首次启动
        final isFirstLaunch = StorageService.instance.getBool(StorageKeys.isFirstLaunch) ?? true;
        if (isFirstLaunch) {
          // 首次启动，进入引导页
          context.go(RouteNames.landing);
        } else {
          // 非首次，进入主框架
          context.go(RouteNames.main);
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 顶部 Logo 区域
              _buildHeader(),

              // Tab 切换
              _buildTabBar(),

              // 表单区域 - 固定高度避免溢出
              SizedBox(
                height: 280.w,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _PasswordLoginForm(
                      isLoading: authState.isLoading,
                      error: authState.error,
                    ),
                    _PhoneLoginForm(
                      isLoading: authState.isLoading,
                      error: authState.error,
                    ),
                  ],
                ),
              ),

              // 底部其他登录方式
              _buildSocialLogin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(
        top: 60,
        bottom: 32,
      ),
      child: Column(
        children: [
          // Logo - 框架风格
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.rocket_launch,
              size: 40,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 24.w),
          Text(
            'Flutter Easy Starter',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            '登录后继续体验 Demo',
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.tertiaryGrey,
          borderRadius: BorderRadius.circular(12.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.lightGrey,
        labelStyle: TextStyle(fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 15.sp,
          fontWeight: FontWeight.normal,
        ),
        dividerHeight: 0,
        padding: EdgeInsets.all(4.w),
        tabs: [
          Tab(text: '账号密码'),
          Tab(text: '手机验证码'),
        ],
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Container(
      padding: EdgeInsets.fromLTRB(32, 16, 32, 24),
      child: Column(
        children: [
          // 第三方登录方式
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialLoginButton(
                icon: Icons.wechat,
                color: const Color(0xFF07C160),
                label: '微信',
                onTap: () => _loginWithWechat(),
              ),
              SizedBox(width: 32.w),
              _SocialLoginButton(
                icon: Icons.apple,
                color: AppColors.white,
                label: 'Apple',
                onTap: () {},
              ),
              SizedBox(width: 32.w),
              _SocialLoginButton(
                icon: Icons.bolt,
                color: AppColors.primary,
                label: '演示',
                onTap: () => _quickLogin(),
              ),
            ],
          ),

          SizedBox(height: 24.w),

          // 分隔线 + 演示账号
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '演示账号',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.lightGrey,
                  ),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
          SizedBox(height: 16.w),

          // 演示账号提示
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColors.lightGrey,
                ),
                SizedBox(width: 8.w),
                Text(
                  '账号: ${AppConstants.demoAccount} / 密码: ${AppConstants.demoPassword}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.lightGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loginWithWechat() async {
    final success = await ref.read(authProvider.notifier).loginWithWechat();
    if (!success && mounted) {
      final error = ref.read(authProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? '微信登录失败')),
      );
    }
  }

  Future<void> _quickLogin() async {
    final success = await ref.read(authProvider.notifier).loginWithPassword(
      username: AppConstants.demoAccount,
      password: AppConstants.demoPassword,
    );
    if (!success && mounted) {
      final error = ref.read(authProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? '登录失败')),
      );
    }
  }
}

/// 社交登录按钮 - 深色风格
class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String? label;
  final VoidCallback onTap;

  const _SocialLoginButton({
    required this.icon,
    required this.color,
    this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          if (label != null) ...[
            SizedBox(height: 8.w),
            Text(
              label!,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.lightGrey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 账号密码登录表单
class _PasswordLoginForm extends ConsumerStatefulWidget {
  final bool isLoading;
  final String? error;

  const _PasswordLoginForm({
    required this.isLoading,
    this.error,
  });

  @override
  ConsumerState<_PasswordLoginForm> createState() => _PasswordLoginFormState();
}

class _PasswordLoginFormState extends ConsumerState<_PasswordLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.error!)),
        );
        ref.read(authProvider.notifier).clearError();
      });
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // 用户名输入
            TextFormField(
              controller: _usernameController,
              style: TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                hintText: '用户名',
                hintStyle: TextStyle(color: AppColors.tertiaryGrey),
                prefixIcon: Icon(Icons.person_outline, color: AppColors.lightGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入用户名';
                }
                return null;
              },
            ),
            SizedBox(height: 16.w),
            // 密码输入
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                hintText: '密码',
                hintStyle: TextStyle(color: AppColors.tertiaryGrey),
                prefixIcon: Icon(Icons.lock_outline, color: AppColors.lightGrey),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.lightGrey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入密码';
                }
                if (value.length < 6) {
                  return '密码长度不能少于6位';
                }
                return null;
              },
            ),
            SizedBox(height: 12.w),
            // 忘记密码
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text('忘记密码?'),
              ),
            ),
            SizedBox(height: 8.w),
            // 登录按钮
            SizedBox(
              width: double.infinity,
              height: 52.w,
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: widget.isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text('登录',
                        style: TextStyle(fontSize: 16.sp),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).loginWithPassword(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );
  }
}

/// 手机验证码登录表单
class _PhoneLoginForm extends ConsumerStatefulWidget {
  final bool isLoading;
  final String? error;

  const _PhoneLoginForm({
    required this.isLoading,
    this.error,
  });

  @override
  ConsumerState<_PhoneLoginForm> createState() => _PhoneLoginFormState();
}

class _PhoneLoginFormState extends ConsumerState<_PhoneLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isCountingDown = false;
  int _countDown = 60;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // 手机号输入
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                hintText: '手机号',
                hintStyle: TextStyle(color: AppColors.tertiaryGrey),
                prefixIcon: Icon(Icons.phone_outlined, color: AppColors.lightGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入手机号';
                }
                if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
                  return '请输入正确的手机号';
                }
                return null;
              },
            ),
            SizedBox(height: 16.w),
            // 验证码输入
            TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                hintText: '验证码',
                hintStyle: TextStyle(color: AppColors.tertiaryGrey),
                prefixIcon: Icon(Icons.security_outlined, color: AppColors.lightGrey),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: TextButton(
                    onPressed: _isCountingDown || widget.isLoading
                        ? null
                        : _sendCode,
                    child: Text(
                      _isCountingDown ? '${_countDown}s' : '获取验证码',
                      style: TextStyle(
                        color: _isCountingDown
                            ? AppColors.lightGrey
                            : AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入验证码';
                }
                if (value.length != 6) {
                  return '验证码为6位数字';
                }
                return null;
              },
            ),
            SizedBox(height: 32.w),
            // 登录按钮
            SizedBox(
              width: double.infinity,
              height: 52.w,
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: widget.isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text('登录',
                        style: TextStyle(fontSize: 16.sp),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    final success = await ref.read(authProvider.notifier).sendSmsCode(phone);

    if (success) {
      setState(() {
        _isCountingDown = true;
        _countDown = 60;
      });

      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return false;
        setState(() {
          _countDown--;
        });
        if (_countDown <= 0) {
          setState(() {
            _isCountingDown = false;
          });
          return false;
        }
        return true;
      });
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).loginWithPhone(
      phone: _phoneController.text.trim(),
      code: _codeController.text.trim(),
    );
  }
}
