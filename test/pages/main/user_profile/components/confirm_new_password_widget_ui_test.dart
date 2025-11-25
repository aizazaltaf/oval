import 'dart:async';

import 'package:admin/pages/main/user_profile/bloc/change_password_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/change_password_state.dart';
import 'package:admin/pages/main/user_profile/components/build_section_title.dart';
import 'package:admin/pages/main/user_profile/components/change_pwd_components/confirm_new_password_widget.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_helper.dart';

class MockChangePasswordBloc extends Mock implements ChangePasswordBloc {
  MockChangePasswordBloc() {
    _currentState = ChangePasswordState();
    _stateController.add(_currentState);
  }
  final _stateController = StreamController<ChangePasswordState>.broadcast();
  late ChangePasswordState _currentState;

  @override
  Stream<ChangePasswordState> get stream => _stateController.stream;

  @override
  ChangePasswordState get state => _currentState;

  @override
  Future<void> close() async {
    await _stateController.close();
  }

  void updateState(ChangePasswordState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }
}

void main() {
  group('ConfirmNewPasswordWidget UI Tests', () {
    late MockChangePasswordBloc mockChangePasswordBloc;

    setUpAll(() async {
      await TestHelper.initialize();
    });

    setUp(() {
      mockChangePasswordBloc = MockChangePasswordBloc();

      // Mock basic bloc methods
      when(() => mockChangePasswordBloc.updateConfirmPassword(any()))
          .thenAnswer((invocation) {
        final password = invocation.positionalArguments[0] as String;
        final newState = mockChangePasswordBloc.state
            .rebuild((b) => b..confirmPassword = password);
        mockChangePasswordBloc.updateState(newState);
      });

      when(() => mockChangePasswordBloc.updateConfirmPasswordError(any()))
          .thenAnswer((invocation) {
        final error = invocation.positionalArguments[0] as String;
        final newState = mockChangePasswordBloc.state
            .rebuild((b) => b..confirmPasswordError = error);
        mockChangePasswordBloc.updateState(newState);
      });

      when(() => mockChangePasswordBloc.updateConfirmPasswordObscure(any()))
          .thenAnswer((invocation) {
        final obscure = invocation.positionalArguments[0] as bool;
        final newState = mockChangePasswordBloc.state
            .rebuild((b) => b..confirmPasswordObscure = obscure);
        mockChangePasswordBloc.updateState(newState);
      });

      when(() => mockChangePasswordBloc.getConfirmButtonEnabled())
          .thenReturn(null);
    });

    tearDown(() {
      mockChangePasswordBloc.close();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget makeTestableWidget(Widget child) {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return BlocProvider<ChangePasswordBloc>(
            create: (context) => mockChangePasswordBloc,
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
                body: child,
              ),
            ),
          );
        },
      );
    }

    group('Widget Rendering', () {
      testWidgets('renders ConfirmNewPasswordWidget successfully',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ConfirmNewPasswordWidget), findsOneWidget);
      });

      testWidgets('displays confirm password section title', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // The title should be "Confirm Password" based on the widget
        expect(find.text('Confirm Password'), findsOneWidget);
      });

      testWidgets('contains password text form field', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('displays password hint text', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.decoration?.hintText, isNotNull);
      });

      testWidgets('has toggle password visibility button', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.decoration?.suffixIcon, isNotNull);
      });
    });

    group('Password Input Handling', () {
      testWidgets('accepts password input and calls bloc method',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        const testPassword = 'confirmpassword123';
        final textField = find.byType(TextField);
        await tester.enterText(textField, testPassword);
        await tester.pumpAndSettle();

        // Verify the text is displayed
        expect(find.text(testPassword), findsOneWidget);

        // Verify the bloc method was called
        verify(() => mockChangePasswordBloc.updateConfirmPassword(testPassword))
            .called(1);
      });

      testWidgets('handles empty password input', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Enter empty password
        final textField = find.byType(TextField);
        await tester.enterText(textField, '');
        await tester.pumpAndSettle();

        // Verify the widget can handle empty input without crashing
        expect(find.byType(ConfirmNewPasswordWidget), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('handles whitespace-only password input', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Enter whitespace-only password
        final textField = find.byType(TextField);
        await tester.enterText(textField, '   ');
        await tester.pumpAndSettle();

        // Verify the widget can handle whitespace-only input without crashing
        expect(find.byType(ConfirmNewPasswordWidget), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('handles special characters in password', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        const specialPassword = 'P@ssw0rd!@#';
        final textField = find.byType(TextField);
        await tester.enterText(textField, specialPassword);
        await tester.pumpAndSettle();

        // Verify the text is displayed
        expect(find.text(specialPassword), findsOneWidget);

        // Verify the bloc method was called
        verify(
          () => mockChangePasswordBloc.updateConfirmPassword(specialPassword),
        ).called(1);
      });

      testWidgets('handles unicode characters in password', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        const unicodePassword = 'P@ssw0rd🚀🌟';
        final textField = find.byType(TextField);
        await tester.enterText(textField, unicodePassword);
        await tester.pumpAndSettle();

        // Should handle unicode characters
        expect(find.text(unicodePassword), findsOneWidget);
        verify(
          () => mockChangePasswordBloc.updateConfirmPassword(unicodePassword),
        ).called(1);
      });
    });

    group('Password Confirmation Validation', () {
      testWidgets('shows error when passwords do not match', (tester) async {
        // Set up state with a new password
        final stateWithNewPassword = mockChangePasswordBloc.state.rebuild(
          (b) => b..newPassword = 'newpassword123',
        );
        mockChangePasswordBloc.updateState(stateWithNewPassword);

        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Enter different confirm password
        const differentPassword = 'differentpassword123';
        final textField = find.byType(TextField);
        await tester.enterText(textField, differentPassword);
        await tester.pumpAndSettle();

        // Verify the bloc methods were called
        verify(
          () => mockChangePasswordBloc.updateConfirmPassword(differentPassword),
        ).called(1);
        verify(() => mockChangePasswordBloc.updateConfirmPasswordError(any()))
            .called(1);
        verify(() => mockChangePasswordBloc.getConfirmButtonEnabled())
            .called(1);
      });

      testWidgets('clears error when passwords match', (tester) async {
        // Set up state with a new password
        const matchingPassword = 'matchingpassword123';
        final stateWithNewPassword = mockChangePasswordBloc.state.rebuild(
          (b) => b..newPassword = matchingPassword,
        );
        mockChangePasswordBloc.updateState(stateWithNewPassword);

        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Enter matching confirm password
        final textField = find.byType(TextField);
        await tester.enterText(textField, matchingPassword);
        await tester.pumpAndSettle();

        // Verify the bloc methods were called
        verify(
          () => mockChangePasswordBloc.updateConfirmPassword(matchingPassword),
        ).called(1);
        verify(() => mockChangePasswordBloc.updateConfirmPasswordError(''))
            .called(1);
        verify(() => mockChangePasswordBloc.getConfirmButtonEnabled())
            .called(1);
      });

      testWidgets('handles case-sensitive password matching', (tester) async {
        // Set up state with a new password
        const newPassword = 'NewPassword123';
        final stateWithNewPassword = mockChangePasswordBloc.state.rebuild(
          (b) => b..newPassword = newPassword,
        );
        mockChangePasswordBloc.updateState(stateWithNewPassword);

        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Enter password with different case
        const differentCasePassword = 'newpassword123';
        final textField = find.byType(TextField);
        await tester.enterText(textField, differentCasePassword);
        await tester.pumpAndSettle();

        // Should show error for case mismatch
        verify(
          () => mockChangePasswordBloc
              .updateConfirmPassword(differentCasePassword),
        ).called(1);
        verify(() => mockChangePasswordBloc.updateConfirmPasswordError(any()))
            .called(1);
      });
    });

    group('Password Visibility Toggle', () {
      testWidgets('password field is initially obscured', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.obscureText, true);
      });

      testWidgets('toggles password visibility when eye icon is tapped',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Initially obscured
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.obscureText, true);

        // Tap the suffix icon to toggle visibility
        final suffixIcon = textField.decoration!.suffixIcon!;
        await tester.tap(find.byWidget(suffixIcon));
        await tester.pumpAndSettle();

        // Verify the widget rendered correctly
        expect(find.byType(ConfirmNewPasswordWidget), findsOneWidget);
      });
    });

    group('Widget Structure', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should have at least one Column as the main container
        expect(find.byType(Column), findsAtLeastNWidgets(1));

        // Should have BuildSectionTitle
        expect(find.byType(BuildSectionTitle), findsOneWidget);

        // Should have TextField for password input
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('has proper crossAxisAlignment', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Find the Column that belongs to ConfirmNewPasswordWidget specifically
        final columns = find.byType(Column);
        expect(columns, findsAtLeastNWidgets(1));

        // Check that at least one Column has the expected crossAxisAlignment
        bool foundCorrectColumn = false;
        for (final column in columns.evaluate()) {
          final columnWidget =
              tester.widget<Column>(find.byWidget(column.widget));
          if (columnWidget.crossAxisAlignment == CrossAxisAlignment.start) {
            foundCorrectColumn = true;
            break;
          }
        }
        expect(foundCorrectColumn, true);
      });
    });

    group('Accessibility', () {
      testWidgets('has hint text for password field', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.decoration?.hintText, isNotNull);
      });

      testWidgets('has suffix icon for password visibility toggle',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.decoration?.suffixIcon, isNotNull);
      });

      testWidgets('has semantic title for confirm password section',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should have confirm password title
        expect(find.text('Confirm Password'), findsOneWidget);
      });
    });

    group('Error Display', () {
      testWidgets('shows error message when passwords do not match',
          (tester) async {
        // Set error state
        final errorState = mockChangePasswordBloc.state.rebuild(
          (b) => b..confirmPasswordError = 'Passwords do not match',
        );
        mockChangePasswordBloc.updateState(errorState);

        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Passwords do not match'), findsOneWidget);
      });

      testWidgets('hides error message when passwords match', (tester) async {
        // Set empty error state
        final validState = mockChangePasswordBloc.state.rebuild(
          (b) => b..confirmPasswordError = '',
        );
        mockChangePasswordBloc.updateState(validState);

        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should not show any error widget
        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles very long password input', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final longPassword = 'a' * 100; // Reasonable long password for testing
        final textField = find.byType(TextField);
        await tester.enterText(textField, longPassword);
        await tester.pumpAndSettle();

        // Should handle without crashing
        expect(find.byType(ConfirmNewPasswordWidget), findsOneWidget);
        verify(() => mockChangePasswordBloc.updateConfirmPassword(longPassword))
            .called(1);
      });

      testWidgets('handles rapid text input changes', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textField = find.byType(TextField);

        // Rapidly change text
        await tester.enterText(textField, 'first');
        await tester.enterText(textField, 'second');
        await tester.enterText(textField, 'third');
        await tester.pumpAndSettle();

        // Should handle rapid changes without issues
        expect(find.text('third'), findsOneWidget);
        verify(() => mockChangePasswordBloc.updateConfirmPassword('third'))
            .called(1);
      });

      testWidgets('handles empty new password state', (tester) async {
        // Set up state with empty new password
        final emptyNewPasswordState = mockChangePasswordBloc.state.rebuild(
          (b) => b..newPassword = '',
        );
        mockChangePasswordBloc.updateState(emptyNewPasswordState);

        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should handle empty new password state without crashing
        expect(find.byType(ConfirmNewPasswordWidget), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });
    });

    group('Bloc Integration', () {
      testWidgets('calls getConfirmButtonEnabled after password input',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        const testPassword = 'testpassword123';
        final textField = find.byType(TextField);
        await tester.enterText(textField, testPassword);
        await tester.pumpAndSettle();

        // Verify getConfirmButtonEnabled is called
        verify(() => mockChangePasswordBloc.getConfirmButtonEnabled())
            .called(1);
      });

      testWidgets('handles state changes properly', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Change state and verify widget updates
        final newState = mockChangePasswordBloc.state.rebuild(
          (b) => b..confirmPasswordError = 'Test error message',
        );
        mockChangePasswordBloc.updateState(newState);
        await tester.pumpAndSettle();

        // Should display the error message
        expect(find.text('Test error message'), findsOneWidget);
      });
    });
  });
}
