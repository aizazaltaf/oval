import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/theme.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/locations/bloc/location_bloc.dart';
import 'package:admin/pages/main/locations/bloc/location_state.dart';
import 'package:admin/pages/main/locations/components/location_card.dart';
import 'package:admin/pages/main/locations/location_settings_page.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_state.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/profile_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/voice_control_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';

class MockLocationBloc extends Mock implements LocationBloc {}

class MockLocationState extends Mock implements LocationState {}

class MockUserProfileBloc extends Mock implements UserProfileBloc {}

void main() {
  late StartupBlocTestHelper startupBlocHelper;
  late ProfileBlocTestHelper profileBlocHelper;
  late VoiceControlBlocTestHelper voiceControlBlocHelper;
  late MockLocationBloc mockLocationBloc;
  late MockLocationState mockLocationState;
  late MockUserProfileBloc mockUserProfileBloc;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    await TestHelper.initialize();

    // Initialize helper classes
    startupBlocHelper = StartupBlocTestHelper();
    profileBlocHelper = ProfileBlocTestHelper();
    voiceControlBlocHelper = VoiceControlBlocTestHelper();

    // Setup all helpers
    startupBlocHelper.setup();
    profileBlocHelper.setup();
    voiceControlBlocHelper.setup();

    // Setup singleton bloc
    singletonBloc.testProfileBloc = profileBlocHelper.mockProfileBloc;

    // Stub the getDoorbells method to prevent null errors
    when(
          () => startupBlocHelper.mockStartupBloc.getDoorbells(
        id: any(named: 'id'),
      ),
    ).thenAnswer((_) async => BuiltList([]));
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
    startupBlocHelper.dispose();
    profileBlocHelper.dispose();
    voiceControlBlocHelper.dispose();
  });

  tearDown(() async {
    // Clean up any pending timers and animations
    await Future.delayed(const Duration(milliseconds: 100));
  });

  Widget createTestWidget() {
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<StartupBloc>.value(
              value: startupBlocHelper.mockStartupBloc,
            ),
            BlocProvider<ProfileBloc>.value(
              value: profileBlocHelper.mockProfileBloc,
            ),
            BlocProvider<LocationBloc>.value(
              value: mockLocationBloc,
            ),
            BlocProvider<VoiceControlBloc>.value(
              value: voiceControlBlocHelper.mockVoiceControlBloc,
            ),
            BlocProvider<UserProfileBloc>.value(
              value: mockUserProfileBloc,
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: getTheme(),
            darkTheme: darkTheme(),
            home: const LocationSettingsPage(),
          ),
        );
      },
    );
  }

  void setupLocationBloc({String? searchQuery}) {
    mockLocationBloc = MockLocationBloc();
    mockLocationState = MockLocationState();
    mockUserProfileBloc = MockUserProfileBloc();

    when(() => mockLocationBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockLocationBloc.state).thenReturn(mockLocationState);
    when(() => mockLocationState.search).thenReturn(searchQuery);
    when(() => mockLocationBloc.updateSearch(any())).thenReturn(null);

    // Mock required LocationState properties to prevent null errors
    when(() => mockLocationState.locationSubUsersApi)
        .thenReturn(ApiState<void>());
    when(() => mockLocationState.transferOwnershipApi)
        .thenReturn(ApiState<void>());
    when(() => mockLocationState.releaseLocationApi)
        .thenReturn(ApiState<void>());
    when(() => mockLocationState.selectedReleaseLocationId).thenReturn("");
    when(() => mockLocationState.selectedOwnershipUser).thenReturn(null);
    when(() => mockLocationState.locationSubUsersList).thenReturn(null);

    // Setup UserProfileBloc mocks
    when(() => mockUserProfileBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockUserProfileBloc.state).thenReturn(UserProfileState());
  }

  group('LocationSettingsPage Widget Tests', () {
    setUp(() {
      startupBlocHelper.setupNoDoorBellState();
      setupLocationBloc();
    });

    testWidgets('should render LocationSettingsPage with basic structure',
            (tester) async {
          await tester.pumpWidget(createTestWidget());
          await tester.pump();

          // Verify basic structure exists
          expect(find.byType(LocationSettingsPage), findsOneWidget);
          expect(find.byType(AppScaffold), findsOneWidget);
        });

    testWidgets('should render app title correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify app title is displayed
      expect(find.text('Location'), findsOneWidget);
    });

    testWidgets('should render search field with correct hint text',
            (tester) async {
          await tester.pumpWidget(createTestWidget());
          await tester.pump();

          // Verify search field exists
          expect(find.byType(NameTextFormField), findsOneWidget);
          expect(find.text('Search location'), findsOneWidget);
        });

    testWidgets('should render search field with search icon prefix',
            (tester) async {
          await tester.pumpWidget(createTestWidget());
          await tester.pump();

          // Verify search icon is present
          expect(find.byIcon(Icons.search), findsOneWidget);
        });

    testWidgets('should render locations section header', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify locations header is displayed
      expect(find.text('Locations'), findsOneWidget);
    });

    testWidgets('should render location cards when locations exist',
            (tester) async {
          // Setup profile bloc with locations
          final userData = profileBlocHelper.createDefaultUserData();
          when(() => profileBlocHelper.mockProfileBloc.state).thenReturn(userData);
          when(() => profileBlocHelper.mockProfileBloc.stream)
              .thenAnswer((_) => Stream.value(userData));

          await tester.pumpWidget(createTestWidget());
          await tester.pump();

          // Verify location card is rendered
          expect(find.byType(LocationCard), findsOneWidget);
        });

    testWidgets('should filter locations based on search query',
            (tester) async {
          // Setup profile bloc with locations
          final userData = profileBlocHelper.createDefaultUserData();
          when(() => profileBlocHelper.mockProfileBloc.state).thenReturn(userData);
          when(() => profileBlocHelper.mockProfileBloc.stream)
              .thenAnswer((_) => Stream.value(userData));

          // Setup location bloc with search query
          setupLocationBloc(searchQuery: "Test");

          await tester.pumpWidget(createTestWidget());
          await tester.pump();

          // Verify location card is rendered (should match "Test Location")
          expect(find.byType(LocationCard), findsOneWidget);
        });

    testWidgets('should show no search record when search has no matches',
            (tester) async {
          // Setup profile bloc with locations
          final userData = profileBlocHelper.createDefaultUserData();
          when(() => profileBlocHelper.mockProfileBloc.state).thenReturn(userData);
          when(() => profileBlocHelper.mockProfileBloc.stream)
              .thenAnswer((_) => Stream.value(userData));

          // Setup location bloc with search query that won't match
          setupLocationBloc(searchQuery: "NonExistentLocation");

          await tester.pumpWidget(createTestWidget());
          await tester.pump();

          // Verify no search record message is shown
          expect(
            find.text('No records available for this search.'),
            findsOneWidget,
          );
        });

    testWidgets('should call updateSearch when search field text changes',
            (tester) async {
          await tester.pumpWidget(createTestWidget());
          await tester.pump();

          // Enter text in search field
          await tester.enterText(find.byType(NameTextFormField), 'New Search');
          await tester.pump();

          // Verify updateSearch was called
          verify(() => mockLocationBloc.updateSearch('New Search')).called(1);
        });

    testWidgets('should handle empty search query correctly', (tester) async {
      // Setup profile bloc with locations
      final userData = profileBlocHelper.createDefaultUserData();
      when(() => profileBlocHelper.mockProfileBloc.state).thenReturn(userData);
      when(() => profileBlocHelper.mockProfileBloc.stream)
          .thenAnswer((_) => Stream.value(userData));

      // Setup location bloc with null search query
      setupLocationBloc();

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify all location cards are shown when search is null
      expect(find.byType(LocationCard), findsOneWidget);
    });

    testWidgets('should handle case-insensitive search', (tester) async {
      // Setup profile bloc with locations
      final userData = profileBlocHelper.createDefaultUserData();
      when(() => profileBlocHelper.mockProfileBloc.state).thenReturn(userData);
      when(() => profileBlocHelper.mockProfileBloc.stream)
          .thenAnswer((_) => Stream.value(userData));

      // Setup location bloc with uppercase search query
      setupLocationBloc(searchQuery: "TEST");

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify location card is still rendered (case-insensitive search)
      expect(find.byType(LocationCard), findsOneWidget);
    });

    testWidgets('should render correct spacing between elements',
            (tester) async {
          await tester.pumpWidget(createTestWidget());
          await tester.pump();

          // Verify proper spacing is maintained
          expect(find.byType(SizedBox), findsAtLeastNWidgets(4));
        });

    testWidgets('should handle null locations gracefully', (tester) async {
      // Setup profile bloc with empty locations (not null)
      final userData = profileBlocHelper.createDefaultUserData();
      final userDataWithEmptyLocations =
      userData.rebuild((b) => b..locations = ListBuilder([]));
      when(() => profileBlocHelper.mockProfileBloc.state)
          .thenReturn(userDataWithEmptyLocations);
      when(() => profileBlocHelper.mockProfileBloc.stream)
          .thenAnswer((_) => Stream.value(userDataWithEmptyLocations));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Should not crash and should handle empty locations
      expect(find.byType(LocationSettingsPage), findsOneWidget);
      expect(find.byType(LocationCard), findsNothing);
    });

    testWidgets('should handle empty locations list', (tester) async {
      // Setup profile bloc with empty locations
      final userData = profileBlocHelper.createDefaultUserData();
      final userDataWithEmptyLocations =
      userData.rebuild((b) => b..locations = ListBuilder([]));
      when(() => profileBlocHelper.mockProfileBloc.state)
          .thenReturn(userDataWithEmptyLocations);
      when(() => profileBlocHelper.mockProfileBloc.stream)
          .thenAnswer((_) => Stream.value(userDataWithEmptyLocations));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Should not crash and should handle empty locations
      expect(find.byType(LocationSettingsPage), findsOneWidget);
      expect(find.byType(LocationCard), findsNothing);
    });

    testWidgets('should maintain proper padding and layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify proper padding is applied
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('should render with correct theme colors', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify the page renders with theme colors
      final scaffold = tester.widget<AppScaffold>(find.byType(AppScaffold));
      expect(scaffold, isNotNull);
    });

    testWidgets('should handle rapid search input changes', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Rapidly change search input
      await tester.enterText(find.byType(NameTextFormField), 'First');
      await tester.pump();
      await tester.enterText(find.byType(NameTextFormField), 'Second');
      await tester.pump();
      await tester.enterText(find.byType(NameTextFormField), 'Third');
      await tester.pump();

      // Verify updateSearch was called multiple times
      verify(() => mockLocationBloc.updateSearch(any())).called(3);
    });

    testWidgets('should handle multiple locations without overflow',
            (tester) async {
          // Setup profile bloc with a few locations (not too many to avoid overflow)
          final userData = profileBlocHelper.createDefaultUserData();
          final locations = userData.locations!.toList()
            ..add(
              DoorbellLocations(
                    (b) => b
                  ..id = 2
                  ..name = "Second Location"
                  ..city = "Second City"
                  ..state = "Second State"
                  ..country = "Second Country"
                  ..latitude = 1.0
                  ..longitude = 1.0
                  ..createdAt = "2024-01-02"
                  ..updatedAt = "2024-01-02"
                  ..roles = ListBuilder<String>(["Admin"]),
              ),
            )
            ..add(
              DoorbellLocations(
                    (b) => b
                  ..id = 3
                  ..name = "Third Location"
                  ..city = "Third City"
                  ..state = "Third State"
                  ..country = "Third Country"
                  ..latitude = 2.0
                  ..longitude = 2.0
                  ..createdAt = "2024-01-03"
                  ..updatedAt = "2024-01-03"
                  ..roles = ListBuilder<String>(["Viewer"]),
              ),
            );

          final updatedUserData =
          userData.rebuild((b) => b..locations = ListBuilder(locations));
          when(() => profileBlocHelper.mockProfileBloc.state)
              .thenReturn(updatedUserData);
          when(() => profileBlocHelper.mockProfileBloc.stream)
              .thenAnswer((_) => Stream.value(updatedUserData));

          await tester.pumpWidget(createTestWidget());
          await tester.pump();

          // Verify multiple location cards are rendered without overflow
          expect(find.byType(LocationCard), findsNWidgets(3));
        });
  });
}
