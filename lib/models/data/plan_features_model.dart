import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'plan_features_model.g.dart';

abstract class PlanFeaturesModel
    implements Built<PlanFeaturesModel, PlanFeaturesModelBuilder> {
  factory PlanFeaturesModel([void Function(PlanFeaturesModelBuilder) updates]) =
      _$PlanFeaturesModel;

  PlanFeaturesModel._();

  static Serializer<PlanFeaturesModel> get serializer =>
      _$planFeaturesModelSerializer;

  String get code;

  String get category;

  String? get feature;

  @BuiltValueField(wireName: 'sub_feature')
  String? get subFeature;

  static PlanFeaturesModel fromDynamic(dynamic json) {
    return serializers.deserializeWith(PlanFeaturesModel.serializer, json)!;
  }

  static BuiltList<PlanFeaturesModel> fromDynamics(List<dynamic> list) {
    return BuiltList<PlanFeaturesModel>(list.map(fromDynamic));
  }
}
