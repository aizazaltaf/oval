import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'theme_data_model.g.dart';

abstract class ThemeDataModel
    implements Built<ThemeDataModel, ThemeDataModelBuilder> {
  factory ThemeDataModel([void Function(ThemeDataModelBuilder) updates]) =
      _$ThemeDataModel;

  ThemeDataModel._();
  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final ThemeDataModelBuilder b) =>
      b..fromCache = false;
  int get id;

  String get title;

  String get description;

  String? get colors;

  @BlocUpdateField()
  String get cover;

  bool get fromCache;

  String get thumbnail;

  @BuiltValueField(wireName: 'user_uploaded')
  int? get userUploaded;

  @BuiltValueField(wireName: 'is_active')
  int get isActive;

  @BuiltValueField(wireName: 'created_at')
  String? get createdAt;

  @BuiltValueField(wireName: 'category_id')
  int get categoryId;

  @BuiltValueField(wireName: 'location_id')
  int? get locationId;

  @BuiltValueField(wireName: 'total_likes')
  int get totalLikes;

  @BuiltValueField(wireName: 'media_type')
  int get mediaType;

  @BuiltValueField(wireName: 'user_like')
  int get userLike;

  @BuiltValueField(wireName: 'is_applied')
  bool get isApplied;

  @BuiltValueField(wireName: 'device_id')
  String? get deviceId;

  static Serializer<ThemeDataModel> get serializer =>
      _$themeDataModelSerializer;

  static ThemeDataModel fromDynamic(final json) {
    json["cover"] ??=
        "https://gitlab-server.irvinei.com/oval/irvineiapp-2.0/-/raw/develop/assets/images/placeholder.jpeg?ref_type=heads";
    json["thumbnail"] ??= json["cover"];
    return serializers.deserializeWith(ThemeDataModel.serializer, json)!;
  }

  static BuiltList<ThemeDataModel> fromDynamics(final List<dynamic> list) {
    return BuiltList<ThemeDataModel>(list.map(fromDynamic));
  }
}
