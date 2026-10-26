# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2026-10-26

### ✨ Features & Enhancements
- **Dual Theme System (Dark / Light / System)**:
  - Added complete `AppTheme.light` (`#F8FAFC` background, `#FFFFFF` cards) alongside `AppTheme.dark`.
  - Connected `themeModeProvider` in `EasyStarterApp` and added an interactive Dark Mode toggle switch in `ProfilePage`.
  - Adapted all 4 bottom-tab pages (`IntroPage`, `TravelHomePage`, `MessagePage`, `ProfilePage`) to dynamically follow `Theme.of(context)`.
- **Network Layer Closure (`HttpService`)**:
  - Added lazy-loaded `dio` getter preventing `LateInitializationError` and explicit `HttpService.instance.init()` at startup.
  - Implemented `uploadFile<T>` with `MultipartFile` and upload progress callback.
  - Added `_TokenRefreshInterceptor` (`QueuedInterceptorsWrapper`) for concurrent-safe 401 `RefreshToken` silent renewal and `onUnauthorized` logout callback.
- **Privacy Compliance & Cold-Start Lifecycle (`PrivacyManager`)**:
  - Deferred `DeviceUtils.init()` until after the user accepts the privacy policy (`PrivacyManager.onPrivacyAccepted()`).
  - Automatically initialized SDKs on subsequent cold starts via `PrivacyManager.instance.initIfAccepted()`.
- **Modern Riverpod `Notifier` & GoRouter `StatefulShellRoute`**:
  - Upgraded `AuthNotifier` and `ThemeModeNotifier` from legacy `StateNotifier` to Riverpod 2.x `Notifier`.
  - Refactored the 4 bottom tabs into `StatefulShellRoute.indexedStack` and added global `redirect` guards for privacy and authentication.

### 🐛 Bug Fixes & Code Quality
- Fixed `UserModel` persistence in `AuthNotifier` using standard `jsonEncode(user.toJson())` and `UserModel.fromJson`.
- Fixed `StorageKeys.isFirstLaunch` default logic in `SplashPage` and `LandingPage`.
- Resolved all `flutter analyze` warnings and deprecated API usages (`withOpacity` -> `withValues(alpha: ...)`), achieving **0 errors and 0 warnings**.
- Added unit & widget tests (`test/widget_test.dart`) and GitHub Actions CI workflow (`.github/workflows/flutter_ci.yml`).

---

## [1.0.0] - 2025-12-01

- Initial release of **Flutter Easy Starter** with Clean Architecture, Riverpod, GoRouter, Dio, Travel & Social UI modules, and custom animations.
