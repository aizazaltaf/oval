import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/category_widget.dart';
import 'package:admin/pages/themes/componenets/view_category_screen.dart';
import 'package:admin/pages/themes/model/theme_category_model.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/singleton_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/theme_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/voice_control_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';
import '../../../mocks/bloc/bloc_mocks.dart';

void main() {
  late ThemeBlocTestHelper themeBlocHelper;
  late SingletonBlocTestHelper singletonBlocHelper;
  late VoiceControlBlocTestHelper voiceControlBlocHelper;
  late MockProfileBloc mockProfileBloc;
  late MockStartupBloc mockStartupBloc;

  // Sample theme category data for testing
  late List<ThemeCategoryModel> testThemeCategories;
  late PaginatedData<ThemeCategoryModel> testPaginatedData;
  late ApiState<PaginatedData<ThemeCategoryModel>> testApiState;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(MockStartupBloc());
    registerFallbackValue(Colors.red);
    await TestHelper.initialize();

    // Initialize helper classes
    themeBlocHelper = ThemeBlocTestHelper();
    singletonBlocHelper = SingletonBlocTestHelper();
    voiceControlBlocHelper = VoiceControlBlocTestHelper();

    // Setup all helpers
    themeBlocHelper.setup();
    singletonBlocHelper.setup();
    voiceControlBlocHelper.setup();

    // Setup profile bloc mock
    mockProfileBloc = MockProfileBloc();
    mockStartupBloc = MockStartupBloc();

    // Set the test profile bloc in singleton
    singletonBloc.testProfileBloc = mockProfileBloc;

    // Create test theme category data
    testThemeCategories = [
      ThemeCategoryModel(
        (b) => b
          ..id = 1
          ..name = "Nature"
          ..image = "https://example.com/nature.jpg"
          ..isActive = 1
          ..createdAt = "2024-01-01T00:00:00Z"
          ..updatedAt = "2024-01-01T00:00:00Z",
      ),
      ThemeCategoryModel(
        (b) => b
          ..id = 2
          ..name = "Technology"
          ..image = "https://example.com/tech.jpg"
          ..isActive = 1
          ..createdAt = "2024-01-01T00:00:00Z"
          ..updatedAt = "2024-01-01T00:00:00Z",
      ),
      ThemeCategoryModel(
        (b) => b
          ..id = 3
          ..name = "Abstract"
          ..image = "https://example.com/abstract.jpg"
          ..isActive = 1
          ..createdAt = "2024-01-01T00:00:00Z"
          ..updatedAt = "2024-01-01T00:00:00Z",
      ),
      ThemeCategoryModel(
        (b) => b
          ..id = 4
          ..name = "Minimalist"
          ..image = "https://example.com/minimalist.jpg"
          ..isActive = 1
          ..createdAt = "2024-01-01T00:00:00Z"
          ..updatedAt = "2024-01-01T00:00:00Z",
      ),
    ];

    testPaginatedData = PaginatedData<ThemeCategoryModel>(
      (b) => b
        ..data = ListBuilder<ThemeCategoryModel>(testThemeCategories)
        ..currentPage = 1
        ..lastPage = 1,
    );

    testApiState = ApiState<PaginatedData<ThemeCategoryModel>>(
      (b) => b
        ..data = testPaginatedData
        ..isApiInProgress = false
        ..currentPage = 1
        ..totalCount = 4,
    );

    // Setup theme bloc mock methods
    when(() => themeBlocHelper.mockThemeBloc.updateCategoryApiId(any()))
        .thenReturn(null);
    when(() => themeBlocHelper.mockThemeBloc.updateActiveType(any()))
        .thenReturn(null);
    when(() => themeBlocHelper.mockThemeBloc.clearSearchFromCategories())
        .thenReturn(null);
    when(
      () => themeBlocHelper.mockThemeBloc.callThemesApi(
        type: any(named: 'type'),
        categoryId: any(named: 'categoryId'),
        refresh: any(named: 'refresh'),
        isPageChangeRefreshTheme: any(named: 'isPageChangeRefreshTheme'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
    themeBlocHelper.dispose();
    voiceControlBlocHelper.dispose();
  });

  tearDown(() async {
    // Clean up any pending timers and animations
    await Future.delayed(const Duration(milliseconds: 100));
  });

  Widget createTestWidget() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      home: MultiBlocProvider(
        providers: [
          BlocProvider<StartupBloc>.value(
            value: mockStartupBloc,
          ),
          BlocProvider<ThemeBloc>.value(value: themeBlocHelper.mockThemeBloc),
          BlocProvider<VoiceControlBloc>.value(
            value: voiceControlBlocHelper.mockVoiceControlBloc,
          ),
        ],
        child: const ViewCategoryScreen(),
      ),
    );
  }

  group('ViewCategoryScreen UI Tests', () {
    group('Initial Rendering', () {
      testWidgets('should render view category screen with app bar and title',
          (tester) async {
        // Setup theme bloc with sample data
        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(testApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(AppScaffold), findsOneWidget);
        expect(find.text('Categories'), findsOneWidget);
      });

      testWidgets('should render loading indicator when API is in progress',
          (tester) async {
        // Setup theme bloc with loading state
        final loadingApiState = ApiState<PaginatedData<ThemeCategoryModel>>(
          (b) => b
            ..isApiInProgress = true
            ..data = null,
        );
        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(loadingApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(GridView), findsNothing);
      });

      testWidgets('should render no samples message when data is empty',
          (tester) async {
        // Setup theme bloc with empty data
        final emptyApiState = ApiState<PaginatedData<ThemeCategoryModel>>(
          (b) => b
            ..isApiInProgress = false
            ..data = PaginatedData<ThemeCategoryModel>(
              (b) => b
                ..data = ListBuilder<ThemeCategoryModel>([])
                ..currentPage = 1
                ..lastPage = 1,
            ),
        );
        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(emptyApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Look for the Text widget that contains the no samples message
        expect(find.text('No samples available for display.'), findsOneWidget);
        expect(find.byType(GridView), findsNothing);
      });

      testWidgets('should render no samples message when data is null',
          (tester) async {
        // Setup theme bloc with null data
        final nullApiState = ApiState<PaginatedData<ThemeCategoryModel>>(
          (b) => b
            ..isApiInProgress = false
            ..data = null,
        );
        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(nullApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Look for the Text widget that contains the no samples message
        expect(find.text('No samples available for display.'), findsOneWidget);
        expect(find.byType(GridView), findsNothing);
      });
    });

    group('Category Grid Display', () {
      testWidgets('should render category grid with correct number of items',
          (tester) async {
        // Setup theme bloc with sample data
        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(testApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(GridView), findsOneWidget);
        expect(find.byType(CategoryWidget), findsNWidgets(4));
      });

      testWidgets('should render category grid with correct grid properties',
          (tester) async {
        // Setup theme bloc with sample data
        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(testApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView.shrinkWrap, isTrue);
        expect(gridView.padding, const EdgeInsets.symmetric(vertical: 15));
        expect(gridView.physics, const AlwaysScrollableScrollPhysics());
      });

      testWidgets('should render category grid with correct grid delegate',
          (tester) async {
        // Setup theme bloc with sample data
        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(testApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final gridView = tester.widget<GridView>(find.byType(GridView));
        final gridDelegate =
            gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

        expect(gridDelegate.crossAxisCount, 2);
        expect(gridDelegate.mainAxisSpacing, 10);
        expect(gridDelegate.crossAxisSpacing, 10);
        expect(gridDelegate.childAspectRatio, 1.6);
      });

      testWidgets('should render category widgets with correct data',
          (tester) async {
        // Setup theme bloc with sample data
        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(testApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Verify first category widget
        final firstCategoryWidget = tester.widget<CategoryWidget>(
          find.byType(CategoryWidget).first,
        );
        expect(firstCategoryWidget.themeCategory.id, 1);
        expect(firstCategoryWidget.themeCategory.name, "Nature");
        expect(firstCategoryWidget.viewCategoriesScreen, isTrue);

        // Verify last category widget
        final lastCategoryWidget = tester.widget<CategoryWidget>(
          find.byType(CategoryWidget).last,
        );
        expect(lastCategoryWidget.themeCategory.id, 4);
        expect(lastCategoryWidget.themeCategory.name, "Minimalist");
        expect(lastCategoryWidget.viewCategoriesScreen, isTrue);
      });
    });

    group('Layout and Styling', () {
      testWidgets('should apply correct padding to body', (tester) async {
        // Setup theme bloc with sample data
        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(testApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Find the Padding widget that wraps the body content
        final paddingWidgets = find.byType(Padding);
        expect(paddingWidgets, findsWidgets);

        // Check if any of the padding widgets has the correct horizontal padding
        bool foundCorrectPadding = false;
        for (final element in paddingWidgets.evaluate()) {
          final padding = tester.widget<Padding>(find.byWidget(element.widget));
          if (padding.padding == const EdgeInsets.symmetric(horizontal: 20)) {
            foundCorrectPadding = true;
            break;
          }
        }
        expect(foundCorrectPadding, isTrue);
      });

      testWidgets('should render app scaffold with correct title',
          (tester) async {
        // Setup theme bloc with sample data
        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(testApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final appScaffold =
            tester.widget<AppScaffold>(find.byType(AppScaffold));
        expect(appScaffold.appTitle, 'Categories');
      });
    });

    group('State Management', () {
      testWidgets('should show loading state when API is in progress',
          (tester) async {
        // Setup theme bloc with loading state
        final loadingApiState = ApiState<PaginatedData<ThemeCategoryModel>>(
          (b) => b
            ..isApiInProgress = true
            ..data = null,
        );
        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(loadingApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(GridView), findsNothing);
      });

      testWidgets('should show data when API is loaded', (tester) async {
        // Setup theme bloc with sample data
        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(testApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(CategoryWidget), findsNWidgets(4));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle single category gracefully', (tester) async {
        // Setup theme bloc with single category
        final singleCategory = [
          ThemeCategoryModel(
            (b) => b
              ..id = 1
              ..name = "Single Category"
              ..image = "https://example.com/single.jpg"
              ..isActive = 1
              ..createdAt = "2024-01-01T00:00:00Z"
              ..updatedAt = "2024-01-01T00:00:00Z",
          ),
        ];

        final singlePaginatedData = PaginatedData<ThemeCategoryModel>(
          (b) => b
            ..data = ListBuilder<ThemeCategoryModel>(singleCategory)
            ..currentPage = 1
            ..lastPage = 1,
        );

        final singleApiState = ApiState<PaginatedData<ThemeCategoryModel>>(
          (b) => b
            ..data = singlePaginatedData
            ..isApiInProgress = false
            ..currentPage = 1
            ..totalCount = 1,
        );

        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(singleApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(CategoryWidget), findsOneWidget);
        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('should handle large number of categories', (tester) async {
        // Setup theme bloc with many categories (limit to a reasonable number for testing)
        final manyCategories = List.generate(
          6,
          (index) => ThemeCategoryModel(
            (b) => b
              ..id = index + 1
              ..name = "Category ${index + 1}"
              ..image = "https://example.com/category${index + 1}.jpg"
              ..isActive = 1
              ..createdAt = "2024-01-01T00:00:00Z"
              ..updatedAt = "2024-01-01T00:00:00Z",
          ),
        );

        final manyPaginatedData = PaginatedData<ThemeCategoryModel>(
          (b) => b
            ..data = ListBuilder<ThemeCategoryModel>(manyCategories)
            ..currentPage = 1
            ..lastPage = 1,
        );

        final manyApiState = ApiState<PaginatedData<ThemeCategoryModel>>(
          (b) => b
            ..data = manyPaginatedData
            ..isApiInProgress = false
            ..currentPage = 1
            ..totalCount = 6,
        );

        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(manyApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(CategoryWidget), findsNWidgets(6));
        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('should handle category with long name', (tester) async {
        // Setup theme bloc with category having long name
        final longNameCategory = [
          ThemeCategoryModel(
            (b) => b
              ..id = 1
              ..name =
                  "This is a very long category name that should be handled properly in the UI without breaking the layout"
              ..image = "https://example.com/long-name.jpg"
              ..isActive = 1
              ..createdAt = "2024-01-01T00:00:00Z"
              ..updatedAt = "2024-01-01T00:00:00Z",
          ),
        ];

        final longNamePaginatedData = PaginatedData<ThemeCategoryModel>(
          (b) => b
            ..data = ListBuilder<ThemeCategoryModel>(longNameCategory)
            ..currentPage = 1
            ..lastPage = 1,
        );

        final longNameApiState = ApiState<PaginatedData<ThemeCategoryModel>>(
          (b) => b
            ..data = longNamePaginatedData
            ..isApiInProgress = false
            ..currentPage = 1
            ..totalCount = 1,
        );

        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(longNameApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(CategoryWidget), findsOneWidget);
        expect(find.byType(GridView), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantic labels', (tester) async {
        // Setup theme bloc with sample data
        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(testApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Verify that the screen has proper semantic structure
        expect(find.bySemanticsLabel('Categories'), findsOneWidget);
      });

      testWidgets('should support screen readers', (tester) async {
        // Setup theme bloc with sample data
        when(() => themeBlocHelper.mockThemeBloc.state.categoryThemesApi)
            .thenReturn(testApiState);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Verify that category widgets are accessible
        expect(find.byType(CategoryWidget), findsNWidgets(4));

        // Each category widget should be tappable
        for (int i = 0; i < 4; i++) {
          final categoryWidget = find.byType(CategoryWidget).at(i);
          expect(tester.getSemantics(categoryWidget), isNotNull);
        }
      });
    });
  });
}
