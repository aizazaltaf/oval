import 'package:admin/models/data/sub_user_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'location_state.g.dart';

abstract class LocationState
    implements Built<LocationState, LocationStateBuilder> {
  factory LocationState([
    final void Function(LocationStateBuilder) updates,
  ]) = _$LocationState;

  LocationState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final LocationStateBuilder b) =>
      b..selectedReleaseLocationId = "";

  @BlocUpdateField()
  String? get search;

  @BlocUpdateField()
  SubUserModel? get selectedOwnershipUser;

  @BlocUpdateField()
  BuiltList<SubUserModel>? get locationSubUsersList;

  @BlocUpdateField()
  String get selectedReleaseLocationId;

  ApiState<void> get locationSubUsersApi;

  ApiState<void> get transferOwnershipApi;

  ApiState<void> get releaseLocationApi;
}
