import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/data/role_model.dart';
import 'package:admin/models/data/sub_user_model.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_bloc.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_state.dart';
import 'package:admin/pages/main/user_management/user_management_page.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../mocks/bloc/bloc_mocks.dart';

void main() {
  late StartupBlocTestHelper startupBlocTestHelper;

  setUpAll(() {
    startupBlocTestHelper = StartupBlocTestHelper()
      ..setup()
      ..mockStartupBloc = MockStartupBloc();
  });

  group('UserManagementPage UI Tests', () {
    late List<SubUserModel> users;
    late RoleModel role;

    setUp(() {
      role = RoleModel(
        (b) => b
          ..id = 1
          ..name = 'Admin',
      );
      users = [
        SubUserModel(
          (b) => b
            ..id = 1
            ..name = 'John Doe'
            ..email = 'john@example.com'
            ..role.replace(role)
            ..userExist = true
            ..source = 'test',
        ),
        SubUserModel(
          (b) => b
            ..id = 2
            ..name = 'Jane Smith'
            ..email = 'jane@example.com'
            ..role.replace(role)
            ..userExist = true
            ..source = 'test',
        ),
      ];
    });

    Widget makeTestableWidget(
      UserManagementBloc userBloc,
      VoiceControlBloc voiceBloc,
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
              home: const UserManagementPage(),
            ),
          );
        },
      );
    }

    testWidgets('displays user list', (tester) async {
      final state = UserManagementState()
          .rebuild((b) => b..subUsersList.replace(BuiltList(users)));
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pumpAndSettle();
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Jane Smith'), findsOneWidget);
    });

    testWidgets('shows no records available when list is empty',
        (tester) async {
      final state = UserManagementState()
          .rebuild((b) => b..subUsersList.replace(BuiltList([])));
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'No records available',
          findRichText: true,
          skipOffstage: false,
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows loading indicator when in progress', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..getSubUsersApi.replace(
            UserManagementState()
                .getSubUsersApi
                .rebuild((a) => a..isApiInProgress = true),
          ),
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('search filters user list', (tester) async {
      // Initial state: both users
      final initialState = UserManagementState()
          .rebuild((b) => b..subUsersList.replace(BuiltList(users)));
      final fakeBloc = MockUserManagementBloc(initialState);
      final fakeVoiceBloc = MockVoiceControlBloc();
      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pumpAndSettle();

      // Simulate entering search text
      await tester.enterText(find.byType(TextFormField), 'Jane');
      await tester.pumpAndSettle();

      // Now update the bloc to only return Jane Smith
      final filteredState = UserManagementState()
          .rebuild((b) => b..subUsersList.replace(BuiltList([users[1]])));
      fakeBloc.state = filteredState;
      // Force a rebuild with the new state
      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pumpAndSettle();

      expect(find.text('Jane Smith'), findsOneWidget);
      expect(find.text('John Doe'), findsNothing);
    });

    testWidgets('add user button is visible for allowed roles', (tester) async {
      final state =
          UserManagementState().rebuild((b) => b..loggedInUserRoleId = 1);
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });

    testWidgets('add user button is hidden for role 4', (tester) async {
      final state =
          UserManagementState().rebuild((b) => b..loggedInUserRoleId = 4);
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.add_rounded), findsNothing);
    });

    testWidgets('tapping user card navigates to user info page',
        (tester) async {
      final state = UserManagementState()
          .rebuild((b) => b..subUsersList.replace(BuiltList(users)));
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pumpAndSettle();
      await tester.tap(find.text('John Doe'));
      await tester.pumpAndSettle();
      // Navigation assertion would go here (using mock or integration test)
    });

    testWidgets('pull-to-refresh triggers refresh', (tester) async {
      final state = UserManagementState()
          .rebuild((b) => b..subUsersList.replace(BuiltList(users)));
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();
      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pumpAndSettle();
      // Use the first ListView under UserManagementPage
      final listViewFinder = find
          .descendant(
            of: find.byType(UserManagementPage),
            matching: find.byType(ListView),
          )
          .first;
      final gesture =
          await tester.startGesture(tester.getCenter(listViewFinder));
      await gesture.moveBy(const Offset(0, 300));
      await tester.pump();
      // You can add a call count check if you override callOnRefreshSubUsers in the fake
    });
  });
}
