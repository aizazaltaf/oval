import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/models/data/login_session_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/logout/bloc/logout_state.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/dio.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'logout_bloc.bloc.g.dart';

@BlocGen()
class LogoutBloc extends BVCubit<LogoutState, LogoutStateBuilder>
    with _LogoutBlocMixin {
  LogoutBloc() : super(LogoutState());

  factory LogoutBloc.of(final BuildContext context) =>
      BlocProvider.of<LogoutBloc>(context);

  Future<void> callDeviceToken() async {
    final String deviceToken = await CommonFunctions.getDeviceToken() ?? '';
    updateCurrentDeviceToken(deviceToken);
  }

  Future<void> callLogoutOfSpecificDevice({required String deviceToken}) async {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.logoutOfSpecificDeviceApi,
      updateApiState: (final b, final apiState) =>
          b.logoutOfSpecificDeviceApi.replace(apiState),
      onError: (exception) {
        if (exception is DioException && exception.response != null) {
          ToastUtils.errorToast(exception.response!.data["message"]);
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
      callApi: () async {
        await apiService.logoutOfSpecificDevice(
          deviceToken: deviceToken,
          sendPushNotification: true,
        );
        ToastUtils.successToast(
          "You have successfully logged out from the selected device.",
        );
        await callLoginActivities();
      },
    );
  }

  Future<void> callLogoutAllSessions() async {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.logoutAllSessionsApi,
      updateApiState: (final b, final apiState) =>
          b.logoutAllSessionsApi.replace(apiState),
      onError: (exception) {
        if (exception is DioException && exception.response != null) {
          ToastUtils.errorToast(exception.response!.data["message"]);
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
      callApi: () async {
        await apiService.logoutAllSessions();
        ToastUtils.successToast(
          "You have successfully logged out from all devices.",
        );
        await singletonBloc.getBox.erase();
      },
    );
  }

  Future<void> callLoginActivities() {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.loginActivityApi,
      updateApiState: (final b, final apiState) =>
          b.loginActivityApi.replace(apiState),
      onError: (exception) {
        updateLoginActivities(BuiltList<LoginSessionModel>([]));
      },
      callApi: () async {
        final BuiltList<LoginSessionModel> sessions =
            await apiService.getLoginActivities();
        updateLoginActivities(sortLoginSessionModels(sessions));
      },
    );
  }

  Future<void> callOnRefreshLoginActivities() async {
    final BuiltList<LoginSessionModel> sessions =
        await apiService.getLoginActivities();
    updateLoginActivities(sortLoginSessionModels(sessions));
  }

  BuiltList<LoginSessionModel> sortLoginSessionModels(
    BuiltList<LoginSessionModel> sessions,
  ) {
    final List<LoginSessionModel> sortedList = sessions.toList()
      ..sort((a, b) {
        int getPriority(LoginSessionModel session) {
          if (session.status == null &&
              session.deviceToken == state.currentDeviceToken) {
            return 0;
          } else if (session.status == null) {
            return 1;
          } else {
            return 2;
          }
        }

        return getPriority(a).compareTo(getPriority(b));
      });

    return BuiltList<LoginSessionModel>(sortedList);
  }
}
