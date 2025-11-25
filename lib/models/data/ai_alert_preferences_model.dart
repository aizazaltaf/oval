import 'package:admin/models/data/notification_code_model.dart';
import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ai_alert_preferences_model.g.dart';

abstract class AiAlertPreferencesModel
    implements Built<AiAlertPreferencesModel, AiAlertPreferencesModelBuilder> {
  factory AiAlertPreferencesModel([
    void Function(AiAlertPreferencesModelBuilder) updates,
  ]) = _$AiAlertPreferencesModel;

  AiAlertPreferencesModel._();

  static Serializer<AiAlertPreferencesModel> get serializer =>
      _$aiAlertPreferencesModelSerializer;

  int? get id;

  @BuiltValueField(wireName: 'device_id')
  int? get deviceId;

  @BuiltValueField(wireName: 'doorbell_id')
  int? get doorbellId;

  @BuiltValueField(wireName: 'notification_code_id')
  int get notificationCodeId;

  @BuiltValueField(wireName: 'is_enabled')
  int get isEnabled;

  @BuiltValueField(wireName: 'notification_code')
  NotificationCodeModel get notificationCode;

  /// Deserialize single object
  static AiAlertPreferencesModel fromDynamic(dynamic json) {
    return serializers.deserializeWith(
      AiAlertPreferencesModel.serializer,
      json,
    )!;
  }

  /// Deserialize list of objects
  static BuiltList<AiAlertPreferencesModel> fromDynamics(List<dynamic> list) {
    return BuiltList<AiAlertPreferencesModel>(
      list.map(fromDynamic),
    );
  }
}
