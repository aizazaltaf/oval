import 'package:admin/models/data/role_model.dart';
import 'package:admin/models/data/sub_user_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/bloc/bloc_mocks.dart';
import '../../mocks/bloc/state_mocks.dart';

class UserManagementBlocTestHelper {
  late MockUserManagementBloc mockUserManagementBloc;
  late UserManagementState currentUserManagementState;

  void setup() {
    mockUserManagementBloc = MockUserManagementBloc();
    currentUserManagementState = MockUserManagementState();

    when(() => mockUserManagementBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockUserManagementBloc.state)
        .thenReturn(currentUserManagementState);

    setupDefaultState();
  }

  void setupDefaultState() {
    when(() => currentUserManagementState.search).thenReturn(null);
    when(() => currentUserManagementState.loggedInUserRoleId).thenReturn(4);
    when(() => currentUserManagementState.addEmail).thenReturn('');
    when(() => currentUserManagementState.addEmailError).thenReturn('');
    when(() => currentUserManagementState.addName).thenReturn('');
    when(() => currentUserManagementState.addNameError).thenReturn('');
    when(() => currentUserManagementState.addPhoneNumber).thenReturn('');
    when(() => currentUserManagementState.addPhoneNumberError).thenReturn('');
    when(() => currentUserManagementState.addRelation).thenReturn('Friend');
    when(() => currentUserManagementState.addRelationError).thenReturn('');
    when(() => currentUserManagementState.addRole).thenReturn(null);
    when(() => currentUserManagementState.countryCode).thenReturn('+1');
    when(() => currentUserManagementState.addUserButtonEnabled)
        .thenReturn(false);
    when(() => currentUserManagementState.subUsersList)
        .thenReturn(BuiltList<SubUserModel>([]));
    when(() => currentUserManagementState.relationshipList).thenReturn(
      BuiltList<String>(['Friend', 'Colleague', 'Father', 'Mother']),
    );
    when(() => currentUserManagementState.roles)
        .thenReturn(BuiltList<RoleModel>([]));
    when(() => currentUserManagementState.getRolesApi)
        .thenReturn(ApiState<void>());
    when(() => currentUserManagementState.createUserInviteApi)
        .thenReturn(ApiState<void>());
    when(() => currentUserManagementState.getSubUsersApi)
        .thenReturn(ApiState<void>());
    when(() => currentUserManagementState.getDeleteInviteApi)
        .thenReturn(ApiState<void>());
    when(() => currentUserManagementState.getDeleteUserApi)
        .thenReturn(ApiState<void>());
  }

  void dispose() {
    // No stream controller to dispose
  }
}
