import 'dart:convert';

import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_device_model.g.dart';

abstract class UserDeviceModel
    implements Built<UserDeviceModel, UserDeviceModelBuilder> {
  factory UserDeviceModel([void Function(UserDeviceModelBuilder) updates]) =
      _$UserDeviceModel;

  UserDeviceModel._();
  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final UserDeviceModelBuilder b) =>
      b..isExternalCamera = false;

  static Serializer<UserDeviceModel> get serializer =>
      _$userDeviceModelSerializer;

  int get id;

  @BuiltValueField(wireName: 'device_id')
  String? get deviceId;

  @BuiltValueField(wireName: 'entity_id')
  String? get entityId;

  @BuiltValueField(wireName: 'location_id')
  int? get locationId;

  @BuiltValueField(wireName: 'room_id')
  int? get roomId;
  @BuiltValueField(wireName: 'is_streaming')
  int? get isStreaming;

  @BuiltValueField(wireName: 'push_notification_token')
  String? get deviceToken;

  @BuiltValueField(wireName: 'uuid')
  String get callUserId;

  @BuiltValueField(wireName: 'image_preview')
  String? get image;

  @BuiltValueField(wireName: 'device_name')
  String? get name;

  @BuiltValueField(wireName: 'location')
  DoorbellLocations? get doorbellLocations;

  bool? get isExternalCamera;

  @BuiltValueField(wireName: 'is_default')
  int? get isDefault;

  @BuiltValueField(wireName: 'details')
  String? get details;

  @BuiltValueField(wireName: 'edgelight')
  bool? get edge;

  @BuiltValueField(wireName: 'flashlight')
  bool? get flash;

  static int? tempLocationId;

  static UserDeviceModel fromDynamic(json) {
    if (json["entity_id"] != null) {
      json["isExternalCamera"] = true;
    }
    if (json["isExternalCamera"] == null) {
      json["isExternalCamera"] = false;
    }

    if (json["location_id"] != null) {
      tempLocationId = json["location_id"];
    } else {
      if (tempLocationId != null) {
        json["location_id"] = tempLocationId;
      }
    }

    if (json["details"] != null) {
      json["details"] = jsonEncode(json["details"]);
    }
    json["device_id"] = json["device_id"].toString();
    return serializers.deserializeWith(
      UserDeviceModel.serializer,
      json,
    )!;
  }

  static BuiltList<UserDeviceModel> fromDynamics(final List<dynamic> list) {
    if (list.isNotEmpty) {
      return BuiltList<UserDeviceModel>(list.map(fromDynamic));
    }
    return <UserDeviceModel>[].toBuiltList();
  }
}
