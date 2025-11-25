import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/theme.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/role_model.dart';
import 'package:admin/models/data/sub_user_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/locations/bloc/location_bloc.dart';
import 'package:admin/pages/main/locations/bloc/location_state.dart';
import 'package:admin/pages/main/locations/components/ownership_transfer_dialog.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_state.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/profile_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/user_profile_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';

class MockLocationBloc extends Mock implements LocationBloc {}

class MockLocationState extends Mock implements LocationState {}

class MockUserProfileBloc extends Mock implements UserProfileBloc {}

class MockUserProfileState extends Mock implements UserProfileState {}

class MockDoorbellLocations extends Mock implements DoorbellLocations {}

class MockSubUserModel extends Mock implements SubUserModel {}

class MockRoleModel extends Mock implements RoleModel {}

void main() {
  late StartupBlocTestHelper startupBlocHelper;
  late ProfileBlocTestHelper profileBlocHelper;
  late UserProfileBlocTestHelper userProfileBlocHelper;
  late MockLocationBloc mockLocationBloc;
  late MockLocationState mockLocationState;
  late MockUserProfileBloc mockUserProfileBloc;
  late MockUserProfileState mockUserProfileState;
  late MockDoorbellLocations mockLocation;
  late MockSubUserModel mockSubUser1;
  late MockRoleModel mockRole1;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    await TestHelper.initialize();

    // Initialize helper classes
    startupBlocHelper = StartupBlocTestHelper();
    profileBlocHelper = ProfileBlocTestHelper();
    userProfileBlocHelper = UserProfileBlocTestHelper();

    // Setup all helpers
    startupBlocHelper.setup();
    profileBlocHelper.setup();
    userProfileBlocHelper.setup();

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
    userProfileBlocHelper.dispose();
  });

  tearDown(() async {
    // Clean up any pending timers and animations
    await Future.delayed(const Duration(milliseconds: 100));
  });

  void setupMocks() {
    // Setup LocationBloc mocks
    mockLocationBloc = MockLocationBloc();
    mockLocationState = MockLocationState();
    mockUserProfileBloc = MockUserProfileBloc();
    mockUserProfileState = MockUserProfileState();
    mockLocation = MockDoorbellLocations();
    mockSubUser1 = MockSubUserModel();
    mockRole1 = MockRoleModel();

    // Setup location mock
    when(() => mockLocation.id).thenReturn(1);
    when(() => mockLocation.ownerId).thenReturn(100);

    // Setup role mock
    when(() => mockRole1.id).thenReturn(1); // Owner

    // Setup sub user mock
    when(() => mockSubUser1.id).thenReturn(101);
    when(() => mockSubUser1.name).thenReturn("John Doe");
    when(() => mockSubUser1.role).thenReturn(mockRole1);

    // Setup location state mocks with at least one sub user
    when(() => mockLocationState.locationSubUsersList)
        .thenReturn(BuiltList([mockSubUser1]));
    when(() => mockLocationState.selectedOwnershipUser)
        .thenReturn(mockSubUser1);

    // Setup location bloc mocks
    when(() => mockLocationBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockLocationBloc.state).thenReturn(mockLocationState);
    when(() => mockLocationBloc.updateSelectedOwnershipUser(any()))
        .thenReturn(null);

    // Setup user profile bloc mocks with proper state
    when(() => mockUserProfileBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockUserProfileBloc.state).thenReturn(mockUserProfileState);

    // Mock all required UserProfileState properties to prevent null errors
    when(() => mockUserProfileState.isProfileEditing).thenReturn(false);
    when(() => mockUserProfileState.fromGallery).thenReturn(null);
    when(() => mockUserProfileState.clearOtp).thenReturn(false);
    when(() => mockUserProfileState.otpError).thenReturn("");
    when(() => mockUserProfileState.countryCode).thenReturn("");
    when(() => mockUserProfileState.userPassword).thenReturn("");
    when(() => mockUserProfileState.validatePassword).thenReturn("");
    when(() => mockUserProfileState.obscurePassword).thenReturn(true);
    when(() => mockUserProfileState.resendOtp).thenReturn(false);
    when(() => mockUserProfileState.otp).thenReturn(null);
    when(() => mockUserProfileState.remainingSeconds).thenReturn(60);
    when(() => mockUserProfileState.editName).thenReturn("");
    when(() => mockUserProfileState.editEmail).thenReturn("");
    when(() => mockUserProfileState.editPhoneNumber).thenReturn("");
    when(() => mockUserProfileState.editImage).thenReturn(null);
    when(() => mockUserProfileState.editImageStr).thenReturn(null);
    when(() => mockUserProfileState.nameErrorMessage).thenReturn("");
    when(() => mockUserProfileState.emailErrorMessage).thenReturn("");
    when(() => mockUserProfileState.phoneErrorMessage).thenReturn("");
    when(() => mockUserProfileState.passwordErrorMessage).thenReturn("");
    when(() => mockUserProfileState.updateProfileButtonEnabled)
        .thenReturn(false);
    when(() => mockUserProfileState.confirmButtonEnabled).thenReturn(false);
    when(() => mockUserProfileState.updateProfileApi)
        .thenReturn(ApiState<void>());
    when(() => mockUserProfileState.callOtpApi).thenReturn(ApiState<void>());
    when(() => mockUserProfileState.validatePasswordApi)
        .thenReturn(ApiState<void>());

    // Setup startup bloc mocks for navigation
    when(() => startupBlocHelper.mockStartupBloc.clearPageIndexes())
        .thenReturn(null);
    when(
      () => startupBlocHelper.mockStartupBloc.updateDashboardApiCalling(any()),
    ).thenReturn(null);
    when(
      () => startupBlocHelper.mockStartupBloc
          .callEverything(id: any(named: 'id')),
    ).thenAnswer((_) async {});
  }

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
            home: Builder(
              builder: (context) => OwnershipTransferDialog(
                location: mockLocation,
                parentContext: context,
              ),
            ),
          ),
        );
      },
    );
  }

  group('OwnershipTransferDialog UI Tests', () {
    setUp(setupMocks);

    testWidgets('should render dialog with correct title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Select User Role'), findsOneWidget);
    });

    testWidgets('should render proceed button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Proceed'), findsOneWidget);
    });

    testWidgets('should render cancel button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should close dialog when cancel button is tapped',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final cancelButton = find.text('Cancel');
      expect(cancelButton, findsOneWidget);

      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.byType(OwnershipTransferDialog), findsNothing);
    });

    testWidgets('should handle different screen sizes with FlutterSizer',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify that FlutterSizer is used for responsive design
      expect(find.byType(FlutterSizer), findsOneWidget);
    });

    testWidgets('should maintain proper dialog structure', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check if the dialog has proper structure
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should handle API states gracefully', (tester) async {
      // Setup API loading state
      when(() => mockLocationState.transferOwnershipApi)
          .thenReturn(ApiState<void>((b) => b..isApiInProgress = true));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Dialog should still render
      expect(find.byType(OwnershipTransferDialog), findsOneWidget);
    });

    testWidgets('should display user information correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should display the user name
      expect(find.textContaining('John Doe'), findsOneWidget);
    });

    testWidgets('should handle proceed button tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final proceedButton = find.text('Proceed');
      expect(proceedButton, findsOneWidget);

      // Tap proceed button - this should close the dialog
      await tester.tap(proceedButton);
      await tester.pumpAndSettle();

      // Original dialog should be closed
      expect(find.byType(OwnershipTransferDialog), findsNothing);
    });
  });
}
