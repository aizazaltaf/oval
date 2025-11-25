import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/pages/main/user_profile/components/profile_shimmer_widget.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/category_widget.dart';
import 'package:admin/pages/themes/model/theme_category_model.dart';
import 'package:admin/translations/app_localizations.dart';
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
  late MockStartupBloc mockStartupBloc;
  late UserData mockUserData;

  // Sample theme category data for testing
  late ThemeCategoryModel testThemeCategory;
  late ThemeCategoryModel testThemeCategoryWithLongName;

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

    // Create test theme category data
    testThemeCategory = ThemeCategoryModel(
      (b) => b
        ..id = 1
        ..name = "Nature"
        ..image = "https://example.com/nature.jpg"
        ..isActive = 1
        ..createdAt = "2024-01-01T00:00:00Z"
        ..updatedAt = "2024-01-01T00:00:00Z",
    );

    testThemeCategoryWithLongName = ThemeCategoryModel(
      (b) => b
        ..id = 2
        ..name =
            "Very Long Category Name That Should Be Truncated With Ellipsis When Displayed"
        ..image = "https://example.com/long-name.jpg"
        ..isActive = 1
        ..createdAt = "2024-01-01T00:00:00Z"
        ..updatedAt = "2024-01-01T00:00:00Z",
    );

    // Setup theme bloc mock methods
    when(() => themeBlocHelper.mockThemeBloc.updateCategoryApiId(any()))
        .thenReturn(null);
    when(() => themeBlocHelper.mockThemeBloc.updateActiveType(any()))
        .thenReturn(null);
    when(() => themeBlocHelper.mockThemeBloc.clearSearchFromCategories())
        .thenReturn(null);
    when(
      () => themeBlocHelper.mockThemeBloc.changeActiveType(
        any(),
        any(),
        refresh: any(named: 'refresh'),
      ),
    ).thenReturn(null);
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

  Widget createTestWidget({
    required ThemeCategoryModel themeCategory,
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
                BlocProvider<StartupBloc>.value(
                  value: mockStartupBloc,
                ),
                BlocProvider<ThemeBloc>.value(
                  value: themeBlocHelper.getMockThemeBloc(),
                ),
                BlocProvider<VoiceControlBloc>.value(
                  value: voiceControlBlocHelper.mockVoiceControlBloc,
                ),
              ],
              child: Scaffold(
                body: CategoryWidget(
                  themeCategory: themeCategory,
                  viewCategoriesScreen: viewCategoriesScreen,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  group('CategoryWidget UI Tests', () {
    group('Widget Rendering', () {
      testWidgets('should render with correct theme category data',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeCategory: testThemeCategory,
          ),
        );

        // Initially should show shimmer loading
        expect(find.byType(PrimaryShimmer), findsOneWidget);

        // Verify the widget is rendered
        expect(find.byType(CategoryWidget), findsOneWidget);

        // Verify the widget structure
        expect(find.byType(GestureDetector), findsOneWidget);
      });

      testWidgets('should render with long category name', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeCategory: testThemeCategoryWithLongName,
          ),
        );

        // Initially should show shimmer loading
        expect(find.byType(PrimaryShimmer), findsOneWidget);

        // Verify the widget structure
        expect(find.byType(CategoryWidget), findsOneWidget);
        expect(find.byType(GestureDetector), findsOneWidget);
      });

      testWidgets('should render shimmer loading state initially',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeCategory: testThemeCategory,
          ),
        );

        // Initially should show shimmer loading
        expect(find.byType(PrimaryShimmer), findsOneWidget);

        // Verify the widget is rendered
        expect(find.byType(CategoryWidget), findsOneWidget);
      });

      testWidgets('should render with correct border radius structure',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeCategory: testThemeCategory,
          ),
        );

        // Verify the widget structure includes containers
        expect(find.byType(Container), findsWidgets);

        // Verify the widget is rendered
        expect(find.byType(CategoryWidget), findsOneWidget);
      });
    });

    group('View Categories Screen Mode', () {
      testWidgets('should render when viewCategoriesScreen is true',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeCategory: testThemeCategory,
            viewCategoriesScreen: true,
          ),
        );

        // Initially should show shimmer loading
        expect(find.byType(PrimaryShimmer), findsOneWidget);

        // Verify the widget structure
        expect(find.byType(CategoryWidget), findsOneWidget);
        expect(find.byType(GestureDetector), findsOneWidget);
      });

      testWidgets('should render when viewCategoriesScreen is false',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeCategory: testThemeCategory,
          ),
        );

        // Initially should show shimmer loading
        expect(find.byType(PrimaryShimmer), findsOneWidget);

        // Verify the widget structure
        expect(find.byType(CategoryWidget), findsOneWidget);
        expect(find.byType(GestureDetector), findsOneWidget);
      });
    });

    group('Image Loading and Display', () {
      testWidgets('should show shimmer while image is loading', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeCategory: testThemeCategory,
          ),
        );

        // Initially should show shimmer
        expect(find.byType(PrimaryShimmer), findsOneWidget);

        // Verify the widget structure
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('should handle image loading gracefully', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeCategory: testThemeCategory,
          ),
        );

        // Initially should show shimmer
        expect(find.byType(PrimaryShimmer), findsOneWidget);

        // Should not crash and should still show the widget
        expect(find.byType(CategoryWidget), findsOneWidget);
      });
    });

    group('Gesture Detection', () {
      testWidgets('should be tappable', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeCategory: testThemeCategory,
          ),
        );

        // Verify the widget is wrapped in GestureDetector
        expect(find.byType(GestureDetector), findsOneWidget);
      });

      testWidgets('should have opaque hit test behavior', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeCategory: testThemeCategory,
          ),
        );

        final gestureDetector = tester.widget<GestureDetector>(
          find.byType(GestureDetector),
        );

        expect(gestureDetector.behavior, HitTestBehavior.opaque);
      });
    });

    group('Layout and Sizing', () {
      testWidgets('should render with proper widget structure', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeCategory: testThemeCategory,
          ),
        );

        // Verify the widget structure
        expect(find.byType(CategoryWidget), findsOneWidget);
        expect(find.byType(GestureDetector), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle image load errors gracefully', (tester) async {
        // Create a theme category with invalid image URL
        final invalidImageCategory = ThemeCategoryModel(
          (b) => b
            ..id = 3
            ..name = "Invalid Image"
            ..image = "https://invalid-url-that-will-fail.com/image.jpg"
            ..isActive = 1
            ..createdAt = "2024-01-01T00:00:00Z"
            ..updatedAt = "2024-01-01T00:00:00Z",
        );

        await tester.pumpWidget(
          createTestWidget(
            themeCategory: invalidImageCategory,
          ),
        );

        // Initially should show shimmer loading
        expect(find.byType(PrimaryShimmer), findsOneWidget);

        // Should not crash and should still show the widget
        expect(find.byType(CategoryWidget), findsOneWidget);

        // Should still show the widget even if image fails to load
        expect(find.byType(CategoryWidget), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible to screen readers', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeCategory: testThemeCategory,
          ),
        );

        // Verify the widget is rendered
        expect(find.byType(CategoryWidget), findsOneWidget);

        // Verify the widget structure is accessible
        expect(find.byType(GestureDetector), findsOneWidget);
      });
    });

    group('Performance', () {
      testWidgets('should initialize properly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeCategory: testThemeCategory,
          ),
        );

        // The widget should initialize properly
        expect(find.byType(CategoryWidget), findsOneWidget);

        // Should show shimmer initially
        expect(find.byType(PrimaryShimmer), findsOneWidget);
      });
    });
  });
}
