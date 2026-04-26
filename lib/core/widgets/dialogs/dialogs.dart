/// 弹窗组件库导出文件
/// 提供多种类型的弹窗组件，满足各种业务场景
///
/// 使用示例：
/// ```dart
/// // 确认弹窗
/// final result = await AppDialogs.showConfirm(
///   context: context,
///   title: '确认删除?',
///   content: '此操作不可撤销',
/// );
///
/// // 底部操作菜单
/// final action = await AppDialogs.showBottomSheet<String>(
///   context: context,
///   title: '选择操作',
///   actions: [
///     BottomSheetAction(label: '分享', value: 'share', icon: LucideIcons.share),
///     BottomSheetAction(label: '删除', value: 'delete', icon: LucideIcons.trash, isDestructive: true),
///   ],
/// );
///
/// // 输入弹窗
/// final text = await AppDialogs.showInput(
///   context: context,
///   title: '输入昵称',
///   hint: '请输入您的昵称',
///   validator: (v) => v?.isEmpty == true ? '昵称不能为空' : null,
/// );
///
/// // 选择弹窗
/// final selected = await AppDialogs.showSelection<String>(
///   context: context,
///   title: '选择语言',
///   items: [
///     SelectionItem(label: '简体中文', value: 'zh', icon: LucideIcons.globe),
///     SelectionItem(label: 'English', value: 'en', icon: LucideIcons.globe),
///   ],
/// );
///
/// // Toast 提示
/// AppDialogs.showSuccess(context: context, message: '操作成功');
/// AppDialogs.showError(context: context, message: '操作失败');
/// AppDialogs.showWarning(context: context, message: '请注意');
/// AppDialogs.showInfo(context: context, message: '新消息');
///
/// // 加载弹窗
/// AppDialogs.showLoading(context: context, message: '加载中...');
/// AppDialogs.hide(context); // 关闭加载
///
/// // 通知弹窗
/// await AppDialogs.showNotification(
///   context: context,
///   title: '系统更新',
///   content: '发现新版本，是否立即更新?',
///   icon: LucideIcons.download,
/// );
/// ```

export 'app_dialogs.dart';
export 'confirm_dialog.dart';
export 'bottom_action_sheet.dart';
export 'input_dialog.dart';
export 'selection_dialog.dart';
export 'loading_dialog.dart';
export 'toast_message.dart';
export 'notification_dialog.dart';
export 'dialog_models.dart';
