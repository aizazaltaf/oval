import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'role_model.g.dart';

abstract class RoleModel implements Built<RoleModel, RoleModelBuilder> {
  factory RoleModel([void Function(RoleModelBuilder) updates]) = _$RoleModel;

  RoleModel._();

  static Serializer<RoleModel> get serializer => _$roleModelSerializer;

  int get id;

  String get name;

  String? get description;

  @BuiltValueField(wireName: 'created_at')
  String? get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  String? get updatedAt;

  static RoleModel fromDynamic(json) {
    return serializers.deserializeWith(RoleModel.serializer, json)!;
  }

  static BuiltList<RoleModel> fromDynamics(final List<dynamic> list) {
    return BuiltList<RoleModel>(list.map(fromDynamic));
  }
}
