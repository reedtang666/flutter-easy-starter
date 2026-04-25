/// API 响应数据模型
class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;
  final bool success;

  ApiResponse({
    required this.code,
    required this.message,
    this.data,
    this.success = false,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      code: json['code'] ?? -1,
      message: json['message'] ?? json['msg'] ?? '未知错误',
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : json['data'],
      success: json['code'] == 200 || json['success'] == true,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T?) toJsonT) {
    return {
      'code': code,
      'message': message,
      'data': toJsonT(data),
      'success': success,
    };
  }

  @override
  String toString() {
    return 'ApiResponse{code: $code, message: $message, success: $success, data: $data}';
  }
}

/// 分页数据模型
class PaginationData<T> {
  final List<T> list;
  final int page;
  final int pageSize;
  final int total;
  final bool hasMore;

  PaginationData({
    required this.list,
    required this.page,
    required this.pageSize,
    required this.total,
    this.hasMore = false,
  });

  factory PaginationData.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    final List<dynamic> listData = json['list'] ?? json['data'] ?? [];
    return PaginationData(
      list: listData.map((e) => fromJsonT(e)).toList(),
      page: json['page'] ?? json['pageNum'] ?? 1,
      pageSize: json['pageSize'] ?? json['size'] ?? 20,
      total: json['total'] ?? 0,
      hasMore: json['hasMore'] ?? json['hasNext'] ?? false,
    );
  }
}
