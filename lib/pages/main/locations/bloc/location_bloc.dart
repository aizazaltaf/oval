import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/sub_user_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/dashboard/main_dashboard.dart';
import 'package:admin/pages/main/locations/bloc/location_state.dart';
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

part 'location_bloc.bloc.g.dart';

@BlocGen()
class LocationBloc extends BVCubit<LocationState, LocationStateBuilder>
    with _LocationBlocMixin {
  LocationBloc() : super(LocationState());

  factory LocationBloc.of(final BuildContext context) =>
      BlocProvider.of<LocationBloc>(context);

  void reInitializeLocationFields() {
    emit(state.rebuild((b) => b..search = null));
  }

  Future<void> callReleaseLocation({
    required int locationId,
    required VoidCallback successFunction,
  }) async {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.releaseLocationApi,
      updateApiState: (final b, final apiState) =>
          b.releaseLocationApi.replace(apiState),
      onError: (exception) {
        if (exception is DioException && exception.response != null) {
          ToastUtils.errorToast(exception.response!.data["message"]);
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
      callApi: () async {
        final response = await apiService.releaseLocation(
          locationId: locationId,
        );
        if (response.data['success'] == true) {
          ToastUtils.successToast(response.data["message"]);
          successFunction();
        } else {
          ToastUtils.errorToast(response.data["message"]);
        }
      },
    );
  }

  void successRelease(BuildContext context, DoorbellLocations location) {
    final startupBloc = StartupBloc.of(context);
    int? anyOtherLocationId;
    try {
      anyOtherLocationId = startupBloc.state.userDeviceModel!
          .where(
            (element) =>
                element.locationId != location.id && element.entityId == null,
          )
          .firstOrNull!
          .locationId;
      releaseLocationFunction(
        context,
        anyOtherLocationId,
        getRoleId(location),
        location,
      );
    } catch (e) {
      releaseLocationFunction(
        context,
        anyOtherLocationId,
        getRoleId(location),
        location,
      );
    }
  }

  int getRoleId(DoorbellLocations location) {
    if (location.roles[0] == "Admin") {
      return 3;
    } else if (location.roles[0] == "Viewer") {
      return 4;
    } else {
      return 2;
    }
  }

  Future<void> releaseSocketEmit({
    required StartupBloc startupBloc,
    required int roleId,
    required DoorbellLocations location,
  }) async {
    final doorbellsList = startupBloc.state.userDeviceModel
        ?.where((e) => e.locationId == location.id)
        .toList();

    if (roleId == 2) {
      doorbellsList?.forEach((doorbell) async {
        await singletonBloc.socketEmitter(
          roomName: Constants.doorbell,
          roomId: doorbell.locationId.toString(),
          deviceId: doorbell.deviceId,
          request: Constants.doorbellRelease,
        );
      });
    }
    singletonBloc.socket?.emit("leaveRoom", location.id.toString());
    singletonBloc.joinRoom = false;
  }

  Future<void> releaseLocationFunction(
    BuildContext context,
    int? anyOtherLocationId,
    int roleId,
    DoorbellLocations location,
  ) async {
    final startupBloc = StartupBloc.of(context)..clearPageIndexes();
    final navigationContext = singletonBloc.navigatorKey?.currentState?.context;

    await releaseSocketEmit(
      startupBloc: startupBloc,
      roleId: roleId,
      location: location,
    );

    if (context.mounted) {
      ProfileBloc.of(context).updateSelectedDoorBellToNull();
      StartupBloc.of(context).updateDashboardApiCalling(true);
      await startupBloc.callEverything(id: anyOtherLocationId);
      if (navigationContext != null && navigationContext.mounted) {
        unawaited(CommonFunctions.updateLocationData(navigationContext));
        unawaited(MainDashboard.pushRemove(navigationContext));
      }
    }
  }

  Future<void> callTransferOwnership({
    required int locationId,
    required int newOwnerId,
    required int currentOwnerId,
    required VoidCallback successFunction,
  }) async {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.transferOwnershipApi,
      updateApiState: (final b, final apiState) =>
          b.transferOwnershipApi.replace(apiState),
      onError: (exception) {
        if (exception is DioException && exception.response != null) {
          ToastUtils.errorToast(exception.response!.data["message"]);
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
      callApi: () async {
        final response = await apiService.getOwnershipTransfer(
          locationId: locationId,
          newOwnerId: newOwnerId,
          currentOwnerId: currentOwnerId,
        );
        if (response.data['success'] == true) {
          ToastUtils.successToast(response.data["message"]);
          successFunction();
        } else {
          ToastUtils.errorToast(response.data["message"]);
        }
      },
    );
  }

  Future<void> callSubUsers({required int locationId}) async {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.locationSubUsersApi,
      updateApiState: (final b, final apiState) =>
          b.locationSubUsersApi.replace(apiState),
      onError: (exception) {
        updateLocationSubUsersList(BuiltList<SubUserModel>([]));
      },
      callApi: () async {
        BuiltList<SubUserModel> subUsers =
            await apiService.getSubUsers(locationId: locationId);
        subUsers = subUsers.rebuild(
          (builder) => builder.removeWhere(
            (user) => (user.role!.id == 2) || (user.inviteId != null),
          ),
        );
        updateLocationSubUsersList(subUsers);
        if (subUsers.isNotEmpty) {
          updateSelectedOwnershipUser(subUsers.first);
        }
      },
    );
  }
}
