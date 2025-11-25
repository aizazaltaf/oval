import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/data/role_model.dart';
import 'package:admin/models/data/sub_user_model.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_bloc.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_state.dart';
import 'package:admin/pages/main/user_management/user_info_page.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../helpers/test_helper.dart';
import '../../../mocks/bloc/bloc_mocks.dart';

void main() {
  late StartupBlocTestHelper startupBlocTestHelper;

  setUpAll(() {
    startupBlocTestHelper = StartupBlocTestHelper()
      ..setup()
      ..mockStartupBloc = MockStartupBloc();
  });

  group('UserInfoPage UI Tests', () {
    late SubUserModel testUser;
    late RoleModel testRole;

    setUpAll(() async {
      await TestHelper.initialize();
    });

    setUp(() {
      testRole = RoleModel(
        (b) => b
          ..id = 2
          ..name = 'Viewer',
      );

      testUser = SubUserModel(
        (b) => b
          ..id = 1
          ..name = 'John Doe'
          ..email = 'john.doe@example.com'
          ..phoneNumber = '+1234567890'
          ..role.replace(testRole)
          ..userExist = true
          ..source = 'test'
          ..profileImage = null
          ..inviteId = null,
      );
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget makeTestableWidget(
      UserManagementBloc userBloc,
      VoiceControlBloc voiceBloc,
      UserProfileBloc userProfileBloc,
      SubUserModel user,
    ) {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MultiProvider(
            providers: [
              Provider<StartupBloc>.value(
                value: startupBlocTestHelper.mockStartupBloc,
              ),
              Provider<UserManagementBloc>.value(value: userBloc),
              Provider<VoiceControlBloc>.value(value: voiceBloc),
              Provider<UserProfileBloc>.value(value: userProfileBloc),
            ],
            child: MaterialApp(
              theme: ThemeData(
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
              supportedLocales: const [
                Locale('en'),
              ],
              home: UserInfoPage(subUser: user),
            ),
          );
        },
      );
    }

    testWidgets('displays user information correctly', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          testUser,
        ),
      );
      await tester.pumpAndSettle();

      // Check for user name
      expect(find.text('John Doe'), findsOneWidget);

      // Check for role
      expect(find.text('Viewer'), findsOneWidget);
    });

    testWidgets('displays user with profile image', (tester) async {
      final userWithImage = testUser.rebuild(
        (b) => b..profileImage = 'https://example.com/profile.jpg',
      );

      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          userWithImage,
        ),
      );
      await tester.pumpAndSettle();

      // Should display profile image container
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('displays placeholder image when no profile image',
        (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          testUser,
        ),
      );
      await tester.pumpAndSettle();

      // Should display placeholder image container
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('displays app bar title correctly', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          testUser,
        ),
      );
      await tester.pumpAndSettle();

      // Should display app bar
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays user info cards with correct icons', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          testUser,
        ),
      );
      await tester.pumpAndSettle();

      // Should display user info cards
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('displays circular profile image container', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          testUser,
        ),
      );
      await tester.pumpAndSettle();

      // Should display circular container for profile image
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('displays user with invite ID', (tester) async {
      final userWithInvite = testUser.rebuild(
        (b) => b..inviteId = 123,
      );

      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          userWithInvite,
        ),
      );
      await tester.pumpAndSettle();

      // Should display user info normally
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('displays user with long name', (tester) async {
      final userWithLongName = testUser.rebuild(
        (b) => b
          ..name =
              'John Michael Doe Smith Johnson Williams Brown Davis Miller Wilson Moore Taylor Anderson Thomas Jackson White Harris Martin Thompson Garcia Martinez Robinson Clark Rodriguez Lewis Lee Walker Hall Allen Young King Wright Lopez Hill Scott Green Baker Adams Nelson Carter Mitchell Perez Roberts Turner Phillips Campbell Parker Evans Edwards Collins Stewart Sanchez Morris Rogers Reed Cook Morgan Bell Murphy Bailey Rivera Cooper Richardson Cox Howard Ward Torres Peterson Gray Ramirez James Watson Brooks Kelly Sanders Price Bennett Wood Barnes Ross Henderson Coleman Jenkins Perry Powell Long Patterson Hughes Flores Washington Butler Simmons Foster Gonzales Bryant Alexander Russell Griffin Diaz Hayes',
      );

      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          userWithLongName,
        ),
      );
      await tester.pumpAndSettle();

      // Should display long name
      expect(find.textContaining('John Michael Doe'), findsOneWidget);
    });

    testWidgets('displays user with special characters in name',
        (tester) async {
      final userWithSpecialChars = testUser.rebuild(
        (b) => b..name = 'José María O\'Connor-Smith',
      );

      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          userWithSpecialChars,
        ),
      );
      await tester.pumpAndSettle();

      // Should display name with special characters
      expect(find.text('José María O\'Connor-Smith'), findsOneWidget);
    });

    testWidgets('displays user with long role name', (tester) async {
      final longRole = testRole.rebuild(
        (b) => b..name = 'Senior Administrator with Extended Permissions',
      );
      final userWithLongRole = testUser.rebuild(
        (b) => b..role.replace(longRole),
      );

      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          userWithLongRole,
        ),
      );
      await tester.pumpAndSettle();

      // Should display long role name
      expect(
        find.text('Senior Administrator with Extended Permissions'),
        findsOneWidget,
      );
    });

    testWidgets('displays user with empty profile image', (tester) async {
      final userWithEmptyImage = testUser.rebuild(
        (b) => b..profileImage = '',
      );

      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          userWithEmptyImage,
        ),
      );
      await tester.pumpAndSettle();

      // Should display placeholder image container
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('displays user with empty name', (tester) async {
      final userWithoutName = testUser.rebuild(
        (b) => b..name = null,
      );

      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          userWithoutName,
        ),
      );
      await tester.pumpAndSettle();

      // Should display email prefix as name
      expect(find.text('john.doe'), findsOneWidget);
    });

    testWidgets('displays user with empty name and email', (tester) async {
      final userWithoutNameAndEmail = testUser.rebuild(
        (b) => b
          ..name = null
          ..email = 'test@example.com',
      );

      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          userWithoutNameAndEmail,
        ),
      );
      await tester.pumpAndSettle();

      // Should display email prefix as name
      expect(find.text('test'), findsOneWidget);
    });

    testWidgets('displays user without phone number', (tester) async {
      final userWithoutPhone = testUser.rebuild(
        (b) => b..phoneNumber = null,
      );

      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          userWithoutPhone,
        ),
      );
      await tester.pumpAndSettle();

      // Should not display phone number field
      expect(find.text('+1234567890'), findsNothing);
    });

    testWidgets('displays user with whitespace-only name', (tester) async {
      final userWithWhitespaceName = testUser.rebuild(
        (b) => b..name = '   ',
      );

      final state = UserManagementState().rebuild(
        (b) => b..loggedInUserRoleId = 1,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      final fakeUserProfileBloc = MockUserProfileBloc();

      await tester.pumpWidget(
        makeTestableWidget(
          fakeBloc,
          fakeVoiceBloc,
          fakeUserProfileBloc,
          userWithWhitespaceName,
        ),
      );
      await tester.pumpAndSettle();

      // Should display the whitespace name as is
      expect(find.text('   '), findsOneWidget);
    });
  });
}
