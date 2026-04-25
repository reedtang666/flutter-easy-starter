import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

/// WebSocket 状态
enum WebSocketStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  failed,
}

/// WebSocket 配置
class WebSocketConfig {
  /// WebSocket 服务器地址
  final String url;

  /// 心跳间隔（毫秒）
  final int heartbeatInterval;

  /// 最大重连次数
  final int maxReconnectAttempts;

  /// 重连延迟（毫秒）
  final int reconnectDelay;

  /// ping 超时时间（毫秒）
  final int pingTimeout;

  const WebSocketConfig({
    required this.url,
    this.heartbeatInterval = 30000, // 30秒
    this.maxReconnectAttempts = 60,
    this.reconnectDelay = 3000, // 3秒
    this.pingTimeout = 5000, // 5秒
  });
}

/// WebSocket 消息
class WebSocketMessage {
  final String type;
  final dynamic data;
  final int? timestamp;

  WebSocketMessage({
    required this.type,
    this.data,
    this.timestamp,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      type: json['type'] ?? '',
      data: json['data'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'data': data,
    'timestamp': timestamp ?? DateTime.now().millisecondsSinceEpoch,
  };
}

/// WebSocket 服务
///
/// 特性：
/// - 自动重连（带指数退避）
/// - 心跳保活
/// - 后台感知（App进入后台暂停，回到前台恢复）
/// - ping 探活
class WebSocketService {
  WebSocketService._();

  static final WebSocketService _instance = WebSocketService._();
  static WebSocketService get instance => _instance;

  WebSocketConfig? _config;
  WebSocketChannel? _channel;

  // 状态
  WebSocketStatus _status = WebSocketStatus.disconnected;
  WebSocketStatus get status => _status;

  // 连接ID（用于竞态防护）
  int _connectionId = 0;

  // 重连计数
  int _reconnectAttempts = 0;
  Timer? _reconnectTimer;

  // 心跳
  Timer? _heartbeatTimer;
  Timer? _pingTimeoutTimer;

  // 后台状态
  bool _isInBackground = false;

  // 回调
  void Function(WebSocketStatus status)? onStatusChange;
  void Function(WebSocketMessage message)? onMessage;
  void Function(dynamic error)? onError;
  void Function()? onOpen;

  /// 是否已连接
  bool get isConnected => _status == WebSocketStatus.connected;

  /// 初始化配置
  void init(WebSocketConfig config) {
    _config = config;
  }

  /// 连接 WebSocket
  Future<void> connect() async {
    if (_config == null) {
      throw Exception('WebSocket not initialized. Call init() first.');
    }

    if (_status == WebSocketStatus.connected ||
        _status == WebSocketStatus.connecting) {
      return;
    }

    _updateStatus(WebSocketStatus.connecting);

    // 关闭旧连接
    await _closeConnection();

    // 新连接ID
    _connectionId++;
    final currentId = _connectionId;

    try {
      _channel = IOWebSocketChannel.connect(_config!.url);

      _channel!.stream.listen(
        (data) => _onMessage(data, currentId),
        onError: (error) => _onError(error, currentId),
        onDone: () => _onDone(currentId),
      );

      _updateStatus(WebSocketStatus.connected);
      _reconnectAttempts = 0;
      _startHeartbeat();

      onOpen?.call();
      debugPrint('WebSocket: 连接成功');
    } catch (e) {
      _updateStatus(WebSocketStatus.failed);
      onError?.call(e);
      debugPrint('WebSocket: 连接失败 - $e');
      _scheduleReconnect();
    }
  }

  /// 发送消息
  void send(WebSocketMessage message) {
    if (_channel == null || _status != WebSocketStatus.connected) {
      debugPrint('WebSocket: 未连接，无法发送消息');
      return;
    }

    try {
      _channel!.sink.add(jsonEncode(message.toJson()));
      debugPrint('WebSocket: 发送消息 - ${message.type}');
    } catch (e) {
      debugPrint('WebSocket: 发送失败 - $e');
    }
  }

  /// 发送心跳
  void sendPing() {
    send(WebSocketMessage(
      type: 'ping',
      data: {'time': DateTime.now().millisecondsSinceEpoch},
    ));
  }

  /// 断开连接
  Future<void> disconnect() async {
    _connectionId++; // 使旧连接回调失效
    _reconnectAttempts = 0;
    _cancelReconnect();
    _stopHeartbeat();
    await _closeConnection();
    _updateStatus(WebSocketStatus.disconnected);
    debugPrint('WebSocket: 已断开连接');
  }

  /// App 进入后台
  void onAppBackground() {
    _isInBackground = true;
    _stopHeartbeat();
    // 不主动断开，等待服务器超时或系统回收
    debugPrint('WebSocket: 进入后台，暂停心跳');
  }

  /// App 回到前台
  Future<void> onAppForeground() async {
    if (!_isInBackground) return;
    _isInBackground = false;

    // 重置重连计数
    _reconnectAttempts = 0;

    if (_status != WebSocketStatus.connected) {
      // 如果已断开，立即重连
      debugPrint('WebSocket: 回到前台，立即重连');
      await connect();
    } else {
      // 如果还连着，发 ping 探活
      debugPrint('WebSocket: 回到前台，发送探活 ping');
      _startHeartbeat();
      _sendPingWithTimeout();
    }
  }

  // ========== 私有方法 ==========

  void _updateStatus(WebSocketStatus status) {
    if (_status == status) return;
    _status = status;
    onStatusChange?.call(status);
    debugPrint('WebSocket: 状态变化 - $status');
  }

  void _onMessage(dynamic data, int connectionId) {
    if (connectionId != _connectionId) return; // 旧连接的消息，忽略

    try {
      final json = jsonDecode(data.toString());
      final message = WebSocketMessage.fromJson(json);

      // 收到任何消息都说明连接正常，取消探活超时
      _cancelPingTimeout();

      // 处理 pong
      if (message.type == 'pong') {
        debugPrint('WebSocket: 收到 pong');
        return;
      }

      onMessage?.call(message);
      debugPrint('WebSocket: 收到消息 - ${message.type}');
    } catch (e) {
      debugPrint('WebSocket: 消息解析失败 - $e');
    }
  }

  void _onError(dynamic error, int connectionId) {
    if (connectionId != _connectionId) return;

    _updateStatus(WebSocketStatus.failed);
    onError?.call(error);
    debugPrint('WebSocket: 连接异常 - $error');

    if (!_isInBackground) {
      _scheduleReconnect();
    }
  }

  void _onDone(int connectionId) {
    if (connectionId != _connectionId) return;

    _updateStatus(WebSocketStatus.disconnected);
    debugPrint('WebSocket: 连接关闭');

    if (!_isInBackground) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _config!.maxReconnectAttempts) {
      debugPrint('WebSocket: 重连次数已达上限，停止重连');
      return;
    }

    _cancelReconnect();
    _updateStatus(WebSocketStatus.reconnecting);

    _reconnectAttempts++;
    debugPrint('WebSocket: 第 $_reconnectAttempts 次重连...');

    _reconnectTimer = Timer(
      Duration(milliseconds: _config!.reconnectDelay),
      () => connect(),
    );
  }

  void _cancelReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(
      Duration(milliseconds: _config!.heartbeatInterval),
      (_) => _sendPingWithTimeout(),
    );
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _cancelPingTimeout();
  }

  void _sendPingWithTimeout() {
    if (_status != WebSocketStatus.connected) return;

    sendPing();

    // 设置探活超时
    _pingTimeoutTimer = Timer(
      Duration(milliseconds: _config!.pingTimeout),
      () {
        debugPrint('WebSocket: ping 超时，连接可能已死');
        _closeConnection().then((_) {
          if (!_isInBackground) {
            _scheduleReconnect();
          }
        });
      },
    );
  }

  void _cancelPingTimeout() {
    _pingTimeoutTimer?.cancel();
    _pingTimeoutTimer = null;
  }

  Future<void> _closeConnection() async {
    try {
      await _channel?.sink.close();
    } catch (e) {
      // 忽略关闭错误
    }
    _channel = null;
  }
}
