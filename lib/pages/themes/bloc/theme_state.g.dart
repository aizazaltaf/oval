// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ThemeState extends ThemeState {
  @override
  final String activeType;
  @override
  final bool canPop;
  @override
  final bool uploadOnDoorBell;
  @override
  final bool isDetailThemePage;
  @override
  final String search;
  @override
  final material.TextEditingController searchField;
  @override
  final String aiError;
  @override
  final String aiThemeText;
  @override
  final UserDeviceModel? selectedDoorBell;
  @override
  final String simpleThemesError;
  @override
  final String? generatedImage;
  @override
  final String? categorySelectedValue;
  @override
  final int? themeId;
  @override
  final int? categoryId;
  @override
  final int? apiCategoryId;
  @override
  final String? themeNameField;
  @override
  final material.TextEditingController themeDropdownField;
  @override
  final int index;
  @override
  final material.Color timeZoneColor;
  @override
  final material.Color weatherColor;
  @override
  final material.Color locationColor;
  @override
  final material.Color textColor;
  @override
  final material.Color bottomTextColor;
  @override
  final material.Color pickerColor;
  @override
  final BuiltList<String> getThemeCategoryNameList;
  @override
  final ApiState<PaginatedData<ThemeCategoryModel>> categoryThemesApi;
  @override
  final ApiState<PaginatedData<ThemeDataModel>> categoryDetailsThemesApi;
  @override
  final ApiState<void> themeLikeApi;
  @override
  final ApiState<WeatherModel> weatherApi;
  @override
  final ApiState<void> deleteThemeApi;
  @override
  final ApiState<void> applyThemeApi;
  @override
  final ApiState<void> removeThemeApi;
  @override
  final ApiState<void> generateAiThemeApi;
  @override
  final ApiState<void> uploadThemeApi;
  @override
  final ApiState<PaginatedData<ThemeDataModel>> feedThemes;
  @override
  final ApiState<PaginatedData<ThemeDataModel>> myThemes;
  @override
  final ApiState<PaginatedData<ThemeDataModel>> favouriteThemes;
  @override
  final ApiState<PaginatedData<ThemeDataModel>> popularThemes;
  @override
  final ApiState<PaginatedData<ThemeDataModel>> videosThemes;
  @override
  final ApiState<PaginatedData<ThemeDataModel>> gifsThemes;

  factory _$ThemeState([void Function(ThemeStateBuilder)? updates]) =>
      (ThemeStateBuilder()..update(updates))._build();

  _$ThemeState._(
      {required this.activeType,
      required this.canPop,
      required this.uploadOnDoorBell,
      required this.isDetailThemePage,
      required this.search,
      required this.searchField,
      required this.aiError,
      required this.aiThemeText,
      this.selectedDoorBell,
      required this.simpleThemesError,
      this.generatedImage,
      this.categorySelectedValue,
      this.themeId,
      this.categoryId,
      this.apiCategoryId,
      this.themeNameField,
      required this.themeDropdownField,
      required this.index,
      required this.timeZoneColor,
      required this.weatherColor,
      required this.locationColor,
      required this.textColor,
      required this.bottomTextColor,
      required this.pickerColor,
      required this.getThemeCategoryNameList,
      required this.categoryThemesApi,
      required this.categoryDetailsThemesApi,
      required this.themeLikeApi,
      required this.weatherApi,
      required this.deleteThemeApi,
      required this.applyThemeApi,
      required this.removeThemeApi,
      required this.generateAiThemeApi,
      required this.uploadThemeApi,
      required this.feedThemes,
      required this.myThemes,
      required this.favouriteThemes,
      required this.popularThemes,
      required this.videosThemes,
      required this.gifsThemes})
      : super._();
  @override
  ThemeState rebuild(void Function(ThemeStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ThemeStateBuilder toBuilder() => ThemeStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ThemeState &&
        activeType == other.activeType &&
        canPop == other.canPop &&
        uploadOnDoorBell == other.uploadOnDoorBell &&
        isDetailThemePage == other.isDetailThemePage &&
        search == other.search &&
        searchField == other.searchField &&
        aiError == other.aiError &&
        aiThemeText == other.aiThemeText &&
        selectedDoorBell == other.selectedDoorBell &&
        simpleThemesError == other.simpleThemesError &&
        generatedImage == other.generatedImage &&
        categorySelectedValue == other.categorySelectedValue &&
        themeId == other.themeId &&
        categoryId == other.categoryId &&
        apiCategoryId == other.apiCategoryId &&
        themeNameField == other.themeNameField &&
        themeDropdownField == other.themeDropdownField &&
        index == other.index &&
        timeZoneColor == other.timeZoneColor &&
        weatherColor == other.weatherColor &&
        locationColor == other.locationColor &&
        textColor == other.textColor &&
        bottomTextColor == other.bottomTextColor &&
        pickerColor == other.pickerColor &&
        getThemeCategoryNameList == other.getThemeCategoryNameList &&
        categoryThemesApi == other.categoryThemesApi &&
        categoryDetailsThemesApi == other.categoryDetailsThemesApi &&
        themeLikeApi == other.themeLikeApi &&
        weatherApi == other.weatherApi &&
        deleteThemeApi == other.deleteThemeApi &&
        applyThemeApi == other.applyThemeApi &&
        removeThemeApi == other.removeThemeApi &&
        generateAiThemeApi == other.generateAiThemeApi &&
        uploadThemeApi == other.uploadThemeApi &&
        feedThemes == other.feedThemes &&
        myThemes == other.myThemes &&
        favouriteThemes == other.favouriteThemes &&
        popularThemes == other.popularThemes &&
        videosThemes == other.videosThemes &&
        gifsThemes == other.gifsThemes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, activeType.hashCode);
    _$hash = $jc(_$hash, canPop.hashCode);
    _$hash = $jc(_$hash, uploadOnDoorBell.hashCode);
    _$hash = $jc(_$hash, isDetailThemePage.hashCode);
    _$hash = $jc(_$hash, search.hashCode);
    _$hash = $jc(_$hash, searchField.hashCode);
    _$hash = $jc(_$hash, aiError.hashCode);
    _$hash = $jc(_$hash, aiThemeText.hashCode);
    _$hash = $jc(_$hash, selectedDoorBell.hashCode);
    _$hash = $jc(_$hash, simpleThemesError.hashCode);
    _$hash = $jc(_$hash, generatedImage.hashCode);
    _$hash = $jc(_$hash, categorySelectedValue.hashCode);
    _$hash = $jc(_$hash, themeId.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, apiCategoryId.hashCode);
    _$hash = $jc(_$hash, themeNameField.hashCode);
    _$hash = $jc(_$hash, themeDropdownField.hashCode);
    _$hash = $jc(_$hash, index.hashCode);
    _$hash = $jc(_$hash, timeZoneColor.hashCode);
    _$hash = $jc(_$hash, weatherColor.hashCode);
    _$hash = $jc(_$hash, locationColor.hashCode);
    _$hash = $jc(_$hash, textColor.hashCode);
    _$hash = $jc(_$hash, bottomTextColor.hashCode);
    _$hash = $jc(_$hash, pickerColor.hashCode);
    _$hash = $jc(_$hash, getThemeCategoryNameList.hashCode);
    _$hash = $jc(_$hash, categoryThemesApi.hashCode);
    _$hash = $jc(_$hash, categoryDetailsThemesApi.hashCode);
    _$hash = $jc(_$hash, themeLikeApi.hashCode);
    _$hash = $jc(_$hash, weatherApi.hashCode);
    _$hash = $jc(_$hash, deleteThemeApi.hashCode);
    _$hash = $jc(_$hash, applyThemeApi.hashCode);
    _$hash = $jc(_$hash, removeThemeApi.hashCode);
    _$hash = $jc(_$hash, generateAiThemeApi.hashCode);
    _$hash = $jc(_$hash, uploadThemeApi.hashCode);
    _$hash = $jc(_$hash, feedThemes.hashCode);
    _$hash = $jc(_$hash, myThemes.hashCode);
    _$hash = $jc(_$hash, favouriteThemes.hashCode);
    _$hash = $jc(_$hash, popularThemes.hashCode);
    _$hash = $jc(_$hash, videosThemes.hashCode);
    _$hash = $jc(_$hash, gifsThemes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ThemeState')
          ..add('activeType', activeType)
          ..add('canPop', canPop)
          ..add('uploadOnDoorBell', uploadOnDoorBell)
          ..add('isDetailThemePage', isDetailThemePage)
          ..add('search', search)
          ..add('searchField', searchField)
          ..add('aiError', aiError)
          ..add('aiThemeText', aiThemeText)
          ..add('selectedDoorBell', selectedDoorBell)
          ..add('simpleThemesError', simpleThemesError)
          ..add('generatedImage', generatedImage)
          ..add('categorySelectedValue', categorySelectedValue)
          ..add('themeId', themeId)
          ..add('categoryId', categoryId)
          ..add('apiCategoryId', apiCategoryId)
          ..add('themeNameField', themeNameField)
          ..add('themeDropdownField', themeDropdownField)
          ..add('index', index)
          ..add('timeZoneColor', timeZoneColor)
          ..add('weatherColor', weatherColor)
          ..add('locationColor', locationColor)
          ..add('textColor', textColor)
          ..add('bottomTextColor', bottomTextColor)
          ..add('pickerColor', pickerColor)
          ..add('getThemeCategoryNameList', getThemeCategoryNameList)
          ..add('categoryThemesApi', categoryThemesApi)
          ..add('categoryDetailsThemesApi', categoryDetailsThemesApi)
          ..add('themeLikeApi', themeLikeApi)
          ..add('weatherApi', weatherApi)
          ..add('deleteThemeApi', deleteThemeApi)
          ..add('applyThemeApi', applyThemeApi)
          ..add('removeThemeApi', removeThemeApi)
          ..add('generateAiThemeApi', generateAiThemeApi)
          ..add('uploadThemeApi', uploadThemeApi)
          ..add('feedThemes', feedThemes)
          ..add('myThemes', myThemes)
          ..add('favouriteThemes', favouriteThemes)
          ..add('popularThemes', popularThemes)
          ..add('videosThemes', videosThemes)
          ..add('gifsThemes', gifsThemes))
        .toString();
  }
}

class ThemeStateBuilder implements Builder<ThemeState, ThemeStateBuilder> {
  _$ThemeState? _$v;

  String? _activeType;
  String? get activeType => _$this._activeType;
  set activeType(String? activeType) => _$this._activeType = activeType;

  bool? _canPop;
  bool? get canPop => _$this._canPop;
  set canPop(bool? canPop) => _$this._canPop = canPop;

  bool? _uploadOnDoorBell;
  bool? get uploadOnDoorBell => _$this._uploadOnDoorBell;
  set uploadOnDoorBell(bool? uploadOnDoorBell) =>
      _$this._uploadOnDoorBell = uploadOnDoorBell;

  bool? _isDetailThemePage;
  bool? get isDetailThemePage => _$this._isDetailThemePage;
  set isDetailThemePage(bool? isDetailThemePage) =>
      _$this._isDetailThemePage = isDetailThemePage;

  String? _search;
  String? get search => _$this._search;
  set search(String? search) => _$this._search = search;

  material.TextEditingController? _searchField;
  material.TextEditingController? get searchField => _$this._searchField;
  set searchField(material.TextEditingController? searchField) =>
      _$this._searchField = searchField;

  String? _aiError;
  String? get aiError => _$this._aiError;
  set aiError(String? aiError) => _$this._aiError = aiError;

  String? _aiThemeText;
  String? get aiThemeText => _$this._aiThemeText;
  set aiThemeText(String? aiThemeText) => _$this._aiThemeText = aiThemeText;

  UserDeviceModelBuilder? _selectedDoorBell;
  UserDeviceModelBuilder get selectedDoorBell =>
      _$this._selectedDoorBell ??= UserDeviceModelBuilder();
  set selectedDoorBell(UserDeviceModelBuilder? selectedDoorBell) =>
      _$this._selectedDoorBell = selectedDoorBell;

  String? _simpleThemesError;
  String? get simpleThemesError => _$this._simpleThemesError;
  set simpleThemesError(String? simpleThemesError) =>
      _$this._simpleThemesError = simpleThemesError;

  String? _generatedImage;
  String? get generatedImage => _$this._generatedImage;
  set generatedImage(String? generatedImage) =>
      _$this._generatedImage = generatedImage;

  String? _categorySelectedValue;
  String? get categorySelectedValue => _$this._categorySelectedValue;
  set categorySelectedValue(String? categorySelectedValue) =>
      _$this._categorySelectedValue = categorySelectedValue;

  int? _themeId;
  int? get themeId => _$this._themeId;
  set themeId(int? themeId) => _$this._themeId = themeId;

  int? _categoryId;
  int? get categoryId => _$this._categoryId;
  set categoryId(int? categoryId) => _$this._categoryId = categoryId;

  int? _apiCategoryId;
  int? get apiCategoryId => _$this._apiCategoryId;
  set apiCategoryId(int? apiCategoryId) =>
      _$this._apiCategoryId = apiCategoryId;

  String? _themeNameField;
  String? get themeNameField => _$this._themeNameField;
  set themeNameField(String? themeNameField) =>
      _$this._themeNameField = themeNameField;

  material.TextEditingController? _themeDropdownField;
  material.TextEditingController? get themeDropdownField =>
      _$this._themeDropdownField;
  set themeDropdownField(material.TextEditingController? themeDropdownField) =>
      _$this._themeDropdownField = themeDropdownField;

  int? _index;
  int? get index => _$this._index;
  set index(int? index) => _$this._index = index;

  material.Color? _timeZoneColor;
  material.Color? get timeZoneColor => _$this._timeZoneColor;
  set timeZoneColor(material.Color? timeZoneColor) =>
      _$this._timeZoneColor = timeZoneColor;

  material.Color? _weatherColor;
  material.Color? get weatherColor => _$this._weatherColor;
  set weatherColor(material.Color? weatherColor) =>
      _$this._weatherColor = weatherColor;

  material.Color? _locationColor;
  material.Color? get locationColor => _$this._locationColor;
  set locationColor(material.Color? locationColor) =>
      _$this._locationColor = locationColor;

  material.Color? _textColor;
  material.Color? get textColor => _$this._textColor;
  set textColor(material.Color? textColor) => _$this._textColor = textColor;

  material.Color? _bottomTextColor;
  material.Color? get bottomTextColor => _$this._bottomTextColor;
  set bottomTextColor(material.Color? bottomTextColor) =>
      _$this._bottomTextColor = bottomTextColor;

  material.Color? _pickerColor;
  material.Color? get pickerColor => _$this._pickerColor;
  set pickerColor(material.Color? pickerColor) =>
      _$this._pickerColor = pickerColor;

  ListBuilder<String>? _getThemeCategoryNameList;
  ListBuilder<String> get getThemeCategoryNameList =>
      _$this._getThemeCategoryNameList ??= ListBuilder<String>();
  set getThemeCategoryNameList(ListBuilder<String>? getThemeCategoryNameList) =>
      _$this._getThemeCategoryNameList = getThemeCategoryNameList;

  ApiStateBuilder<PaginatedData<ThemeCategoryModel>>? _categoryThemesApi;
  ApiStateBuilder<PaginatedData<ThemeCategoryModel>> get categoryThemesApi =>
      _$this._categoryThemesApi ??=
          ApiStateBuilder<PaginatedData<ThemeCategoryModel>>();
  set categoryThemesApi(
          ApiStateBuilder<PaginatedData<ThemeCategoryModel>>?
              categoryThemesApi) =>
      _$this._categoryThemesApi = categoryThemesApi;

  ApiStateBuilder<PaginatedData<ThemeDataModel>>? _categoryDetailsThemesApi;
  ApiStateBuilder<PaginatedData<ThemeDataModel>> get categoryDetailsThemesApi =>
      _$this._categoryDetailsThemesApi ??=
          ApiStateBuilder<PaginatedData<ThemeDataModel>>();
  set categoryDetailsThemesApi(
          ApiStateBuilder<PaginatedData<ThemeDataModel>>?
              categoryDetailsThemesApi) =>
      _$this._categoryDetailsThemesApi = categoryDetailsThemesApi;

  ApiStateBuilder<void>? _themeLikeApi;
  ApiStateBuilder<void> get themeLikeApi =>
      _$this._themeLikeApi ??= ApiStateBuilder<void>();
  set themeLikeApi(ApiStateBuilder<void>? themeLikeApi) =>
      _$this._themeLikeApi = themeLikeApi;

  ApiStateBuilder<WeatherModel>? _weatherApi;
  ApiStateBuilder<WeatherModel> get weatherApi =>
      _$this._weatherApi ??= ApiStateBuilder<WeatherModel>();
  set weatherApi(ApiStateBuilder<WeatherModel>? weatherApi) =>
      _$this._weatherApi = weatherApi;

  ApiStateBuilder<void>? _deleteThemeApi;
  ApiStateBuilder<void> get deleteThemeApi =>
      _$this._deleteThemeApi ??= ApiStateBuilder<void>();
  set deleteThemeApi(ApiStateBuilder<void>? deleteThemeApi) =>
      _$this._deleteThemeApi = deleteThemeApi;

  ApiStateBuilder<void>? _applyThemeApi;
  ApiStateBuilder<void> get applyThemeApi =>
      _$this._applyThemeApi ??= ApiStateBuilder<void>();
  set applyThemeApi(ApiStateBuilder<void>? applyThemeApi) =>
      _$this._applyThemeApi = applyThemeApi;

  ApiStateBuilder<void>? _removeThemeApi;
  ApiStateBuilder<void> get removeThemeApi =>
      _$this._removeThemeApi ??= ApiStateBuilder<void>();
  set removeThemeApi(ApiStateBuilder<void>? removeThemeApi) =>
      _$this._removeThemeApi = removeThemeApi;

  ApiStateBuilder<void>? _generateAiThemeApi;
  ApiStateBuilder<void> get generateAiThemeApi =>
      _$this._generateAiThemeApi ??= ApiStateBuilder<void>();
  set generateAiThemeApi(ApiStateBuilder<void>? generateAiThemeApi) =>
      _$this._generateAiThemeApi = generateAiThemeApi;

  ApiStateBuilder<void>? _uploadThemeApi;
  ApiStateBuilder<void> get uploadThemeApi =>
      _$this._uploadThemeApi ??= ApiStateBuilder<void>();
  set uploadThemeApi(ApiStateBuilder<void>? uploadThemeApi) =>
      _$this._uploadThemeApi = uploadThemeApi;

  ApiStateBuilder<PaginatedData<ThemeDataModel>>? _feedThemes;
  ApiStateBuilder<PaginatedData<ThemeDataModel>> get feedThemes =>
      _$this._feedThemes ??= ApiStateBuilder<PaginatedData<ThemeDataModel>>();
  set feedThemes(ApiStateBuilder<PaginatedData<ThemeDataModel>>? feedThemes) =>
      _$this._feedThemes = feedThemes;

  ApiStateBuilder<PaginatedData<ThemeDataModel>>? _myThemes;
  ApiStateBuilder<PaginatedData<ThemeDataModel>> get myThemes =>
      _$this._myThemes ??= ApiStateBuilder<PaginatedData<ThemeDataModel>>();
  set myThemes(ApiStateBuilder<PaginatedData<ThemeDataModel>>? myThemes) =>
      _$this._myThemes = myThemes;

  ApiStateBuilder<PaginatedData<ThemeDataModel>>? _favouriteThemes;
  ApiStateBuilder<PaginatedData<ThemeDataModel>> get favouriteThemes =>
      _$this._favouriteThemes ??=
          ApiStateBuilder<PaginatedData<ThemeDataModel>>();
  set favouriteThemes(
          ApiStateBuilder<PaginatedData<ThemeDataModel>>? favouriteThemes) =>
      _$this._favouriteThemes = favouriteThemes;

  ApiStateBuilder<PaginatedData<ThemeDataModel>>? _popularThemes;
  ApiStateBuilder<PaginatedData<ThemeDataModel>> get popularThemes =>
      _$this._popularThemes ??=
          ApiStateBuilder<PaginatedData<ThemeDataModel>>();
  set popularThemes(
          ApiStateBuilder<PaginatedData<ThemeDataModel>>? popularThemes) =>
      _$this._popularThemes = popularThemes;

  ApiStateBuilder<PaginatedData<ThemeDataModel>>? _videosThemes;
  ApiStateBuilder<PaginatedData<ThemeDataModel>> get videosThemes =>
      _$this._videosThemes ??= ApiStateBuilder<PaginatedData<ThemeDataModel>>();
  set videosThemes(
          ApiStateBuilder<PaginatedData<ThemeDataModel>>? videosThemes) =>
      _$this._videosThemes = videosThemes;

  ApiStateBuilder<PaginatedData<ThemeDataModel>>? _gifsThemes;
  ApiStateBuilder<PaginatedData<ThemeDataModel>> get gifsThemes =>
      _$this._gifsThemes ??= ApiStateBuilder<PaginatedData<ThemeDataModel>>();
  set gifsThemes(ApiStateBuilder<PaginatedData<ThemeDataModel>>? gifsThemes) =>
      _$this._gifsThemes = gifsThemes;

  ThemeStateBuilder() {
    ThemeState._initialize(this);
  }

  ThemeStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _activeType = $v.activeType;
      _canPop = $v.canPop;
      _uploadOnDoorBell = $v.uploadOnDoorBell;
      _isDetailThemePage = $v.isDetailThemePage;
      _search = $v.search;
      _searchField = $v.searchField;
      _aiError = $v.aiError;
      _aiThemeText = $v.aiThemeText;
      _selectedDoorBell = $v.selectedDoorBell?.toBuilder();
      _simpleThemesError = $v.simpleThemesError;
      _generatedImage = $v.generatedImage;
      _categorySelectedValue = $v.categorySelectedValue;
      _themeId = $v.themeId;
      _categoryId = $v.categoryId;
      _apiCategoryId = $v.apiCategoryId;
      _themeNameField = $v.themeNameField;
      _themeDropdownField = $v.themeDropdownField;
      _index = $v.index;
      _timeZoneColor = $v.timeZoneColor;
      _weatherColor = $v.weatherColor;
      _locationColor = $v.locationColor;
      _textColor = $v.textColor;
      _bottomTextColor = $v.bottomTextColor;
      _pickerColor = $v.pickerColor;
      _getThemeCategoryNameList = $v.getThemeCategoryNameList.toBuilder();
      _categoryThemesApi = $v.categoryThemesApi.toBuilder();
      _categoryDetailsThemesApi = $v.categoryDetailsThemesApi.toBuilder();
      _themeLikeApi = $v.themeLikeApi.toBuilder();
      _weatherApi = $v.weatherApi.toBuilder();
      _deleteThemeApi = $v.deleteThemeApi.toBuilder();
      _applyThemeApi = $v.applyThemeApi.toBuilder();
      _removeThemeApi = $v.removeThemeApi.toBuilder();
      _generateAiThemeApi = $v.generateAiThemeApi.toBuilder();
      _uploadThemeApi = $v.uploadThemeApi.toBuilder();
      _feedThemes = $v.feedThemes.toBuilder();
      _myThemes = $v.myThemes.toBuilder();
      _favouriteThemes = $v.favouriteThemes.toBuilder();
      _popularThemes = $v.popularThemes.toBuilder();
      _videosThemes = $v.videosThemes.toBuilder();
      _gifsThemes = $v.gifsThemes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ThemeState other) {
    _$v = other as _$ThemeState;
  }

  @override
  void update(void Function(ThemeStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ThemeState build() => _build();

  _$ThemeState _build() {
    _$ThemeState _$result;
    try {
      _$result = _$v ??
          _$ThemeState._(
            activeType: BuiltValueNullFieldError.checkNotNull(
                activeType, r'ThemeState', 'activeType'),
            canPop: BuiltValueNullFieldError.checkNotNull(
                canPop, r'ThemeState', 'canPop'),
            uploadOnDoorBell: BuiltValueNullFieldError.checkNotNull(
                uploadOnDoorBell, r'ThemeState', 'uploadOnDoorBell'),
            isDetailThemePage: BuiltValueNullFieldError.checkNotNull(
                isDetailThemePage, r'ThemeState', 'isDetailThemePage'),
            search: BuiltValueNullFieldError.checkNotNull(
                search, r'ThemeState', 'search'),
            searchField: BuiltValueNullFieldError.checkNotNull(
                searchField, r'ThemeState', 'searchField'),
            aiError: BuiltValueNullFieldError.checkNotNull(
                aiError, r'ThemeState', 'aiError'),
            aiThemeText: BuiltValueNullFieldError.checkNotNull(
                aiThemeText, r'ThemeState', 'aiThemeText'),
            selectedDoorBell: _selectedDoorBell?.build(),
            simpleThemesError: BuiltValueNullFieldError.checkNotNull(
                simpleThemesError, r'ThemeState', 'simpleThemesError'),
            generatedImage: generatedImage,
            categorySelectedValue: categorySelectedValue,
            themeId: themeId,
            categoryId: categoryId,
            apiCategoryId: apiCategoryId,
            themeNameField: themeNameField,
            themeDropdownField: BuiltValueNullFieldError.checkNotNull(
                themeDropdownField, r'ThemeState', 'themeDropdownField'),
            index: BuiltValueNullFieldError.checkNotNull(
                index, r'ThemeState', 'index'),
            timeZoneColor: BuiltValueNullFieldError.checkNotNull(
                timeZoneColor, r'ThemeState', 'timeZoneColor'),
            weatherColor: BuiltValueNullFieldError.checkNotNull(
                weatherColor, r'ThemeState', 'weatherColor'),
            locationColor: BuiltValueNullFieldError.checkNotNull(
                locationColor, r'ThemeState', 'locationColor'),
            textColor: BuiltValueNullFieldError.checkNotNull(
                textColor, r'ThemeState', 'textColor'),
            bottomTextColor: BuiltValueNullFieldError.checkNotNull(
                bottomTextColor, r'ThemeState', 'bottomTextColor'),
            pickerColor: BuiltValueNullFieldError.checkNotNull(
                pickerColor, r'ThemeState', 'pickerColor'),
            getThemeCategoryNameList: getThemeCategoryNameList.build(),
            categoryThemesApi: categoryThemesApi.build(),
            categoryDetailsThemesApi: categoryDetailsThemesApi.build(),
            themeLikeApi: themeLikeApi.build(),
            weatherApi: weatherApi.build(),
            deleteThemeApi: deleteThemeApi.build(),
            applyThemeApi: applyThemeApi.build(),
            removeThemeApi: removeThemeApi.build(),
            generateAiThemeApi: generateAiThemeApi.build(),
            uploadThemeApi: uploadThemeApi.build(),
            feedThemes: feedThemes.build(),
            myThemes: myThemes.build(),
            favouriteThemes: favouriteThemes.build(),
            popularThemes: popularThemes.build(),
            videosThemes: videosThemes.build(),
            gifsThemes: gifsThemes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'selectedDoorBell';
        _selectedDoorBell?.build();

        _$failedField = 'getThemeCategoryNameList';
        getThemeCategoryNameList.build();
        _$failedField = 'categoryThemesApi';
        categoryThemesApi.build();
        _$failedField = 'categoryDetailsThemesApi';
        categoryDetailsThemesApi.build();
        _$failedField = 'themeLikeApi';
        themeLikeApi.build();
        _$failedField = 'weatherApi';
        weatherApi.build();
        _$failedField = 'deleteThemeApi';
        deleteThemeApi.build();
        _$failedField = 'applyThemeApi';
        applyThemeApi.build();
        _$failedField = 'removeThemeApi';
        removeThemeApi.build();
        _$failedField = 'generateAiThemeApi';
        generateAiThemeApi.build();
        _$failedField = 'uploadThemeApi';
        uploadThemeApi.build();
        _$failedField = 'feedThemes';
        feedThemes.build();
        _$failedField = 'myThemes';
        myThemes.build();
        _$failedField = 'favouriteThemes';
        favouriteThemes.build();
        _$failedField = 'popularThemes';
        popularThemes.build();
        _$failedField = 'videosThemes';
        videosThemes.build();
        _$failedField = 'gifsThemes';
        gifsThemes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ThemeState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
