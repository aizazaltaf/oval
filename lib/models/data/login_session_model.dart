import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'login_session_model.g.dart';

abstract class LoginSessionModel
    implements Built<LoginSessionModel, LoginSessionModelBuilder> {
  factory LoginSessionModel([void Function(LoginSessionModelBuilder) updates]) =
      _$LoginSessionModel;

  LoginSessionModel._();

  static Serializer<LoginSessionModel> get serializer =>
      _$loginSessionModelSerializer;

  int get id;

  @BuiltValueField(wireName: 'user_id')
  int get userId;

  @BuiltValueField(wireName: 'device_type')
  String? get deviceType;

  @BuiltValueField(wireName: 'ip_address')
  String? get ipAddress;

  String? get status;

  @BuiltValueField(wireName: 'logout_device')
  String? get logoutDevice;

  @BuiltValueField(wireName: 'device_token')
  String? get deviceToken;

  @BuiltValueField(wireName: 'is_trusted')
  int? get isTrusted;

  @BuiltValueField(wireName: 'login_time')
  String? get loginTime;

  @BuiltValueField(wireName: 'logout_time')
  String? get logoutTime;

  @BuiltValueField(wireName: 'created_at')
  String? get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  String? get updatedAt;

  @BuiltValueField(wireName: 'device_name')
  String? get deviceName;

  String? get location;

  static LoginSessionModel fromDynamic(json) {
    return serializers.deserializeWith(LoginSessionModel.serializer, json)!;
  }

  static BuiltList<LoginSessionModel> fromDynamics(final List<dynamic> list) {
    return BuiltList<LoginSessionModel>(list.map(fromDynamic));
  }
}
