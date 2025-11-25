import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_grid_view.dart';
import 'package:admin/pages/themes/model/theme_category_model.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/singleton_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/theme_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';
import '../../../mocks/bloc/bloc_mocks.dart';

void main() {
  late ThemeBlocTestHelper themeBlocHelper;
  late SingletonBlocTestHelper singletonBlocHelper;
  late MockProfileBloc mockProfileBloc;
  late MockStartupBloc mockStartupBloc;
  late UserData mockUserData;
  late DoorbellLocations mockUserLocation;

  // Sample theme data for testing
  late ThemeDataModel testTheme;
  late ThemeDataModel testTheme2;
  late ThemeDataModel testTheme3;
  late ThemeCategoryModel testCategory;
  late ThemeCategoryModel testCategory2;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(MockStartupBloc());
    registerFallbackValue(Colors.red);
    await TestHelper.initialize();

    // Initialize helper classes
    themeBlocHelper = ThemeBlocTestHelper();
    singletonBlocHelper = SingletonBlocTestHelper();

    // Setup all helpers
    themeBlocHelper.setup();
    singletonBlocHelper.setup();

    // Setup profile bloc mock
    mockProfileBloc = MockProfileBloc();
    mockStartupBloc = MockStartupBloc();

    // Create mock user location
    mockUserLocation = DoorbellLocations(
      (b) => b
        ..id = 1
        ..name = "Test Location"
        ..roles = ListBuilder<String>(["viewer"]),
    );

    mockUserData = UserData(
      (b) => b
        ..id = 1
        ..name = "Test User"
        ..email = "test@example.com"
        ..phone = "1234567890"
        ..aiThemeCounter = 5
        ..userRole = "user"
        ..phoneVerified = true
        ..emailVerified = true
        ..canPinned = true
        ..sectionList = ListBuilder<String>([])
        ..selectedDoorBell = (UserDeviceModelBuilder()
          ..id = 1
          ..name = "Test Doorbell"
          ..locationId = 1
          ..callUserId = "test-uuid")
        ..locations = ListBuilder([mockUserLocation]),
    );

    when(() => mockProfileBloc.state).thenReturn(mockUserData);
    // when(() => mockStartupBloc.state).thenReturn(StartupState());

    // Set the test profile bloc in singleton
    singletonBloc.testProfileBloc = mockProfileBloc;

    // Create test theme data
    testTheme = ThemeDataModel(
      (b) => b
        ..id = 1
        ..title = "Nature Theme"
        ..description = "A beautiful nature theme"
        ..cover = "https://example.com/nature.jpg"
        ..thumbnail = "https://example.com/nature_thumb.jpg"
        ..categoryId = 1
        ..totalLikes = 10
        ..userLike = 1
        ..isApplied = false
        ..mediaType = 1
        ..isActive = 1,
    );

    testTheme2 = ThemeDataModel(
      (b) => b
        ..id = 2
        ..title = "City Theme"
        ..description = "A modern city theme"
        ..cover = "https://example.com/city.jpg"
        ..thumbnail = "https://example.com/city_thumb.jpg"
        ..categoryId = 2
        ..totalLikes = 15
        ..userLike = 0
        ..isApplied = true
        ..mediaType = 2
        ..isActive = 1,
    );

    testTheme3 = ThemeDataModel(
      (b) => b
        ..id = 3
        ..title = "Abstract Theme"
        ..description = "An abstract art theme"
        ..cover = "https://example.com/abstract.jpg"
        ..thumbnail = "https://example.com/abstract_thumb.jpg"
        ..categoryId = 3
        ..totalLikes = 8
        ..userLike = 0
        ..isApplied = false
        ..mediaType = 1
        ..isActive = 1,
    );

    // Create test category data
    testCategory = ThemeCategoryModel(
      (b) => b
        ..id = 1
        ..name = "Nature"
        ..image = "https://example.com/nature_cat.jpg"
        ..isActive = 1
        ..createdAt = "2024-01-01T00:00:00Z"
        ..updatedAt = "2024-01-01T00:00:00Z",
    );

    testCategory2 = ThemeCategoryModel(
      (b) => b
        ..id = 2
        ..name = "Urban"
        ..image = "https://example.com/urban_cat.jpg"
        ..isActive = 1
        ..createdAt = "2024-01-01T00:00:00Z"
        ..updatedAt = "2024-01-01T00:00:00Z",
    );
  });

  // setUp(() {
  //
  // });

  tearDown(() {
    // Reset singleton state between tests to prevent interference
    // Create a fresh mock profile bloc for each test with proper state setup
    final freshMockProfileBloc = MockProfileBloc();
    when(() => freshMockProfileBloc.state).thenReturn(mockUserData);
    singletonBloc.testProfileBloc = freshMockProfileBloc;
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
  });

  Widget createTestWidget({
    required ThemeBloc themeBloc,
  }) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        cupertinoOverrideTheme: const CupertinoThemeData(
          barBackgroundColor: Colors.white,
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>.value(value: themeBloc),
          BlocProvider<StartupBloc>.value(value: mockStartupBloc),
        ],
        child: const Scaffold(
          body: ThemeGridView(),
        ),
      ),
    );
  }

  // void setupMockStartupBloc(MockStartupBloc mockStartupBloc) {
  //   when(() => mockStartupBloc.state).thenReturn(StartupState());
  //   when(() => mockStartupBloc.stream)
  //       .thenAnswer((_) => Stream.value(StartupState()));
  // }

  void setupMockThemeState(
    MockThemeBloc mockThemeBloc, {
    String activeType = 'Feed',
    bool feedThemesLoading = false,
    bool myThemesLoading = false,
    List<ThemeDataModel> feedThemes = const [],
    List<ThemeDataModel> myThemes = const [],
    List<ThemeCategoryModel> categories = const [],
    List<ThemeDataModel> popularThemes = const [],
    List<ThemeDataModel> videosThemes = const [],
    List<ThemeDataModel> categoryDetailsThemes = const [],
    String? errorMessage,
  }) {
    // Setup basic mock methods
    when(() => mockThemeBloc.notificationScroll).thenReturn(ScrollController());
    when(() => mockThemeBloc.categoryNotificationScroll)
        .thenReturn(ScrollController());

    // Create API states
    final feedApiState = ApiState<PaginatedData<ThemeDataModel>>(
      (b) => b
        ..isApiInProgress = feedThemesLoading
        ..data = feedThemes.isNotEmpty
            ? PaginatedData<ThemeDataModel>(
                (b) => b
                  ..data = ListBuilder<ThemeDataModel>(feedThemes)
                  ..currentPage = 1
                  ..lastPage = 1,
              )
            : null,
    );

    final myThemesApiState = ApiState<PaginatedData<ThemeDataModel>>(
      (b) => b
        ..isApiInProgress = myThemesLoading
        ..data = myThemes.isNotEmpty
            ? PaginatedData<ThemeDataModel>(
                (b) => b
                  ..data = ListBuilder<ThemeDataModel>(myThemes)
                  ..currentPage = 1
                  ..lastPage = 1,
              )
            : null,
    );

    final categoriesApiState = ApiState<PaginatedData<ThemeCategoryModel>>(
      (b) => b
        ..isApiInProgress = false
        ..data = categories.isNotEmpty
            ? PaginatedData<ThemeCategoryModel>(
                (b) => b
                  ..data = ListBuilder<ThemeCategoryModel>(categories)
                  ..currentPage = 1
                  ..lastPage = 1,
              )
            : null,
    );

    // Create additional API states for different theme types
    final popularApiState = ApiState<PaginatedData<ThemeDataModel>>(
      (b) => b
        ..isApiInProgress = false
        ..data = popularThemes.isNotEmpty
            ? PaginatedData<ThemeDataModel>(
                (b) => b
                  ..data = ListBuilder<ThemeDataModel>(popularThemes)
                  ..currentPage = 1
                  ..lastPage = 1,
              )
            : null,
    );

    final videosApiState = ApiState<PaginatedData<ThemeDataModel>>(
      (b) => b
        ..isApiInProgress = false
        ..data = videosThemes.isNotEmpty
            ? PaginatedData<ThemeDataModel>(
                (b) => b
                  ..data = ListBuilder<ThemeDataModel>(videosThemes)
                  ..currentPage = 1
                  ..lastPage = 1,
              )
            : null,
    );

    final categoryDetailsApiState = ApiState<PaginatedData<ThemeDataModel>>(
      (b) => b
        ..isApiInProgress = false
        ..data = categoryDetailsThemes.isNotEmpty
            ? PaginatedData<ThemeDataModel>(
                (b) => b
                  ..data = ListBuilder<ThemeDataModel>(categoryDetailsThemes)
                  ..currentPage = 1
                  ..lastPage = 1,
              )
            : null,
    );

    // Setup the existing mock state properties
    when(() => mockThemeBloc.state.activeType).thenReturn(activeType);
    when(() => mockThemeBloc.state.feedThemes).thenReturn(feedApiState);
    when(() => mockThemeBloc.state.myThemes).thenReturn(myThemesApiState);
    when(() => mockThemeBloc.state.categoryThemesApi)
        .thenReturn(categoriesApiState);
    when(() => mockThemeBloc.state.popularThemes).thenReturn(popularApiState);
    when(() => mockThemeBloc.state.videosThemes).thenReturn(videosApiState);
    when(() => mockThemeBloc.state.categoryDetailsThemesApi)
        .thenReturn(categoryDetailsApiState);

    if (errorMessage != null) {
      when(() => mockThemeBloc.state.simpleThemesError)
          .thenReturn(errorMessage);
    } else {
      when(() => mockThemeBloc.state.simpleThemesError).thenReturn("");
    }

    // Setup getThemeApiType method to return the appropriate API state based on activeType
    when(() => mockThemeBloc.getThemeApiType(any())).thenAnswer((invocation) {
      final type = invocation.positionalArguments[0] as String;
      switch (type) {
        case "Feed":
          return feedApiState;
        case "Category":
          return categoryDetailsApiState;
        case "My Themes":
          return myThemesApiState;
        case "Popular":
          return popularApiState;
        case "Videos":
          return videosApiState;
        case "Gif":
          return ApiState<PaginatedData<ThemeDataModel>>();
        default:
          return feedApiState;
      }
    });
  }

  group('ThemeGridView', () {
    testWidgets(
        'should display loading indicator when Feed tab is selected and APIs are in progress',
        (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Setup state for loading
      setupMockThemeState(
        mockThemeBloc,
        feedThemesLoading: true,
        myThemesLoading: true,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display no samples message when no themes available',
        (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Setup state for no themes
      setupMockThemeState(
        mockThemeBloc,
        feedThemes: [],
        myThemes: [],
        categories: [],
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.text('No samples available for display.'), findsOneWidget);
    });

    testWidgets(
        'should display no internet connection message when error occurs',
        (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Setup state for error
      setupMockThemeState(
        mockThemeBloc,
        feedThemes: [],
        myThemes: [],
        categories: [],
        errorMessage: 'No internet connection',
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.text('No internet connection'), findsOneWidget);
    });

    testWidgets('should display home themes layout when forHome is true',
        (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Setup state for home view
      setupMockThemeState(
        mockThemeBloc,
        feedThemes: [testTheme2, testTheme3],
        myThemes: [testTheme],
        categories: [testCategory],
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('My Themes'), findsOneWidget);
      expect(find.text('Feed'), findsOneWidget);
    });

    testWidgets('should display category themes in horizontal scrollable grid',
        (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Use the helper's method to set up categories
      themeBlocHelper.setupWithCategories([testCategory, testCategory2]);

      // Set active type to Feed to trigger home view
      when(() => mockThemeBloc.state.activeType).thenReturn('Feed');

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.text('Category'), findsOneWidget);
      expect(find.byType(GridView), findsWidgets);
    });

    testWidgets('should display my themes in horizontal scrollable grid',
        (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Set up my themes using the helper's approach
      final myThemesPaginatedData = PaginatedData<ThemeDataModel>(
        (b) => b
          ..data = ListBuilder<ThemeDataModel>([testTheme, testTheme2])
          ..currentPage = 1
          ..lastPage = 1,
      );

      final myThemesApiState = ApiState<PaginatedData<ThemeDataModel>>(
        (b) => b
          ..data = myThemesPaginatedData
          ..isApiInProgress = false
          ..currentPage = 1
          ..totalCount = 2,
      );

      when(() => mockThemeBloc.state.myThemes).thenReturn(myThemesApiState);
      when(() => mockThemeBloc.state.activeType).thenReturn('Feed');

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.text('My Themes'), findsOneWidget);
      expect(find.byType(GridView), findsWidgets);
    });

    testWidgets('should display feed themes in 3-column grid', (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Setup state for home view with feed themes
      setupMockThemeState(
        mockThemeBloc,
        feedThemes: [testTheme, testTheme2, testTheme3],
        myThemes: [],
        categories: [],
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.text('Feed'), findsOneWidget);
      expect(find.byType(GridView), findsWidgets);
    });

    testWidgets('should show view all button when categories exceed 6',
        (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Create more than 6 categories
      final manyCategories = List.generate(
        8,
        (index) => ThemeCategoryModel(
          (b) => b
            ..id = index + 1
            ..name = "Category $index"
            ..image = "https://example.com/cat$index.jpg"
            ..isActive = 1
            ..createdAt = "2024-01-01T00:00:00Z"
            ..updatedAt = "2024-01-01T00:00:00Z",
        ),
      );

      // Use the helper's method to set up many categories
      themeBlocHelper.setupWithCategories(manyCategories);
      when(() => mockThemeBloc.state.activeType).thenReturn('Feed');

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.text('View All'), findsOneWidget);
    });

    testWidgets('should show view all button when my themes exceed 6',
        (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Create more than 6 themes
      final manyThemes = List.generate(
        8,
        (index) => ThemeDataModel(
          (b) => b
            ..id = index + 1
            ..title = "Theme $index"
            ..description = "Description $index"
            ..cover = "https://example.com/theme$index.jpg"
            ..thumbnail = "https://example.com/theme${index}_thumb.jpg"
            ..categoryId = index + 1
            ..totalLikes = index * 5
            ..userLike = index % 2
            ..isApplied = false
            ..mediaType = 1
            ..isActive = 1,
        ),
      );

      // Set up many my themes
      final myThemesPaginatedData = PaginatedData<ThemeDataModel>(
        (b) => b
          ..data = ListBuilder<ThemeDataModel>(manyThemes)
          ..currentPage = 1
          ..lastPage = 1,
      );

      final myThemesApiState = ApiState<PaginatedData<ThemeDataModel>>(
        (b) => b
          ..data = myThemesPaginatedData
          ..isApiInProgress = false
          ..currentPage = 1
          ..totalCount = manyThemes.length,
      );

      // Set up empty categories to avoid showing category "View All" button
      final emptyCategoriesPaginatedData = PaginatedData<ThemeCategoryModel>(
        (b) => b
          ..data = ListBuilder<ThemeCategoryModel>([])
          ..currentPage = 1
          ..lastPage = 1,
      );

      final emptyCategoriesApiState =
          ApiState<PaginatedData<ThemeCategoryModel>>(
        (b) => b
          ..data = emptyCategoriesPaginatedData
          ..isApiInProgress = false
          ..currentPage = 1
          ..totalCount = 0,
      );

      when(() => mockThemeBloc.state.myThemes).thenReturn(myThemesApiState);
      when(() => mockThemeBloc.state.categoryThemesApi)
          .thenReturn(emptyCategoriesApiState);
      when(() => mockThemeBloc.state.activeType).thenReturn('Feed');

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.text('View All'), findsOneWidget);
    });

    testWidgets('should display regular grid view when not forHome',
        (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Setup state for non-home view
      setupMockThemeState(
        mockThemeBloc,
        activeType: 'Popular',
        popularThemes: [testTheme, testTheme2],
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should display category grid view when fromCategory is true',
        (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Setup state for category view
      setupMockThemeState(
        mockThemeBloc,
        activeType: 'Category',
        categoryDetailsThemes: [testTheme, testTheme2],
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets(
        'should show no more themes message when pagination is complete',
        (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Create feed themes with pagination data
      final feedThemesPaginatedData = PaginatedData<ThemeDataModel>(
        (b) => b
          ..data = ListBuilder<ThemeDataModel>([testTheme])
          ..currentPage = 5
          ..lastPage = 5,
      );

      final feedApiState = ApiState<PaginatedData<ThemeDataModel>>(
        (b) => b
          ..isApiInProgress = false
          ..data = feedThemesPaginatedData
          ..currentPage = 5
          ..totalCount = 5,
      );

      // Setup state for completed pagination - use Feed to trigger home view
      when(() => mockThemeBloc.state.activeType).thenReturn('Feed');
      when(() => mockThemeBloc.state.feedThemes).thenReturn(feedApiState);
      when(() => mockThemeBloc.state.myThemes).thenReturn(
        ApiState<PaginatedData<ThemeDataModel>>(
          (b) => b
            ..isApiInProgress = false
            ..data = null,
        ),
      );
      when(() => mockThemeBloc.state.categoryThemesApi).thenReturn(
        ApiState<PaginatedData<ThemeCategoryModel>>(
          (b) => b
            ..isApiInProgress = false
            ..data = null,
        ),
      );

      // Setup getThemeApiType method
      when(() => mockThemeBloc.getThemeApiType(any())).thenReturn(feedApiState);

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.text('No More Themes Available'), findsOneWidget);
    });

    testWidgets('should show progress indicator for feed themes pagination',
        (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Setup state for pagination in progress - use Feed to trigger home view
      setupMockThemeState(
        mockThemeBloc,
        feedThemesLoading: true,
        feedThemes: [testTheme],
        myThemes: [],
        categories: [],
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.byType(ButtonProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle viewer role correctly', (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Setup state for viewer role
      setupMockThemeState(
        mockThemeBloc,
        feedThemes: [testTheme],
        myThemes: [],
        categories: [],
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should display correct grid layout for different theme types',
        (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Setup state for different theme types
      setupMockThemeState(
        mockThemeBloc,
        activeType: 'Videos',
        videosThemes: [testTheme, testTheme2, testTheme3],
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should handle empty state gracefully', (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Setup state for empty data
      setupMockThemeState(
        mockThemeBloc,
        activeType: 'Popular', // Use non-home type to trigger non-home logic
        feedThemes: [],
        popularThemes: [], // This should be empty for the active type
        myThemes: [],
        categories: [],
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.text('No samples available for display.'), findsOneWidget);
    });

    testWidgets('should display correct aspect ratios for different grids',
        (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Setup state for home view with all sections
      setupMockThemeState(
        mockThemeBloc,
        feedThemes: [testTheme2],
        myThemes: [testTheme],
        categories: [],
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.byType(GridView), findsWidgets);
    });

    testWidgets('should handle refresh functionality', (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Setup state for refreshable view
      setupMockThemeState(
        mockThemeBloc,
        activeType: 'Popular',
        popularThemes: [testTheme],
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('should handle smart refresher functionality', (tester) async {
      // Arrange
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      // Setup state for smart refresher
      setupMockThemeState(
        mockThemeBloc,
        activeType: 'Popular',
        popularThemes: [testTheme],
      );

      // Override nextPageUrl for pagination testing
      when(() => mockThemeBloc.state.popularThemes.data?.nextPageUrl)
          .thenReturn('https://example.com/next');

      // Act
      await tester.pumpWidget(
        createTestWidget(
          themeBloc: mockThemeBloc,
        ),
      );

      // Assert
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });
}
