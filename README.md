# Flutter Easy Starter

Flutter 简易开箱即用框架 | 快速二次开发

## ✨ 特性

- ✅ **完整的启动流程**：启动页 → 隐私政策 → 引导页 → 登录 → 主页
- ✅ **隐私合规**：符合应用商店上架要求，必须同意隐私政策后才能初始化第三方SDK
- ✅ **多种登录方式**：账号密码、手机验证码、微信一键登录
- ✅ **状态管理**：使用 Riverpod，类型安全、性能优秀
- ✅ **路由管理**：使用 go_router，支持深度链接
- ✅ **网络请求**：Dio 封装，支持拦截器、统一响应、错误处理
- ✅ **第三方服务预留**：极光推送、微信登录/分享/支付（预留接口，需自行配置）
- ✅ **主题管理**：支持亮/暗模式切换
- ✅ **示例丰富**：登录页、主页、个人中心、信息补充等完整示例

## 🚀 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/reedtang666/flutter-easy-starter.git
cd flutter-easy-starter
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 运行项目

```bash
flutter run
```

### 4. 登录体验

**演示账号：**
- 账号：`test`
- 密码：`123456`

也可以直接使用"演示"快捷登录按钮。

## 📱 启动流程

```
Splash (启动页 2秒)
    ↓
判断隐私政策
    ↓ 未同意
PrivacyPage (隐私政策)
    ↓ 同意
GuidePage (引导页 首次启动展示)
    ↓
判断登录状态
    ↓ 未登录
LoginPage (登录页)
    ↓ 登录成功
UserInfoPage (信息补充页，可选)
    ↓
HomePage (主页)
```

## 📁 目录结构

```
lib/
├── main.dart                      # App 入口
├── app.dart                       # MaterialApp 配置
├── core/                          # 核心层
│   ├── constants/                 # 常量
│   │   ├── app_constants.dart     # App信息
│   │   ├── api_constants.dart     # API地址
│   │   └── storage_keys.dart      # 存储Key
│   ├── router/                    # 路由
│   │   ├── app_router.dart        # go_router配置
│   │   └── route_names.dart       # 路由名称
│   ├── services/                  # 服务
│   │   ├── http_service.dart      # Dio封装
│   │   ├── storage_service.dart   # 本地存储
│   │   ├── push_service.dart      # 极光推送预留
│   │   └── wechat_service.dart    # 微信SDK预留
│   ├── theme/                     # 主题
│   │   ├── app_colors.dart        # 颜色配置
│   │   ├── app_theme.dart         # 亮/暗主题
│   │   └── theme_provider.dart    # 主题状态
│   └── utils/                     # 工具类
├── features/                      # 功能模块
│   ├── splash/                    # 启动页
│   ├── privacy/                   # 隐私政策
│   ├── guide/                     # 引导页
│   ├── auth/                      # 认证
│   │   ├── login/                 # 登录页
│   │   └── user_info/             # 信息补充
│   ├── home/                      # 主页
│   └── profile/                   # 个人中心
├── models/                        # 数据模型
│   ├── api_response.dart
│   └── user_model.dart
├── providers/                     # 全局状态
│   └── auth_provider.dart
└── widgets/                       # 通用组件
```

## ⚙️ 配置第三方服务

### 1. 极光推送

**获取 AppKey：**
1. 前往极光官网注册：https://www.jiguang.cn/
2. 创建应用，获取 AppKey

**Android 配置：**

修改 `android/app/build.gradle`：
```gradle
android {
    defaultConfig {
        manifestPlaceholders = [
            JPUSH_APPKEY: "your_app_key",
            JPUSH_CHANNEL: "developer-default",
        ]
    }
}
```

**iOS 配置：**

修改 `ios/Runner/Info.plist`：
```xml
<key>jiguang_appKey</key>
<string>your_app_key</string>
```

**代码启用：**

编辑 `lib/core/services/push_service.dart`，取消 `init` 方法的注释。

编辑 `lib/features/privacy/privacy_manager.dart`，取消 `_initJPush` 中相关代码的注释。

### 2. 微信 SDK

**获取 AppID：**
1. 前往微信开放平台：https://open.weixin.qq.com/
2. 注册应用，获取 AppID
3. 配置 Universal Link（iOS 必须）

**Android 配置：**

修改 `android/app/build.gradle`：
```gradle
android {
    defaultConfig {
        manifestPlaceholders = [
            WX_APP_ID: "your_wx_app_id",
        ]
    }
}
```

**iOS 配置：**

1. 修改 `ios/Runner/Info.plist`
2. 配置 URL Types
3. 配置 Universal Link

**代码启用：**

编辑 `lib/core/services/wechat_service.dart`，取消相关方法的注释。

编辑 `lib/features/privacy/privacy_manager.dart`，取消 `_initWechat` 中相关代码的注释。

### 3. 隐私政策动态获取（可选）

当前隐私政策为本地 HTML，如需从服务器动态获取：

1. 编辑 `lib/features/privacy/privacy_page.dart`
2. 修改 `PrivacyContent.htmlContent` 为网络请求获取
3. 添加加载状态和错误处理

## 🔧 自定义配置

### 修改 App 信息

编辑 `lib/core/constants/app_constants.dart`：
```dart
static const String appName = '您的应用名称';
static const String appVersion = '1.0.0';
```

### 修改 API 地址

编辑 `lib/core/constants/api_constants.dart`：
```dart
static String get baseUrl {
  if (isProduction) {
    return 'https://your-production-api.com';
  }
  return 'https://your-dev-api.com';
}
```

### 修改引导页内容

编辑 `lib/features/guide/guide_page.dart`：
```dart
const List<GuideItem> guideItems = [
  GuideItem(
    title: '您的标题',
    subtitle: '您的描述',
    icon: Icons.your_icon,
    color: YourColor,
  ),
  // ...
];
```

### 添加新的路由

1. 在 `lib/core/router/route_names.dart` 添加路由名：
```dart
static const String myPage = '/my-page';
```

2. 在 `lib/core/router/app_router.dart` 添加路由配置：
```dart
GoRoute(
  path: RouteNames.myPage,
  name: RouteNames.myPage,
  builder: (context, state) => const MyPage(),
),
```

## 📦 依赖说明

| 包名 | 用途 | 版本 |
|------|------|------|
| flutter_riverpod | 状态管理 | ^2.5.1 |
| go_router | 路由管理 | ^14.1.0 |
| dio | 网络请求 | ^5.4.0 |
| shared_preferences | 本地存储 | ^2.2.2 |
| flutter_screenutil | 屏幕适配 | ^5.9.0 |
| jpush_flutter | 极光推送 | ^3.2.8 |
| fluwx | 微信SDK | ^5.7.0 |
| flutter_html | HTML渲染 | ^3.0.0-beta.2 |
| smooth_page_indicator | 页面指示器 | ^1.1.0 |

## 🎯 下一步开发

### 添加新页面

1. 在 `lib/features/` 创建新文件夹
2. 创建 `xxx_page.dart` 和 `xxx_controller.dart`
3. 在 `lib/core/router/` 注册路由
4. 使用 `context.go(RouteNames.xxx)` 跳转

### 添加新 API

1. 在 `lib/core/constants/api_constants.dart` 添加 API 路径
2. 在 Service 或 Provider 中调用：
```dart
final response = await HttpService.instance.post<UserModel>(
  ApiConstants.login,
  data: {'username': username, 'password': password},
  fromJsonT: (json) => UserModel.fromJson(json),
);
```

### 状态管理

使用 Riverpod：
```dart
// 定义 Provider
final myProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier();
});

// 在 Widget 中使用
final state = ref.watch(myProvider);
ref.read(myProvider.notifier).someMethod();
```

## 📄 许可证

MIT License

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📧 联系方式

- 邮箱：your-email@example.com
- GitHub：https://github.com/reedtang666/flutter-easy-starter
