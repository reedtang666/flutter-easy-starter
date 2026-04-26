/// EventBus - 跨组件事件通信
///
/// 使用场景：
/// - 页面A触发事件，页面B监听处理
/// - 不需要 context 的组件通信
/// - 全局状态变化通知
///
/// 示例：
/// ```dart
/// // 订阅事件
/// EventBus().on('user_login', (data) {
///   print('用户登录: $data');
/// });
///
/// // 触发事件
/// EventBus().emit('user_login', {'userId': '123'});
///
/// // 取消订阅
/// EventBus().off('user_login', callback);
/// ```
class EventBus {
  EventBus._();

  static final EventBus _instance = EventBus._();
  static EventBus get instance => _instance;

  final Map<String, List<EventCallback>> _emap = {};

  /// 订阅事件
  ///
  /// - eventName: 事件名称
  /// - callback: 回调函数
  void on(String eventName, EventCallback callback) {
    _emap[eventName] ??= <EventCallback>[];
    _emap[eventName]!.add(callback);
  }

  /// 取消订阅
  ///
  /// - eventName: 事件名称
  /// - callback: 不传则取消该事件所有订阅
  void off(String eventName, [EventCallback? callback]) {
    final list = _emap[eventName];
    if (list == null) return;

    if (callback == null) {
      _emap[eventName] = [];
    } else {
      list.remove(callback);
    }
  }

  /// 触发事件
  ///
  /// - eventName: 事件名称
  /// - arg: 传递的参数
  void emit(String eventName, [dynamic arg]) {
    final list = _emap[eventName];
    if (list == null || list.isEmpty) return;

    // 反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (var i = list.length - 1; i >= 0; i--) {
      list[i](arg);
    }
  }

  /// 一次性订阅（触发后自动取消）
  void once(String eventName, EventCallback callback) {
    late EventCallback wrapper;
    wrapper = (arg) {
      off(eventName, wrapper);
      callback(arg);
    };
    on(eventName, wrapper);
  }

  /// 清除所有订阅
  void clear() {
    _emap.clear();
  }
}

/// 事件回调签名
typedef EventCallback = void Function(dynamic arg);

/// 全局 EventBus 实例（快捷访问）
final eventBus = EventBus.instance;

/// 常用事件名称常量
class EventNames {
  EventNames._();

  /// 用户登录
  static const String userLogin = 'user_login';

  /// 用户退出
  static const String userLogout = 'user_logout';

  /// 用户信息更新
  static const String userInfoUpdated = 'user_info_updated';

  /// 网络状态变化
  static const String networkChanged = 'network_changed';

  /// App 进入前台
  static const String appForeground = 'app_foreground';

  /// App 进入后台
  static const String appBackground = 'app_background';

  /// 主题切换
  static const String themeChanged = 'theme_changed';

  /// 语言切换
  static const String localeChanged = 'locale_changed';
}
