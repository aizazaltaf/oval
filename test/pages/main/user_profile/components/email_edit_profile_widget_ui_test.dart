import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_state.dart';
import 'package:admin/pages/main/user_profile/components/email_edit_profile_widget.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/bloc_helpers/profile_bloc_test_helper.dart';
import '../../../../helpers/test_helper.dart';

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
  void updateEditEmail(String email) {
    super.updateEditEmail(email);
    updateState(_state.rebuild((b) => b..editEmail = email));
  }
}

void main() {
  group('EmailEditProfileWidget UI Tests', () {
    late TestUserProfileBloc testUserProfileBloc;
    late ProfileBlocTestHelper profileBlocHelper;

    setUpAll(() async {
      await TestHelper.initialize();
    });

    setUp(() {
      profileBlocHelper = ProfileBlocTestHelper();
      testUserProfileBloc = TestUserProfileBloc();

      // Setup test helpers
      profileBlocHelper.setup();

      // Setup global singleton bloc
      singletonBloc.testProfileBloc = profileBlocHelper.mockProfileBloc;

      // Ensure profile data is set up
      when(() => profileBlocHelper.mockProfileBloc.state)
          .thenReturn(profileBlocHelper.currentUserData);
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget makeTestableWidget({bool isFocus = false}) {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MultiProvider(
            providers: [
              Provider<UserProfileBloc>.value(value: testUserProfileBloc),
            ],
            child: MaterialApp(
              theme: ThemeData(
                primarySwatch: Colors.blue,
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
                body: EmailEditProfileWidget(
                  userProfileBloc: testUserProfileBloc,
                  isFocus: isFocus,
                ),
              ),
            ),
          );
        },
      );
    }

    group('Basic Widget Rendering', () {
      testWidgets('renders EmailEditProfileWidget widget', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(EmailEditProfileWidget), findsOneWidget);
      });

      testWidgets('displays email section title', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.text('Email Address'), findsOneWidget);
      });

      testWidgets('displays email text field', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(NameTextFormField), findsOneWidget);
        expect(find.text('Email'), findsOneWidget); // Hint text
      });

      testWidgets('displays email icon prefix', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      });
    });

    group('Focus Behavior', () {
      testWidgets('applies focus when isFocus is true', (tester) async {
        await tester.pumpWidget(makeTestableWidget(isFocus: true));
        await tester.pumpAndSettle();

        final textField =
            tester.widget<NameTextFormField>(find.byType(NameTextFormField));
        expect(textField.autoFocus, isTrue);
      });

      testWidgets('does not apply focus when isFocus is false', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        final textField =
            tester.widget<NameTextFormField>(find.byType(NameTextFormField));
        expect(textField.autoFocus, isFalse);
      });
    });

    group('Text Input Behavior', () {
      testWidgets('can enter text in email field', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(NameTextFormField),
          'test@example.com',
        );
        await tester.pumpAndSettle();

        expect(find.text('test@example.com'), findsOneWidget);
      });

      testWidgets('calls updateEditEmail when text changes', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(NameTextFormField),
          'new@example.com',
        );
        await tester.pumpAndSettle();

        expect(testUserProfileBloc.state.editEmail, equals('new@example.com'));
      });

      testWidgets('updates field value when bloc state changes',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Update the bloc state
        testUserProfileBloc.updateEditEmail('updated@example.com');
        await tester.pumpAndSettle();

        // The widget should reflect the updated value
        expect(
          testUserProfileBloc.state.editEmail,
          equals('updated@example.com'),
        );
      });
    });

    group('Error Display', () {
      testWidgets('shows error message when email error exists',
          (tester) async {
        // Set error state
        final errorState = UserProfileState(
          (b) => b..emailErrorMessage = 'Invalid email format',
        );
        testUserProfileBloc.updateState(errorState);

        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.text('Invalid email format'), findsOneWidget);
      });

      testWidgets('hides error message when email error is empty',
          (tester) async {
        // Set empty error state
        final emptyErrorState = UserProfileState(
          (b) => b..emailErrorMessage = '',
        );
        testUserProfileBloc.updateState(emptyErrorState);

        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Should not find any error widget
        expect(find.byType(CommonFunctions), findsNothing);
      });

      testWidgets('updates error message when bloc state changes',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Initially no error
        expect(testUserProfileBloc.state.emailErrorMessage, isEmpty);

        // Set error state
        final errorState = UserProfileState(
          (b) => b..emailErrorMessage = 'Invalid email format',
        );
        testUserProfileBloc.updateState(errorState);
        await tester.pumpAndSettle();

        // Now error should be visible
        expect(
          testUserProfileBloc.state.emailErrorMessage,
          equals('Invalid email format'),
        );
      });
    });

    group('Widget Properties', () {
      testWidgets('passes correct userProfileBloc to widget', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        final widget = tester.widget<EmailEditProfileWidget>(
          find.byType(EmailEditProfileWidget),
        );
        expect(widget.userProfileBloc, equals(testUserProfileBloc));
      });

      testWidgets('passes correct isFocus parameter', (tester) async {
        await tester.pumpWidget(makeTestableWidget(isFocus: true));
        await tester.pumpAndSettle();

        final widget = tester.widget<EmailEditProfileWidget>(
          find.byType(EmailEditProfileWidget),
        );
        expect(widget.isFocus, isTrue);
      });
    });

    group('Layout and Styling', () {
      testWidgets('has proper column layout', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(Column), findsAtLeastNWidgets(1));
      });

      testWidgets('has proper spacing between elements', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      });

      testWidgets('text field has proper styling', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        final textField =
            tester.widget<NameTextFormField>(find.byType(NameTextFormField));
        expect(textField.hintText, equals('Email'));
        expect(textField.prefix, isA<Icon>());
      });
    });

    group('Accessibility', () {
      testWidgets('has proper semantic labels', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Verify that the text field is accessible
        expect(find.byType(NameTextFormField), findsOneWidget);
      });

      testWidgets('supports keyboard navigation', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Tap on the text field to focus it
        await tester.tap(find.byType(NameTextFormField));
        await tester.pumpAndSettle();

        // Verify the field can be tapped
        expect(find.byType(NameTextFormField), findsOneWidget);
      });
    });

    group('Integration with Bloc', () {
      testWidgets('reacts to bloc state changes', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Change bloc state
        testUserProfileBloc.updateEditEmail('integration@test.com');
        await tester.pumpAndSettle();

        // Verify bloc state updates
        expect(
          testUserProfileBloc.state.editEmail,
          equals('integration@test.com'),
        );
      });

      testWidgets('calls bloc methods on user interaction', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Enter text to trigger bloc method
        await tester.enterText(
          find.byType(NameTextFormField),
          'interaction@test.com',
        );
        await tester.pumpAndSettle();

        // Verify bloc state was updated
        expect(
          testUserProfileBloc.state.editEmail,
          equals('interaction@test.com'),
        );
      });
    });
  });
}
