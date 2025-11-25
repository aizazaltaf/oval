import 'dart:io';

import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/serializers.dart';
import 'package:admin/utils/dio.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'api_meta_data.g.dart';

final Logger _logger = Logger('api_meta_data.dart');

abstract class ApiMetaData implements Built<ApiMetaData, ApiMetaDataBuilder> {
  factory ApiMetaData([void Function(ApiMetaDataBuilder) updates]) =
      _$ApiMetaData;

  /// Deserialize from JSON
  factory ApiMetaData.fromDynamic(Map<String, dynamic> json) {
    return serializers.deserializeWith(ApiMetaData.serializer, json) ??
        ApiMetaData(
          (b) => b
            ..statusCode = -1
            ..code = 8001
            ..success = false
            ..message = "Invalid response format",
        );
  }

  /// Named Constructor for Message
  factory ApiMetaData.fromMessage(String message) {
    return ApiMetaData(
      (b) => b
        ..statusCode = -1
        ..code = 8001
        ..success = false
        ..message = message,
    );
  }

  /// Named Constructor for Exception Handling
  factory ApiMetaData.fromException(Object e) {
    _logger.severe(e.toString());

    if (e is CustomDioException) {
      return ApiMetaData(
        (b) => b
          ..statusCode = e.status
          ..code = 8001
          ..success = false
          ..message = '',
      );
    }

    if (e is DioException) {
      if (e.type == DioExceptionType.unknown && e.error is! SocketException) {
        return ApiMetaData.fromMessage("Unknown error occurred");
      }

      if (e.response == null) {
        return ApiMetaData(
          (b) => b
            ..statusCode = -2
            ..code = 8001
            ..success = false
            ..message = "Internet connection failed",
        );
      }

      try {
        final responseData = e.response!.data as Map<String, dynamic>? ?? {};
        return ApiMetaData(
          (b) => b
            ..statusCode = e.response!.statusCode ?? -1
            ..code = responseData['code'] ?? 8001
            ..success = responseData['success'] ?? false
            ..message =
                // "Error Code: ${e.response!.statusCode ?? -1}\nMessage: ${responseData["message"] ?? "Unknown error"}",
                "${(e.response!.statusCode == null || e.response!.statusCode == 500 || responseData["message"] == null) ? "Something went wrong. Please try again." : responseData["message"]}",
        );
      } catch (e2) {
        _logger.severe("Error parsing response: $e2");
        return ApiMetaData.fromMessage("Failed to parse error response");
      }
    }

    return ApiMetaData.fromMessage(e.toString());
  }
  ApiMetaData._();

  static Serializer<ApiMetaData> get serializer => _$apiMetaDataSerializer;

  int? get statusCode;
  int? get code;
  String? get message;
  bool? get success;
  PaginatedDataNew? get pagination;
}
