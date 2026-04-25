import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView 配置
class WebViewConfig {
  final String? title;
  final String? url;
  final String? htmlContent;
  final bool hideAppBar;
  final bool enableJavascript;
  final bool enableZoom;

  const WebViewConfig({
    this.title,
    this.url,
    this.htmlContent,
    this.hideAppBar = false,
    this.enableJavascript = true,
    this.enableZoom = false,
  });
}

/// WebView 页面 - 支持与 H5 双向通信
class WebViewPage extends StatefulWidget {
  final WebViewConfig config;

  const WebViewPage({
    super.key,
    required this.config,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(
        widget.config.enableJavascript
            ? JavaScriptMode.unrestricted
            : JavaScriptMode.disabled,
      )
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
            // 启动加载超时检测
            _loadingTimer?.cancel();
            _loadingTimer = Timer(const Duration(seconds: 15), () {
              if (_isLoading && mounted) {
                setState(() {
                  _isLoading = false;
                  _hasError = true;
                  _errorMessage = '页面加载超时';
                });
              }
            });
          },
          onPageFinished: (url) {
            _loadingTimer?.cancel();
            setState(() {
              _isLoading = false;
            });
            // 向 H5 传递状态栏高度
            _injectStatusBarHeight();
          },
          onWebResourceError: (error) {
            _loadingTimer?.cancel();
            setState(() {
              _isLoading = false;
              _hasError = true;
              _errorMessage = '加载失败: ${error.description}';
            });
          },
        ),
      )
      // 添加 JS Bridge
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: _handleJsMessage,
      );

    // 加载内容
    if (widget.config.htmlContent != null) {
      _controller.loadHtmlString(widget.config.htmlContent!);
    } else if (widget.config.url != null) {
      _controller.loadRequest(Uri.parse(widget.config.url!));
    }
  }

  /// 处理 JS 消息
  void _handleJsMessage(JavaScriptMessage message) {
    try {
      final data = jsonDecode(message.message);
      final action = data['action'] as String?;
      final params = data['params'];

      debugPrint('WebView: 收到 JS 消息 - $action');

      switch (action) {
        case 'back':
          _handleBack();
          break;
        case 'navigate':
          _handleNavigate(params);
          break;
        case 'showToast':
          _handleShowToast(params);
          break;
        case 'copyText':
          _handleCopyText(params);
          break;
        case 'getUserInfo':
          _handleGetUserInfo();
          break;
        case 'openImagePicker':
          _handleImagePicker();
          break;
        default:
          debugPrint('WebView: 未知 action - $action');
      }
    } catch (e) {
      debugPrint('WebView: 消息解析失败 - $e');
    }
  }

  /// 返回处理
  Future<void> _handleBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    } else {
      if (mounted) Navigator.pop(context);
    }
  }

  /// 跳转页面
  void _handleNavigate(dynamic params) {
    if (params == null) return;
    final route = params['route'] as String?;
    if (route != null) {
      // 使用 Navigator 跳转 Flutter 页面
      debugPrint('WebView: 跳转路由 - $route');
      // context.go(route);
    }
  }

  /// 显示 Toast
  void _handleShowToast(dynamic params) {
    if (params == null) return;
    final message = params['message'] as String?;
    if (message != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  /// 复制文本
  void _handleCopyText(dynamic params) {
    if (params == null) return;
    final text = params['text'] as String?;
    if (text != null) {
      Clipboard.setData(ClipboardData(text: text));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已复制到剪贴板')),
        );
      }
    }
  }

  /// 获取用户信息
  void _handleGetUserInfo() {
    // 返回用户信息给 H5
    final userInfo = {
      'id': '1',
      'nickname': '测试用户',
      'avatar': 'https://via.placeholder.com/100',
    };
    _callJs('onUserInfoResult', userInfo);
  }

  /// 图片选择
  void _handleImagePicker() async {
    // 打开图片选择
    // final images = await _pickImages();
    // _callJs('onImagePicked', {'images': images});
  }

  /// 调用 JS 方法
  void _callJs(String functionName, dynamic data) {
    final json = jsonEncode(data);
    final js = '''
      if (typeof window.$functionName === 'function') {
        window.$functionName($json);
      }
    ''';
    _controller.runJavaScript(js);
  }

  /// 注入状态栏高度
  void _injectStatusBarHeight() {
    if (mounted) {
      final height = MediaQuery.of(context).padding.top;
      _controller.runJavaScript('''
        window.flutterStatusBarHeight = $height;
        if (typeof onStatusBarHeightChanged === 'function') {
          onStatusBarHeightChanged($height);
        }
      ''');
    }
  }

  /// 生成错误页面 HTML
  String _buildErrorHtml(String message) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
      font-family: -apple-system, BlinkMacSystemFont, sans-serif;
      background: #f5f5f5;
    }
    .card {
      background: white;
      border-radius: 16px;
      padding: 32px;
      text-align: center;
      box-shadow: 0 2px 16px rgba(0,0,0,0.1);
    }
    .icon {
      width: 64px;
      height: 64px;
      background: #f5f5f5;
      border-radius: 16px;
      margin: 0 auto 20px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .title { font-size: 17px; font-weight: 600; color: #333; margin-bottom: 8px; }
    .desc { font-size: 14px; color: #999; line-height: 1.5; }
  </style>
</head>
<body>
  <div class="card">
    <div class="icon">⚠️</div>
    <div class="title">加载失败</div>
    <div class="desc">$message</div>
  </div>
</body>
</html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.config.hideAppBar
          ? null
          : AppBar(
              title: Text(widget.config.title ?? ''), // 标题从 H5 获取
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _handleBack(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // 显示更多选项
                  },
                ),
              ],
            ),
      body: Stack(
        children: [
          // WebView
          if (!_hasError)
            WebViewWidget(controller: _controller)
          else
            _buildErrorView(),

          // 加载指示器
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      '加载中...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return WebViewWidget(
      controller: WebViewController()
        ..loadHtmlString(_buildErrorHtml(_errorMessage)),
    );
  }
}
