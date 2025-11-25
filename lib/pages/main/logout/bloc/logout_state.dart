import 'package:admin/models/data/login_session_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'logout_state.g.dart';

abstract class LogoutState implements Built<LogoutState, LogoutStateBuilder> {
  factory LogoutState([
    final void Function(LogoutStateBuilder) updates,
  ]) = _$LogoutState;

  LogoutState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final LogoutStateBuilder b) =>
      b..currentDeviceToken = '';

  @BlocUpdateField()
  String get currentDeviceToken;

  @BlocUpdateField()
  BuiltList<LoginSessionModel>? get loginActivities;

  ApiState<void> get loginActivityApi;

  ApiState<void> get logoutOfSpecificDeviceApi;

  ApiState<void> get logoutAllSessionsApi;
}
