import 'dart:convert';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/core/config.dart';
import 'package:admin/models/data/api_meta_data.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:dio/dio.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

export 'package:dio/dio.dart';

final _logger = Logger('dio.dart');

Dio _createDioInstance() {
  final headers = <String, dynamic>{};
  final options = BaseOptions(
    baseUrl: config.apiUrl,
    headers: headers,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );
  final dio = Dio(options);
  dio.interceptors.add(
    _CustomInterceptor(),
  );
  return dio;
}

class _CustomInterceptor extends Interceptor {
  _CustomInterceptor();

  final ignoreAuthForPaths = <String>[
    "auth/login",
    "auth/register",
    "otp/verify",
  ];
  final changeBearer = <String>['get-all-iot-devices'];

  final List<dynamic> _requestQueue = [];
  bool _isRefreshing = false; // Flag to prevent multiple token refresh calls
  Completer<String>? _refreshCompleter; // Completer to handle token refresh

  @override
  Future<void> onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    // options.headers["X-Client-Secret"] = config.secret;

    options.headers['Authorization'] = "Bearer ${config.key}";
    options.headers['x-api-key'] =
        "${singletonBloc.profileBloc.state?.apiToken}";
    options.headers['Content-Type'] = "application/json";
    options.headers['Connection'] = 'keep-alive';
    options.headers['Accept'] = "application/json";

    _logger.fine(
      'PATH: ${options.method} ${options.path} ${options.queryParameters} UserToken ${singletonBloc.profileBloc.state?.apiToken}',
    );

    super.onRequest(options, handler);
  }

  bool isInternet = false;

  // void isInternetError() {
  //   if (!isInternet) {
  //     isInternet = true;
  //     Future.delayed(const Duration(seconds: 2), () {
  //       isInternet = false;
  //     });
  //     singletonBloc.voipBloc?.updateIsInternetConnected(false);
  //     // ToastUtils.errorToast(
  //     //   "Network error. Please check your internet connection",
  //     // );
  //   }
  // }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 500) {
      handler.next(err);
      return;
    }

    // Handle connection errors and SSL handshake issues
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.unknown) {
      _logger.warning(
        'Connection Error: ${err.requestOptions.path} - ${err.message}',
      );

      // Check if it's an SSL/TLS related error
      if (err.message?.contains('HandshakeException') == true ||
          err.message?.contains('CertificateException') == true ||
          err.message?.contains('TlsException') == true) {
        _logger.severe(
          'SSL/TLS Error: ${err.requestOptions.path} - ${err.message}',
        );
        // Don't retry SSL errors immediately
        handler.next(err);
        return;
      }

      // Handle other connection errors
      // isIntern`etError();
      handler.next(err);
      return;
    }

    // Handle Timeout Errors (Prevents Bugfender Logging)
    if (err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionTimeout) {
      _logger.info(
        'Timeout Error: ${err.requestOptions.path} - Skipping Bugfender Logging - ${err.type}',
      );
      handler.next(err);
      return;
    }
    if (err.response?.statusCode == 403 && err.response?.data["code"] == 8020) {
      await singletonBloc.getBox.erase();
      singletonBloc.profileBloc.updateProfile(null);
      return;
    }

    // Handle 401 Unauthorized error
    if (err.response?.statusCode == 401 &&
        (singletonBloc.profileBloc.state != null ||
            ignoreAuthForPaths.contains(err.requestOptions.path))) {
      return _handle401Error(err, handler);
    }

    // Handle 404 (Not Found) as a 200 OK response with empty data
    if (err.response?.statusCode == 404 &&
        (err.response?.data).toString().contains("data")) {
      return handler.next(err);
    }

    _logger.severe(
      'PATH: ${err.requestOptions.method} ${err.requestOptions.path} || ERROR: ${err.message}|| Code: ${err.response?.statusCode}',
    );

    return handler.next(err); // Default error handling
  }

  Timer? _debounceTimer; // ✅ Debounce timer
  /// Handles 401 errors with debounced token refresh
  Future<void> _handle401Error(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    _requestQueue.add({
      "requestOptions": requestOptions,
      "handler": handler,
    }); // ✅ Queue request

    // ✅ If a refresh is in progress, wait for completion
    if (_isRefreshing) {
      await _refreshCompleter?.future;
      return;
    }

    // ✅ Debounce the token refresh to avoid frequent API calls
    _debounceTimer?.cancel(); // Cancel previous debounce timer if any
    _debounceTimer = Timer(const Duration(seconds: 2), () async {
      await _refreshToken();
      await _retryQueuedRequests();
    });
  }

  /// Refreshes the token with debounce protection
  Future<void> _refreshToken() async {
    if (_isRefreshing) {
      return; // Avoid duplicate calls
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String>();

    try {
      _logger.info("🔄 Refreshing token...");
      final newToken = await apiService.refreshToken();

      singletonBloc.profileBloc.emit(
        singletonBloc.profileBloc.state!.rebuild((e) => e.apiToken = newToken),
      );

      _refreshCompleter!.complete(newToken);
    } catch (e) {
      _logger.severe("❌ Token refresh failed: $e");
      _refreshCompleter!.completeError(e);
      await singletonBloc.getBox.erase();
      singletonBloc.profileBloc.updateProfile(null);
    } finally {
      _isRefreshing = false;
    }
  }

  /// Retries queued requests in FIFO order
  Future<void> _retryQueuedRequests() async {
    while (_requestQueue.isNotEmpty) {
      final queuedRequest = _requestQueue.removeAt(0);
      await _retryRequest(
        queuedRequest['requestOptions'],
        queuedRequest['handler'],
      );
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  /// Retries a failed request after token refresh
  Future<void> _retryRequest(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    final newToken = singletonBloc.profileBloc.state?.apiToken;
    if (newToken == null) {
      if (!handler.isCompleted) {
        handler.reject(
          DioException(
            requestOptions: requestOptions,
            response: Response(
              requestOptions: requestOptions,
              statusCode: 401,
              statusMessage: "Token refresh failed",
            ),
          ),
        );
      }
      return;
    }

    final newHeaders = Map<String, dynamic>.from(requestOptions.headers);
    newHeaders['Authorization'] = "Bearer $newToken";

    final newOptions = Options(
      method: requestOptions.method,
      headers: newHeaders,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
    );

    try {
      final response = await dio.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: newOptions,
      );

      if (!handler.isCompleted) {
        handler.resolve(response);
      }
    } catch (e) {
      if (!handler.isCompleted) {
        handler.reject(
          DioException(
            requestOptions: requestOptions,
            response: Response(
              requestOptions: requestOptions,
              statusCode: 500,
              statusMessage: "Retry request failed",
            ),
          ),
        );
      }
    }
  }

  @override
  void onResponse(
    final Response response,
    final ResponseInterceptorHandler handler,
  ) {
    try {
      final ApiMetaData meta;
      if (jsonEncode(response.data).contains("code")) {
        meta = ApiMetaData.fromDynamic(response.data);
      } else {
        meta = ApiMetaData.fromDynamic({
          "statusCode": response.statusCode,
          "code": 8001,
          "message": response.data['message'] ?? "No message found",
          "success": response.statusCode == 200,
        });
      }

      if (response.statusCode != 200) {
        if (response.statusCode != 201) {
          _logger.severe(
            'PATH: ${response.requestOptions.method} ${response.requestOptions.path} || ERROR: ${response.data}',
          );
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              message: meta.message,
              response: response,
              type: DioExceptionType.badResponse,
              error: meta,
            ),
          );
        }
      }
    } catch (e) {
      _logger.severe('onResponse: $e');
    }

    if (!handler.isCompleted) {
      super.onResponse(response, handler);
    }
  }
}

final Dio dio = _createDioInstance();

void cancelDioToken(final CancelToken? token) {
  if (token == null) {
    return;
  }
  if (token.isCancelled) {
    return;
  }
  try {
    token.cancel();
  } catch (e) {
    _logger.severe('cancelDioToken: $e');
  }
}

class CustomDioException implements Exception {
  CustomDioException({
    required this.status,
    required this.message,
  });

  final int status;
  final String message;
}
