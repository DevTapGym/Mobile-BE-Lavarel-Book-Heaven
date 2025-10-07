// models/base_response.dart
class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? error;

  BaseResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return BaseResponse(
      success: json['status'] >= 200 && json['status'] < 300,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error'],
    );
  }

  // Method để check response thành công
  bool get isSuccess => success;
}
