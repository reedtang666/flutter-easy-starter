import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easy_starter/core/constants/api_constants.dart';
import 'package:flutter_easy_starter/core/constants/app_constants.dart';
import 'package:flutter_easy_starter/core/constants/storage_keys.dart';
import 'package:flutter_easy_starter/core/services/storage_service.dart';
import 'package:flutter_easy_starter/models/api_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// HTTP 请求方法
enum HttpMethod { get, post, put, delete, patch }

/// HTTP 服务类
///
/// 封装 Dio，提供统一的网络请求能力
class HttpService {
  HttpService._();

  static final HttpService _instance = HttpService._();
  static HttpService get instance => _instance;

  Dio? _dio;

  /// 全局未授权（401）回调，可绑定至 AuthNotifier.logout 或路由跳转
  VoidCallback? onUnauthorized;

  /// 获取 Dio 实例（确保未显式调用 init 时也能安全懒加载）
  Dio get dio {
    if (_dio == null) {
      init();
    }
    return _dio!;
  }

  /// 初始化
  void init() {
    if (_dio != null) return;

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: AppConstants.connectTimeout),
        receiveTimeout: const Duration(seconds: AppConstants.receiveTimeout),
        sendTimeout: const Duration(seconds: AppConstants.sendTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 添加拦截器
    _dio!.interceptors.add(_AuthInterceptor());
    _dio!.interceptors.add(_TokenRefreshInterceptor(_dio!));

    // 开发环境添加日志
    if (kDebugMode) {
      _dio!.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
    }
  }

  /// GET 请求
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJsonT,
  }) async {
    return _request<T>(
      HttpMethod.get,
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJsonT: fromJsonT,
    );
  }

  /// POST 请求
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJsonT,
  }) async {
    return _request<T>(
      HttpMethod.post,
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJsonT: fromJsonT,
    );
  }

  /// PUT 请求
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJsonT,
  }) async {
    return _request<T>(
      HttpMethod.put,
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJsonT: fromJsonT,
    );
  }

  /// DELETE 请求
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJsonT,
  }) async {
    return _request<T>(
      HttpMethod.delete,
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJsonT: fromJsonT,
    );
  }

  /// 文件上传请求
  Future<ApiResponse<T>> uploadFile<T>(
    String path, {
    required String filePath,
    String fileKey = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJsonT,
  }) async {
    try {
      final formMap = <String, dynamic>{
        if (data != null) ...data,
        fileKey: await MultipartFile.fromFile(filePath),
      };
      final formData = FormData.fromMap(formMap);

      final response = await dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return ApiResponse<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJsonT,
      );
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse<T>(
        code: -1,
        message: '文件上传异常: $e',
        success: false,
      );
    }
  }

  /// 统一请求方法
  Future<ApiResponse<T>> _request<T>(
    HttpMethod method,
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJsonT,
  }) async {
    try {
      Response response;
      final requestOptions = options ?? Options();

      switch (method) {
        case HttpMethod.get:
          response = await dio.get(
            path,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.post:
          response = await dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.put:
          response = await dio.put(
            path,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.delete:
          response = await dio.delete(
            path,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.patch:
          response = await dio.patch(
            path,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
          );
          break;
      }

      return ApiResponse<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJsonT,
      );
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse<T>(
        code: -1,
        message: '网络请求异常: $e',
        success: false,
      );
    }
  }

  /// 处理 Dio 错误
  ApiResponse<T> _handleDioError<T>(DioException e) {
    String message = '网络请求失败';

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = '连接超时，请检查网络';
        break;
      case DioExceptionType.badResponse:
        message = _getHttpErrorMessage(e.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        message = '请求已取消';
        break;
      case DioExceptionType.connectionError:
        message = '网络连接错误，请检查网络';
        break;
      default:
        message = '网络请求失败: ${e.message}';
    }

    return ApiResponse<T>(
      code: e.response?.statusCode ?? -1,
      message: message,
      success: false,
    );
  }

  /// 获取 HTTP 错误信息
  String _getHttpErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '登录已过期，请重新登录';
      case 403:
        return '拒绝访问';
      case 404:
        return '请求的资源不存在';
      case 500:
        return '服务器内部错误';
      case 502:
        return '网关错误';
      case 503:
        return '服务不可用';
      default:
        return '服务器错误 (HTTP $statusCode)';
    }
  }
}

/// 认证拦截器
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 添加 Token
    final token = StorageService.instance.getString(StorageKeys.token);
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // 添加设备信息
    options.headers['X-Device-Type'] = Platform.operatingSystem;
    options.headers['X-App-Version'] = AppConstants.appVersion;

    handler.next(options);
  }
}

/// Token 自动刷新与 401 全局未授权拦截器
///
/// 使用 QueuedInterceptorsWrapper 保证并发请求遇到 401 时串行刷新 Token
class _TokenRefreshInterceptor extends QueuedInterceptorsWrapper {
  final Dio _mainDio;

  _TokenRefreshInterceptor(this._mainDio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final requestPath = err.requestOptions.path;

    // 非 401 错误，或者本身就是登录/刷新接口报错，直接放行
    if (statusCode != 401 ||
        requestPath == ApiConstants.refreshToken ||
        requestPath == ApiConstants.login ||
        requestPath == ApiConstants.loginByPhone) {
      handler.next(err);
      return;
    }

    final refreshToken = StorageService.instance.getString(
      StorageKeys.refreshToken,
    );

    if (refreshToken.isNotEmpty) {
      try {
        // 使用独立 Dio 实例刷新 Token，避免拦截器死锁
        final refreshDio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: AppConstants.connectTimeout),
            receiveTimeout: const Duration(seconds: AppConstants.receiveTimeout),
          ),
        );

        final response = await refreshDio.post(
          ApiConstants.refreshToken,
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
          final data = response.data['data'] as Map<String, dynamic>?;
          final newToken = data?['token'] as String?;
          final newRefreshToken = data?['refreshToken'] as String?;

          if (newToken != null && newToken.isNotEmpty) {
            await StorageService.instance.setString(StorageKeys.token, newToken);
            if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
              await StorageService.instance.setString(
                StorageKeys.refreshToken,
                newRefreshToken,
              );
            }

            // 替换原请求的 Authorization Header 并重发请求
            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            final retryResponse = await _mainDio.fetch(err.requestOptions);
            handler.resolve(retryResponse);
            return;
          }
        }
      } catch (e) {
        debugPrint('Token 自动续期失败: $e');
      }
    }

    // 刷新失败或无 RefreshToken：清理本地登录凭证并通知全局未授权回调
    await StorageService.instance.remove(StorageKeys.token);
    await StorageService.instance.remove(StorageKeys.refreshToken);
    await StorageService.instance.remove(StorageKeys.userInfo);
    HttpService.instance.onUnauthorized?.call();

    handler.next(err);
  }
}
