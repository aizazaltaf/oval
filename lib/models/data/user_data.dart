import 'dart:convert';

import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/guide_data.dart';
import 'package:admin/models/data/plan_features_model.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'user_data.g.dart';

final logger = Logger('user_data.dart');

abstract class UserData implements Built<UserData, UserDataBuilder> {
  factory UserData([
    final void Function(UserDataBuilder) updates,
  ]) = _$UserData;

  UserData._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final UserDataBuilder b) =>
      b..sectionList = BuiltList<String>().toBuilder();

  static Serializer<UserData> get serializer => _$userDataSerializer;
  int get id;

  String? get name;

  String? get email;

  String? get phone;

  @BuiltValueField(wireName: "push_notification_token")
  String? get pushNotificationToken;

  @BuiltValueField(wireName: "ai_theme_counter")
  int get aiThemeCounter;

  @BuiltValueField(wireName: "uuid")
  String? get callUserId;

  String? get streamingId;

  UserDeviceModel? get selectedDoorBell;

  BuiltList<String>? get sectionList;

  BuiltList<PlanFeaturesModel>? get planFeaturesList;

  bool? get canPinned;

  String? get image;

  @BuiltValueField(wireName: "session_token")
  String? get apiToken;

  @BuiltValueField(wireName: "refresh_token")
  String? get refreshToken;

  @BuiltValueField(wireName: "pending_email")
  String? get pendingEmail;

  @BuiltValueField(wireName: "phone_verified")
  bool? get phoneVerified;

  @BuiltValueField(wireName: "email_verified")
  bool? get emailVerified;

  GuideModel? get guides;

  @BlocUpdateField()
  String? get userRole;

  BuiltList<DoorbellLocations>? get locations;

  static UserData fromDynamic(final json) {
    if (!(json["guides"] == null || json["guides"].isEmpty)) {
      json["guides"] = jsonDecode(json["guides"]);
    }

    return serializers.deserializeWith(
      UserData.serializer,
      json,
    )!;
  }
}
