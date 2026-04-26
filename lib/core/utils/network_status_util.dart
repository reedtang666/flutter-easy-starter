import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// 网络状态类型
enum NetworkType {
  none,
  wifi,
  mobile,
  ethernet,
  vpn,
  other,
}

/// 网络状态工具
///
/// 功能：
/// - 监听网络状态变化
/// - 判断当前网络类型
/// - WiFi/移动数据切换检测
class NetworkStatusUtil {
  NetworkStatusUtil._();

  static final NetworkStatusUtil _instance = NetworkStatusUtil._();
  static NetworkStatusUtil get instance => _instance;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  NetworkType _currentType = NetworkType.none;
  NetworkType get currentType => _currentType;

  /// 是否有网络连接
  bool get isConnected => _currentType != NetworkType.none;

  /// 是否是 WiFi
  bool get isWifi => _currentType == NetworkType.wifi;

  /// 是否是移动数据
  bool get isMobile => _currentType == NetworkType.mobile;

  /// 网络状态变化回调
  void Function(NetworkType type)? onStatusChanged;

  /// 初始化并开始监听
  void init() {
    _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      if (results.isNotEmpty) {
        _updateStatus(results.first);
      }
    });

    // 获取初始状态
    _connectivity.checkConnectivity().then((results) {
      if (results.isNotEmpty) {
        _updateStatus(results.first);
      }
    });
  }

  /// 更新状态
  void _updateStatus(ConnectivityResult result) {
    final newType = _convertType(result);
    if (_currentType == newType) return;

    _currentType = newType;
    onStatusChanged?.call(newType);
  }

  /// 转换类型
  NetworkType _convertType(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return NetworkType.wifi;
      case ConnectivityResult.mobile:
        return NetworkType.mobile;
      case ConnectivityResult.ethernet:
        return NetworkType.ethernet;
      case ConnectivityResult.vpn:
        return NetworkType.vpn;
      case ConnectivityResult.none:
        return NetworkType.none;
      default:
        return NetworkType.other;
    }
  }

  /// 释放资源
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
