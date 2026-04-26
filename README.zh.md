# Flutter Easy Starter 🚀

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-blue.svg" alt="Flutter 版本">
  <img src="https://img.shields.io/badge/Dart-3.0+-blue.svg" alt="Dart 版本">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="许可证">
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-9cf.svg" alt="平台">
</p>

<p align="center">
  <a href="./README.md">English</a> | <b>中文</b>
</p>

<p align="center">
  <b>开箱即用的 Flutter 快速开发框架</b><br>
  <i>生产级 Flutter 启动模板，拥有整洁架构、精美 UI 和丰富功能</i>
</p>

---

## 📋 目录

- [功能特性](#-功能特性)
- [截图预览](#-截图预览)
- [快速开始](#-快速开始)
- [架构设计](#-架构设计)
- [项目结构](#-项目结构)
- [动画系统](#-动画系统)
- [UI 组件](#-ui-组件)
- [配置指南](#-配置指南)
- [API 参考](#-api-参考)
- [常见问题](#-常见问题)

---

## ✨ 功能特性

### 🎨 UI/UX 精品设计

| 功能 | 描述 | 状态 |
|---------|-------------|--------|
| **深色主题** | 优雅的深色模式，紫色强调色 | ✅ |
| **动画系统** | 微交互、骨架屏、闪烁效果 | ✅ |
| **响应式布局** | 使用 flutter_screenutil 屏幕适配 | ✅ |
| **玻璃拟态** | 毛玻璃效果贯穿整个应用 | ✅ |
| **渐变图标** | Lucide 图标配合渐变背景 | ✅ |

### 🏗️ 架构设计

| 功能 | 描述 | 状态 |
|---------|-------------|--------|
| **整洁架构** | 功能优先的分层架构 | ✅ |
| **Riverpod** | 类型安全的状态管理 | ✅ |
| **Go Router** | 声明式路由，支持深度链接 | ✅ |
| **Dio** | 支持拦截器的 HTTP 客户端 | ✅ |
| **仓库模式** | 抽象的数据层 | ✅ |

### 📱 完整流程

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   启动页    │────▶│  隐私政策   │────▶│   引导页    │
│   (2秒)     │     │             │     │  (首次启动) │
└─────────────┘     └─────────────┘     └─────────────┘
                                                │
                        ┌───────────────────────┘
                        ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    主页     │◀────│   登录页    │◀────│  登录状态   │
│             │     │             │     │   检查      │
└─────────────┘     └─────────────┘     └─────────────┘
```

### 🎯 内置页面

- **启动页** - 带动画的品牌启动屏幕
- **隐私政策** - 符合 GDPR 的隐私政策，支持 HTML 渲染
- **引导页** - 带平滑页面指示器的 onboarding
- **登录页** - 多种认证方式（密码、短信、微信）
- **用户信息** - 带图片选择器的资料完善页
- **主页/旅游** - 带 hero 动画的目的地浏览
- **消息** - 带故事环和滑动操作的聊天列表
- **个人中心** - 带 VIP 会员的用户资料
- **礼物商店** - 带购物车功能的精美礼品店
- **VIP** - 带发光效果的订阅计划页

---

## 📸 截图预览

<p align="center">
  <i>截图将在此添加</i>
</p>

---

## 🚀 快速开始

### 环境要求

```bash
# Flutter 3.0 或更高版本
flutter --version

# Dart 3.0 或更高版本
dart --version
```

### 安装步骤

```bash
# 克隆仓库
git clone https://github.com/reedtang666/flutter-easy-starter.git

# 进入项目目录
cd flutter-easy-starter

# 安装依赖
flutter pub get

# 运行应用
flutter run
```

### 演示账号

```
用户名: test
密码: 123456
```

或使用 **"演示登录"** 按钮快速进入。

---

## 🏗️ 架构设计

### 整洁架构分层

```
┌─────────────────────────────────────────┐
│              表现层 (Presentation)       │
│  ┌─────────┐ ┌─────────┐ ┌──────────┐  │
│  │  页面   │ │  组件   │ │ 状态管理 │  │
│  └────┬────┘ └────┬────┘ └────┬─────┘  │
│       └─────────────┴─────────┘         │
├─────────────────────────────────────────┤
│              领域层 (Domain)             │
│  ┌─────────┐ ┌─────────┐ ┌──────────┐  │
│  │  模型   │ │ 用例    │ │ 仓库接口 │  │
│  │         │ │         │ │          │  │
│  └────┬────┘ └────┬────┘ └────┬─────┘  │
│       └─────────────┴─────────┘         │
├─────────────────────────────────────────┤
│              数据层 (Data)               │
│  ┌─────────┐ ┌─────────┐ ┌──────────┐  │
│  │ 仓库实现│ │  API    │ │  本地    │  │
│  │         │ │         │ │ 存储     │  │
│  └─────────┘ └─────────┘ └──────────┘  │
└─────────────────────────────────────────┘
```

### Riverpod 状态管理

```dart
// 定义 Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// 在组件中使用
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);
    
    return ElevatedButton(
      onPressed: () => ref.read(authProvider.notifier).login(),
      child: Text('登录'),
    );
  }
}
```

---

## 📁 项目结构

```
flutter-easy-starter/
├── android/                      # Android 平台代码
├── ios/                          # iOS 平台代码
├── assets/                       # 静态资源
│   ├── images/                   # 图片资源
│   │   ├── profiles/            # 用户头像
│   │   ├── guide/               # 引导页图片
│   │   └── travel/              # 旅游目的地图片
│   ├── animations/              # Lottie 动画
│   └── fonts/                   # 自定义字体（可选）
├── lib/
│   ├── main.dart                # 应用入口
│   ├── app.dart                 # MaterialApp 配置
│   │
│   ├── core/                    # 核心层（共享）
│   │   ├── constants/           # 应用常量
│   │   │   ├── app_constants.dart
│   │   │   ├── api_constants.dart
│   │   │   └── storage_keys.dart
│   │   ├── router/              # 导航
│   │   │   ├── app_router.dart  # GoRouter 配置
│   │   │   └── route_names.dart # 路由常量
│   │   ├── services/            # 业务服务
│   │   │   ├── http_service.dart    # Dio 封装
│   │   │   ├── storage_service.dart # SharedPreferences
│   │   │   ├── push_service.dart    # 极光推送集成
│   │   │   └── wechat_service.dart  # 微信 SDK
│   │   ├── theme/               # 主题
│   │   │   ├── app_colors.dart  # 颜色配置
│   │   │   ├── app_theme.dart   # 亮/暗主题
│   │   │   └── theme_provider.dart
│   │   ├── utils/               # 工具类
│   │   │   ├── dialog_utils.dart
│   │   │   └── validators.dart
│   │   └── widgets/             # 共享组件
│   │       ├── animated_button.dart   # 动画系统
│   │       ├── shimmer_widgets.dart   # 骨架屏
│   │       └── empty_widgets.dart     # 空状态
│   │
│   ├── features/                # 功能模块
│   │   ├── splash/              # 启动页
│   │   ├── privacy/             # 隐私政策
│   │   ├── guide/               # 引导页
│   │   ├── auth/                # 认证
│   │   │   ├── login/
│   │   │   ├── user_info/
│   │   │   └── real_name_auth/
│   │   ├── intro/               # 介绍页
│   │   ├── travel/              # 旅游功能
│   │   │   ├── pages/
│   │   │   └── widgets/
│   │   ├── message/             # 消息
│   │   │   ├── models/
│   │   │   └── widgets/
│   │   ├── chat/                # 聊天功能
│   │   ├── profile/             # 个人中心
│   │   ├── vip/                 # VIP 会员
│   │   ├── gift_shop/           # 礼物商店
│   │   ├── photos/              # 照片画廊
│   │   ├── help/                # 帮助与反馈
│   │   └── main/                # 主框架（底部导航）
│   │
│   ├── models/                  # 数据模型
│   │   ├── user_model.dart
│   │   └── api_response.dart
│   │
│   └── providers/               # 全局状态
│       └── auth_provider.dart
│
├── test/                        # 单元测试
├── pubspec.yaml                 # 依赖配置
└── README.md                    # 本文档
```

---

## 🎬 动画系统

### 内置动画组件

我们的动画系统提供了即开即用的常用动画模式：

#### 1. AnimatedButton（动画按钮）

带触觉反馈的点击动画：

```dart
AnimatedButton(
  onTap: () => print('点击!'),
  scaleDown: 0.95,
  enableHaptic: true,
  hapticType: HapticFeedbackType.medium,
  child: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text('点我'),
  ),
)
```

#### 2. PulseAnimation（脉冲动画）

吸引注意力的脉冲效果：

```dart
PulseAnimation(
  duration: Duration(milliseconds: 1500),
  minScale: 1.0,
  maxScale: 1.05,
  child: MyWidget(),
)
```

#### 3. StaggeredAnimation（交错动画）

列表的交错入场动画：

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return StaggeredAnimation(
      index: index,
      type: AnimationType.slideUp,
      child: ListTile(...),
    );
  },
)
```

#### 4. AnimatedGlowCard（发光卡片）

带选中发光效果的卡片：

```dart
AnimatedGlowCard(
  isSelected: isSelected,
  onTap: () => setState(() => isSelected = !isSelected),
  glowColor: AppColors.primary,
  child: MyContent(),
)
```

### 动画时长规范

| 类型 | 时长 | 使用场景 |
|------|----------|----------|
| `AppDurations.fast` | 150ms | 微交互、按钮点击 |
| `AppDurations.normal` | 300ms | 页面切换、卡片展开 |
| `AppDurations.slow` | 500ms | 复杂过渡、Hero 动画 |

---

## 🎨 UI 组件

### FrostedWidget（毛玻璃效果）

创建精美的毛玻璃效果：

```dart
FrostedWidget(
  borderRadius: 20,
  blurSigma: 20,
  backgroundColor: Colors.white.withOpacity(0.1),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('毛玻璃内容'),
  ),
)
```

### Shimmer Loading（闪烁加载）

加载状态的骨架屏：

```dart
// 列表骨架屏
ShimmerList(
  itemCount: 6,
  hasImage: true,
  hasSubtitle: true,
)

// 网格骨架屏
ShimmerGrid(
  crossAxisCount: 3,
  itemCount: 9,
)

// 自定义骨架屏
ShimmerContainer(
  width: 200,
  height: 100,
  borderRadius: 12,
)
```

### Empty States（空状态）

精美的空状态和错误状态：

```dart
// 空状态
EmptyWidget(
  icon: LucideIcons.inbox,
  title: '暂无消息',
  subtitle: '开始对话后，消息将显示在这里',
  onRetry: () => loadData(),
)

// 错误状态
AppErrorWidget(
  message: '加载失败',
  onRetry: () => retry(),
)

// 加载状态
LoadingWidget(
  message: '加载中...',
)
```

---

## ⚙️ 配置指南

### 应用常量

编辑 `lib/core/constants/app_constants.dart`：

```dart
class AppConstants {
  static const String appName = '我的应用';
  static const String appVersion = '1.0.0';
  static const String apiBaseUrl = 'https://api.example.com';
}
```

### 主题定制

编辑 `lib/core/theme/app_colors.dart`：

```dart
class AppColors {
  // 品牌主色
  static const Color primary = Color(0xFFAF52DE);
  static const Color primaryLight = Color(0xFFBF5AF2);
  
  // 背景色
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1C1C1E);
  
  // 文字颜色
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFF8E8E93);
}
```

### 添加新路由

1. 在 `lib/core/router/route_names.dart` 添加路由名：

```dart
class RouteNames {
  static const String myPage = '/my-page';
}
```

2. 在 `lib/core/router/app_router.dart` 添加路由配置：

```dart
GoRoute(
  path: RouteNames.myPage,
  name: RouteNames.myPage,
  builder: (context, state) => const MyPage(),
),
```

3. 使用路由跳转：

```dart
context.go(RouteNames.myPage);
// 或
context.push(RouteNames.myPage);
```

---

## 📡 API 参考

### HTTP 服务

`HttpService` 提供了 Dio 的封装：

```dart
// GET 请求
final response = await HttpService.instance.get<List<User>>(
  '/users',
  fromJsonT: (json) => (json as List).map((e) => User.fromJson(e)).toList(),
);

// POST 请求
final response = await HttpService.instance.post<User>(
  '/users',
  data: {'name': 'John', 'email': 'john@example.com'},
  fromJsonT: (json) => User.fromJson(json),
);

// 文件上传
final response = await HttpService.instance.uploadFile(
  '/upload',
  filePath: '/path/to/file.jpg',
);
```

### 存储服务

使用 SharedPreferences 的本地存储：

```dart
// 保存数据
await StorageService.instance.setString('key', 'value');
await StorageService.instance.setBool('isLoggedIn', true);
await StorageService.instance.setInt('userId', 123);

// 读取数据
final value = StorageService.instance.getString('key');
final isLoggedIn = StorageService.instance.getBool('isLoggedIn');

// 删除数据
await StorageService.instance.remove('key');

// 清空所有
await StorageService.instance.clear();
```

---

## 🔧 第三方服务

### 1. 极光推送 (JPush)

**Android 配置：**

编辑 `android/app/build.gradle`：

```gradle
android {
    defaultConfig {
        manifestPlaceholders = [
            JPUSH_APPKEY: "your_jpush_appkey",
            JPUSH_CHANNEL: "developer-default",
        ]
    }
}
```

**iOS 配置：**

编辑 `ios/Runner/Info.plist`：

```xml
<key>jiguang_appKey</key>
<string>your_jpush_appkey</string>
```

**代码中启用：**

取消以下文件中的相关代码注释：
- `lib/core/services/push_service.dart`
- `lib/features/privacy/privacy_manager.dart`

### 2. 微信 SDK

**Android 配置：**

编辑 `android/app/build.gradle`：

```gradle
android {
    defaultConfig {
        manifestPlaceholders = [
            WX_APP_ID: "your_wechat_appid",
        ]
    }
}
```

**iOS 配置：**

1. 在 `ios/Runner/Info.plist` 中配置 URL Types
2. 配置 Universal Link

**代码中启用：**

取消以下文件中的相关代码注释：
- `lib/core/services/wechat_service.dart`
- `lib/features/privacy/privacy_manager.dart`

---

## 🐛 常见问题

### 构建问题

**问题：** `Gradle task assembleDebug failed`

**解决：**
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter run
```

**问题：** iOS 上 CocoaPods 错误

**解决：**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

### 运行问题

**问题：** 图片无法加载

**解决：** 确保在 `pubspec.yaml` 中声明了资源：

```yaml
flutter:
  assets:
    - assets/images/
    - assets/images/profiles/
```

**问题：** 路由不工作

**解决：** 检查 `route_names.dart` 和 `app_router.dart` 中的路由名称是否完全匹配。

---

## 📦 依赖列表

### 核心依赖

| 包名 | 版本 | 用途 |
|---------|---------|---------|
| flutter_riverpod | ^2.5.1 | 状态管理 |
| riverpod_annotation | ^2.3.5 | 代码生成 |
| go_router | ^14.1.0 | 路由 |
| dio | ^5.4.0 | HTTP 客户端 |
| flutter_screenutil | ^5.9.0 | 屏幕适配 |

### UI 依赖

| 包名 | 版本 | 用途 |
|---------|---------|---------|
| flutter_lucide | ^1.4.0 | 现代图标 |
| shimmer | ^3.0.0 | 骨架屏 |
| smooth_page_indicator | ^1.1.0 | 页面指示器 |
| flutter_slidable | ^3.1.0 | 滑动操作 |
| flutter_easyloading | ^3.0.5 | 加载指示器 |

### 第三方服务

| 包名 | 版本 | 用途 |
|---------|---------|---------|
| jpush_flutter | ^3.2.8 | 推送通知 |
| fluwx | ^5.7.0 | 微信集成 |
| flutter_html | ^3.0.0-beta.2 | HTML 渲染 |

---

## 🤝 贡献指南

欢迎贡献！请按以下步骤操作：

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m '添加 amazing 功能'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

### 提交规范

- `feat:` 新功能
- `fix:` Bug 修复
- `docs:` 文档更改
- `style:` 代码格式更改
- `refactor:` 代码重构
- `test:` 测试更改
- `chore:` 构建/依赖更改

---

## 📝 许可证

本项目采用 MIT 许可证 - 详情见 [LICENSE](LICENSE) 文件。

---

## 👤 作者

**Reed Tang**

- GitHub: [@reedtang666](https://github.com/reedtang666)
- 邮箱: your-email@example.com

---

## 🙏 致谢

- [Flutter Team](https://flutter.dev) 提供优秀的框架
- [Riverpod](https://riverpod.dev) 提供卓越的状态管理
- [Lucide](https://lucide.dev) 提供精美的图标
- 所有帮助改进本项目的贡献者

---

<p align="center">
  使用 ❤️ 和 Flutter 构建
</p>
