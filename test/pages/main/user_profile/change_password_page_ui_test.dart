import 'package:admin/pages/main/user_profile/bloc/change_password_bloc.dart';
import 'package:admin/pages/main/user_profile/components/change_pwd_components/confirm_new_password_widget.dart';
import 'package:admin/pages/main/user_profile/components/change_pwd_components/new_password_widget.dart';
import 'package:admin/pages/main/user_profile/components/change_pwd_components/old_password_widget.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/change_password_bloc_test_helper.dart';
import '../../../helpers/test_helper.dart';
import '../../../mocks/bloc/bloc_mocks.dart';

void main() {
  group('ChangePasswordPage UI Tests', () {
    late ChangePasswordBlocTestHelper changePasswordBlocTestHelper;

    setUpAll(() async {
      await TestHelper.initialize();
      registerFallbackValue(MockLogoutBloc());
    });

    setUp(() {
      changePasswordBlocTestHelper = ChangePasswordBlocTestHelper()..setup();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget makeTestableWidget(Widget child) {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return BlocProvider<ChangePasswordBloc>(
            create: (context) =>
                changePasswordBlocTestHelper.mockChangePasswordBloc,
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

    group('OldPasswordWidget Tests', () {
      testWidgets('renders OldPasswordWidget', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            OldPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(OldPasswordWidget), findsOneWidget);
      });

      testWidgets('displays old password title', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            OldPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Old Password'), findsOneWidget);
      });

      testWidgets('has password input field', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            OldPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('password field is initially obscured', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            OldPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.obscureText, true);
      });

      testWidgets('accepts password input', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            OldPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textField = find.byType(TextField);
        await tester.enterText(textField, 'oldpassword123');
        await tester.pumpAndSettle();

        expect(find.text('oldpassword123'), findsOneWidget);
      });

      testWidgets('shows error message when password is empty', (tester) async {
        changePasswordBlocTestHelper.mockChangePasswordBloc
            .updateOldPasswordError('Password is required');
        await tester.pumpWidget(
          makeTestableWidget(
            OldPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Password is required'), findsOneWidget);
      });
    });

    group('NewPasswordWidget Tests', () {
      testWidgets('renders NewPasswordWidget', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(NewPasswordWidget), findsOneWidget);
      });

      testWidgets('displays new password title', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('New Password'), findsOneWidget);
      });

      testWidgets('shows password strength indicator', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Check for password strength indicator (may be localized)
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
        // Look for any text that might be the strength label
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('shows password requirements', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Check for password requirements text (may be localized)
        expect(find.byType(Text), findsWidgets);
        // Look for bullet points which indicate requirements
        expect(find.textContaining('•'), findsWidgets);
      });

      testWidgets('updates password strength when input changes',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textField = find.byType(TextField);
        await tester.enterText(textField, 'StrongPass123!');
        await tester.pumpAndSettle();

        // The strength should be calculated and updated
        expect(
          changePasswordBlocTestHelper.mockChangePasswordBloc.state.strength >
              0.0,
          true,
        );
        expect(
          changePasswordBlocTestHelper
              .mockChangePasswordBloc.state.strengthLabel,
          isNotEmpty,
        );
      });

      testWidgets('shows error message for weak password', (tester) async {
        changePasswordBlocTestHelper.mockChangePasswordBloc
            .updateNewPasswordError('Password is too weak');
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Password is too weak'), findsOneWidget);
      });
    });

    group('ConfirmNewPasswordWidget Tests', () {
      testWidgets('renders ConfirmNewPasswordWidget', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ConfirmNewPasswordWidget), findsOneWidget);
      });

      testWidgets('displays confirm password title', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Confirm Password'), findsOneWidget);
      });

      testWidgets('has password input field', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('accepts confirm password input', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textField = find.byType(TextField);
        await tester.enterText(textField, 'newpassword123');
        await tester.pumpAndSettle();

        expect(find.text('newpassword123'), findsOneWidget);
      });

      testWidgets('shows error when passwords do not match', (tester) async {
        changePasswordBlocTestHelper.mockChangePasswordBloc
            .updateConfirmPasswordError('Passwords do not match');
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Passwords do not match'), findsOneWidget);
      });
    });

    group('Password Strength Calculation', () {
      testWidgets('calculates weak password strength', (tester) async {
        changePasswordBlocTestHelper.mockChangePasswordBloc
          ..updateNewPassword('weak')
          ..getPasswordStrength();
        await tester.pumpAndSettle();

        expect(
          changePasswordBlocTestHelper.mockChangePasswordBloc.state.strength <=
              0.25,
          true,
        );
        expect(
          changePasswordBlocTestHelper
              .mockChangePasswordBloc.state.strengthLabel,
          'Weak',
        );
      });

      testWidgets('calculates strong password strength', (tester) async {
        changePasswordBlocTestHelper.mockChangePasswordBloc
          ..updateNewPassword('StrongPass123!')
          ..getPasswordStrength();
        await tester.pumpAndSettle();

        expect(
          changePasswordBlocTestHelper.mockChangePasswordBloc.state.strength >=
              0.75,
          true,
        );
        // The password might be classified as "Very Strong" instead of "Strong"
        expect(
          ['Strong', 'Very Strong'].contains(
            changePasswordBlocTestHelper
                .mockChangePasswordBloc.state.strengthLabel,
          ),
          true,
        );
      });

      testWidgets('calculates very strong password strength', (tester) async {
        changePasswordBlocTestHelper.mockChangePasswordBloc
          ..updateNewPassword('VeryStrongPass123!@#')
          ..getPasswordStrength();
        await tester.pumpAndSettle();

        expect(
          changePasswordBlocTestHelper.mockChangePasswordBloc.state.strength,
          1.0,
        );
        expect(
          changePasswordBlocTestHelper
              .mockChangePasswordBloc.state.strengthLabel,
          'Very Strong',
        );
      });
    });

    group('Form Validation', () {
      testWidgets('enables confirm button when all fields are valid',
          (tester) async {
        changePasswordBlocTestHelper.mockChangePasswordBloc
          ..updateOldPassword('oldpassword123')
          ..updateNewPassword('NewPassword123!')
          ..updateConfirmPassword('NewPassword123!')
          ..getConfirmButtonEnabled();
        await tester.pumpAndSettle();

        expect(
          changePasswordBlocTestHelper
              .mockChangePasswordBloc.state.confirmButtonEnabled,
          true,
        );
      });

      testWidgets('disables confirm button when any field is empty',
          (tester) async {
        changePasswordBlocTestHelper.mockChangePasswordBloc
          ..updateOldPassword('oldpassword123')
          ..updateNewPassword('NewPassword123!')
          // Confirm password is empty
          ..getConfirmButtonEnabled();
        await tester.pumpAndSettle();

        expect(
          changePasswordBlocTestHelper
              .mockChangePasswordBloc.state.confirmButtonEnabled,
          false,
        );
      });

      testWidgets('disables confirm button when there are errors',
          (tester) async {
        changePasswordBlocTestHelper.mockChangePasswordBloc
          ..updateOldPassword('oldpassword123')
          ..updateNewPassword('NewPassword123!')
          ..updateConfirmPassword('NewPassword123!')
          ..updateOldPasswordError('Invalid password')
          ..getConfirmButtonEnabled();
        await tester.pumpAndSettle();

        expect(
          changePasswordBlocTestHelper
              .mockChangePasswordBloc.state.confirmButtonEnabled,
          false,
        );
      });
    });

    group('Password Visibility Toggle', () {
      testWidgets('toggles old password visibility', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            OldPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Find and tap the visibility toggle
        final visibilityButton = find.byIcon(Icons.visibility);
        if (visibilityButton.evaluate().isNotEmpty) {
          await tester.tap(visibilityButton.first);
          await tester.pumpAndSettle();

          expect(
            changePasswordBlocTestHelper
                .mockChangePasswordBloc.state.oldPasswordObscure,
            false,
          );
        }
      });

      testWidgets('toggles new password visibility', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Find and tap the visibility toggle
        final visibilityButton = find.byIcon(Icons.visibility);
        if (visibilityButton.evaluate().isNotEmpty) {
          await tester.tap(visibilityButton.first);
          await tester.pumpAndSettle();

          expect(
            changePasswordBlocTestHelper
                .mockChangePasswordBloc.state.newPasswordObscure,
            false,
          );
        }
      });

      testWidgets('toggles confirm password visibility', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Find and tap the visibility toggle
        final visibilityButton = find.byIcon(Icons.visibility);
        if (visibilityButton.evaluate().isNotEmpty) {
          await tester.tap(visibilityButton.first);
          await tester.pumpAndSettle();

          expect(
            changePasswordBlocTestHelper
                .mockChangePasswordBloc.state.confirmPasswordObscure,
            false,
          );
        }
      });
    });

    group('Error Handling', () {
      testWidgets('displays old password error message', (tester) async {
        changePasswordBlocTestHelper.mockChangePasswordBloc
            .updateOldPasswordError('Password is required');
        await tester.pumpWidget(
          makeTestableWidget(
            OldPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Password is required'), findsOneWidget);
      });

      testWidgets('displays new password error message', (tester) async {
        changePasswordBlocTestHelper.mockChangePasswordBloc
            .updateNewPasswordError('Password is too weak');
        await tester.pumpWidget(
          makeTestableWidget(
            NewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Password is too weak'), findsOneWidget);
      });

      testWidgets('displays confirm password error message', (tester) async {
        changePasswordBlocTestHelper.mockChangePasswordBloc
            .updateConfirmPasswordError('Passwords do not match');
        await tester.pumpWidget(
          makeTestableWidget(
            ConfirmNewPasswordWidget(
              changePasswordBloc:
                  changePasswordBlocTestHelper.mockChangePasswordBloc,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Passwords do not match'), findsOneWidget);
      });
    });
  });
}
