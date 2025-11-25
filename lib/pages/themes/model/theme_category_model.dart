import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'theme_category_model.g.dart';

abstract class ThemeCategoryModel
    implements Built<ThemeCategoryModel, ThemeCategoryModelBuilder> {
  factory ThemeCategoryModel([
    void Function(ThemeCategoryModelBuilder) updates,
  ]) = _$ThemeCategoryModel;

  ThemeCategoryModel._();
  int get id;

  String get name;

  String get image;

  @BuiltValueField(wireName: 'is_active')
  int? get isActive;

  @BuiltValueField(wireName: 'created_at')
  String get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  String get updatedAt;

  static Serializer<ThemeCategoryModel> get serializer =>
      _$themeCategoryModelSerializer;

  static ThemeCategoryModel fromDynamic(final json) {
    return serializers.deserializeWith(ThemeCategoryModel.serializer, json)!;
  }

  static BuiltList<ThemeCategoryModel> fromDynamics(final List<dynamic> list) {
    return BuiltList<ThemeCategoryModel>(list.map(fromDynamic));
  }
}
