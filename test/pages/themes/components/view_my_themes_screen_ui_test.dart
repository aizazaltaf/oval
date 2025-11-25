import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_list_card.dart';
import 'package:admin/pages/themes/componenets/view_my_themes_screen.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
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

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(MockStartupBloc());
    registerFallbackValue(Colors.red); // Add fallback for Color type
    await TestHelper.initialize();

    // Initialize helper classes
    themeBlocHelper = ThemeBlocTestHelper();
    singletonBlocHelper = SingletonBlocTestHelper();
    voiceControlBlocHelper = VoiceControlBlocTestHelper();

    // Setup all helpers
    themeBlocHelper.setup();
    singletonBlocHelper.setup();
    voiceControlBlocHelper.setup();
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
    themeBlocHelper.dispose();
    voiceControlBlocHelper.dispose();
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
            value: singletonBlocHelper.mockStartupBloc,
          ),
          BlocProvider<ThemeBloc>.value(value: themeBlocHelper.mockThemeBloc),
          BlocProvider<VoiceControlBloc>.value(
            value: voiceControlBlocHelper.mockVoiceControlBloc,
          ),
        ],
        child: const ViewMyThemesScreen(),
      ),
    );
  }

  group('ViewMyThemesScreen UI Tests', () {
    testWidgets('should display loading indicator when API is in progress',
        (tester) async {
      // Setup loading state using helper
      final loadingApiState = ApiState<PaginatedData<ThemeDataModel>>(
        (b) => b
          ..data = null
          ..isApiInProgress = true
          ..currentPage = 1
          ..totalCount = 0,
      );

      when(() => themeBlocHelper.currentThemeState.myThemes)
          .thenReturn(loadingApiState);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
    });

    testWidgets('should display no samples message when no themes available',
        (tester) async {
      // Setup empty state
      final emptyApiState = ApiState<PaginatedData<ThemeDataModel>>(
        (b) => b
          ..data = null
          ..isApiInProgress = false
          ..currentPage = 1
          ..totalCount = 0,
      );

      when(() => themeBlocHelper.currentThemeState.myThemes)
          .thenReturn(emptyApiState);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify no samples message is displayed
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(GridView), findsNothing);
      expect(find.text('No samples available for display.'), findsOneWidget);
    });

    testWidgets('should display grid of themes when themes are available',
        (tester) async {
      // Setup themes data
      final mockThemes = [
        ThemeDataModel(
          (b) => b
            ..id = 1
            ..title = 'Test Theme 1'
            ..description = 'Test Description 1'
            ..cover = 'https://example.com/theme1.jpg'
            ..thumbnail = 'https://example.com/theme1_thumb.jpg'
            ..mediaType = 1
            ..totalLikes = 10
            ..userLike = 0
            ..isApplied = false
            ..categoryId = 1
            ..isActive = 1
            ..fromCache = false,
        ),
        ThemeDataModel(
          (b) => b
            ..id = 2
            ..title = 'Test Theme 2'
            ..description = 'Test Description 2'
            ..cover = 'https://example.com/theme2.jpg'
            ..thumbnail = 'https://example.com/theme2_thumb.jpg'
            ..mediaType = 2
            ..totalLikes = 15
            ..userLike = 1
            ..isApplied = true
            ..categoryId = 1
            ..isActive = 1
            ..fromCache = false,
        ),
      ];

      final mockPaginatedData = PaginatedData<ThemeDataModel>(
        (b) => b
          ..data = ListBuilder<ThemeDataModel>(mockThemes)
          ..currentPage = 1
          ..lastPage = 1,
      );

      final themesApiState = ApiState<PaginatedData<ThemeDataModel>>(
        (b) => b
          ..data = mockPaginatedData
          ..isApiInProgress = false
          ..currentPage = 1
          ..totalCount = 2,
      );

      when(() => themeBlocHelper.currentThemeState.myThemes)
          .thenReturn(themesApiState);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify grid is displayed
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Verify theme cards are displayed
      expect(find.byType(ThemeListCard), findsNWidgets(2));
    });

    testWidgets('should call themes API on initState', (tester) async {
      // Setup mock for API call
      when(
        () => themeBlocHelper.mockThemeBloc.callThemesApi(
          type: "My Themes",
          refresh: true,
        ),
      ).thenAnswer((_) async {});

      // Setup empty state to avoid rendering issues
      final emptyApiState = ApiState<PaginatedData<ThemeDataModel>>(
        (b) => b
          ..data = null
          ..isApiInProgress = false
          ..currentPage = 1
          ..totalCount = 0,
      );

      when(() => themeBlocHelper.currentThemeState.myThemes)
          .thenReturn(emptyApiState);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify API was called at least once
      verify(
        () => themeBlocHelper.mockThemeBloc.callThemesApi(
          type: "My Themes",
          refresh: true,
        ),
      ).called(greaterThan(0));
    });

    testWidgets('should display correct app title', (tester) async {
      // Setup empty state
      final emptyApiState = ApiState<PaginatedData<ThemeDataModel>>(
        (b) => b
          ..data = null
          ..isApiInProgress = false
          ..currentPage = 1
          ..totalCount = 0,
      );

      when(() => themeBlocHelper.currentThemeState.myThemes)
          .thenReturn(emptyApiState);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify app title is displayed
      expect(find.byType(AppScaffold), findsOneWidget);
      expect(find.text('My Themes'), findsOneWidget);
    });

    testWidgets('should handle grid scroll physics correctly', (tester) async {
      // Setup themes data
      final mockThemes = [
        ThemeDataModel(
          (b) => b
            ..id = 1
            ..title = 'Test Theme 1'
            ..description = 'Test Description 1'
            ..cover = 'https://example.com/theme1.jpg'
            ..thumbnail = 'https://example.com/theme1_thumb.jpg'
            ..mediaType = 1
            ..totalLikes = 10
            ..userLike = 0
            ..isApplied = false
            ..categoryId = 1
            ..isActive = 1
            ..fromCache = false,
        ),
      ];

      final mockPaginatedData = PaginatedData<ThemeDataModel>(
        (b) => b
          ..data = ListBuilder<ThemeDataModel>(mockThemes)
          ..currentPage = 1
          ..lastPage = 1,
      );

      final themesApiState = ApiState<PaginatedData<ThemeDataModel>>(
        (b) => b
          ..data = mockPaginatedData
          ..isApiInProgress = false
          ..currentPage = 1
          ..totalCount = 1,
      );

      when(() => themeBlocHelper.currentThemeState.myThemes)
          .thenReturn(themesApiState);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify grid has correct scroll physics
      final gridView = tester.widget<GridView>(find.byType(GridView));
      expect(gridView.physics, isA<AlwaysScrollableScrollPhysics>());
    });

    testWidgets('should display correct grid layout properties',
        (tester) async {
      // Setup themes data
      final mockThemes = List.generate(
        20,
        (index) => ThemeDataModel(
          (b) => b
            ..id = index + 1
            ..title = 'Test Theme ${index + 1}'
            ..description = 'Test Description ${index + 1}'
            ..cover = 'https://example.com/theme${index + 1}.jpg'
            ..thumbnail = 'https://example.com/theme${index + 1}_thumb.jpg'
            ..mediaType = 1
            ..totalLikes = 10
            ..userLike = 0
            ..isApplied = false
            ..categoryId = 1
            ..isActive = 1
            ..fromCache = false,
        ),
      );

      final mockPaginatedData = PaginatedData<ThemeDataModel>(
        (b) => b
          ..data = ListBuilder<ThemeDataModel>(mockThemes)
          ..currentPage = 1
          ..lastPage = 1,
      );

      final themesApiState = ApiState<PaginatedData<ThemeDataModel>>(
        (b) => b
          ..data = mockPaginatedData
          ..isApiInProgress = false
          ..currentPage = 1
          ..totalCount = 20,
      );

      when(() => themeBlocHelper.currentThemeState.myThemes)
          .thenReturn(themesApiState);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify grid layout properties
      final gridView = tester.widget<GridView>(find.byType(GridView));
      expect(gridView.shrinkWrap, isTrue);
      expect(gridView.padding, const EdgeInsets.symmetric(vertical: 15));

      // Verify grid delegate properties
      final gridDelegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(gridDelegate.crossAxisCount, 3);
      expect(gridDelegate.mainAxisSpacing, 10);
      expect(gridDelegate.crossAxisSpacing, 10);
      expect(gridDelegate.childAspectRatio, 0.55);
    });

    testWidgets('should handle theme card interactions correctly',
        (tester) async {
      // Setup single theme data
      final mockTheme = ThemeDataModel(
        (b) => b
          ..id = 1
          ..title = 'Test Theme 1'
          ..description = 'Test Description 1'
          ..cover = 'https://example.com/theme1.jpg'
          ..thumbnail = 'https://example.com/theme1_thumb.jpg'
          ..mediaType = 1
          ..totalLikes = 10
          ..userLike = 0
          ..isApplied = false
          ..categoryId = 1
          ..isActive = 1
          ..fromCache = false,
      );

      final mockPaginatedData = PaginatedData<ThemeDataModel>(
        (b) => b
          ..data = ListBuilder<ThemeDataModel>([mockTheme])
          ..currentPage = 1
          ..lastPage = 1,
      );

      final themesApiState = ApiState<PaginatedData<ThemeDataModel>>(
        (b) => b
          ..data = mockPaginatedData
          ..isApiInProgress = false
          ..currentPage = 1
          ..totalCount = 1,
      );

      when(() => themeBlocHelper.currentThemeState.myThemes)
          .thenReturn(themesApiState);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify theme card is displayed
      expect(find.byType(ThemeListCard), findsOneWidget);

      // Verify theme card has correct data
      final themeCard =
          tester.widget<ThemeListCard>(find.byType(ThemeListCard));
      expect(themeCard.data.id, 1);
      expect(themeCard.data.title, 'Test Theme 1');
      expect(themeCard.index, 0);
      expect(themeCard.themes.length, 1);
    });

    testWidgets('should handle empty data state correctly', (tester) async {
      // Setup empty data state
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

      when(() => themeBlocHelper.currentThemeState.myThemes)
          .thenReturn(emptyApiState);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify no samples message is displayed
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(GridView), findsNothing);
      expect(find.text('No samples available for display.'), findsOneWidget);
    });

    testWidgets('should handle null data state correctly', (tester) async {
      // Setup null data state
      final nullDataApiState = ApiState<PaginatedData<ThemeDataModel>>(
        (b) => b
          ..data = null
          ..isApiInProgress = false
          ..currentPage = 1
          ..totalCount = 0,
      );

      when(() => themeBlocHelper.currentThemeState.myThemes)
          .thenReturn(nullDataApiState);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify no samples message is displayed
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(GridView), findsNothing);
      expect(find.text('No samples available for display.'), findsOneWidget);
    });

    testWidgets('should handle API error state gracefully', (tester) async {
      // Setup error state
      final errorApiState = ApiState<PaginatedData<ThemeDataModel>>(
        (b) => b
          ..data = null
          ..isApiInProgress = false
          ..currentPage = 1
          ..totalCount = 0,
      );

      when(() => themeBlocHelper.currentThemeState.myThemes)
          .thenReturn(errorApiState);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify error state is handled gracefully
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(GridView), findsNothing);
      expect(find.text('No samples available for display.'), findsOneWidget);
    });
  });
}
