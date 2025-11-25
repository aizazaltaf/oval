import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/themes/model/theme_category_model.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:admin/pages/themes/model/weather_model.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' as material;
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'theme_state.g.dart';

abstract class ThemeState implements Built<ThemeState, ThemeStateBuilder> {
  factory ThemeState([
    final void Function(ThemeStateBuilder) updates,
  ]) = _$ThemeState;

  ThemeState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final ThemeStateBuilder b) => b
    ..activeType = 'Feed'
    ..search = ''
    ..aiThemeText = ''
    ..themeNameField = ''
    ..simpleThemesError = ''
    ..uploadOnDoorBell = false
    ..isDetailThemePage = false
    ..aiError = ''
    ..themeDropdownField = material.TextEditingController()
    ..index = 0
    ..searchField = material.TextEditingController()
    ..timeZoneColor = AppColors.defaultColorPicker
    ..weatherColor = AppColors.defaultColorPicker
    ..locationColor = AppColors.defaultColorPicker
    ..textColor = AppColors.defaultColorPicker
    ..bottomTextColor = AppColors.defaultColorPicker
    ..pickerColor = AppColors.defaultColorPicker
    ..canPop = true;

  @BlocUpdateField()
  String get activeType;
  @BlocUpdateField()
  bool get canPop;
  @BlocUpdateField()
  bool get uploadOnDoorBell;
  @BlocUpdateField()
  bool get isDetailThemePage;
  @BlocUpdateField()
  String get search;
  material.TextEditingController get searchField;
  @BlocUpdateField()
  String get aiError;
  @BlocUpdateField()
  String get aiThemeText;
  @BlocUpdateField()
  UserDeviceModel? get selectedDoorBell;
  @BlocUpdateField()
  String get simpleThemesError;
  @BlocUpdateField()
  String? get generatedImage;
  @BlocUpdateField()
  String? get categorySelectedValue;
  @BlocUpdateField()
  int? get themeId;
  int? get categoryId;
  int? get apiCategoryId;
  @BlocUpdateField()
  String? get themeNameField;
  material.TextEditingController get themeDropdownField;

  int get index;

  material.Color get timeZoneColor;
  material.Color get weatherColor;
  material.Color get locationColor;
  material.Color get textColor;
  material.Color get bottomTextColor;
  material.Color get pickerColor;
  @BlocUpdateField()
  BuiltList<String> get getThemeCategoryNameList;

  ApiState<PaginatedData<ThemeCategoryModel>> get categoryThemesApi;
  ApiState<PaginatedData<ThemeDataModel>> get categoryDetailsThemesApi;
  ApiState<void> get themeLikeApi;
  ApiState<WeatherModel> get weatherApi;
  ApiState<void> get deleteThemeApi;
  ApiState<void> get applyThemeApi;
  ApiState<void> get removeThemeApi;
  ApiState<void> get generateAiThemeApi;
  ApiState<void> get uploadThemeApi;
  ApiState<PaginatedData<ThemeDataModel>> get feedThemes;
  ApiState<PaginatedData<ThemeDataModel>> get myThemes;
  ApiState<PaginatedData<ThemeDataModel>> get favouriteThemes;
  // ApiState<PaginatedData<ThemeDataModel>> get trendingThemes;
  ApiState<PaginatedData<ThemeDataModel>> get popularThemes;
  ApiState<PaginatedData<ThemeDataModel>> get videosThemes;
  ApiState<PaginatedData<ThemeDataModel>> get gifsThemes;
  // ApiState<PaginatedData<ThemeDataModel>> get recentThemes;
}
