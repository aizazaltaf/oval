import 'package:admin/models/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_code_model.g.dart';

abstract class NotificationCodeModel
    implements Built<NotificationCodeModel, NotificationCodeModelBuilder> {
  factory NotificationCodeModel([
    void Function(NotificationCodeModelBuilder) updates,
  ]) = _$NotificationCodeModel;

  NotificationCodeModel._();

  static Serializer<NotificationCodeModel> get serializer =>
      _$notificationCodeModelSerializer;

  int get id;

  String get slug;

  String get title;

  String get message;

  @BuiltValueField(wireName: 'created_at')
  String get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  String get updatedAt;

  @BuiltValueField(wireName: 'has_preferences')
  bool get hasPreferences;

  /// Deserialize single object
  static NotificationCodeModel fromDynamic(dynamic json) {
    return serializers.deserializeWith(
      NotificationCodeModel.serializer,
      json,
    )!;
  }
}
