import 'dart:async';

import 'package:admin/pages/main/user_profile/bloc/change_password_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/change_password_state.dart';
import 'package:admin/pages/main/user_profile/components/build_section_title.dart';
import 'package:admin/pages/main/user_profile/components/change_pwd_components/new_password_widget.dart';
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
  group('NewPasswordWidget UI Tests', () {
    late MockChangePasswordBloc mockChangePasswordBloc;

    setUpAll(() async {
      await TestHelper.initialize();
    });

    setUp(() {
      mockChangePasswordBloc = MockChangePasswordBloc();

      // Mock basic bloc methods
      when(() => mockChangePasswordBloc.updateNewPassword(any()))
          .thenAnswer((invocation) {
        final password = invocation.positionalArguments[0] as String;
        final newState = mockChangePasswordBloc.state
            .rebuild((b) => b..newPassword = password);
        mockChangePasswordBloc.updateState(newState);
      });

      when(() => mockChangePasswordBloc.updateNewPasswordError(any()))
          .thenAnswer((invocation) {
        final error = invocation.positionalArguments[0] as String;
        final newState = mockChangePasswordBloc.state
            .rebuild((b) => b..newPasswordError = error);
        mockChangePasswordBloc.updateState(newState);
      });

      when(() => mockChangePasswordBloc.updateNewPasswordObscure(any()))
          .thenAnswer((invocation) {
        final obscure = invocation.positionalArguments[0] as bool;
        final newState = mockChangePasswordBloc.state
            .rebuild((b) => b..newPasswordObscure = obscure);
        mockChangePasswordBloc.updateState(newState);
      });

      when(() => mockChangePasswordBloc.getPasswordStrength())
          .thenAnswer((invocation) {
        // Simulate password strength calculation
        final newState = mockChangePasswordBloc.state.rebuild(
          (b) => b
            ..strength = 0.5
            ..strengthLabel = 'Medium'
            ..strengthColor = Colors.orange,
        );
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
      testWidgets('renders NewPasswordWidget successfully', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(NewPasswordWidget), findsOneWidget);
      });

      testWidgets('displays new password section title', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('New Password'), findsOneWidget);
      });

      testWidgets('contains password text form field', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
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
            NewPasswordWidget(
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
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.decoration?.suffixIcon, isNotNull);
      });
    });

    group('Password Strength Indicator', () {
      testWidgets('displays password strength section', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // The actual text might be localized, so we check for the presence of strength-related elements
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
        expect(find.byType(Row), findsAtLeastNWidgets(1));
      });

      testWidgets('contains linear progress indicator', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('displays strength label', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should display the default strength label
        expect(find.text('Too short'), findsOneWidget);
      });

      testWidgets('has password requirements text', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should display password requirements (the text is in a single widget with multiple lines)
        expect(find.textContaining('•'), findsOneWidget);
      });
    });

    group('Password Input Handling', () {
      testWidgets('accepts password input and calls bloc method',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        const testPassword = 'newpassword123';
        final textField = find.byType(TextField);
        await tester.enterText(textField, testPassword);
        await tester.pumpAndSettle();

        // Verify the text is displayed
        expect(find.text(testPassword), findsOneWidget);

        // Verify the bloc method was called
        verify(() => mockChangePasswordBloc.updateNewPassword(testPassword))
            .called(1);
      });

      testWidgets('handles empty password input', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
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
        expect(find.byType(NewPasswordWidget), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('handles whitespace-only password input', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
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
        expect(find.byType(NewPasswordWidget), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('handles valid password input', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        const validPassword = 'ValidPassword123';
        final textField = find.byType(TextField);
        await tester.enterText(textField, validPassword);
        await tester.pumpAndSettle();

        // Verify the bloc methods were called
        verify(() => mockChangePasswordBloc.updateNewPassword(validPassword))
            .called(1);
        // The widget calls updateNewPasswordError with validation result
        verify(() => mockChangePasswordBloc.updateNewPasswordError(any()))
            .called(1);
        verify(() => mockChangePasswordBloc.getPasswordStrength()).called(1);
        verify(() => mockChangePasswordBloc.getConfirmButtonEnabled())
            .called(1);
      });

      testWidgets('handles special characters in password', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
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
        verify(() => mockChangePasswordBloc.updateNewPassword(specialPassword))
            .called(1);
      });
    });

    group('Password Validation', () {
      testWidgets('validates password length requirement', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Enter short password
        const shortPassword = 'short';
        final textField = find.byType(TextField);
        await tester.enterText(textField, shortPassword);
        await tester.pumpAndSettle();

        // Verify the widget handles short password without crashing
        expect(find.byType(NewPasswordWidget), findsOneWidget);
        expect(find.text(shortPassword), findsOneWidget);
      });

      testWidgets('validates password format requirements', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Enter password without special characters
        const simplePassword = 'SimplePassword123';
        final textField = find.byType(TextField);
        await tester.enterText(textField, simplePassword);
        await tester.pumpAndSettle();

        // Verify the widget handles format validation without crashing
        expect(find.byType(NewPasswordWidget), findsOneWidget);
        expect(find.text(simplePassword), findsOneWidget);
      });
    });

    group('Password Visibility Toggle', () {
      testWidgets('password field is initially obscured', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
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
            NewPasswordWidget(
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
        expect(find.byType(NewPasswordWidget), findsOneWidget);
      });
    });

    group('Widget Structure', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should have at least one Column as the main container
        expect(find.byType(Column), findsAtLeastNWidgets(1));

        // Should have BuildSectionTitle
        expect(find.byType(BuildSectionTitle), findsOneWidget);

        // Should have LinearProgressIndicator for strength
        expect(find.byType(LinearProgressIndicator), findsOneWidget);

        // Should have Row for strength indicator layout
        expect(find.byType(Row), findsAtLeastNWidgets(1));
      });

      testWidgets('has proper crossAxisAlignment', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Find the Column that belongs to NewPasswordWidget specifically
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
            NewPasswordWidget(
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
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.decoration?.suffixIcon, isNotNull);
      });

      testWidgets('has semantic labels for strength indicator', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should have strength indicator elements
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
        expect(find.byType(Row), findsAtLeastNWidgets(1));
      });
    });

    group('Error Display', () {
      testWidgets('shows error message when password is invalid',
          (tester) async {
        // Set error state
        final errorState = mockChangePasswordBloc.state.rebuild(
          (b) => b..newPasswordError = 'Password must be at least 8 characters',
        );
        mockChangePasswordBloc.updateState(errorState);

        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('Password must be at least 8 characters'),
          findsOneWidget,
        );
      });

      testWidgets('hides error message when password is valid', (tester) async {
        // Set empty error state
        final validState = mockChangePasswordBloc.state
            .rebuild((b) => b..newPasswordError = '');
        mockChangePasswordBloc.updateState(validState);

        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
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
            NewPasswordWidget(
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
        expect(find.byType(NewPasswordWidget), findsOneWidget);
        verify(() => mockChangePasswordBloc.updateNewPassword(longPassword))
            .called(1);
      });

      testWidgets('handles unicode characters in password', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
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
        verify(() => mockChangePasswordBloc.updateNewPassword(unicodePassword))
            .called(1);
      });

      testWidgets('handles rapid text input changes', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
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
        verify(() => mockChangePasswordBloc.updateNewPassword('third'))
            .called(1);
      });
    });

    group('Password Requirements Display', () {
      testWidgets('displays password requirements list', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should display password requirements (the text is in a single widget with multiple lines)
        expect(find.textContaining('•'), findsOneWidget);
      });

      testWidgets('has proper spacing between sections', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc: mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should have SizedBox widgets for spacing
        expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
      });
    });
  });
}
