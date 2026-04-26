# Flutter Easy Starter 🚀

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-blue.svg" alt="Flutter Version">
  <img src="https://img.shields.io/badge/Dart-3.0+-blue.svg" alt="Dart Version">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-9cf.svg" alt="Platform">
</p>

<p align="center">
  <b>English</b> | <a href="./README.zh.md">中文</a>
</p>

<p align="center">
  <b>开箱即用的 Flutter 快速开发框架</b><br>
  <i>Production-ready Flutter starter with clean architecture, beautiful UI, and comprehensive features</i>
</p>

---

## 📋 Table of Contents

- [Features](#-features)
- [Screenshots](#-screenshots)
- [Quick Start](#-quick-start)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Animation System](#-animation-system)
- [UI Components](#-ui-components)
- [Configuration](#-configuration)
- [API Reference](#-api-reference)
- [Troubleshooting](#-troubleshooting)

---

## ✨ Features

### 🎨 UI/UX Excellence

| Feature | Description | Status |
|---------|-------------|--------|
| **Dark Theme** | Elegant dark mode with purple accent | ✅ |
| **Animations** | Micro-interactions, skeleton screens, shimmer effects | ✅ |
| **Responsive** | Screen adaptation with flutter_screenutil | ✅ |
| **Glassmorphism** | Frosted glass effects throughout the app | ✅ |
| **Gradient Icons** | Lucide icons with gradient backgrounds | ✅ |

### 🏗️ Architecture

| Feature | Description | Status |
|---------|-------------|--------|
| **Clean Architecture** | Feature-first, layered architecture | ✅ |
| **Riverpod** | Type-safe state management | ✅ |
| **Go Router** | Declarative routing with deep links | ✅ |
| **Dio** | HTTP client with interceptors | ✅ |
| **Repository Pattern** | Abstracted data layer | ✅ |

### 📱 Complete Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Splash     │────▶│   Privacy   │────▶│   Guide     │
│  (2s)       │     │   Policy    │     │   (First)   │
└─────────────┘     └─────────────┘     └─────────────┘
                                                │
                        ┌───────────────────────┘
                        ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Home      │◀────│   Login     │◀────│   Auth      │
│             │     │             │     │   Check     │
└─────────────┘     └─────────────┘     └─────────────┘
```

### 🎯 Pre-built Pages

- **Splash** - Branded launch screen with animation
- **Privacy** - GDPR-compliant privacy policy with HTML rendering
- **Guide** - Onboarding with smooth page indicators
- **Login** - Multiple auth methods (password, SMS, WeChat)
- **User Info** - Profile completion with image picker
- **Home/Travel** - Destination browsing with hero animations
- **Message** - Chat list with stories, swipe actions
- **Profile** - User profile with VIP membership
- **Gift Shop** - Beautiful gift store with cart functionality
- **VIP** - Subscription plans with glowing effects

---

## 📸 Screenshots

<p align="center">
  <i>Screenshots will be added here</i>
</p>

---

## 🚀 Quick Start

### Prerequisites

```bash
# Flutter 3.0 or higher
flutter --version

# Dart 3.0 or higher
dart --version
```

### Installation

```bash
# Clone the repository
git clone https://github.com/reedtang666/flutter-easy-starter.git

# Navigate to project
cd flutter-easy-starter

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Demo Credentials

```
Username: test
Password: 123456
```

Or use the **"演示登录"** (Demo Login) button for instant access.

---

## 🏗️ Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  ┌─────────┐ ┌─────────┐ ┌──────────┐  │
│  │  Pages  │ │ Widgets │ │ Providers│  │
│  └────┬────┘ └────┬────┘ └────┬─────┘  │
│       └─────────────┴─────────┘         │
├─────────────────────────────────────────┤
│           Domain Layer                  │
│  ┌─────────┐ ┌─────────┐ ┌──────────┐  │
│  │  Models │ │Use Cases│ │Repository│  │
│  │         │ │         │ │ Interface│  │
│  └────┬────┘ └────┬────┘ └────┬─────┘  │
│       └─────────────┴─────────┘         │
├─────────────────────────────────────────┤
│           Data Layer                    │
│  ┌─────────┐ ┌─────────┐ ┌──────────┐  │
│  │  Repos  │ │  APIs   │ │  Local   │  │
│  │         │ │         │ │ Storage  │  │
│  └─────────┘ └─────────┘ └──────────┘  │
└─────────────────────────────────────────┘
```

### State Management with Riverpod

```dart
// Define a provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Use in widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);
    
    return ElevatedButton(
      onPressed: () => ref.read(authProvider.notifier).login(),
      child: Text('Login'),
    );
  }
}
```

---

## 📁 Project Structure

```
flutter-easy-starter/
├── android/                      # Android platform code
├── ios/                          # iOS platform code
├── assets/                       # Static resources
│   ├── images/                   # Image assets
│   │   ├── profiles/            # User avatars
│   │   ├── guide/               # Onboarding images
│   │   └── travel/              # Travel destination images
│   ├── animations/              # Lottie animations
│   └── fonts/                   # Custom fonts (optional)
├── lib/
│   ├── main.dart                # Application entry point
│   ├── app.dart                 # MaterialApp configuration
│   │
│   ├── core/                    # Core layer (shared)
│   │   ├── constants/           # App constants
│   │   │   ├── app_constants.dart
│   │   │   ├── api_constants.dart
│   │   │   └── storage_keys.dart
│   │   ├── router/              # Navigation
│   │   │   ├── app_router.dart  # GoRouter configuration
│   │   │   └── route_names.dart # Route constants
│   │   ├── services/            # Business services
│   │   │   ├── http_service.dart    # Dio wrapper
│   │   │   ├── storage_service.dart # SharedPreferences
│   │   │   ├── push_service.dart    # JPush integration
│   │   │   └── wechat_service.dart  # WeChat SDK
│   │   ├── theme/               # Theming
│   │   │   ├── app_colors.dart  # Color palette
│   │   │   ├── app_theme.dart   # Light/Dark themes
│   │   │   └── theme_provider.dart
│   │   ├── utils/               # Utilities
│   │   │   ├── dialog_utils.dart
│   │   │   └── validators.dart
│   │   └── widgets/             # Shared widgets
│   │       ├── animated_button.dart   # Animation system
│   │       ├── shimmer_widgets.dart   # Skeleton screens
│   │       └── empty_widgets.dart     # Empty states
│   │
│   ├── features/                # Feature modules
│   │   ├── splash/              # Launch screen
│   │   ├── privacy/             # Privacy policy
│   │   ├── guide/               # Onboarding
│   │   ├── auth/                # Authentication
│   │   │   ├── login/
│   │   │   ├── user_info/
│   │   │   └── real_name_auth/
│   │   ├── intro/               # Introduction page
│   │   ├── travel/              # Travel feature
│   │   │   ├── pages/
│   │   │   └── widgets/
│   │   ├── message/             # Messaging
│   │   │   ├── models/
│   │   │   └── widgets/
│   │   ├── chat/                # Chat functionality
│   │   ├── profile/             # User profile
│   │   ├── vip/                 # VIP membership
│   │   ├── gift_shop/           # Gift store
│   │   ├── photos/              # Photo gallery
│   │   ├── help/                # Help & feedback
│   │   └── main/                # Main shell with bottom nav
│   │
│   ├── models/                  # Data models
│   │   ├── user_model.dart
│   │   └── api_response.dart
│   │
│   └── providers/               # Global providers
│       └── auth_provider.dart
│
├── test/                        # Unit tests
├── pubspec.yaml                 # Dependencies
└── README.md                    # This file
```

---

## 🎬 Animation System

### Built-in Animations

Our animation system provides ready-to-use widgets for common animation patterns:

#### 1. AnimatedButton

Tap animations with haptic feedback:

```dart
AnimatedButton(
  onTap: () => print('Tapped!'),
  scaleDown: 0.95,
  enableHaptic: true,
  hapticType: HapticFeedbackType.medium,
  child: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text('Tap Me'),
  ),
)
```

#### 2. PulseAnimation

Attention-grabbing pulse effect:

```dart
PulseAnimation(
  duration: Duration(milliseconds: 1500),
  minScale: 1.0,
  maxScale: 1.05,
  child: MyWidget(),
)
```

#### 3. StaggeredAnimation

Staggered entrance animations for lists:

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

#### 4. AnimatedGlowCard

Cards with selectable glow effects:

```dart
AnimatedGlowCard(
  isSelected: isSelected,
  onTap: () => setState(() => isSelected = !isSelected),
  glowColor: AppColors.primary,
  child: MyContent(),
)
```

### Animation Durations

| Type | Duration | Use Case |
|------|----------|----------|
| `AppDurations.fast` | 150ms | Micro-interactions, button presses |
| `AppDurations.normal` | 300ms | Page transitions, card expansions |
| `AppDurations.slow` | 500ms | Complex transitions, hero animations |

---

## 🎨 UI Components

### FrostedWidget (Glassmorphism)

Create beautiful frosted glass effects:

```dart
FrostedWidget(
  borderRadius: 20,
  blurSigma: 20,
  backgroundColor: Colors.white.withOpacity(0.1),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Frosted Content'),
  ),
)
```

### Shimmer Loading

Skeleton screens for loading states:

```dart
// List shimmer
ShimmerList(
  itemCount: 6,
  hasImage: true,
  hasSubtitle: true,
)

// Grid shimmer
ShimmerGrid(
  crossAxisCount: 3,
  itemCount: 9,
)

// Custom shimmer
ShimmerContainer(
  width: 200,
  height: 100,
  borderRadius: 12,
)
```

### Empty States

Beautiful empty and error states:

```dart
// Empty state
EmptyWidget(
  icon: LucideIcons.inbox,
  title: 'No Messages',
  subtitle: 'Start a conversation to see it here',
  onRetry: () => loadData(),
)

// Error state
AppErrorWidget(
  message: 'Failed to load',
  onRetry: () => retry(),
)

// Loading state
LoadingWidget(
  message: 'Loading...',
)
```

---

## ⚙️ Configuration

### App Constants

Edit `lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  static const String appName = 'My App';
  static const String appVersion = '1.0.0';
  static const String apiBaseUrl = 'https://api.example.com';
}
```

### Theme Customization

Edit `lib/core/theme/app_colors.dart`:

```dart
class AppColors {
  // Primary brand color
  static const Color primary = Color(0xFFAF52DE);
  static const Color primaryLight = Color(0xFFBF5AF2);
  
  // Background colors
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1C1C1E);
  
  // Text colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFF8E8E93);
}
```

### Adding New Routes

1. Add route name in `lib/core/router/route_names.dart`:

```dart
class RouteNames {
  static const String myPage = '/my-page';
}
```

2. Add route configuration in `lib/core/router/app_router.dart`:

```dart
GoRoute(
  path: RouteNames.myPage,
  name: RouteNames.myPage,
  builder: (context, state) => const MyPage(),
),
```

3. Navigate using:

```dart
context.go(RouteNames.myPage);
// or
context.push(RouteNames.myPage);
```

---

## 📡 API Reference

### HTTP Service

The `HttpService` provides a wrapper around Dio:

```dart
// GET request
final response = await HttpService.instance.get<List<User>>(
  '/users',
  fromJsonT: (json) => (json as List).map((e) => User.fromJson(e)).toList(),
);

// POST request
final response = await HttpService.instance.post<User>(
  '/users',
  data: {'name': 'John', 'email': 'john@example.com'},
  fromJsonT: (json) => User.fromJson(json),
);

// File upload
final response = await HttpService.instance.uploadFile(
  '/upload',
  filePath: '/path/to/file.jpg',
);
```

### Storage Service

Local storage using SharedPreferences:

```dart
// Save data
await StorageService.instance.setString('key', 'value');
await StorageService.instance.setBool('isLoggedIn', true);
await StorageService.instance.setInt('userId', 123);

// Read data
final value = StorageService.instance.getString('key');
final isLoggedIn = StorageService.instance.getBool('isLoggedIn');

// Remove data
await StorageService.instance.remove('key');

// Clear all
await StorageService.instance.clear();
```

---

## 🔧 Third-Party Services

### 1. JPush (极光推送)

**Android Setup:**

Edit `android/app/build.gradle`:

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

**iOS Setup:**

Edit `ios/Runner/Info.plist`:

```xml
<key>jiguang_appKey</key>
<string>your_jpush_appkey</string>
```

**Enable in Code:**

Uncomment relevant code in:
- `lib/core/services/push_service.dart`
- `lib/features/privacy/privacy_manager.dart`

### 2. WeChat SDK

**Android Setup:**

Edit `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        manifestPlaceholders = [
            WX_APP_ID: "your_wechat_appid",
        ]
    }
}
```

**iOS Setup:**

1. Configure URL Types in `ios/Runner/Info.plist`
2. Set up Universal Link

**Enable in Code:**

Uncomment relevant code in:
- `lib/core/services/wechat_service.dart`
- `lib/features/privacy/privacy_manager.dart`

---

## 🐛 Troubleshooting

### Build Issues

**Issue:** `Gradle task assembleDebug failed`

**Solution:**
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter run
```

**Issue:** CocoaPods errors on iOS

**Solution:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

### Runtime Issues

**Issue:** Images not loading

**Solution:** Ensure assets are declared in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/images/profiles/
```

**Issue:** Routes not working

**Solution:** Check that route names match exactly between `route_names.dart` and `app_router.dart`.

---

## 📦 Dependencies

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_riverpod | ^2.5.1 | State management |
| riverpod_annotation | ^2.3.5 | Code generation |
| go_router | ^14.1.0 | Routing |
| dio | ^5.4.0 | HTTP client |
| flutter_screenutil | ^5.9.0 | Screen adaptation |

### UI Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_lucide | ^1.4.0 | Modern icons |
| shimmer | ^3.0.0 | Skeleton screens |
| smooth_page_indicator | ^1.1.0 | Page indicators |
| flutter_slidable | ^3.1.0 | Swipe actions |
| flutter_easyloading | ^3.0.5 | Loading indicators |

### Third-Party Services

| Package | Version | Purpose |
|---------|---------|---------|
| jpush_flutter | ^3.2.8 | Push notifications |
| fluwx | ^5.7.0 | WeChat integration |
| flutter_html | ^3.0.0-beta.2 | HTML rendering |

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Commit Convention

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes
- `refactor:` Code refactoring
- `test:` Test changes
- `chore:` Build/dependency changes

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Reed Tang**

- GitHub: [@reedtang666](https://github.com/reedtang666)
- Email: your-email@example.com

---

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev) for the amazing framework
- [Riverpod](https://riverpod.dev) for excellent state management
- [Lucide](https://lucide.dev) for beautiful icons
- All contributors who helped improve this project

---

<p align="center">
  Made with ❤️ using Flutter
</p>
