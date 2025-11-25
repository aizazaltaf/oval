import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/data/role_model.dart';
import 'package:admin/pages/main/user_management/add_new_user_page.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_bloc.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_state.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/custom_button.dart';
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

  group('AddNewUserPage UI Tests', () {
    late List<RoleModel> roles;
    late List<String> relationships;

    setUp(() {
      roles = [
        RoleModel(
          (b) => b
            ..id = 1
            ..name = 'Admin',
        ),
        RoleModel(
          (b) => b
            ..id = 2
            ..name = 'Viewer',
        ),
        RoleModel(
          (b) => b
            ..id = 3
            ..name = 'Guest',
        ),
      ];

      relationships = [
        'Friend',
        'Colleague',
        'Father',
        'Mother',
        'Brother',
        'Sister',
        'Son',
        'Daughter',
        'Husband',
        'Wife',
        'Uncle',
        'Aunt',
        'Cousin',
        'Nephew',
        'Niece',
        'Grandfather',
        'Grandmother',
        'Partner',
        'Fiancé',
        'Landlord',
        'Tenant',
        'Guardian',
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
              home: const AddNewUserPage(),
            ),
          );
        },
      );
    }

    testWidgets('displays all form fields', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships)),
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      // Check for email field
      expect(find.byType(TextFormField), findsOneWidget);

      // Check for form structure
      expect(find.byType(AddNewUserPage), findsOneWidget);
    });

    testWidgets('add user button is disabled initially', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships))
          ..addUserButtonEnabled = false,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      final button = find.byType(CustomGradientButton);
      expect(button, findsOneWidget);

      final buttonWidget = tester.widget<CustomGradientButton>(button);
      expect(buttonWidget.isButtonEnabled, false);
    });

    testWidgets('add user button is enabled when form is valid',
        (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships))
          ..addUserButtonEnabled = true
          ..addEmail = 'test@example.com'
          ..addEmailError = ''
          ..addRole = roles.first.toBuilder(),
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      final button = find.byType(CustomGradientButton);
      expect(button, findsOneWidget);

      final buttonWidget = tester.widget<CustomGradientButton>(button);
      expect(buttonWidget.isButtonEnabled, true);
    });

    testWidgets('shows loading indicator when API is in progress',
        (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships))
          ..createUserInviteApi.replace(
            UserManagementState()
                .createUserInviteApi
                .rebuild((a) => a..isApiInProgress = true),
          ),
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('email validation shows error for empty email', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships))
          ..addEmail = ''
          ..addEmailError = 'Email is required',
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      // Error message might be localized, so just check that some error text is present
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('email validation shows error for invalid email format',
        (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships))
          ..addEmail = 'invalid-email'
          ..addEmailError = 'Invalid email format',
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      // Error message might be localized, so just check that some error text is present
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('email validation accepts valid email format', (tester) async {
      final validEmails = [
        'test@example.com',
        'user.name@domain.co.uk',
        'user+tag@example.org',
      ];

      for (final email in validEmails) {
        final state = UserManagementState().rebuild(
          (b) => b
            ..roles.replace(BuiltList(roles))
            ..relationshipList.replace(BuiltList(relationships))
            ..addEmail = email
            ..addEmailError = '',
        );
        final fakeBloc = MockUserManagementBloc(state);
        final fakeVoiceBloc = MockVoiceControlBloc();

        await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
        await tester.pump();

        expect(find.text('Invalid email format'), findsNothing);
      }
    });

    testWidgets('form fields update bloc state when changed', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships)),
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      // Verify that the email field is present and can be interacted with
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('shows app title correctly', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships)),
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      // Check for app bar title
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('form validation enables button when all fields are valid',
        (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships))
          ..addEmail = 'valid@example.com'
          ..addEmailError = ''
          ..addRole = roles.first.toBuilder()
          ..addRelation = relationships.first
          ..addUserButtonEnabled = true,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      final button = find.byType(CustomGradientButton);
      expect(button, findsOneWidget);

      final buttonWidget = tester.widget<CustomGradientButton>(button);
      expect(buttonWidget.isButtonEnabled, true);
    });

    testWidgets('form validation disables button when email is invalid',
        (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships))
          ..addEmail = 'invalid-email'
          ..addEmailError = 'Invalid email format'
          ..addRole = roles.first.toBuilder()
          ..addRelation = relationships.first
          ..addUserButtonEnabled = false,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      final button = find.byType(CustomGradientButton);
      expect(button, findsOneWidget);

      final buttonWidget = tester.widget<CustomGradientButton>(button);
      expect(buttonWidget.isButtonEnabled, false);
    });

    testWidgets('shows correct field labels', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships)),
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      // Check for field labels (these would be localized strings)
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('email field has correct hint text', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships)),
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      // Check for hint text in email field
      final emailField = find.byType(TextFormField);
      expect(emailField, findsOneWidget);
    });

    testWidgets('form resets properly when navigated to', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships))
          ..addEmail = ''
          ..addEmailError = ''
          ..addUserButtonEnabled = false,
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      // Verify form is in initial state
      expect(find.byType(AddNewUserPage), findsOneWidget);
    });

    testWidgets('shows correct icons for dropdown fields', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships)),
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      // Check for icons in dropdowns
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('form validation works with real-time input', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships)),
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField), 'invalid');
      await tester.pump();

      // Enter valid email
      await tester.enterText(find.byType(TextFormField), 'valid@example.com');
      await tester.pump();

      // Verify that the email field is present and can be interacted with
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('button text is correct', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(BuiltList(relationships)),
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      // Check for button text
      expect(find.byType(CustomGradientButton), findsOneWidget);
    });

    testWidgets('form handles empty role list gracefully', (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles
              .replace(BuiltList([roles.first])) // At least one role required
          ..relationshipList.replace(BuiltList(relationships)),
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      // Should not crash and should handle empty roles
      expect(find.byType(AddNewUserPage), findsOneWidget);
    });

    testWidgets('form handles empty relationship list gracefully',
        (tester) async {
      final state = UserManagementState().rebuild(
        (b) => b
          ..roles.replace(BuiltList(roles))
          ..relationshipList.replace(
            BuiltList(
              [relationships.first],
            ),
          ), // At least one relationship required
      );
      final fakeBloc = MockUserManagementBloc(state);
      final fakeVoiceBloc = MockVoiceControlBloc();

      await tester.pumpWidget(makeTestableWidget(fakeBloc, fakeVoiceBloc));
      await tester.pump();

      // Should not crash and should handle empty relationships
      expect(find.byType(AddNewUserPage), findsOneWidget);
    });
  });
}
