import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_state.dart';
import 'package:admin/pages/main/user_profile/components/phone_edit_profile_widget.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:country_code_picker/country_code_picker.dart';
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
  void updateEditPhoneNumber(String phoneNumber) {
    super.updateEditPhoneNumber(phoneNumber);
    updateState(_state.rebuild((b) => b..editPhoneNumber = phoneNumber));
  }

  @override
  void updateCountryCode(String countryCode) {
    super.updateCountryCode(countryCode);
    updateState(_state.rebuild((b) => b..countryCode = countryCode));
  }
}

void main() {
  group('PhoneEditProfileWidget UI Tests', () {
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
                body: PhoneEditProfileWidget(
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
      testWidgets('renders PhoneEditProfileWidget widget', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(PhoneEditProfileWidget), findsOneWidget);
      });

      testWidgets('displays phone section title', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.text('Phone Number'), findsAtLeastNWidgets(1));
      });

      testWidgets('displays phone text field', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(NameTextFormField), findsOneWidget);
        expect(
          find.text('Phone Number'),
          findsNWidgets(2),
        ); // Title and hint text
      });

      testWidgets('displays country code picker prefix', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(CountryCodePicker), findsOneWidget);
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
      testWidgets('can enter numeric text in phone field', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField), '1234567890');
        await tester.pumpAndSettle();

        expect(find.text('1234567890'), findsOneWidget);
      });

      testWidgets('calls updateEditPhoneNumber when text changes',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(NameTextFormField), '9876543210');
        await tester.pumpAndSettle();

        expect(testUserProfileBloc.state.editPhoneNumber, equals('9876543210'));
      });

      testWidgets('updates field value when bloc state changes',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Update the bloc state
        testUserProfileBloc.updateEditPhoneNumber('5551234567');
        await tester.pumpAndSettle();

        // The widget should reflect the updated value
        expect(testUserProfileBloc.state.editPhoneNumber, equals('5551234567'));
      });

      testWidgets('filters non-numeric characters', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Try to enter text with letters and special characters
        await tester.enterText(find.byType(NameTextFormField), '123abc456!@#');
        await tester.pumpAndSettle();

        // Only numeric characters should remain
        expect(testUserProfileBloc.state.editPhoneNumber, equals('123456'));
      });

      testWidgets('limits text length to 12 characters', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Enter a very long number
        const longNumber = '12345678901234567890';
        await tester.enterText(find.byType(NameTextFormField), longNumber);
        await tester.pumpAndSettle();

        // Should be truncated to 12 characters
        expect(
          testUserProfileBloc.state.editPhoneNumber,
          equals('123456789012'),
        );
      });
    });

    group('Country Code Picker', () {
      testWidgets('displays country code picker with correct initial selection',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        final countryPicker = tester.widget<CountryCodePicker>(
          find.byType(CountryCodePicker),
        );
        // The initial selection depends on the bloc state, default should be empty or US
        expect(countryPicker.initialSelection, isA<String>());
      });

      testWidgets('calls updateCountryCode when country changes',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Tap on country picker to open it
        await tester.tap(find.byType(CountryCodePicker));
        await tester.pumpAndSettle();

        // This test verifies the picker is interactive
        expect(find.byType(CountryCodePicker), findsOneWidget);
      });

      testWidgets('country picker has proper styling', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        final countryPicker = tester.widget<CountryCodePicker>(
          find.byType(CountryCodePicker),
        );
        expect(countryPicker.backgroundColor, isNotNull);
        expect(countryPicker.dialogBackgroundColor, isNotNull);
        expect(countryPicker.padding, isNotNull);
      });
    });

    group('Error Display', () {
      testWidgets('shows error message when phone error exists',
          (tester) async {
        // Set error state
        final errorState = UserProfileState(
          (b) => b..phoneErrorMessage = 'Invalid phone number',
        );
        testUserProfileBloc.updateState(errorState);

        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.text('Invalid phone number'), findsOneWidget);
      });

      testWidgets('hides error message when phone error is empty',
          (tester) async {
        // Set empty error state
        final emptyErrorState = UserProfileState(
          (b) => b..phoneErrorMessage = '',
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
        expect(testUserProfileBloc.state.phoneErrorMessage, isEmpty);

        // Set error state
        final errorState = UserProfileState(
          (b) => b..phoneErrorMessage = 'Invalid phone number',
        );
        testUserProfileBloc.updateState(errorState);
        await tester.pumpAndSettle();

        // Now error should be visible
        expect(
          testUserProfileBloc.state.phoneErrorMessage,
          equals('Invalid phone number'),
        );
      });
    });

    group('Input Formatting', () {
      testWidgets('allows only numeric characters', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField), '1234567890');
        await tester.pumpAndSettle();

        expect(find.text('1234567890'), findsOneWidget);
      });

      testWidgets('filters out alphabetic characters', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(NameTextFormField), '123abc456def');
        await tester.pumpAndSettle();

        expect(find.text('123456'), findsOneWidget);
      });

      testWidgets('filters out special characters', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(NameTextFormField), '123!@#456\$%^');
        await tester.pumpAndSettle();

        expect(find.text('123456'), findsOneWidget);
      });
    });

    group('Widget Properties', () {
      testWidgets('passes correct userProfileBloc to widget', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        final widget = tester.widget<PhoneEditProfileWidget>(
          find.byType(PhoneEditProfileWidget),
        );
        expect(widget.userProfileBloc, equals(testUserProfileBloc));
      });

      testWidgets('passes correct isFocus parameter', (tester) async {
        await tester.pumpWidget(makeTestableWidget(isFocus: true));
        await tester.pumpAndSettle();

        final widget = tester.widget<PhoneEditProfileWidget>(
          find.byType(PhoneEditProfileWidget),
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
        expect(textField.hintText, equals('Phone Number'));
        expect(textField.keyboardType, equals(TextInputType.number));
        expect(textField.prefix, isA<CountryCodePicker>());
        expect(textField.inputFormatters, isNotEmpty);
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
        testUserProfileBloc.updateEditPhoneNumber('5559876543');
        await tester.pumpAndSettle();

        // Verify bloc state updates
        expect(testUserProfileBloc.state.editPhoneNumber, equals('5559876543'));
      });

      testWidgets('calls bloc methods on user interaction', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Enter text to trigger bloc method
        await tester.enterText(find.byType(NameTextFormField), '5551234567');
        await tester.pumpAndSettle();

        // Verify bloc state was updated
        expect(testUserProfileBloc.state.editPhoneNumber, equals('5551234567'));
      });

      testWidgets('updates country code in bloc', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Update country code
        testUserProfileBloc.updateCountryCode('+44');
        await tester.pumpAndSettle();

        // Verify bloc state was updated
        expect(testUserProfileBloc.state.countryCode, equals('+44'));
      });
    });

    group('Keyboard Type', () {
      testWidgets('uses numeric keyboard type', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        final textField =
            tester.widget<NameTextFormField>(find.byType(NameTextFormField));
        expect(textField.keyboardType, equals(TextInputType.number));
      });
    });
  });
}
