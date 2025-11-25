import 'dart:convert';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/data/api_meta_data.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/utils/dio.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:built_value/built_value.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:wc_dart_framework/wc_dart_framework.dart';

final _logger = Logger("cubit_utils.dart");

class CubitUtils {
  CubitUtils._();

  // static List<ConnectivityResult>? connectivityResult;

  // static void initConnectivityCheck() {
  //   Timer.periodic(const Duration(seconds: 2), (v) async {
  //     connectivityResult = await Connectivity().checkConnectivity();
  //   });
  // }

  static Timer? _internetErrorDebounceTimer;
  static bool _isInternetToastVisible = false;

  static Future<void> makeApiCall<V extends Built<V, B>,
          B extends Builder<V, B>, ApiStateData>({
    required final BVCubit<V, B> cubit,
    required final ApiState<ApiStateData> apiState,
    required final void Function(B b, ApiState<ApiStateData> apiState)
        updateApiState,
    required final Future<ApiStateData> Function() callApi,
    final bool makeDataNullAtStart = false,
    final bool dismissLoaderOnApiFail = true,
    final String? successMessage,
    final FutureOr<void> Function(Object error)? onError,
    final FutureOr<void> Function()? onSuccess,
  }) =>
      _changeApiState<V, B, ApiStateData>(
        cubit: cubit,
        apiState: apiState,
        updateApiState: updateApiState,
        dismissLoaderOnApiFail: dismissLoaderOnApiFail,
        getLatestApiState: (final apiState) async {
          final data = await callApi();
          return apiState.rebuild((final b) => b.data = data);
        },
        makeDataNullAtStart: makeDataNullAtStart,
        successMessage: successMessage,
        onError: onError,
        onSuccess: onSuccess,
      );

  static Future<void> _changeApiState<V extends Built<V, B>,
      B extends Builder<V, B>, ApiStateData>({
    required final BVCubit<V, B> cubit,
    required final ApiState<ApiStateData> apiState,
    required final void Function(B b, ApiState<ApiStateData> apiState)
        updateApiState,
    required final Future<ApiState<ApiStateData>> Function(
      ApiState<ApiStateData> apiState,
    ) getLatestApiState,
    required final bool makeDataNullAtStart,
    required final bool dismissLoaderOnApiFail,
    required final String? successMessage,
    required final FutureOr<void> Function(Object error)? onError,
    required final FutureOr<void> Function()? onSuccess,
  }) async {
    await Future.delayed(Duration.zero);

    /// Internet Error check before API call
    // connectivityResult ??= await Connectivity().checkConnectivity();
    // final connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult!.contains(ConnectivityResult.none)) {
    if (!singletonBloc.isInternetConnected) {
      if (!_isInternetToastVisible) {
        _isInternetToastVisible = true;
        // singletonBloc.voipBloc?.updateIsInternetConnected(false);
        // ToastUtils.errorToast(
        //   "Network error. Please check your internet connection",
        // );

        _internetErrorDebounceTimer?.cancel();
        _internetErrorDebounceTimer = Timer(const Duration(seconds: 3), () {
          _isInternetToastVisible = false;
        });
      }
      await onError?.call(DioExceptionType.connectionError);
      return;
    }

    var latestApiState = apiState.rebuild(
      (final bApiState) {
        bApiState
          ..isApiInProgress = true
          ..error = null
          ..message = null;
        if (makeDataNullAtStart) {
          bApiState.data = null;
        }
      },
    );
    cubit.emit(
      cubit.state.rebuild(
        (final b) => updateApiState(
          b,
          latestApiState,
        ),
      ),
    );
    var isSuccess = false;
    try {
      latestApiState = await getLatestApiState(latestApiState);
      latestApiState = latestApiState.rebuild(
        (final b) => b..message = successMessage,
      );
      isSuccess = true;
    } catch (e) {
      if (!(e is DioException && e.type == DioExceptionType.cancel)) {
        latestApiState = latestApiState.rebuild(
          (final b) => b
            ..error.replace(ApiMetaData.fromException(e))
            ..data = null,
        );
        // unawaited(EasyLoading.dismiss());
        if (dismissLoaderOnApiFail) {
          Constants.dismissLoader();
        }

        await onError?.call(e);
      }
    }
    cubit.emit(
      cubit.state.rebuild(
        (final b) {
          updateApiState(
            b,
            latestApiState.rebuild(
              (final bApiState) => bApiState.isApiInProgress = false,
            ),
          );
        },
      ),
    );
    if (isSuccess) {
      onSuccess?.call();
    }
    // unawaited(EasyLoading.dismiss());
  }

  static V dehydrate<V extends Built<V, B>, B extends Builder<V, B>, Data>({
    required final V state,
    required final String key,
    required final Logger logger,
    required final Map<String, dynamic> json,
    required final Data Function(Object) fromDynamic,
    required final void Function(B b, Data data) updateData,
  }) {
    if (json[key] == null) {
      return state;
    }
    try {
      final data = fromDynamic(json[key]);
      return state.rebuild(
        (final b) => updateData(b, data),
      );
    } catch (e) {
      logger.severe('dehydrate: $e');
      return state;
    }
  }

  static Future<void> makePaginatedApiCall<V extends Built<V, B>,
          B extends Builder<V, B>, ApiStateData>({
    required final BVCubit<V, B> cubit,
    required final ApiState<ApiStateData> apiState,
    required final void Function(B b, ApiState<ApiStateData> apiState)
        updateApiState,
    required final Future<ApiStateData> Function(int page) callApi,
    required final int currentPage,
    required final int totalPages,
    required final void Function(int newPage) onPageUpdate,
    final bool makeDataNullAtStart = false,
    final String? successMessage,
    final FutureOr<void> Function(Object error)? onError,
    final FutureOr<void> Function()? onSuccess,
  }) =>
      _changePaginatedApiState<V, B, ApiStateData>(
        cubit: cubit,
        apiState: apiState,
        updateApiState: updateApiState,
        currentPage: currentPage,
        totalPages: totalPages,
        onPageUpdate: onPageUpdate,
        getLatestApiState: (final apiState, page) async {
          final data = await callApi(page);
          return apiState.rebuild((final b) {
            if (apiState.data is List && data is List) {
              b.data = [...(apiState.data! as List), ...data] as dynamic;
            } else if (apiState.data is PaginatedData &&
                data is PaginatedData) {
              /// ✅ Merge `PaginatedData`'s `data` field properly
              b.data = (apiState.data! as PaginatedData).rebuild((pBuilder) {
                if (pBuilder.data.isNotEmpty) {
                  pBuilder.data.addAll(data.data); // ✅ Append new data
                } else {
                  pBuilder.data.replace(data.data); // ✅ Replace if empty
                }

                // ✅ Update pagination details from the latest API response
                pBuilder
                  ..currentPage = data.currentPage
                  ..lastPage = data.lastPage
                  ..nextPageUrl = data.nextPageUrl;
              }) as dynamic;
            } else {
              b.data = data;
            }
            b.isApiPaginationEnabled = true;
            if (data is PaginatedData) {
              b
                ..totalCount = data.lastPage
                ..currentPage = data.currentPage;
            }
          });
        },
        makeDataNullAtStart: makeDataNullAtStart,
        successMessage: successMessage,
        onError: onError,
        onSuccess: onSuccess,
      );

  static Future<void> _changePaginatedApiState<V extends Built<V, B>,
      B extends Builder<V, B>, ApiStateData>({
    required final BVCubit<V, B> cubit,
    required final ApiState<ApiStateData> apiState,
    required final void Function(B b, ApiState<ApiStateData> apiState)
        updateApiState,
    required final int currentPage,
    required final int totalPages,
    required final void Function(int newPage) onPageUpdate,
    required final Future<ApiState<ApiStateData>> Function(
      ApiState<ApiStateData> apiState,
      int page,
    ) getLatestApiState,
    required final bool makeDataNullAtStart,
    required final String? successMessage,
    required final FutureOr<void> Function(Object error)? onError,
    required final FutureOr<void> Function()? onSuccess,
  }) async {
    if (currentPage > totalPages) {
      return; // No more pages to load.
    }

    await Future.delayed(Duration.zero);

    /// Internet Error check before API call
    // connectivityResult ??= await Connectivity().checkConnectivity();
    // final connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult!.contains(ConnectivityResult.none)) {
    if (!singletonBloc.isInternetConnected) {
      if (!_isInternetToastVisible) {
        _isInternetToastVisible = true;
        // singletonBloc.voipBloc?.updateIsInternetConnected(false);
        // ToastUtils.errorToast(
        //   "Network error. Please check your internet connection",
        // );

        _internetErrorDebounceTimer?.cancel();
        _internetErrorDebounceTimer = Timer(const Duration(seconds: 3), () {
          _isInternetToastVisible = false;
        });
      }
      return;
    }
    var latestApiState = apiState.rebuild(
      (final bApiState) {
        bApiState
          ..isApiInProgress = true
          ..error = null
          ..message = null;
        if (makeDataNullAtStart) {
          bApiState.data = null;
        }
      },
    );
    cubit.emit(
      cubit.state.rebuild(
        (final b) => updateApiState(
          b,
          latestApiState,
        ),
      ),
    );

    var isSuccess = false;
    try {
      onPageUpdate(currentPage + 1);
      latestApiState = await getLatestApiState(latestApiState, currentPage + 1);
      latestApiState = latestApiState.rebuild(
        (final b) => b..message = successMessage,
      );
      isSuccess = true;
    } catch (e) {
      if (!(e is DioException && e.type == DioExceptionType.cancel)) {
        latestApiState = latestApiState.rebuild(
          (final b) => b.error.replace(ApiMetaData.fromException(e)),
        );
        await onError?.call(e);
      }
    }

    cubit.emit(
      cubit.state.rebuild(
        (final b) {
          updateApiState(
            b,
            latestApiState.rebuild(
              (final bApiState) => bApiState.isApiInProgress = false,
            ),
          );
        },
      ),
    );

    if (isSuccess) {
      onPageUpdate(currentPage + 1);
      onSuccess?.call();
    }
  }

  // static Timer? _debounceSocketCall;

  static Future<void> makeSocketCall<V extends Built<V, B>,
      B extends Builder<V, B>, SocketStateData>({
    required BVCubit<V, B> cubit,
    required SocketState<SocketStateData> apiState,
    required void Function(B b, SocketState<SocketStateData> apiState)
        updateApiState,
    required io.Socket socket,
    required String eventName,
    required String responseEvent,
    required String command,
    Map<String, dynamic>? data,
    Map<String, dynamic>? message,
    String? deviceId,
    Duration timeout = const Duration(seconds: 30),
    String? successMessage,
    FutureOr<void> Function(Object error)? onError,
    FutureOr<void> Function(SocketStateData data)? onSuccess,
  }) async {
    // _debounceSocketCall?.cancel();
    // _debounceSocketCall = Timer(const Duration(milliseconds: 300), () async {
    // Set loading state
    final loadingState = apiState.rebuild(
      (b) => b
        ..isSocketInProgress = true
        ..message = null,
    );

    cubit.emit(
      cubit.state.rebuild((b) => updateApiState(b, loadingState)),
    );

    if (command == Constants.operateIotDevice) {
      // unawaited(EasyLoading.show());
      Constants.showLoader(showCircularLoader: false);
    }
    await Future.delayed(Duration.zero);

    /// Internet Error check before API call
    // connectivityResult ??= await Connectivity().checkConnectivity();

    // if (connectivityResult!.contains(ConnectivityResult.none)) {
    if (!singletonBloc.isInternetConnected) {
      if (!_isInternetToastVisible) {
        _isInternetToastVisible = true;

        // unawaited(EasyLoading.dismiss());
        Constants.dismissLoader();

        // singletonBloc.voipBloc?.updateIsInternetConnected(false);
        ToastUtils.errorToast(
          "Network error. Device can’t be added due to internet issue.",
        );

        _internetErrorDebounceTimer?.cancel();
        _internetErrorDebounceTimer = Timer(const Duration(seconds: 3), () {
          _isInternetToastVisible = false;
        });
      }
      final updatedState = loadingState.rebuild(
        (b) => b
          ..isSocketInProgress = false
          ..message = successMessage,
      );

      cubit.emit(
        cubit.state.rebuild((b) => updateApiState(b, updatedState)),
      );
    } else {
      final sessionId = await CommonFunctions.getDeviceModel();

      final Map<String, dynamic> payload = {
        // Constants.roomId: singletonBloc.profileBloc.state?.locationId ?? '',
        Constants.roomId: singletonBloc
                .profileBloc.state?.selectedDoorBell?.locationId
                .toString() ??
            '',
        Constants.command: command,
        Constants.deviceId: deviceId ??
            singletonBloc.profileBloc.state?.selectedDoorBell?.deviceId ??
            '',
        Constants.sessionId: sessionId,
        Constants.data: jsonEncode(data ?? {}),
        if (message != null) "message": message,
      };

      // if (command != Constants.allIotDevicesState) {
      // Register success/error handler
      SocketRequestManager.registerRequest(
        command: command,
        sessionId: sessionId,
        timeout: timeout,
        onSuccess: (response) {
          final updatedState = loadingState.rebuild(
            (b) => b
              ..data = response
              ..isSocketInProgress = false
              ..message = successMessage,
          );

          cubit.emit(
            cubit.state.rebuild((b) => updateApiState(b, updatedState)),
          );

          onSuccess?.call(response);
        },
        onError: (error) {
          final errorState = loadingState.rebuild(
            (b) => b
              ..isSocketInProgress = false
              ..error.replace(ApiMetaData.fromException(error)),
          );

          cubit.emit(
            cubit.state.rebuild((b) => updateApiState(b, errorState)),
          );

          onError?.call(error);
        },
      );
      // }

      _logger.info("📤 Emitting $eventName with command $command");
      await socket.emitWithAckAsync(
        eventName,
        payload,
        ack: (data) async {
          if (command == Constants.operateIotDevice) {
            payload["status"] = true;
            payload["data"] = jsonEncode({"success": true});
            SocketRequestManager.handleResponse(payload);
          }
        },
      );
    }
    // });
  }
}

mixin SocketRequestManager {
  static final Map<String, _SocketRequest> _pendingRequests = {};

  static void registerRequest({
    required String command,
    required String sessionId,
    required void Function(dynamic data) onSuccess,
    required void Function(Object error) onError,
    Duration timeout = const Duration(seconds: 30),
  }) {
    final internalKey = _generateUniqueKey(command, sessionId);

    _pendingRequests[internalKey] = _SocketRequest(
      onSuccess: onSuccess,
      onError: onError,
    );

    // Set timeout
    Future.delayed(timeout, () async {
      if (_pendingRequests.containsKey(internalKey)) {
        // CubitUtils.connectivityResult ??=
        //     await Connectivity().checkConnectivity();

        // final connectivityResult = await Connectivity().checkConnectivity();
        // unawaited(EasyLoading.dismiss());
        Constants.dismissLoader();

        // if (CubitUtils.connectivityResult!.contains(ConnectivityResult.none)) {
        if (!singletonBloc.isInternetConnected) {
          // ToastUtils.errorToast(
          //   "Network error. Please check your internet connection",
          // );
        }
        _pendingRequests.remove(internalKey)?.onError(
              TimeoutException("Socket call for '$command' timed out."),
            );
      }
    });
  }

  static bool handleResponse(dynamic data) {
    final command = data[Constants.command];
    final sessionId = data[Constants.sessionId];
    final baseKey = _baseKey(command, sessionId);

    // Find and trigger all matching requests
    final matchingKeys =
        _pendingRequests.keys.where((k) => k.startsWith(baseKey)).toList();

    for (final key in matchingKeys) {
      final request = _pendingRequests.remove(key);
      request?.onSuccess(data);
      return true;
    }
    return false;
  }

  static String _generateUniqueKey(String command, String sessionId) {
    final timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    return '$command|$sessionId|$timestamp';
  }

  static String _baseKey(String command, String sessionId) =>
      '$command|$sessionId';
}

class _SocketRequest {
  _SocketRequest({required this.onSuccess, required this.onError});

  final void Function(dynamic data) onSuccess;
  final void Function(Object error) onError;
}
