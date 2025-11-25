import 'package:admin/models/data/role_model.dart';
import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sub_user_model.g.dart';

abstract class SubUserModel
    implements Built<SubUserModel, SubUserModelBuilder> {
  factory SubUserModel([void Function(SubUserModelBuilder) updates]) =
      _$SubUserModel;

  SubUserModel._();

  static Serializer<SubUserModel> get serializer => _$subUserModelSerializer;

  @BuiltValueField(wireName: 'user_id')
  int get id;

  String? get name;

  String get email;

  @BuiltValueField(wireName: 'phone_number')
  String? get phoneNumber;

  RoleModel? get role;

  @BuiltValueField(wireName: 'is_accepted')
  String? get isAccepted;

  @BuiltValueField(wireName: 'invite_id')
  int? get inviteId;

  @BuiltValueField(wireName: 'user_exist')
  bool get userExist;

  String get source;

  @BuiltValueField(wireName: 'profile_image')
  String? get profileImage;

  static SubUserModel fromDynamic(json) {
    return serializers.deserializeWith(SubUserModel.serializer, json)!;
  }

  static BuiltList<SubUserModel> fromDynamics(List<dynamic> list) {
    return BuiltList<SubUserModel>(list.map(fromDynamic));
  }
}
