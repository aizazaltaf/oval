import 'dart:async';

import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/bloc/theme_state.dart';
import 'package:admin/pages/themes/model/theme_category_model.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:admin/pages/themes/model/weather_model.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/bloc/bloc_mocks.dart';
import '../../mocks/bloc/state_mocks.dart';

class ThemeBlocTestHelper {
  late MockThemeBloc mockThemeBloc;
  late ThemeState currentThemeState;
  StreamController<ThemeState>? stateController;

  void setup() {
    mockThemeBloc = MockThemeBloc();
    currentThemeState = MockThemeState();
    stateController = StreamController<ThemeState>.broadcast();

    setupDefaultState();
    setupMockMethods(); // Ensure all mock methods are properly configured

    // Set the state using the setter, which will properly set _state
    mockThemeBloc.state = currentThemeState;

    // The stream is already implemented in MockThemeBloc, no need to mock it
  }

  MockThemeBloc getMockThemeBloc() {
    return mockThemeBloc;
  }

  void setupDefaultState() {
    when(() => currentThemeState.activeType).thenReturn('Feed');
    when(() => currentThemeState.canPop).thenReturn(true);
    when(() => currentThemeState.uploadOnDoorBell).thenReturn(false);
    when(() => currentThemeState.isDetailThemePage).thenReturn(false);
    when(() => currentThemeState.search).thenReturn('');
    when(() => currentThemeState.searchField)
        .thenReturn(TextEditingController());
    when(() => currentThemeState.aiError).thenReturn('');
    when(() => currentThemeState.aiThemeText).thenReturn('');
    when(() => currentThemeState.selectedDoorBell).thenReturn(null);
    when(() => currentThemeState.simpleThemesError).thenReturn('');
    when(() => currentThemeState.generatedImage).thenReturn(null);
    when(() => currentThemeState.categorySelectedValue).thenReturn(null);
    when(() => currentThemeState.themeId).thenReturn(null);
    when(() => currentThemeState.categoryId).thenReturn(null);
    when(() => currentThemeState.apiCategoryId).thenReturn(null);
    when(() => currentThemeState.themeNameField).thenReturn('');
    when(() => currentThemeState.themeDropdownField)
        .thenReturn(TextEditingController());
    when(() => currentThemeState.index).thenReturn(0);
    when(() => currentThemeState.timeZoneColor)
        .thenReturn(AppColors.defaultColorPicker);
    when(() => currentThemeState.weatherColor)
        .thenReturn(AppColors.defaultColorPicker);
    when(() => currentThemeState.locationColor)
        .thenReturn(AppColors.defaultColorPicker);
    when(() => currentThemeState.textColor)
        .thenReturn(AppColors.defaultColorPicker);
    when(() => currentThemeState.bottomTextColor)
        .thenReturn(AppColors.defaultColorPicker);
    when(() => currentThemeState.pickerColor)
        .thenReturn(AppColors.defaultColorPicker);
    when(() => currentThemeState.getThemeCategoryNameList)
        .thenReturn(BuiltList<String>([]));
    when(() => currentThemeState.categoryThemesApi)
        .thenReturn(ApiState<PaginatedData<ThemeCategoryModel>>());
    when(() => currentThemeState.categoryDetailsThemesApi)
        .thenReturn(ApiState<PaginatedData<ThemeDataModel>>());
    when(() => currentThemeState.themeLikeApi).thenReturn(ApiState<void>());
    when(() => currentThemeState.weatherApi)
        .thenReturn(ApiState<WeatherModel>());
    when(() => currentThemeState.deleteThemeApi).thenReturn(ApiState<void>());
    when(() => currentThemeState.applyThemeApi).thenReturn(ApiState<void>());
    when(() => currentThemeState.removeThemeApi).thenReturn(ApiState<void>());

    // Ensure generateAiThemeApi has a clean state with no errors
    final cleanApiState = ApiState<void>(
      (b) => b
        ..isApiInProgress = false
        ..error = null
        ..message = null
        ..data = null
        ..totalCount = 0
        ..currentPage = 0
        ..isApiPaginationEnabled = false
        ..uploadProgress = null
        ..pagination = null,
    );
    when(() => currentThemeState.generateAiThemeApi).thenReturn(cleanApiState);

    when(() => currentThemeState.uploadThemeApi).thenReturn(ApiState<void>());
    when(() => currentThemeState.feedThemes)
        .thenReturn(ApiState<PaginatedData<ThemeDataModel>>());
    when(() => currentThemeState.myThemes)
        .thenReturn(ApiState<PaginatedData<ThemeDataModel>>());
    when(() => currentThemeState.favouriteThemes)
        .thenReturn(ApiState<PaginatedData<ThemeDataModel>>());
    when(() => currentThemeState.popularThemes)
        .thenReturn(ApiState<PaginatedData<ThemeDataModel>>());
    when(() => currentThemeState.videosThemes)
        .thenReturn(ApiState<PaginatedData<ThemeDataModel>>());
    when(() => currentThemeState.gifsThemes)
        .thenReturn(ApiState<PaginatedData<ThemeDataModel>>());
  }

  void dispose() {
    stateController?.close();
  }

  // Helper methods for UI tests
  void setupWithSampleData() {
    final sampleThemeData = ThemeDataModel.fromDynamic({
      'id': 1,
      'title': 'Test Theme',
      'description': 'A test theme',
      'cover': 'https://example.com/cover.jpg',
      'thumbnail': 'https://example.com/thumbnail.jpg',
      'total_likes': 10,
      'user_like': 1,
      'is_applied': false,
      'media_type': 1,
      'category_id': 1,
      'is_active': 1,
      'device_id': 'test_device_1', // Add device_id to match the doorbell
    });

    final samplePaginatedData = PaginatedData<ThemeDataModel>(
      (b) => b
        ..data = ListBuilder<ThemeDataModel>([sampleThemeData])
        ..currentPage = 1
        ..lastPage = 1,
    );

    final sampleApiState = ApiState<PaginatedData<ThemeDataModel>>(
      (b) => b
        ..data = samplePaginatedData
        ..isApiInProgress = false
        ..currentPage = 1
        ..totalCount = 1,
    );

    when(() => currentThemeState.feedThemes).thenReturn(sampleApiState);
    when(() => currentThemeState.popularThemes).thenReturn(sampleApiState);
    when(() => currentThemeState.videosThemes).thenReturn(sampleApiState);
    when(() => currentThemeState.gifsThemes).thenReturn(sampleApiState);
  }

  void setupFilters() {
    when(() => mockThemeBloc.getFilters(any())).thenReturn([
      FeatureModel(title: 'Home', value: 'Feed', isSelected: true),
      FeatureModel(title: 'Popular', value: 'Popular'),
      FeatureModel(title: 'Favorite', value: 'Favourite'),
      FeatureModel(title: 'Videos', value: 'Videos'),
      FeatureModel(title: 'Gif', value: 'Gif'),
    ]);
  }

  void emitState(ThemeState newState) {
    currentThemeState = newState;
    when(() => mockThemeBloc.state).thenReturn(currentThemeState);
    stateController?.add(newState);
  }

  void setupMockMethods() {
    // Setup notificationScroll property
    when(() => mockThemeBloc.notificationScroll).thenReturn(
      ScrollController(),
    );

    // Setup categoryNotificationScroll property
    when(() => mockThemeBloc.categoryNotificationScroll)
        .thenReturn(ScrollController());

    when(() => mockThemeBloc.updateSearch(any())).thenAnswer((_) {});
    when(() => mockThemeBloc.clearSearch()).thenAnswer((_) {});
    when(
      () => mockThemeBloc.changeActiveType(
        any(),
        any(),
        onThemeTabChange: any(named: 'onThemeTabChange'),
        refresh: any(named: 'refresh'),
        isPageChangeRefreshTheme: any(named: 'isPageChangeRefreshTheme'),
      ),
    ).thenAnswer((_) {});
    when(() => mockThemeBloc.pickThemeAsset(any())).thenAnswer((_) async {});
    when(() => mockThemeBloc.onScroll()).thenAnswer((_) {});
    when(() => mockThemeBloc.onPop()).thenAnswer((_) {});
    when(() => mockThemeBloc.updateOnPop()).thenAnswer((_) {});
    when(() => mockThemeBloc.callCategoryThemesApi()).thenAnswer((_) async {});
    when(() => mockThemeBloc.weatherApi()).thenAnswer((_) async {});
    when(() => mockThemeBloc.updateDoorBell()).thenAnswer((_) async {});
    when(
      () => mockThemeBloc.callThemesApi(
        type: any(named: 'type'),
        refresh: any(named: 'refresh'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockThemeBloc.callThemesApi(type: any(named: 'type')))
        .thenAnswer((_) async {});

    // Setup onCategoryIdScroll method
    when(() => mockThemeBloc.onCategoryIdScroll()).thenAnswer((_) {});

    // Setup getThemeApiType to return proper ApiState with data
    // Create a default theme data to ensure the list is not empty
    final defaultThemeData = ThemeDataModel(
      (b) => b
        ..id = 1
        ..title = "Default Theme"
        ..description = "A default theme for testing"
        ..colors = "#FF0000"
        ..cover = "https://example.com/cover.jpg"
        ..fromCache = false
        ..thumbnail = "https://example.com/thumbnail.jpg"
        ..userUploaded = null
        ..isActive = 1
        ..createdAt = "2024-01-01T00:00:00Z"
        ..categoryId = 1
        ..locationId = 1
        ..totalLikes = 0
        ..mediaType = 1
        ..userLike = 0
        ..isApplied = false
        ..deviceId = "test-device-123",
    );

    final defaultPaginatedData = PaginatedData<ThemeDataModel>(
      (b) => b
        ..data = ListBuilder<ThemeDataModel>([defaultThemeData])
        ..currentPage = 1
        ..lastPage = 1,
    );

    final defaultApiState = ApiState<PaginatedData<ThemeDataModel>>(
      (b) => b
        ..data = defaultPaginatedData
        ..isApiInProgress = false
        ..error = null
        ..message = null
        ..totalCount = 1
        ..currentPage = 1
        ..isApiPaginationEnabled = false
        ..uploadProgress = null
        ..pagination = null,
    );

    when(() => mockThemeBloc.getThemeApiType(any()))
        .thenReturn(defaultApiState);

    // Setup toHex to return proper hex string
    when(() => mockThemeBloc.toHex(any())).thenReturn('#FF0000');

    // Setup checkIsImageFile to return proper UploadFileType
    when(() => mockThemeBloc.checkIsImageFile('png'))
        .thenReturn(UploadFileType.image);
    when(() => mockThemeBloc.checkIsImageFile('jpg'))
        .thenReturn(UploadFileType.image);
    when(() => mockThemeBloc.checkIsImageFile('jpeg'))
        .thenReturn(UploadFileType.image);
    when(() => mockThemeBloc.checkIsImageFile('gif'))
        .thenReturn(UploadFileType.gif);
    when(() => mockThemeBloc.checkIsImageFile('mp4'))
        .thenReturn(UploadFileType.video);
    when(() => mockThemeBloc.checkIsImageFile('mov'))
        .thenReturn(UploadFileType.mov);
    when(() => mockThemeBloc.checkIsImageFile('txt')).thenReturn(null);
    when(() => mockThemeBloc.checkIsImageFile('pdf')).thenReturn(null);
    when(() => mockThemeBloc.checkIsImageFile('doc')).thenReturn(null);

    // Setup additional methods for UI tests
    when(() => mockThemeBloc.updateThemeNameField(any())).thenAnswer((_) {});
    when(() => mockThemeBloc.updateSelectedValue(any())).thenAnswer((_) {});
    when(() => mockThemeBloc.isUploadOnDoorBell(any())).thenAnswer((_) {});
    when(() => mockThemeBloc.updateSelectedDoorBell(any())).thenAnswer((_) {});
    when(() => mockThemeBloc.updateUploadOnDoorBell(any())).thenAnswer((_) {});
    when(() => mockThemeBloc.weatherApi(value: any(named: 'value')))
        .thenAnswer((_) async {});
    when(() => mockThemeBloc.openDialog(any(), any())).thenAnswer((_) {});

    // Add missing methods that are called in theme_add_info_screen.dart
    when(() => mockThemeBloc.updateActiveType(any())).thenAnswer((_) {});
    when(() => mockThemeBloc.clearSearchFromCategories()).thenAnswer((_) {});
  }

  void setupEmptyState() {
    final emptyPaginatedData = PaginatedData<ThemeDataModel>(
      (b) => b
        ..data = ListBuilder<ThemeDataModel>([])
        ..currentPage = 1
        ..lastPage = 1,
    );

    final emptyApiState = ApiState<PaginatedData<ThemeDataModel>>(
      (b) => b
        ..data = emptyPaginatedData
        ..isApiInProgress = false
        ..currentPage = 1
        ..totalCount = 0,
    );

    when(() => currentThemeState.feedThemes).thenReturn(emptyApiState);
    when(() => currentThemeState.popularThemes).thenReturn(emptyApiState);
    when(() => currentThemeState.videosThemes).thenReturn(emptyApiState);
    when(() => currentThemeState.gifsThemes).thenReturn(emptyApiState);
  }

  void setupAiThemeMethods() {
    when(() => mockThemeBloc.updateAiThemeText(any())).thenAnswer((_) {});
    when(() => mockThemeBloc.processAITheme()).thenAnswer((_) async {
      // Simulate immediate completion for tests
      await Future.value();
    });
    when(() => mockThemeBloc.refreshCreateTheme()).thenAnswer((_) {});
  }

  void setupWithGeneratedImage() {
    when(() => currentThemeState.aiThemeText)
        .thenReturn('A beautiful sunset theme');
    when(() => currentThemeState.generatedImage)
        .thenReturn('https://example.com/generated-image.jpg');
    when(() => currentThemeState.aiError).thenReturn('');

    // Create a proper ApiState<void> for generateAiThemeApi with no errors
    final apiState = ApiState<void>(
      (b) => b
        ..isApiInProgress = false
        ..error = null
        ..message = null
        ..data = null
        ..totalCount = 0
        ..currentPage = 0
        ..isApiPaginationEnabled = false
        ..uploadProgress = null
        ..pagination = null,
    );
    when(() => currentThemeState.generateAiThemeApi).thenReturn(apiState);
  }

  void setupWithError() {
    when(() => currentThemeState.aiThemeText)
        .thenReturn('A beautiful sunset theme');
    when(() => currentThemeState.generatedImage).thenReturn(null);
    when(() => currentThemeState.aiError).thenReturn('Test error message');

    // Create a proper ApiState<void> for generateAiThemeApi with no errors
    final apiState = ApiState<void>(
      (b) => b
        ..isApiInProgress = false
        ..error = null
        ..message = null
        ..data = null
        ..totalCount = 0
        ..currentPage = 0
        ..isApiPaginationEnabled = false
        ..uploadProgress = null
        ..pagination = null,
    );
    when(() => currentThemeState.generateAiThemeApi).thenReturn(apiState);
  }

  void setupWithApiInProgress() {
    // Create a proper ApiState<void> for generateAiThemeApi with in progress state
    final apiState = ApiState<void>(
      (b) => b
        ..isApiInProgress = true
        ..error = null
        ..message = null
        ..data = null
        ..totalCount = 0
        ..currentPage = 0
        ..isApiPaginationEnabled = false
        ..uploadProgress = null
        ..pagination = null,
    );
    when(() => currentThemeState.generateAiThemeApi).thenReturn(apiState);
  }

  void setupForDelayedProcess() {
    // Setup processAITheme to complete immediately for tests
    when(() => mockThemeBloc.processAITheme()).thenAnswer((_) async {
      // Simulate immediate completion for tests
      await Future.value();
    });
  }

  // Helper methods for UI tests
  void setupWithCategories(List<ThemeCategoryModel> categories) {
    final paginatedData = PaginatedData<ThemeCategoryModel>(
      (b) => b
        ..data = ListBuilder<ThemeCategoryModel>(categories)
        ..currentPage = 1
        ..lastPage = 1,
    );

    final apiState = ApiState<PaginatedData<ThemeCategoryModel>>(
      (b) => b
        ..data = paginatedData
        ..isApiInProgress = false
        ..currentPage = 1
        ..totalCount = categories.length,
    );

    when(() => currentThemeState.categoryThemesApi).thenReturn(apiState);

    // Also set up a default category selection to avoid null check errors
    if (categories.isNotEmpty) {
      when(() => currentThemeState.categorySelectedValue)
          .thenReturn(categories.first.name);
      when(() => currentThemeState.categoryId).thenReturn(categories.first.id);
    }
  }

  void setupWithSelectedDoorbell(UserDeviceModel doorbell) {
    when(() => currentThemeState.selectedDoorBell).thenReturn(doorbell);
    // Also set uploadOnDoorBell to true so the UI elements are visible
    when(() => currentThemeState.uploadOnDoorBell).thenReturn(true);
  }

  void setupWithDoorbells(List<UserDeviceModel> doorbells) {
    when(() => currentThemeState.selectedDoorBell)
        .thenReturn(doorbells.isNotEmpty ? doorbells.first : null);
  }

  void setupWithApiError() {
    // Create minimal categories to avoid null check errors
    final minimalCategories = [
      ThemeCategoryModel(
        (b) => b
          ..id = 1
          ..name = "Default"
          ..image = "https://example.com/default.jpg"
          ..isActive = 1
          ..createdAt = "2024-01-01T00:00:00Z"
          ..updatedAt = "2024-01-01T00:00:00Z",
      ),
    ];

    final paginatedData = PaginatedData<ThemeCategoryModel>(
      (b) => b
        ..data = ListBuilder<ThemeCategoryModel>(minimalCategories)
        ..currentPage = 1
        ..lastPage = 1,
    );

    final errorApiState = ApiState<PaginatedData<ThemeCategoryModel>>(
      (b) => b
        ..data = paginatedData
        ..isApiInProgress = false
        ..currentPage = 1
        ..totalCount = 1,
    );

    when(() => currentThemeState.categoryThemesApi).thenReturn(errorApiState);

    // Also set up default category selection
    when(() => currentThemeState.categorySelectedValue)
        .thenReturn(minimalCategories.first.name);
    when(() => currentThemeState.categoryId)
        .thenReturn(minimalCategories.first.id);
  }

  // Upload theme specific methods
  void setupUploadThemeMethods() {
    // Setup uploadThemeApi method
    when(
      () => mockThemeBloc.uploadThemeApi(
        any(),
        aiImage: any(named: 'aiImage'),
        file: any(named: 'file'),
        deviceId: any(named: 'deviceId'),
        thumbnail: any(named: 'thumbnail'),
      ),
    ).thenAnswer((_) async {});

    // Setup theme name and category fields
    when(() => currentThemeState.themeNameField).thenReturn('Test Theme');
    when(() => currentThemeState.categorySelectedValue).thenReturn('Nature');
    when(() => currentThemeState.uploadOnDoorBell).thenReturn(false);
  }

  void setupUploadInProgress() {
    // Create ApiState with upload in progress
    final uploadInProgressState = ApiState<void>(
      (b) => b
        ..isApiInProgress = true
        ..error = null
        ..message = null
        ..data = null
        ..totalCount = 0
        ..currentPage = 0
        ..isApiPaginationEnabled = false
        ..uploadProgress = null
        ..pagination = null,
    );
    when(() => currentThemeState.uploadThemeApi)
        .thenReturn(uploadInProgressState);
  }

  void setupUploadNotInProgress() {
    // Create ApiState with upload not in progress
    final uploadNotInProgressState = ApiState<void>(
      (b) => b
        ..isApiInProgress = false
        ..error = null
        ..message = null
        ..data = null
        ..totalCount = 0
        ..currentPage = 0
        ..isApiPaginationEnabled = false
        ..uploadProgress = null
        ..pagination = null,
    );
    when(() => currentThemeState.uploadThemeApi)
        .thenReturn(uploadNotInProgressState);
  }
}
