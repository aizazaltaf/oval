import 'package:admin/models/data/role_model.dart';
import 'package:admin/models/data/sub_user_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'user_management_state.g.dart';

abstract class UserManagementState
    implements Built<UserManagementState, UserManagementStateBuilder> {
  factory UserManagementState([
    final void Function(UserManagementStateBuilder) updates,
  ]) = _$UserManagementState;

  UserManagementState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final UserManagementStateBuilder b) => b
    ..loggedInUserRoleId = 4
    ..countryCode = "+1"
    ..addUserButtonEnabled = false
    ..relationshipList.replace(
      [
        'Friend',
        'Colleague',
        'Father',
        'Mother',
        'Brother',
        'Sister',
        'Son',
        'Daughter',
        'Husband',
        'Wife',
        'Uncle',
        'Aunt',
        'Cousin',
        'Nephew',
        'Niece',
        'Grandfather',
        'Grandmother',
        'Partner',
        'Fiancé',
        'Landlord',
        'Tenant',
        'Guardian',
      ],
    )
    ..addEmail = ""
    ..addEmailError = ""
    ..addName = ""
    ..addNameError = ""
    ..addPhoneNumber = ""
    ..addPhoneNumberError = ""
    ..addRelation = "Friend"
    ..addRelationError = "";

  @BlocUpdateField()
  String? get search;

  @BlocUpdateField()
  int get loggedInUserRoleId;

  @BlocUpdateField()
  String get addEmail;

  @BlocUpdateField()
  String get addEmailError;

  @BlocUpdateField()
  String get addName;

  @BlocUpdateField()
  String get addNameError;

  @BlocUpdateField()
  String get addPhoneNumber;

  @BlocUpdateField()
  String get addPhoneNumberError;

  @BlocUpdateField()
  String get addRelation;

  @BlocUpdateField()
  String get addRelationError;

  @BlocUpdateField()
  RoleModel? get addRole;

  @BlocUpdateField()
  String get countryCode;

  @BlocUpdateField()
  bool get addUserButtonEnabled;

  @BlocUpdateField()
  BuiltList<SubUserModel>? get subUsersList;

  @BlocUpdateField()
  BuiltList<String> get relationshipList;

  @BlocUpdateField()
  BuiltList<RoleModel> get roles;

  ApiState<void> get getRolesApi;

  ApiState<void> get createUserInviteApi;

  ApiState<void> get getSubUsersApi;

  ApiState<void> get getDeleteInviteApi;

  ApiState<void> get getDeleteUserApi;
}
