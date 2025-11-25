import 'package:admin/models/serializers.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paginated_theme_data_model.g.dart';

abstract class PaginatedThemeDataModel
    implements Built<PaginatedThemeDataModel, PaginatedThemeDataModelBuilder> {
  factory PaginatedThemeDataModel([
    void Function(PaginatedThemeDataModelBuilder) updates,
  ]) = _$PaginatedThemeDataModel;

  PaginatedThemeDataModel._();
  bool get success;
  String get message;
  int get code;
  BuiltList<ThemeDataModel> get data;
  PaginationModel get pagination;

  static Serializer<PaginatedThemeDataModel> get serializer =>
      _$paginatedThemeDataModelSerializer;

  static PaginatedThemeDataModel fromDynamic(final json) {
    return serializers.deserializeWith(
      PaginatedThemeDataModel.serializer,
      json,
    )!;
  }
}

abstract class PaginationModel
    implements Built<PaginationModel, PaginationModelBuilder> {
  factory PaginationModel([void Function(PaginationModelBuilder) updates]) =
      _$PaginationModel;
  PaginationModel._();
  int get total;
  @BuiltValueField(wireName: 'current_page')
  int get currentPage;
  @BuiltValueField(wireName: 'last_page')
  int get lastPage;
  @BuiltValueField(wireName: 'per_page')
  int get perPage;
  @BuiltValueField(wireName: 'last_page_url')
  String get lastPageUrl;
  @BuiltValueField(wireName: 'next_page_url')
  String get nextPageUrl;
  String get path;
  @BuiltValueField(wireName: 'prev_page_url')
  String? get prevPageUrl;

  static Serializer<PaginationModel> get serializer =>
      _$paginationModelSerializer;

  static PaginationModel fromDynamic(final json) {
    return serializers.deserializeWith(PaginationModel.serializer, json)!;
  }
}
