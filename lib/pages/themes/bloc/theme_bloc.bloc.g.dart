// ignore_for_file: type=lint, unused_element

part of 'theme_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class ThemeBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<ThemeState>? buildWhen;
  final BlocWidgetBuilder<ThemeState> builder;

  const ThemeBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class ThemeBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<ThemeState, T> selector;
  final Widget Function(T state) builder;
  final ThemeBloc? bloc;

  const ThemeBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static ThemeBlocSelector<String> activeType({
    final Key? key,
    required Widget Function(String activeType) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.activeType,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<bool> canPop({
    final Key? key,
    required Widget Function(bool canPop) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.canPop,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<bool> uploadOnDoorBell({
    final Key? key,
    required Widget Function(bool uploadOnDoorBell) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.uploadOnDoorBell,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<bool> isDetailThemePage({
    final Key? key,
    required Widget Function(bool isDetailThemePage) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.isDetailThemePage,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<String> search({
    final Key? key,
    required Widget Function(String search) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.search,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<TextEditingController> searchField({
    final Key? key,
    required Widget Function(TextEditingController searchField) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.searchField,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<String> aiError({
    final Key? key,
    required Widget Function(String aiError) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.aiError,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<String> aiThemeText({
    final Key? key,
    required Widget Function(String aiThemeText) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.aiThemeText,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<UserDeviceModel?> selectedDoorBell({
    final Key? key,
    required Widget Function(UserDeviceModel? selectedDoorBell) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.selectedDoorBell,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<String> simpleThemesError({
    final Key? key,
    required Widget Function(String simpleThemesError) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.simpleThemesError,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<String?> generatedImage({
    final Key? key,
    required Widget Function(String? generatedImage) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.generatedImage,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<String?> categorySelectedValue({
    final Key? key,
    required Widget Function(String? categorySelectedValue) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.categorySelectedValue,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<int?> themeId({
    final Key? key,
    required Widget Function(int? themeId) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.themeId,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<int?> categoryId({
    final Key? key,
    required Widget Function(int? categoryId) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.categoryId,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<int?> apiCategoryId({
    final Key? key,
    required Widget Function(int? apiCategoryId) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.apiCategoryId,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<String?> themeNameField({
    final Key? key,
    required Widget Function(String? themeNameField) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.themeNameField,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<TextEditingController> themeDropdownField({
    final Key? key,
    required Widget Function(TextEditingController themeDropdownField) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.themeDropdownField,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<int> index({
    final Key? key,
    required Widget Function(int index) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.index,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<Color> timeZoneColor({
    final Key? key,
    required Widget Function(Color timeZoneColor) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.timeZoneColor,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<Color> weatherColor({
    final Key? key,
    required Widget Function(Color weatherColor) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.weatherColor,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<Color> locationColor({
    final Key? key,
    required Widget Function(Color locationColor) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.locationColor,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<Color> textColor({
    final Key? key,
    required Widget Function(Color textColor) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.textColor,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<Color> bottomTextColor({
    final Key? key,
    required Widget Function(Color bottomTextColor) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.bottomTextColor,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<Color> pickerColor({
    final Key? key,
    required Widget Function(Color pickerColor) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.pickerColor,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<BuiltList<String>> getThemeCategoryNameList({
    final Key? key,
    required Widget Function(BuiltList<String> getThemeCategoryNameList)
        builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.getThemeCategoryNameList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<PaginatedData<ThemeCategoryModel>>>
      categoryThemesApi({
    final Key? key,
    required Widget Function(
            ApiState<PaginatedData<ThemeCategoryModel>> categoryThemesApi)
        builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.categoryThemesApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<PaginatedData<ThemeDataModel>>>
      categoryDetailsThemesApi({
    final Key? key,
    required Widget Function(
            ApiState<PaginatedData<ThemeDataModel>> categoryDetailsThemesApi)
        builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.categoryDetailsThemesApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<void>> themeLikeApi({
    final Key? key,
    required Widget Function(ApiState<void> themeLikeApi) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.themeLikeApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<WeatherModel>> weatherApi({
    final Key? key,
    required Widget Function(ApiState<WeatherModel> weatherApi) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.weatherApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<void>> deleteThemeApi({
    final Key? key,
    required Widget Function(ApiState<void> deleteThemeApi) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.deleteThemeApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<void>> applyThemeApi({
    final Key? key,
    required Widget Function(ApiState<void> applyThemeApi) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.applyThemeApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<void>> removeThemeApi({
    final Key? key,
    required Widget Function(ApiState<void> removeThemeApi) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.removeThemeApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<void>> generateAiThemeApi({
    final Key? key,
    required Widget Function(ApiState<void> generateAiThemeApi) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.generateAiThemeApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<void>> uploadThemeApi({
    final Key? key,
    required Widget Function(ApiState<void> uploadThemeApi) builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.uploadThemeApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<PaginatedData<ThemeDataModel>>> feedThemes({
    final Key? key,
    required Widget Function(ApiState<PaginatedData<ThemeDataModel>> feedThemes)
        builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.feedThemes,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<PaginatedData<ThemeDataModel>>> myThemes({
    final Key? key,
    required Widget Function(ApiState<PaginatedData<ThemeDataModel>> myThemes)
        builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.myThemes,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<PaginatedData<ThemeDataModel>>>
      favouriteThemes({
    final Key? key,
    required Widget Function(
            ApiState<PaginatedData<ThemeDataModel>> favouriteThemes)
        builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.favouriteThemes,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<PaginatedData<ThemeDataModel>>>
      popularThemes({
    final Key? key,
    required Widget Function(
            ApiState<PaginatedData<ThemeDataModel>> popularThemes)
        builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.popularThemes,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<PaginatedData<ThemeDataModel>>>
      videosThemes({
    final Key? key,
    required Widget Function(
            ApiState<PaginatedData<ThemeDataModel>> videosThemes)
        builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.videosThemes,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ThemeBlocSelector<ApiState<PaginatedData<ThemeDataModel>>> gifsThemes({
    final Key? key,
    required Widget Function(ApiState<PaginatedData<ThemeDataModel>> gifsThemes)
        builder,
    final ThemeBloc? bloc,
  }) {
    return ThemeBlocSelector(
      key: key,
      selector: (state) => state.gifsThemes,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<ThemeBloc, ThemeState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _ThemeBlocMixin on Cubit<ThemeState> {
  @mustCallSuper
  void updateActiveType(final String activeType) {
    if (this.state.activeType == activeType) {
      return;
    }

    emit(this.state.rebuild((final b) => b.activeType = activeType));

    $onUpdateActiveType();
  }

  @protected
  void $onUpdateActiveType() {}

  @mustCallSuper
  void updateCanPop(final bool canPop) {
    if (this.state.canPop == canPop) {
      return;
    }

    emit(this.state.rebuild((final b) => b.canPop = canPop));

    $onUpdateCanPop();
  }

  @protected
  void $onUpdateCanPop() {}

  @mustCallSuper
  void updateUploadOnDoorBell(final bool uploadOnDoorBell) {
    if (this.state.uploadOnDoorBell == uploadOnDoorBell) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.uploadOnDoorBell = uploadOnDoorBell));

    $onUpdateUploadOnDoorBell();
  }

  @protected
  void $onUpdateUploadOnDoorBell() {}

  @mustCallSuper
  void updateIsDetailThemePage(final bool isDetailThemePage) {
    if (this.state.isDetailThemePage == isDetailThemePage) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isDetailThemePage = isDetailThemePage));

    $onUpdateIsDetailThemePage();
  }

  @protected
  void $onUpdateIsDetailThemePage() {}

  @mustCallSuper
  void updateSearch(final String search) {
    if (this.state.search == search) {
      return;
    }

    emit(this.state.rebuild((final b) => b.search = search));

    $onUpdateSearch();
  }

  @protected
  void $onUpdateSearch() {}

  @mustCallSuper
  void updateAiError(final String aiError) {
    if (this.state.aiError == aiError) {
      return;
    }

    emit(this.state.rebuild((final b) => b.aiError = aiError));

    $onUpdateAiError();
  }

  @protected
  void $onUpdateAiError() {}

  @mustCallSuper
  void updateAiThemeText(final String aiThemeText) {
    if (this.state.aiThemeText == aiThemeText) {
      return;
    }

    emit(this.state.rebuild((final b) => b.aiThemeText = aiThemeText));

    $onUpdateAiThemeText();
  }

  @protected
  void $onUpdateAiThemeText() {}

  @mustCallSuper
  void updateSelectedDoorBell(final UserDeviceModel? selectedDoorBell) {
    if (this.state.selectedDoorBell == selectedDoorBell) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (selectedDoorBell == null)
        b.selectedDoorBell = null;
      else
        b.selectedDoorBell.replace(selectedDoorBell);
    }));

    $onUpdateSelectedDoorBell();
  }

  @protected
  void $onUpdateSelectedDoorBell() {}

  @mustCallSuper
  void updateSimpleThemesError(final String simpleThemesError) {
    if (this.state.simpleThemesError == simpleThemesError) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.simpleThemesError = simpleThemesError));

    $onUpdateSimpleThemesError();
  }

  @protected
  void $onUpdateSimpleThemesError() {}

  @mustCallSuper
  void updateGeneratedImage(final String? generatedImage) {
    if (this.state.generatedImage == generatedImage) {
      return;
    }

    emit(this.state.rebuild((final b) => b.generatedImage = generatedImage));

    $onUpdateGeneratedImage();
  }

  @protected
  void $onUpdateGeneratedImage() {}

  @mustCallSuper
  void updateCategorySelectedValue(final String? categorySelectedValue) {
    if (this.state.categorySelectedValue == categorySelectedValue) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.categorySelectedValue = categorySelectedValue));

    $onUpdateCategorySelectedValue();
  }

  @protected
  void $onUpdateCategorySelectedValue() {}

  @mustCallSuper
  void updateThemeId(final int? themeId) {
    if (this.state.themeId == themeId) {
      return;
    }

    emit(this.state.rebuild((final b) => b.themeId = themeId));

    $onUpdateThemeId();
  }

  @protected
  void $onUpdateThemeId() {}

  @mustCallSuper
  void updateThemeNameField(final String? themeNameField) {
    if (this.state.themeNameField == themeNameField) {
      return;
    }

    emit(this.state.rebuild((final b) => b.themeNameField = themeNameField));

    $onUpdateThemeNameField();
  }

  @protected
  void $onUpdateThemeNameField() {}

  @mustCallSuper
  void updateGetThemeCategoryNameList(
      final BuiltList<String> getThemeCategoryNameList) {
    if (this.state.getThemeCategoryNameList == getThemeCategoryNameList) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.getThemeCategoryNameList.replace(getThemeCategoryNameList);
    }));

    $onUpdateGetThemeCategoryNameList();
  }

  @protected
  void $onUpdateGetThemeCategoryNameList() {}
}
