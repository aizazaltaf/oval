import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/models/serializers.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_data.g.dart';

abstract class NotificationData
    implements Built<NotificationData, NotificationDataBuilder> {
  factory NotificationData([void Function(NotificationDataBuilder) updates]) =
      _$NotificationData;

  NotificationData._();
  int get id;

  String get title;

  @BuiltValueField(wireName: 'image')
  String? get imageUrl;

  @BuiltValueField(wireName: 'voice_message')
  String? get voiceMessage;

  @BuiltValueField(wireName: 'user_id')
  int get userId;

  @BuiltValueField(wireName: 'location_id')
  int get locationId;

  String get text;

  @BuiltValueField(wireName: 'device_id')
  String? get deviceId;

  @BuiltValueField(wireName: 'visitor_id')
  int? get visitorId;

  @BuiltValueField(wireName: 'is_read')
  int get isRead;

  @BuiltValueField(wireName: 'created_at')
  String get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  String get updatedAt;

  @BuiltValueField(wireName: 'entity_id')
  String? get entityId;

  @BuiltValueField(wireName: 'receive_type')
  String? get receiveType;

  @BuiltValueField(wireName: 'deleted_at')
  String? get deletedAt;

  @BuiltValueField(wireName: 'visitors')
  VisitorsModel? get visitor;

  UserDeviceModel? get doorbell;

  @BuiltValueField(wireName: 'iot_device')
  IotDeviceModel? get iotDevice;

  bool get expanded;

  static void _initializeBuilder(NotificationDataBuilder b) {
    b.expanded = false;
  }

  static Serializer<NotificationData> get serializer =>
      _$notificationDataSerializer;

  static NotificationData fromDynamic(final json) {
    return serializers.deserializeWith(
      NotificationData.serializer,
      json,
    )!;
  }

  static BuiltList<NotificationData> fromDynamics(final List<dynamic> list) {
    return BuiltList<NotificationData>(list.map(fromDynamic));
  }
}
