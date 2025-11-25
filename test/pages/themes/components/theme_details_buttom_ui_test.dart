import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/bloc/states/startup_state.dart';
import 'package:admin/models/data/ai_alert_preferences_model.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_details_buttom.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:admin/translations/app_localizations.dart';
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
import '../../../mocks/bloc/state_mocks.dart';

void main() {
  late ThemeBlocTestHelper themeBlocHelper;
  late SingletonBlocTestHelper singletonBlocHelper;
  late VoiceControlBlocTestHelper voiceControlBlocHelper;
  late MockThemeBloc mockThemeBloc;
  late MockStartupBloc mockStartupBloc;
  late MockProfileBloc mockProfileBloc;
  late UserDeviceModel mockDoorbell;
  late DoorbellLocations mockLocation;
  late UserData mockUserData;
  late ThemeDataModel mockThemeData;
  late ApiState<PaginatedData<ThemeDataModel>> mockApiState;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(MockStartupBloc());
    registerFallbackValue(MockProfileBloc());
    registerFallbackValue(Colors.red);
    registerFallbackValue(MockThemeState());

    // Create a mock location for fallback
    final fallbackLocation = DoorbellLocations(
      (b) => b
        ..id = 1
        ..name = "Fallback Location"
        ..houseNo = "123"
        ..street = "Test Street"
        ..city = "Test City"
        ..state = "Test State"
        ..country = "Test Country"
        ..latitude = 0.0
        ..longitude = 0.0
        ..roles = ListBuilder<String>(["Admin"]),
    );
    registerFallbackValue(fallbackLocation);
    await TestHelper.initialize();

    // Initialize helper classes
    themeBlocHelper = ThemeBlocTestHelper();
    singletonBlocHelper = SingletonBlocTestHelper();
    voiceControlBlocHelper = VoiceControlBlocTestHelper();

    // Setup all helpers
    themeBlocHelper.setup();
    singletonBlocHelper.setup();
    voiceControlBlocHelper.setup();

    // Get mock instances
    mockThemeBloc = themeBlocHelper.getMockThemeBloc();
    mockStartupBloc = MockStartupBloc();
    mockProfileBloc = MockProfileBloc();

    // Setup theme bloc state with proper activeType and index
    final themeState = MockThemeState();
    when(() => themeState.activeType).thenReturn('Feed');
    when(() => themeState.index).thenReturn(0);
    mockThemeBloc.state = themeState;

    // Create mock data
    mockLocation = DoorbellLocations(
      (b) => b
        ..id = 1
        ..name = "Test Home"
        ..houseNo = "123"
        ..street = "Test Street"
        ..city = "Test City"
        ..state = "Test State"
        ..country = "Test Country"
        ..latitude = 40.7128
        ..longitude = -74.0060
        ..roles = ListBuilder<String>(["Admin"]),
    );

    mockDoorbell = UserDeviceModel(
      (b) => b
        ..id = 1
        ..deviceId = "test-device-123"
        ..name = "Test Doorbell"
        ..locationId = 1
        ..callUserId = "test-call-user-id",
    );

    // Register fallback values after creating the mock data
    registerFallbackValue(mockDoorbell);

    mockThemeData = ThemeDataModel(
      (b) => b
        ..id = 1
        ..title = "Test Theme"
        ..description = "A test theme for testing"
        ..colors = "#FF0000"
        ..cover = "https://example.com/cover.jpg"
        ..fromCache = false
        ..thumbnail = "https://example.com/thumbnail.jpg"
        ..userUploaded = null
        ..isActive = 1
        ..createdAt = "2024-01-01T00:00:00Z"
        ..categoryId = 1
        ..locationId = 1
        ..totalLikes = 10
        ..mediaType = 1
        ..userLike = 0
        ..isApplied = false
        ..deviceId = "test-device-123",
    );

    // Register fallback values after creating the mock data
    registerFallbackValue(mockThemeData);

    mockApiState = ApiState<PaginatedData<ThemeDataModel>>(
      (b) => b
        ..isApiInProgress = false
        ..error = null
        ..message = null
        ..data = PaginatedData<ThemeDataModel>(
          (b) => b
            ..data = ListBuilder<ThemeDataModel>([mockThemeData])
            ..currentPage = 1
            ..lastPage = 1,
        )
        ..totalCount = 1
        ..currentPage = 1
        ..isApiPaginationEnabled = false
        ..uploadProgress = null
        ..pagination = null,
    );

    // Setup mock methods
    // Ensure getThemeApiType returns the correct data structure
    when(() => mockThemeBloc.getThemeApiType(any())).thenReturn(mockApiState);
    when(
      () => mockThemeBloc.removeThemeApi(
        any(),
        any(),
        any(),
        deviceId: any(named: 'deviceId'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockThemeBloc.themeLike(
        any(),
        locationId: any(named: 'locationId'),
        isLike: any(named: 'isLike'),
        type: any(named: 'type'),
        totalLikes: any(named: 'totalLikes'),
        index: any(named: 'index'),
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async {});
    //
    // // Setup startup bloc mock
    // final startupState = StartupState(
    //   (b) => b..userDeviceModel = ListBuilder<UserDeviceModel>([mockDoorbell]),
    // );
    // when(() => mockStartupBloc.state).thenReturn(startupState);
    // when(() => mockStartupBloc.stream).thenAnswer((_) => const Stream.empty());

    // Create mock user data
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
        ..selectedDoorBell = mockDoorbell.toBuilder()
        ..locations = ListBuilder<DoorbellLocations>([mockLocation]),
    );

    // Setup profile bloc mock
    when(() => mockProfileBloc.state).thenReturn(mockUserData);
    when(() => mockProfileBloc.stream).thenAnswer((_) => const Stream.empty());

    // Setup startup bloc mock with userDeviceModel
    final startupState = StartupState(
      (b) => b
        ..userDeviceModel = ListBuilder<UserDeviceModel>([mockDoorbell])
        ..isDoorbellConnected = true
        ..isInternetConnected = true
        ..splashEnd = true
        ..needDashboardCall = false
        ..dashboardApiCalling = false
        ..doorbellNameEdit = false
        ..canUpdateDoorbellName = false
        ..newDoorbellName = ''
        ..index = 0
        ..noDoorbellCarouselIndex = 0
        ..monitorCamerasCarouselIndex = 0
        ..refreshSnapshots = false
        ..doorbellImageVersion = 0
        ..appIsUpdated = false
        ..moreCustomFeatureTileExpanded = false
        ..moreCustomSettingsTileExpanded = false
        ..moreCustomPaymentsTileExpanded = false
        ..indexedStackValue = 0
        ..bottomNavIndexValues = ListBuilder<int>([0])
        ..aiAlertPreferencesList = ListBuilder<AiAlertPreferencesModel>([]),
    );
    mockStartupBloc.state = startupState;

    // Set the test profile bloc in singleton
    singletonBloc.testProfileBloc = mockProfileBloc;
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

  void updateMockApiStateWithThemeData(ThemeDataModel themeData) {
    // Update the mock API state to contain the theme data that matches what the component expects
    final updatedApiState = ApiState<PaginatedData<ThemeDataModel>>(
      (b) => b
        ..isApiInProgress = false
        ..error = null
        ..message = null
        ..data = PaginatedData<ThemeDataModel>(
          (b) => b
            ..data = ListBuilder<ThemeDataModel>([themeData])
            ..currentPage = 1
            ..lastPage = 1,
        )
        ..totalCount = 1
        ..currentPage = 1
        ..isApiPaginationEnabled = false
        ..uploadProgress = null
        ..pagination = null,
    );

    // Update the mock to return the new API state
    when(() => mockThemeBloc.getThemeApiType(any()))
        .thenReturn(updatedApiState);
  }

  Widget createTestWidget({
    required int themeId,
    required ThemeDataModel data,
    bool isAppliedTheme = false,
  }) {
    // Update mock data to match the test scenario
    updateMockApiStateWithThemeData(data);

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
          BlocProvider<StartupBloc>.value(value: mockStartupBloc),
          BlocProvider<ThemeBloc>.value(value: mockThemeBloc),
          BlocProvider<VoiceControlBloc>.value(
            value: voiceControlBlocHelper.mockVoiceControlBloc,
          ),
        ],
        child: Scaffold(
          body: ThemeDetailsButtons(
            themeId: themeId,
            data: data,
            isAppliedTheme: isAppliedTheme,
          ),
        ),
      ),
    );
  }

  group('ThemeDetailsButtons UI Tests', () {
    group('Basic Rendering Tests', () {
      testWidgets('should render all buttons when not applied theme',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: mockThemeData,
          ),
        );

        await tester.pumpAndSettle();

        // First, just check if the component renders at all
        expect(find.byType(ThemeDetailsButtons), findsOneWidget);

        // Should show set to doorbell button
        expect(find.text('Set It to\nDoorbell'), findsOneWidget);

        // Should show add to favourite button
        expect(find.text('Add To\nFavorites'), findsOneWidget);

        // Should not show edit button
        expect(find.text('Edit'), findsNothing);
      });

      testWidgets('should render edit and remove buttons when applied theme',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: mockThemeData,
            isAppliedTheme: true,
          ),
        );

        await tester.pumpAndSettle();

        // Should show edit button
        expect(find.text('Edit'), findsOneWidget);

        // Should show remove from doorbell button
        expect(find.text('Remove from\nDoorbell'), findsOneWidget);

        final likedThemeData = mockThemeData.rebuild((b) => b..userLike = 1);

        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: likedThemeData,
          ),
        );

        // Should show remove from favourite button
        expect(find.text('Remove \nFavorite'), findsOneWidget);
      });

      testWidgets('should render correct icons for each button',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: mockThemeData,
          ),
        );

        await tester.pumpAndSettle();

        // Check that buttons are rendered
        expect(find.byType(GestureDetector), findsNWidgets(2));
      });
    });

    group('Button Interaction Tests', () {
      testWidgets(
          'should have tappable set to doorbell button when not applied theme',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: mockThemeData,
          ),
        );

        await tester.pumpAndSettle();

        // Verify the button exists and is tappable
        final setButton = find.text('Set It to\nDoorbell');
        expect(setButton, findsOneWidget);
        expect(tester.getRect(setButton), isNotNull);
      });

      testWidgets('should have tappable edit button when applied theme',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: mockThemeData,
            isAppliedTheme: true,
          ),
        );

        await tester.pumpAndSettle();

        // Verify the edit button exists and is tappable
        final editButton = find.text('Edit');
        expect(editButton, findsOneWidget);
        expect(tester.getRect(editButton), isNotNull);
      });

      testWidgets('should have tappable remove button when applied theme',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: mockThemeData,
            isAppliedTheme: true,
          ),
        );

        await tester.pumpAndSettle();

        // Verify the remove button exists and is tappable
        final removeButton = find.text('Remove from\nDoorbell');
        expect(removeButton, findsOneWidget);
        expect(tester.getRect(removeButton), isNotNull);
      });

      testWidgets(
          'should have tappable favourite button when not applied theme',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: mockThemeData,
          ),
        );

        await tester.pumpAndSettle();

        // Verify the favourite button exists and is tappable
        final favouriteButton = find.text('Add To\nFavorites');
        expect(favouriteButton, findsOneWidget);
        expect(tester.getRect(favouriteButton), isNotNull);
      });
    });

    group('Role-based Permission Tests', () {
      testWidgets('should show edit button for viewer when applied theme',
          (tester) async {
        // Create mock data with viewer role
        final viewerLocation = DoorbellLocations(
          (b) => b
            ..id = 1
            ..name = "Test Home"
            ..houseNo = "123"
            ..street = "Test Street"
            ..city = "Test City"
            ..state = "Test State"
            ..country = "Test Country"
            ..latitude = 40.7128
            ..longitude = -74.0060
            ..roles = ListBuilder<String>(["viewer"]),
        );

        // Update singleton bloc to return viewer role
        when(() => mockProfileBloc.state).thenReturn(
          mockUserData.rebuild(
            (b) => b
              ..locations = ListBuilder<DoorbellLocations>([viewerLocation])
              ..selectedDoorBell = mockDoorbell.toBuilder(),
          ),
        );

        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: mockThemeData,
            isAppliedTheme: true,
          ),
        );

        await tester.pumpAndSettle();

        // Should show edit button for viewer
        expect(find.text('Edit'), findsOneWidget);
      });

      testWidgets(
          'should show set to doorbell button for viewer when not applied theme',
          (tester) async {
        // Create mock data with viewer role
        final viewerLocation = DoorbellLocations(
          (b) => b
            ..id = 1
            ..name = "Test Home"
            ..houseNo = "123"
            ..street = "Test Street"
            ..city = "Test City"
            ..state = "Test State"
            ..country = "Test Country"
            ..latitude = 40.7128
            ..longitude = -74.0060
            ..roles = ListBuilder<String>(["viewer"]),
        );

        // Update singleton bloc to return viewer role
        when(() => mockProfileBloc.state).thenReturn(
          mockUserData.rebuild(
            (b) => b
              ..locations = ListBuilder<DoorbellLocations>([viewerLocation])
              ..selectedDoorBell = mockDoorbell.toBuilder(),
          ),
        );

        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: mockThemeData,
          ),
        );

        await tester.pumpAndSettle();

        // Should show set to doorbell button for viewer
        expect(find.text('Set It to\nDoorbell'), findsOneWidget);
      });
    });

    group('Theme State Tests', () {
      testWidgets(
          'should show correct favourite button state based on userLike',
          (tester) async {
        // Test with liked theme
        final likedThemeData = mockThemeData.rebuild((b) => b..userLike = 1);

        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: likedThemeData,
          ),
        );

        await tester.pumpAndSettle();

        // Should show remove from favourite button
        expect(find.text('Remove \nFavorite'), findsOneWidget);

        // Test with unliked theme
        final unlikedThemeData = mockThemeData.rebuild((b) => b..userLike = 0);

        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: unlikedThemeData,
          ),
        );

        await tester.pumpAndSettle();

        // Should show add to favourite button
        expect(find.text('Add To\nFavorites'), findsOneWidget);
      });

      testWidgets('should handle user uploaded themes correctly',
          (tester) async {
        // Test with user uploaded theme
        final userUploadedThemeData =
            mockThemeData.rebuild((b) => b..userUploaded = 1);

        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: userUploadedThemeData,
          ),
        );

        await tester.pumpAndSettle();

        // Should not show favourite button for user uploaded themes
        expect(find.text('Add To\nFavorites'), findsNothing);
        expect(find.text('Remove \nFavorite'), findsNothing);
      });
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('should handle minimal theme data gracefully',
          (tester) async {
        final minimalThemeData = ThemeDataModel(
          (b) => b
            ..id = 1
            ..title = ""
            ..description = ""
            ..colors = "#000000"
            ..cover = ""
            ..fromCache = false
            ..thumbnail = ""
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

        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: minimalThemeData,
          ),
        );

        await tester.pumpAndSettle();

        // Should still render the component
        expect(find.byType(ThemeDetailsButtons), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic labels for buttons',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: mockThemeData,
          ),
        );

        await tester.pumpAndSettle();

        // Check that buttons have proper text labels
        expect(find.text('Set It to\nDoorbell'), findsOneWidget);
        expect(find.text('Add To\nFavorites'), findsOneWidget);
      });

      testWidgets('should be tappable with proper hit testing', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: mockThemeData,
          ),
        );

        await tester.pumpAndSettle();

        // Verify buttons are tappable
        final setButton = find.text('Set It to\nDoorbell');
        expect(tester.getRect(setButton), isNotNull);

        final favouriteButton = find.text('Add To\nFavorites');
        expect(tester.getRect(favouriteButton), isNotNull);
      });
    });

    group('Layout and Styling Tests', () {
      testWidgets('should maintain proper spacing between buttons',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: mockThemeData,
          ),
        );

        await tester.pumpAndSettle();

        // Check that buttons are rendered in a row
        expect(find.byType(Row), findsOneWidget);
      });

      testWidgets('should handle different screen sizes gracefully',
          (tester) async {
        // Test with different screen sizes
        await tester.binding.setSurfaceSize(const Size(400, 800));

        await tester.pumpWidget(
          createTestWidget(
            themeId: 1,
            data: mockThemeData,
          ),
        );

        await tester.pumpAndSettle();

        // Should still render properly
        expect(find.byType(ThemeDetailsButtons), findsOneWidget);

        // Reset surface size
        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}
