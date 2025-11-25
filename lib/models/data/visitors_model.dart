import 'dart:convert';

import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'visitors_model.g.dart';

abstract class VisitorsModel
    implements Built<VisitorsModel, VisitorsModelBuilder> {
  factory VisitorsModel([void Function(VisitorsModelBuilder) updates]) =
      _$VisitorsModel;

  VisitorsModel._();

  static Serializer<VisitorsModel> get serializer => _$visitorsModelSerializer;

  int get id;

  @BuiltValueField(wireName: 'unique_id')
  String? get uniqueId;

  @BuiltValueField(wireName: 'name')
  String get name;

  @BuiltValueField(wireName: 'image')
  String? get imageUrl;

  @BuiltValueField(wireName: 'is_wanted')
  int get isWanted;

  @BuiltValueField(wireName: 'location_id')
  int? get locationId;

  @BuiltValueField(wireName: 'last_visit')
  String? get lastVisit;

  @BuiltValueField(wireName: 'face_coordinate')
  String? get faceCoordinate;

  static VisitorsModel fromDynamic(json) {
    if (json["face_coordinate"] != null) {
      if (json["face_coordinate"] is List) {
        json["face_coordinate"] = jsonEncode(json["face_coordinate"]);
      }
    }
    return serializers.deserializeWith(
      VisitorsModel.serializer,
      json,
    )!;
  }

  static BuiltList<VisitorsModel> fromDynamics(final List<dynamic> list) {
    return BuiltList<VisitorsModel>(list.map(fromDynamic));
  }
}
