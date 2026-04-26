# 弹窗组件系统 (Dialog System)

一套完整的 Flutter 弹窗组件库，提供多种类型的弹窗交互，支持深色主题，与项目设计系统无缝集成。

## 快速开始

```dart
import 'package:flutter_easy_starter/core/widgets/dialogs/dialogs.dart';
```

## 弹窗类型

### 1. 确认弹窗 (Confirm Dialog)

用于需要用户确认的操作场景，如删除、退出等。

```dart
final result = await AppDialogs.showConfirm(
  context: context,
  title: '确认删除?',
  content: '删除后将无法恢复，是否继续?',
  confirmText: '删除',
  cancelText: '取消',
  isDanger: true, // 危险操作使用红色主题
);

if (result == true) {
  // 用户点击了确认
}
```

### 2. 底部操作菜单 (Bottom Action Sheet)

从底部滑出的操作菜单，适用于展示多个选项。

```dart
final action = await AppDialogs.showBottomSheet<String>(
  context: context,
  title: '选择操作',
  actions: [
    BottomSheetAction(
      label: '分享给好友',
      value: 'share',
      icon: LucideIcons.share,
    ),
    BottomSheetAction(
      label: '删除项目',
      value: 'delete',
      icon: LucideIcons.trash,
      isDestructive: true, // 危险操作标红
      isBold: true, // 加粗文字
    ),
  ],
);
```

### 3. 输入弹窗 (Input Dialog)

带表单验证的输入弹窗。

```dart
final text = await AppDialogs.showInput(
  context: context,
  title: '修改昵称',
  hint: '请输入新的昵称',
  initialValue: '当前昵称',
  maxLines: 1,
  keyboardType: TextInputType.text,
  validator: (v) {
    if (v?.trim().isEmpty == true) return '昵称不能为空';
    if (v!.length > 20) return '昵称最多20个字符';
    return null;
  },
);
```

### 4. 选择弹窗 (Selection Dialog)

单选列表弹窗，支持图标和副标题。

```dart
final selected = await AppDialogs.showSelection<String>(
  context: context,
  title: '选择语言',
  items: [
    SelectionItem(
      label: '简体中文',
      value: 'zh',
      subtitle: '默认语言',
      icon: LucideIcons.globe,
    ),
    SelectionItem(
      label: 'English',
      value: 'en',
      icon: LucideIcons.globe,
    ),
  ],
  selectedValue: 'zh', // 默认选中
);
```

### 5. 加载弹窗 (Loading Dialog)

阻塞式加载提示，防止用户重复操作。

```dart
// 显示加载
AppDialogs.showLoading(
  context: context,
  message: '加载中...',
  barrierDismissible: false, // 点击外部不关闭
);

// 模拟异步操作
await Future.delayed(const Duration(seconds: 2));

// 关闭加载
if (context.mounted) {
  AppDialogs.hide(context);
}
```

### 6. Toast 提示

轻量级的非阻塞提示，自动消失。

```dart
// 成功提示
AppDialogs.showSuccess(
  context: context,
  message: '操作成功完成!',
  duration: const Duration(seconds: 2),
);

// 错误提示
AppDialogs.showError(
  context: context,
  message: '网络连接失败，请重试',
  duration: const Duration(seconds: 3),
);

// 警告提示
AppDialogs.showWarning(
  context: context,
  message: '注意: 此操作不可撤销',
);

// 信息提示
AppDialogs.showInfo(
  context: context,
  message: '您有一条新消息',
);
```

### 7. 通知弹窗 (Notification Dialog)

用于系统通知、更新提示等场景。

```dart
await AppDialogs.showNotification(
  context: context,
  title: '系统更新',
  content: '发现新版本 v2.0，建议立即更新',
  icon: LucideIcons.download,
  iconColor: AppColors.blue,
  actionText: '立即更新',
  onAction: () {
    // 点击按钮后的操作
    _performUpdate();
  },
);
```

## 自定义弹窗内容

确认弹窗支持自定义内容区域：

```dart
AppDialogs.showConfirm(
  context: context,
  title: '自定义弹窗',
  customContent: Column(
    children: [
      Image.asset('assets/demo.png'),
      SizedBox(height: 16.w),
      Text('自定义内容'),
    ],
  ),
);
```

## 最佳实践

### 1. 异步操作后检查上下文

```dart
final result = await AppDialogs.showConfirm(context: context, ...);
if (result == true && context.mounted) {
  // 安全地使用 context
  AppDialogs.showSuccess(context: context, message: '成功');
}
```

### 2. 加载状态管理

```dart
try {
  AppDialogs.showLoading(context: context);
  await performAsyncOperation();
  if (context.mounted) {
    AppDialogs.hide(context);
    AppDialogs.showSuccess(context: context, message: '完成');
  }
} catch (e) {
  if (context.mounted) {
    AppDialogs.hide(context);
    AppDialogs.showError(context: context, message: '失败: $e');
  }
}
```

### 3. 表单验证

```dart
final password = await AppDialogs.showInput(
  context: context,
  title: '设置密码',
  hint: '请输入6-20位密码',
  validator: (v) {
    if (v == null || v.length < 6) return '密码至少6位';
    if (v.length > 20) return '密码最多20位';
    if (!RegExp(r'[A-Za-z]').hasMatch(v)) return '需包含字母';
    if (!RegExp(r'[0-9]').hasMatch(v)) return '需包含数字';
    return null;
  },
);
```

## 组件结构

```
lib/core/widgets/dialogs/
├── dialogs.dart              # 主导出文件
├── app_dialogs.dart          # 弹窗管理器 & API
├── dialog_models.dart        # 数据模型
├── confirm_dialog.dart       # 确认弹窗
├── bottom_action_sheet.dart  # 底部菜单
├── input_dialog.dart         # 输入弹窗
├── selection_dialog.dart     # 选择弹窗
├── loading_dialog.dart       # 加载弹窗
├── toast_message.dart        # Toast 提示
└── notification_dialog.dart  # 通知弹窗
```

## 设计规范

- **圆角**: 20.r (弹窗), 16.r (底部菜单)
- **动画时长**: 250ms (正常), 300ms (Toast 滑入)
- **背景色**: AppColors.surface (弹窗), 半透明黑遮罩
- **按钮高度**: 48.w (主要操作), 44.w (次要操作)
- **图标尺寸**: 56.w (弹窗头部), 44.w (列表项)
- **阴影**: 紫色辉光效果 (主要操作按钮)

## 预览

在介绍页 (IntroPage) 中可以预览所有弹窗效果。
