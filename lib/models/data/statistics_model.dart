import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'statistics_model.g.dart';

abstract class StatisticsModel
    implements Built<StatisticsModel, StatisticsModelBuilder> {
  factory StatisticsModel([void Function(StatisticsModelBuilder) updates]) =
      _$StatisticsModel;

  StatisticsModel._();

  static Serializer<StatisticsModel> get serializer =>
      _$statisticsModelSerializer;

  String get title;

  @BuiltValueField(wireName: 'visit_count')
  int get visitCount;

  static StatisticsModel fromDynamic(json) {
    return serializers.deserializeWith(StatisticsModel.serializer, json)!;
  }

  static BuiltList<StatisticsModel> fromDynamics(List<dynamic> list) {
    return BuiltList<StatisticsModel>(list.map(fromDynamic));
  }
}
