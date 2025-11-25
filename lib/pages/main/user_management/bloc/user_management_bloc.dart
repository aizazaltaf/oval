import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/models/data/role_model.dart';
import 'package:admin/models/data/sub_user_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_state.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/dio.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'user_management_bloc.bloc.g.dart';

@BlocGen()
class UserManagementBloc
    extends BVCubit<UserManagementState, UserManagementStateBuilder>
    with _UserManagementBlocMixin {
  UserManagementBloc() : super(UserManagementState());

  factory UserManagementBloc.of(final BuildContext context) =>
      BlocProvider.of<UserManagementBloc>(context);

  void reInitializeUserManagementFields() {
    emit(state.rebuild((b) => b..search = null));
  }

  void reInitializeAddUserFields() {
    emit(
      state.rebuild(
        (b) => b
          ..countryCode = "+1"
          ..addUserButtonEnabled = false
          ..addEmail = ""
          ..addEmailError = ""
          ..addName = ""
          ..addNameError = ""
          ..addPhoneNumber = ""
          ..addPhoneNumberError = ""
          ..addRelation = "Friend"
          ..addRelationError = "",
      ),
    );
  }

  void addUserButtonEnableValidation() {
    if (state.addEmailError.isEmpty && state.addEmail.isNotEmpty) {
      updateAddUserButtonEnabled(true);
    } else {
      updateAddUserButtonEnabled(false);
    }
  }

  void getUserLoggedInRole() {
    for (final SubUserModel subUser in state.subUsersList!) {
      if (subUser.email.trim() ==
          singletonBloc.profileBloc.state!.email!.trim()) {
        updateLoggedInUserRoleId(subUser.role!.id);
      }
    }
  }

  Future<void> callUserDelete({
    required int subUserId,
    required VoidCallback popFunction,
  }) async {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.getDeleteUserApi,
      updateApiState: (final b, final apiState) =>
          b.getDeleteUserApi.replace(apiState),
      onError: (exception) {
        ToastUtils.errorToast("User could not be deleted");
      },
      callApi: () async {
        final response = await apiService.getUserDelete(subUserId: subUserId);

        if (response["success"] == true) {
          ToastUtils.successToast(response["message"]);
          unawaited(callSubUsers());
          popFunction();
        } else {
          ToastUtils.errorToast(response["message"]);
        }
      },
    );
  }

  bool getAddEmailCheck() {
    if (state.addEmail.trim() == singletonBloc.profileBloc.state!.email) {
      return false;
    } else {
      if (state.subUsersList != null) {
        for (final SubUserModel subUser in state.subUsersList!) {
          if (subUser.email == state.addEmail.trim()) {
            return false;
          }
        }
        return true;
      } else {
        return true;
      }
    }
  }

  Future<void> callRoles() async {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.getRolesApi,
      updateApiState: (final b, final apiState) =>
          b.getRolesApi.replace(apiState),
      callApi: () async {
        final BuiltList<RoleModel> list = await apiService.getRoles();
        updateRoles(list);
        updateAddRole(list.first);
      },
    );
  }

  Future<void> callUserInviteDelete({
    required int inviteId,
    required VoidCallback popFunction,
  }) async {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.getDeleteInviteApi,
      updateApiState: (final b, final apiState) =>
          b.getDeleteInviteApi.replace(apiState),
      onError: (exception) {
        ToastUtils.errorToast("Invitation could not be deleted");
      },
      callApi: () async {
        final response =
            await apiService.getUserInviteDelete(inviteId: inviteId);

        if (response["success"] == true) {
          ToastUtils.successToast(response["message"]);
          unawaited(callSubUsers());
          popFunction();
        } else {
          ToastUtils.errorToast(response["message"]);
        }
      },
    );
  }

  //  User Management Bloc => Will make location id dynamic later after dashboard will be updated acc to new apis
  Future<void> callCreateUserInvite({
    required VoidCallback successFunction,
  }) async {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.createUserInviteApi,
      updateApiState: (final b, final apiState) =>
          b.createUserInviteApi.replace(apiState),
      onError: (exception) {
        if (exception is DioException && exception.response != null) {
          ToastUtils.errorToast(exception.response!.data["message"]);
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
      callApi: () async {
        final response = await apiService.getCreateUserInvite(
          userId: singletonBloc.profileBloc.state!.id,
          email: state.addEmail,
          roleId: state.addRole!.id,
          relation: state.addRelation,
        );

        if (response["success"] == true) {
          ToastUtils.successToast(response["message"]);
          unawaited(callSubUsers());
          successFunction();
        } else {
          ToastUtils.errorToast(response["message"]);
        }
      },
    );
  }

  List<SubUserModel> sortUsers(List<SubUserModel> users) {
    int getAcceptedPriority(String? status) {
      switch (status) {
        case "Pending":
          return 0;
        case "Accepted":
          return 1;
        default:
          return 2;
      }
    }

    int getRolePriority(String? roleName) {
      switch (roleName) {
        case "Owner":
          return 0;
        case "Admin":
          return 1;
        case "Viewer":
          return 2;
        default:
          return 3;
      }
    }

    users.sort((a, b) {
      final int acceptedA = getAcceptedPriority(a.isAccepted);
      final int acceptedB = getAcceptedPriority(b.isAccepted);
      if (acceptedA != acceptedB) {
        return acceptedA.compareTo(acceptedB);
      }

      final int roleA = getRolePriority(a.role?.name);
      final int roleB = getRolePriority(b.role?.name);
      return roleA.compareTo(roleB);
    });

    return users;
  }

  //  User Management Bloc => Will make location id dynamic later after dashboard will be updated acc to new apis
  Future<void> callSubUsers() async {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.getSubUsersApi,
      updateApiState: (final b, final apiState) =>
          b.getSubUsersApi.replace(apiState),
      onError: (exception) {
        updateSubUsersList(BuiltList<SubUserModel>([]));
      },
      callApi: () async {
        await callOnRefreshSubUsers();
      },
    );
  }

  Future<void> callOnRefreshSubUsers() async {
    final BuiltList<SubUserModel> subUsers = await apiService.getSubUsers();
    updateSubUsersList(BuiltList<SubUserModel>(sortUsers(subUsers.toList())));
    getUserLoggedInRole();
  }
}
