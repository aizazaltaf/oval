// ignore_for_file: type=lint, unused_element

part of 'user_management_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class UserManagementBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<UserManagementState>? buildWhen;
  final BlocWidgetBuilder<UserManagementState> builder;

  const UserManagementBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<UserManagementBloc, UserManagementState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class UserManagementBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<UserManagementState, T> selector;
  final Widget Function(T state) builder;
  final UserManagementBloc? bloc;

  const UserManagementBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static UserManagementBlocSelector<String?> search({
    final Key? key,
    required Widget Function(String? search) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.search,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<int> loggedInUserRoleId({
    final Key? key,
    required Widget Function(int loggedInUserRoleId) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.loggedInUserRoleId,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<String> addEmail({
    final Key? key,
    required Widget Function(String addEmail) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.addEmail,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<String> addEmailError({
    final Key? key,
    required Widget Function(String addEmailError) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.addEmailError,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<String> addName({
    final Key? key,
    required Widget Function(String addName) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.addName,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<String> addNameError({
    final Key? key,
    required Widget Function(String addNameError) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.addNameError,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<String> addPhoneNumber({
    final Key? key,
    required Widget Function(String addPhoneNumber) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.addPhoneNumber,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<String> addPhoneNumberError({
    final Key? key,
    required Widget Function(String addPhoneNumberError) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.addPhoneNumberError,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<String> addRelation({
    final Key? key,
    required Widget Function(String addRelation) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.addRelation,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<String> addRelationError({
    final Key? key,
    required Widget Function(String addRelationError) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.addRelationError,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<RoleModel?> addRole({
    final Key? key,
    required Widget Function(RoleModel? addRole) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.addRole,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<String> countryCode({
    final Key? key,
    required Widget Function(String countryCode) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.countryCode,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<bool> addUserButtonEnabled({
    final Key? key,
    required Widget Function(bool addUserButtonEnabled) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.addUserButtonEnabled,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<BuiltList<SubUserModel>?> subUsersList({
    final Key? key,
    required Widget Function(BuiltList<SubUserModel>? subUsersList) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.subUsersList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<BuiltList<String>> relationshipList({
    final Key? key,
    required Widget Function(BuiltList<String> relationshipList) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.relationshipList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<BuiltList<RoleModel>> roles({
    final Key? key,
    required Widget Function(BuiltList<RoleModel> roles) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.roles,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<ApiState<void>> getRolesApi({
    final Key? key,
    required Widget Function(ApiState<void> getRolesApi) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.getRolesApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<ApiState<void>> createUserInviteApi({
    final Key? key,
    required Widget Function(ApiState<void> createUserInviteApi) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.createUserInviteApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<ApiState<void>> getSubUsersApi({
    final Key? key,
    required Widget Function(ApiState<void> getSubUsersApi) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.getSubUsersApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<ApiState<void>> getDeleteInviteApi({
    final Key? key,
    required Widget Function(ApiState<void> getDeleteInviteApi) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.getDeleteInviteApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserManagementBlocSelector<ApiState<void>> getDeleteUserApi({
    final Key? key,
    required Widget Function(ApiState<void> getDeleteUserApi) builder,
    final UserManagementBloc? bloc,
  }) {
    return UserManagementBlocSelector(
      key: key,
      selector: (state) => state.getDeleteUserApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<UserManagementBloc, UserManagementState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _UserManagementBlocMixin on Cubit<UserManagementState> {
  @mustCallSuper
  void updateSearch(final String? search) {
    if (this.state.search == search) {
      return;
    }

    emit(this.state.rebuild((final b) => b.search = search));

    $onUpdateSearch();
  }

  @protected
  void $onUpdateSearch() {}

  @mustCallSuper
  void updateLoggedInUserRoleId(final int loggedInUserRoleId) {
    if (this.state.loggedInUserRoleId == loggedInUserRoleId) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.loggedInUserRoleId = loggedInUserRoleId));

    $onUpdateLoggedInUserRoleId();
  }

  @protected
  void $onUpdateLoggedInUserRoleId() {}

  @mustCallSuper
  void updateAddEmail(final String addEmail) {
    if (this.state.addEmail == addEmail) {
      return;
    }

    emit(this.state.rebuild((final b) => b.addEmail = addEmail));

    $onUpdateAddEmail();
  }

  @protected
  void $onUpdateAddEmail() {}

  @mustCallSuper
  void updateAddEmailError(final String addEmailError) {
    if (this.state.addEmailError == addEmailError) {
      return;
    }

    emit(this.state.rebuild((final b) => b.addEmailError = addEmailError));

    $onUpdateAddEmailError();
  }

  @protected
  void $onUpdateAddEmailError() {}

  @mustCallSuper
  void updateAddName(final String addName) {
    if (this.state.addName == addName) {
      return;
    }

    emit(this.state.rebuild((final b) => b.addName = addName));

    $onUpdateAddName();
  }

  @protected
  void $onUpdateAddName() {}

  @mustCallSuper
  void updateAddNameError(final String addNameError) {
    if (this.state.addNameError == addNameError) {
      return;
    }

    emit(this.state.rebuild((final b) => b.addNameError = addNameError));

    $onUpdateAddNameError();
  }

  @protected
  void $onUpdateAddNameError() {}

  @mustCallSuper
  void updateAddPhoneNumber(final String addPhoneNumber) {
    if (this.state.addPhoneNumber == addPhoneNumber) {
      return;
    }

    emit(this.state.rebuild((final b) => b.addPhoneNumber = addPhoneNumber));

    $onUpdateAddPhoneNumber();
  }

  @protected
  void $onUpdateAddPhoneNumber() {}

  @mustCallSuper
  void updateAddPhoneNumberError(final String addPhoneNumberError) {
    if (this.state.addPhoneNumberError == addPhoneNumberError) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.addPhoneNumberError = addPhoneNumberError));

    $onUpdateAddPhoneNumberError();
  }

  @protected
  void $onUpdateAddPhoneNumberError() {}

  @mustCallSuper
  void updateAddRelation(final String addRelation) {
    if (this.state.addRelation == addRelation) {
      return;
    }

    emit(this.state.rebuild((final b) => b.addRelation = addRelation));

    $onUpdateAddRelation();
  }

  @protected
  void $onUpdateAddRelation() {}

  @mustCallSuper
  void updateAddRelationError(final String addRelationError) {
    if (this.state.addRelationError == addRelationError) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.addRelationError = addRelationError));

    $onUpdateAddRelationError();
  }

  @protected
  void $onUpdateAddRelationError() {}

  @mustCallSuper
  void updateAddRole(final RoleModel? addRole) {
    if (this.state.addRole == addRole) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (addRole == null)
        b.addRole = null;
      else
        b.addRole.replace(addRole);
    }));

    $onUpdateAddRole();
  }

  @protected
  void $onUpdateAddRole() {}

  @mustCallSuper
  void updateCountryCode(final String countryCode) {
    if (this.state.countryCode == countryCode) {
      return;
    }

    emit(this.state.rebuild((final b) => b.countryCode = countryCode));

    $onUpdateCountryCode();
  }

  @protected
  void $onUpdateCountryCode() {}

  @mustCallSuper
  void updateAddUserButtonEnabled(final bool addUserButtonEnabled) {
    if (this.state.addUserButtonEnabled == addUserButtonEnabled) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.addUserButtonEnabled = addUserButtonEnabled));

    $onUpdateAddUserButtonEnabled();
  }

  @protected
  void $onUpdateAddUserButtonEnabled() {}

  @mustCallSuper
  void updateSubUsersList(final BuiltList<SubUserModel>? subUsersList) {
    if (this.state.subUsersList == subUsersList) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (subUsersList == null)
        b.subUsersList = null;
      else
        b.subUsersList.replace(subUsersList);
    }));

    $onUpdateSubUsersList();
  }

  @protected
  void $onUpdateSubUsersList() {}

  @mustCallSuper
  void updateRelationshipList(final BuiltList<String> relationshipList) {
    if (this.state.relationshipList == relationshipList) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.relationshipList.replace(relationshipList);
    }));

    $onUpdateRelationshipList();
  }

  @protected
  void $onUpdateRelationshipList() {}

  @mustCallSuper
  void updateRoles(final BuiltList<RoleModel> roles) {
    if (this.state.roles == roles) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.roles.replace(roles);
    }));

    $onUpdateRoles();
  }

  @protected
  void $onUpdateRoles() {}
}
