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

  late Dio _dio;

  /// 初始化
  void init() {
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
    _dio.interceptors.add(_AuthInterceptor());
    _dio.interceptors.add(_ErrorInterceptor());

    // 开发环境添加日志
    if (kDebugMode) {
      _dio.interceptors.add(
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
          response = await _dio.get(
            path,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.post:
          response = await _dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.put:
          response = await _dio.put(
            path,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.delete:
          response = await _dio.delete(
            path,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.patch:
          response = await _dio.patch(
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

/// 错误拦截器
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 处理 401 未授权
    if (err.response?.statusCode == 401) {
      // TODO: 清除登录状态，跳转到登录页
      // 这里可以通过 EventBus 或全局状态管理通知
    }
    handler.next(err);
  }
}
