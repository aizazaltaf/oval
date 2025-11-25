import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'visit_model.g.dart';

abstract class VisitModel implements Built<VisitModel, VisitModelBuilder> {
  factory VisitModel([void Function(VisitModelBuilder) updates]) = _$VisitModel;

  VisitModel._();

  static Serializer<VisitModel> get serializer => _$visitModelSerializer;

  int get id;

  @BuiltValueField(wireName: 'visitor_id')
  int get visitorId;

  @BuiltValueField(wireName: 'device_id')
  String get deviceId;

  @BuiltValueField(wireName: 'created_at')
  String get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  String get updatedAt;

  static VisitModel fromDynamic(json) {
    return serializers.deserializeWith(
      VisitModel.serializer,
      json,
    )!;
  }

  static BuiltList<VisitModel> fromDynamics(List<dynamic> list) {
    return BuiltList<VisitModel>(list.map(fromDynamic));
  }
}
