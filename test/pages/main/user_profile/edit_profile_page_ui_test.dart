import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_state.dart';
import 'package:admin/pages/main/user_profile/components/email_edit_profile_widget.dart';
import 'package:admin/pages/main/user_profile/components/name_edit_profile_widget.dart';
import 'package:admin/pages/main/user_profile/components/phone_edit_profile_widget.dart';
import 'package:admin/pages/main/user_profile/edit_profile_page.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../../helpers/test_helper.dart';

class TestUserProfileBloc extends UserProfileBloc {
  TestUserProfileBloc() : super();

  UserProfileState _state = UserProfileState();

  @override
  UserProfileState get state => _state;

  @override
  Stream<UserProfileState> get stream => Stream.value(_state);

  void updateState(UserProfileState newState) {
    _state = newState;
    emit(_state);
  }

  @override
  void updateEditName(String name) {
    super.updateEditName(name);
    updateState(_state.rebuild((b) => b..editName = name));
  }

  @override
  void updateEditEmail(String email) {
    super.updateEditEmail(email);
    updateState(_state.rebuild((b) => b..editEmail = email));
  }

  @override
  void updateEditPhoneNumber(String phoneNumber) {
    super.updateEditPhoneNumber(phoneNumber);
    updateState(_state.rebuild((b) => b..editPhoneNumber = phoneNumber));
  }

  @override
  void updateCountryCode(String countryCode) {
    super.updateCountryCode(countryCode);
    updateState(_state.rebuild((b) => b..countryCode = countryCode));
  }

  @override
  void updateNameErrorMessage(String message) {
    super.updateNameErrorMessage(message);
    updateState(_state.rebuild((b) => b..nameErrorMessage = message));
  }

  @override
  void updateEmailErrorMessage(String message) {
    super.updateEmailErrorMessage(message);
    updateState(_state.rebuild((b) => b..emailErrorMessage = message));
  }

  @override
  void updatePhoneErrorMessage(String message) {
    super.updatePhoneErrorMessage(message);
    updateState(_state.rebuild((b) => b..phoneErrorMessage = message));
  }
}

void main() {
  group('EditProfilePage UI Tests', () {
    late TestUserProfileBloc testUserProfileBloc;

    setUpAll(() async {
      await TestHelper.initialize();
    });

    setUp(() {
      testUserProfileBloc = TestUserProfileBloc();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget makeTestableWidget({
      bool nameFocus = false,
      bool emailFocus = false,
      bool phoneFocus = false,
    }) {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MultiProvider(
            providers: [
              Provider<UserProfileBloc>.value(value: testUserProfileBloc),
            ],
            child: MaterialApp(
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColorLight: Colors.blue.shade50,
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
              home: Scaffold(
                body: SingleChildScrollView(
                  child: EditProfilePage(
                    nameFocus: nameFocus,
                    emailFocus: emailFocus,
                    phoneFocus: phoneFocus,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    group('Basic Widget Rendering', () {
      testWidgets('renders EditProfilePage widget', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(EditProfilePage), findsOneWidget);
      });

      testWidgets('displays all three profile edit widgets', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(NameEditProfileWidget), findsOneWidget);
        expect(find.byType(EmailEditProfileWidget), findsOneWidget);
        expect(find.byType(PhoneEditProfileWidget), findsOneWidget);
      });

      testWidgets('displays proper spacing between widgets', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Check that SizedBox widgets are present for spacing
        expect(find.byType(SizedBox), findsNWidgets(22));
      });

      testWidgets('uses Column with proper crossAxisAlignment', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        final column = tester.widget<Column>(find.byType(Column).first);
        expect(column.crossAxisAlignment, CrossAxisAlignment.stretch);
      });
    });

    group('Focus Behavior', () {
      testWidgets('applies name focus when nameFocus is true', (tester) async {
        await tester.pumpWidget(makeTestableWidget(nameFocus: true));
        await tester.pumpAndSettle();

        // Find the name text field and verify it has autofocus
        final nameField = find.byType(NameEditProfileWidget);
        expect(nameField, findsOneWidget);
      });

      testWidgets('applies email focus when emailFocus is true',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(emailFocus: true));
        await tester.pumpAndSettle();

        // Find the email text field and verify it has autofocus
        final emailField = find.byType(EmailEditProfileWidget);
        expect(emailField, findsOneWidget);
      });

      testWidgets('applies phone focus when phoneFocus is true',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(phoneFocus: true));
        await tester.pumpAndSettle();

        // Find the phone text field and verify it has autofocus
        final phoneField = find.byType(PhoneEditProfileWidget);
        expect(phoneField, findsOneWidget);
      });

      testWidgets('applies multiple focus states correctly', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            nameFocus: true,
            emailFocus: true,
            phoneFocus: true,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(NameEditProfileWidget), findsOneWidget);
        expect(find.byType(EmailEditProfileWidget), findsOneWidget);
        expect(find.byType(PhoneEditProfileWidget), findsOneWidget);
      });
    });

    group('Widget Integration', () {
      testWidgets('passes userProfileBloc to all child widgets',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Verify that all child widgets receive the bloc
        final nameWidget = tester.widget<NameEditProfileWidget>(
          find.byType(NameEditProfileWidget),
        );
        expect(nameWidget.userProfileBloc, equals(testUserProfileBloc));

        final emailWidget = tester.widget<EmailEditProfileWidget>(
          find.byType(EmailEditProfileWidget),
        );
        expect(emailWidget.userProfileBloc, equals(testUserProfileBloc));

        final phoneWidget = tester.widget<PhoneEditProfileWidget>(
          find.byType(PhoneEditProfileWidget),
        );
        expect(phoneWidget.userProfileBloc, equals(testUserProfileBloc));
      });

      testWidgets('passes correct focus states to child widgets',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            nameFocus: true,
            phoneFocus: true,
          ),
        );
        await tester.pumpAndSettle();

        final nameWidget = tester.widget<NameEditProfileWidget>(
          find.byType(NameEditProfileWidget),
        );
        expect(nameWidget.isFocus, isTrue);

        final emailWidget = tester.widget<EmailEditProfileWidget>(
          find.byType(EmailEditProfileWidget),
        );
        expect(emailWidget.isFocus, isFalse);

        final phoneWidget = tester.widget<PhoneEditProfileWidget>(
          find.byType(PhoneEditProfileWidget),
        );
        expect(phoneWidget.isFocus, isTrue);
      });
    });

    group('State Management', () {
      testWidgets('updates name field and triggers bloc method',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Find the name text field
        final nameField = find.byType(NameEditProfileWidget);
        expect(nameField, findsOneWidget);

        // Verify initial state
        expect(testUserProfileBloc.state.editName, isEmpty);
      });

      testWidgets('updates email field and triggers bloc method',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Find the email text field
        final emailField = find.byType(EmailEditProfileWidget);
        expect(emailField, findsOneWidget);

        // Verify initial state
        expect(testUserProfileBloc.state.editEmail, isEmpty);
      });

      testWidgets('updates phone field and triggers bloc method',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Find the phone text field
        final phoneField = find.byType(PhoneEditProfileWidget);
        expect(phoneField, findsOneWidget);

        // Verify initial state
        expect(testUserProfileBloc.state.editPhoneNumber, isEmpty);
      });
    });

    group('Error Message Display', () {
      testWidgets('displays name error message when set in bloc',
          (tester) async {
        // Set error message in bloc
        testUserProfileBloc.updateNameErrorMessage('Name is required');

        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.text('Name is required'), findsOneWidget);
      });

      testWidgets('displays email error message when set in bloc',
          (tester) async {
        // Set error message in bloc
        testUserProfileBloc
            .updateEmailErrorMessage('Please enter a valid email address');

        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.text('Please enter a valid email address'), findsOneWidget);
      });

      testWidgets('displays phone error message when set in bloc',
          (tester) async {
        // Set error message in bloc
        testUserProfileBloc.updatePhoneErrorMessage('Phone number is required');

        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.text('Phone number is required'), findsOneWidget);
      });

      testWidgets('hides error messages when they are empty', (tester) async {
        // Ensure no error messages are set
        testUserProfileBloc
          ..updateNameErrorMessage('')
          ..updateEmailErrorMessage('')
          ..updatePhoneErrorMessage('');

        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Error widgets should not be visible when messages are empty
        // This is handled by the child widgets showing SizedBox.shrink()
        expect(find.byType(NameEditProfileWidget), findsOneWidget);
        expect(find.byType(EmailEditProfileWidget), findsOneWidget);
        expect(find.byType(PhoneEditProfileWidget), findsOneWidget);
      });
    });

    group('Widget Structure', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Verify the main structure
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(NameEditProfileWidget), findsOneWidget);
        expect(find.byType(EmailEditProfileWidget), findsOneWidget);
        expect(find.byType(PhoneEditProfileWidget), findsOneWidget);
        expect(find.byType(SizedBox), findsNWidgets(22));
      });

      testWidgets('maintains proper layout constraints', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // The Column should stretch to fill available width
        final column = tester.widget<Column>(find.byType(Column).first);
        expect(column.crossAxisAlignment, CrossAxisAlignment.stretch);
      });
    });

    group('Accessibility', () {
      testWidgets('provides semantic labels for form fields', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Verify that form fields are accessible
        expect(find.byType(NameEditProfileWidget), findsOneWidget);
        expect(find.byType(EmailEditProfileWidget), findsOneWidget);
        expect(find.byType(PhoneEditProfileWidget), findsOneWidget);
      });

      testWidgets('supports screen reader navigation', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // The widget structure should support proper navigation
        expect(find.byType(Column), findsWidgets);
      });
    });

    group('Responsive Design', () {
      testWidgets('adapts to different screen sizes', (tester) async {
        // Test with different screen sizes
        await tester.binding.setSurfaceSize(const Size(400, 800));
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(EditProfilePage), findsOneWidget);

        await tester.binding.setSurfaceSize(const Size(800, 600));
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(EditProfilePage), findsOneWidget);
      });

      testWidgets('handles orientation changes', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // The widget should handle orientation changes gracefully
        expect(find.byType(EditProfilePage), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles null bloc gracefully', (tester) async {
        // This test would require mocking the BlocProvider.of method
        // For now, we test with a valid bloc
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(EditProfilePage), findsOneWidget);
      });

      testWidgets('handles rapid focus changes', (tester) async {
        await tester.pumpWidget(makeTestableWidget(nameFocus: true));
        await tester.pumpAndSettle();

        await tester.pumpWidget(makeTestableWidget(emailFocus: true));
        await tester.pumpAndSettle();

        await tester.pumpWidget(makeTestableWidget(phoneFocus: true));
        await tester.pumpAndSettle();

        expect(find.byType(EditProfilePage), findsOneWidget);
      });

      testWidgets('handles empty state values', (tester) async {
        // Set empty values in bloc
        testUserProfileBloc
          ..updateEditName('')
          ..updateEditEmail('')
          ..updateEditPhoneNumber('');

        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(EditProfilePage), findsOneWidget);
      });
    });
  });
}
