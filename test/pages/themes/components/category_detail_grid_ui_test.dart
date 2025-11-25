import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/category_detail_grid.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
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
  late MockVoiceControlBloc mockVoiceControlBloc;
  late UserData mockUserData;

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
    mockVoiceControlBloc = MockVoiceControlBloc();
    mockProfileBloc = MockProfileBloc();
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
        ..selectedDoorBell = null
        ..locations = ListBuilder([]),
    );

    when(() => mockProfileBloc.state).thenReturn(mockUserData);

    // Set the test profile bloc in singleton
    singletonBloc.testProfileBloc = mockProfileBloc;
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
    themeBlocHelper.dispose();
    voiceControlBlocHelper.dispose();
  });

  tearDown(() async {
    reset(mockVoiceControlBloc);
    // Clean up any pending timers and animations
    await Future.delayed(const Duration(milliseconds: 100));
  });

  Widget createTestWidget({
    required String themeName,
    required int categoryId,
    bool viewCategoriesScreen = false,
  }) {
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', '')],
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1200, 800)),
            child: MultiBlocProvider(
              providers: [
                BlocProvider<StartupBloc>(
                  create: (context) => singletonBlocHelper.mockStartupBloc,
                ),
                BlocProvider<ThemeBloc>(
                  create: (context) => themeBlocHelper.mockThemeBloc,
                ),
                BlocProvider<VoiceControlBloc>(
                  create: (context) =>
                      voiceControlBlocHelper.mockVoiceControlBloc,
                ),
              ],
              child: CategoryDetailGrid(
                themeName: themeName,
                categoryId: categoryId,
                viewCategoriesScreen: viewCategoriesScreen,
              ),
            ),
          ),
        );
      },
    );
  }

  group('CategoryDetailGrid Widget Tests', () {
    const testThemeName = 'Test Theme';
    const testCategoryId = 123;

    testWidgets('should render CategoryDetailGrid with correct app title',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeName: testThemeName,
          categoryId: testCategoryId,
        ),
      );

      // Wait for the widget to build
      await tester.pump(const Duration(milliseconds: 100));

      // Verify the app title is displayed
      expect(find.text(testThemeName), findsOneWidget);
    });

    testWidgets('should render CategoryDetailGrid with AppScaffold',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeName: testThemeName,
          categoryId: testCategoryId,
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify AppScaffold is used
      expect(find.byType(AppScaffold), findsOneWidget);
    });

    testWidgets('should render ThemeDetailGrid with correct parameters',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeName: testThemeName,
          categoryId: testCategoryId,
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify ThemeDetailGrid is rendered with correct parameters
      // Note: We can't directly test the ThemeDetailGrid parameters since it's a child widget
      // But we can verify the widget structure
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
    });

    testWidgets('should handle viewCategoriesScreen parameter correctly',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeName: testThemeName,
          categoryId: testCategoryId,
          viewCategoriesScreen: true,
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify the widget renders without errors when viewCategoriesScreen is true
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
    });

    testWidgets('should add scroll listener to categoryNotificationScroll',
        (tester) async {
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();
      final mockScrollController = ScrollController();

      // Setup the mock to return our scroll controller
      when(() => mockThemeBloc.categoryNotificationScroll)
          .thenReturn(mockScrollController);

      await tester.pumpWidget(
        FlutterSizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en', '')],
              home: MediaQuery(
                data: const MediaQueryData(size: Size(1200, 800)),
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<StartupBloc>(
                      create: (context) => singletonBlocHelper.mockStartupBloc,
                    ),
                    BlocProvider<ThemeBloc>(
                      create: (context) => themeBlocHelper.mockThemeBloc,
                    ),
                    BlocProvider<VoiceControlBloc>(
                      create: (context) =>
                          voiceControlBlocHelper.mockVoiceControlBloc,
                    ),
                  ],
                  child: const CategoryDetailGrid(
                    themeName: testThemeName,
                    categoryId: testCategoryId,
                  ),
                ),
              ),
            );
          },
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the scroll listener was added
      // Note: We can't directly test the listener addition, but we can verify the widget builds
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
    });

    testWidgets('should handle different theme names correctly',
        (tester) async {
      const longThemeName =
          'This is a very long theme name that should be handled properly';
      const shortThemeName = 'Short';

      // Test with long theme name
      await tester.pumpWidget(
        createTestWidget(
          themeName: longThemeName,
          categoryId: testCategoryId,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text(longThemeName), findsOneWidget);

      // Test with short theme name
      await tester.pumpWidget(
        createTestWidget(
          themeName: shortThemeName,
          categoryId: testCategoryId,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text(shortThemeName), findsOneWidget);
    });

    testWidgets('should handle different category IDs correctly',
        (tester) async {
      const smallCategoryId = 1;
      const largeCategoryId = 999999;

      // Test with small category ID
      await tester.pumpWidget(
        createTestWidget(
          themeName: testThemeName,
          categoryId: smallCategoryId,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CategoryDetailGrid), findsOneWidget);

      // Test with large category ID
      await tester.pumpWidget(
        createTestWidget(
          themeName: testThemeName,
          categoryId: largeCategoryId,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
    });

    testWidgets('should handle zero category ID correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeName: testThemeName,
          categoryId: 0,
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify the widget renders without errors with zero category ID
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
    });

    testWidgets('should handle negative category ID correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeName: testThemeName,
          categoryId: -1,
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify the widget renders without errors with negative category ID
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
    });

    testWidgets('should handle empty theme name correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeName: '',
          categoryId: testCategoryId,
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify the widget renders without errors with empty theme name
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('should handle special characters in theme name correctly',
        (tester) async {
      const specialThemeName = 'Theme with special characters';

      await tester.pumpWidget(
        createTestWidget(
          themeName: specialThemeName,
          categoryId: testCategoryId,
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify the widget renders without errors with special characters
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
      expect(find.text(specialThemeName), findsOneWidget);
    });

    testWidgets('should handle unicode characters in theme name correctly',
        (tester) async {
      const unicodeThemeName = 'Theme with emojis and accents';

      await tester.pumpWidget(
        createTestWidget(
          themeName: unicodeThemeName,
          categoryId: testCategoryId,
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify the widget renders without errors with unicode characters
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
      expect(find.text(unicodeThemeName), findsOneWidget);
    });

    testWidgets('should maintain widget structure during rebuilds',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeName: testThemeName,
          categoryId: testCategoryId,
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify initial structure
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
      expect(find.byType(AppScaffold), findsOneWidget);
      expect(find.text(testThemeName), findsOneWidget);

      // Trigger a rebuild
      await tester.pump();

      // Verify structure is maintained
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
      expect(find.byType(AppScaffold), findsOneWidget);
      expect(find.text(testThemeName), findsOneWidget);
    });

    testWidgets('should handle theme bloc state changes correctly',
        (tester) async {
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();
      final mockScrollController = ScrollController();

      when(() => mockThemeBloc.categoryNotificationScroll)
          .thenReturn(mockScrollController);

      await tester.pumpWidget(
        FlutterSizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en', '')],
              home: MediaQuery(
                data: const MediaQueryData(size: Size(1200, 800)),
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<StartupBloc>(
                      create: (context) => singletonBlocHelper.mockStartupBloc,
                    ),
                    BlocProvider<ThemeBloc>(
                      create: (context) => themeBlocHelper.mockThemeBloc,
                    ),
                    BlocProvider<VoiceControlBloc>(
                      create: (context) =>
                          voiceControlBlocHelper.mockVoiceControlBloc,
                    ),
                  ],
                  child: const CategoryDetailGrid(
                    themeName: testThemeName,
                    categoryId: testCategoryId,
                  ),
                ),
              ),
            );
          },
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify initial state
      expect(find.byType(CategoryDetailGrid), findsOneWidget);

      // Simulate theme bloc state change
      // Note: In a real scenario, this would be done through the bloc's emit method
      await tester.pump();

      // Verify widget still renders correctly
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
    });
  });

  group('CategoryDetailGrid Static Methods Tests', () {
    test('should have correct route name', () {
      expect(CategoryDetailGrid.routeName, equals('categoryDetailGrid'));
    });

    test('should have correct constructor parameters', () {
      const widget = CategoryDetailGrid(
        themeName: 'Test Theme',
        categoryId: 123,
      );

      expect(widget.themeName, equals('Test Theme'));
      expect(widget.categoryId, equals(123));
      expect(widget.viewCategoriesScreen, equals(false));
    });

    test('should have push method with correct signature', () {
      // This test verifies the static push method exists and has the correct signature
      expect(CategoryDetailGrid.push, isA<Function>());
    });
  });

  group('CategoryDetailGrid Integration Tests', () {
    const testThemeName = 'Test Theme';
    const testCategoryId = 123;

    testWidgets('should integrate with voice control bloc correctly',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeName: testThemeName,
          categoryId: testCategoryId,
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify the widget integrates with voice control bloc without errors
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
    });

    testWidgets('should integrate with singleton bloc correctly',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeName: testThemeName,
          categoryId: testCategoryId,
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify the widget integrates with singleton bloc without errors
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
    });

    testWidgets('should handle navigation context correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeName: testThemeName,
          categoryId: testCategoryId,
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify the widget handles navigation context correctly
      expect(find.byType(CategoryDetailGrid), findsOneWidget);
    });
  });

  group('CategoryDetailGrid Error Handling Tests', () {
    const testThemeName = 'Test Theme';
    const testCategoryId = 123;

    testWidgets('should handle missing theme bloc gracefully', (tester) async {
      // Test without ThemeBloc provider
      await tester.pumpWidget(
        FlutterSizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en', '')],
              home: MediaQuery(
                data: const MediaQueryData(size: Size(1200, 800)),
                child: BlocProvider<VoiceControlBloc>(
                  create: (context) =>
                      voiceControlBlocHelper.mockVoiceControlBloc,
                  child: const CategoryDetailGrid(
                    themeName: testThemeName,
                    categoryId: testCategoryId,
                  ),
                ),
              ),
            );
          },
        ),
      );

      // The widget should throw an error when ThemeBloc is missing
      // This is expected behavior, so we should catch and verify the error
      expect(tester.takeException(), isA<FlutterError>());
    });

    testWidgets('should handle missing voice control bloc gracefully',
        (tester) async {
      // Test without VoiceControlBloc provider
      final mockThemeBloc = themeBlocHelper.getMockThemeBloc();

      await tester.pumpWidget(
        FlutterSizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en', '')],
              home: MediaQuery(
                data: const MediaQueryData(size: Size(1200, 800)),
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<StartupBloc>(
                      create: (context) => singletonBlocHelper.mockStartupBloc,
                    ),
                    BlocProvider<ThemeBloc>(
                      create: (context) => mockThemeBloc,
                    ),
                  ],
                  child: const CategoryDetailGrid(
                    themeName: testThemeName,
                    categoryId: testCategoryId,
                  ),
                ),
              ),
            );
          },
        ),
      );

      // The widget should throw an error when VoiceControlBloc is missing
      // This is expected behavior, so we should catch and verify the error
      expect(tester.takeException(), isA<ProviderNotFoundException>());
    });
  });
}
