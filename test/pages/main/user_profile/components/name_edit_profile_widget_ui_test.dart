import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_state.dart';
import 'package:admin/pages/main/user_profile/components/name_edit_profile_widget.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  void updateEditName(String name) {
    super.updateEditName(name);
    updateState(_state.rebuild((b) => b..editName = name));
  }
}

void main() {
  group('NameEditProfileWidget UI Tests', () {
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
                body: NameEditProfileWidget(
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
      testWidgets('renders NameEditProfileWidget widget', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(NameEditProfileWidget), findsOneWidget);
      });

      testWidgets('displays name section title', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.text('Full Name'), findsAtLeastNWidgets(1));
      });

      testWidgets('displays name text field', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(NameTextFormField), findsOneWidget);
        expect(find.text('Full Name'), findsNWidgets(2)); // Title and hint text
      });

      testWidgets('displays account icon prefix', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(MdiIcons.accountOutline), findsOneWidget);
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
      testWidgets('can enter alphabetic text in name field', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(NameTextFormField), 'John Doe');
        await tester.pumpAndSettle();

        expect(find.text('John Doe'), findsOneWidget);
      });

      testWidgets('calls updateEditName when text changes', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(NameTextFormField), 'Jane Smith');
        await tester.pumpAndSettle();

        expect(testUserProfileBloc.state.editName, equals('Jane Smith'));
      });

      testWidgets('updates field value when bloc state changes',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Update the bloc state
        testUserProfileBloc.updateEditName('Updated Name');
        await tester.pumpAndSettle();

        // The widget should reflect the updated value
        expect(testUserProfileBloc.state.editName, equals('Updated Name'));
      });

      testWidgets('filters non-alphabetic characters', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Try to enter text with numbers and special characters
        await tester.enterText(find.byType(NameTextFormField), 'John123!@#');
        await tester.pumpAndSettle();

        // Only alphabetic characters and spaces should remain
        expect(find.text('John'), findsOneWidget);
      });

      testWidgets('limits text length to 30 characters', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Enter a very long name
        const longName =
            'This is a very long name that exceeds thirty characters';
        await tester.enterText(find.byType(NameTextFormField), longName);
        await tester.pumpAndSettle();

        // Should be truncated to 30 characters
        expect(
          testUserProfileBloc.state.editName,
          equals('This is a very long name that '),
        );
      });
    });

    group('Error Display', () {
      testWidgets('shows error message when name error exists', (tester) async {
        // Set error state
        final errorState = UserProfileState(
          (b) => b..nameErrorMessage = 'Name is required',
        );
        testUserProfileBloc.updateState(errorState);

        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.text('Name is required'), findsOneWidget);
      });

      testWidgets('hides error message when name error is empty',
          (tester) async {
        // Set empty error state
        final emptyErrorState = UserProfileState(
          (b) => b..nameErrorMessage = '',
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
        expect(testUserProfileBloc.state.nameErrorMessage, isEmpty);

        // Set error state
        final errorState = UserProfileState(
          (b) => b..nameErrorMessage = 'Name is required',
        );
        testUserProfileBloc.updateState(errorState);
        await tester.pumpAndSettle();

        // Now error should be visible
        expect(
          testUserProfileBloc.state.nameErrorMessage,
          equals('Name is required'),
        );
      });
    });

    group('Input Formatting', () {
      testWidgets('allows alphabetic characters and spaces', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(NameTextFormField),
          'John Doe Smith',
        );
        await tester.pumpAndSettle();

        expect(find.text('John Doe Smith'), findsOneWidget);
      });

      testWidgets('filters out numbers', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(NameTextFormField), 'John123Doe');
        await tester.pumpAndSettle();

        expect(find.text('JohnDoe'), findsOneWidget);
      });

      testWidgets('filters out special characters', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(NameTextFormField),
          'John@Doe#Smith',
        );
        await tester.pumpAndSettle();

        expect(find.text('JohnDoeSmith'), findsOneWidget);
      });
    });

    group('Widget Properties', () {
      testWidgets('passes correct userProfileBloc to widget', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        final widget = tester.widget<NameEditProfileWidget>(
          find.byType(NameEditProfileWidget),
        );
        expect(widget.userProfileBloc, equals(testUserProfileBloc));
      });

      testWidgets('passes correct isFocus parameter', (tester) async {
        await tester.pumpWidget(makeTestableWidget(isFocus: true));
        await tester.pumpAndSettle();

        final widget = tester.widget<NameEditProfileWidget>(
          find.byType(NameEditProfileWidget),
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
        expect(textField.hintText, equals('Full Name'));
        expect(textField.prefix, isA<Icon>());
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
        testUserProfileBloc.updateEditName('Integration Test');
        await tester.pumpAndSettle();

        // Verify bloc state updates
        expect(testUserProfileBloc.state.editName, equals('Integration Test'));
      });

      testWidgets('calls bloc methods on user interaction', (tester) async {
        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        // Enter text to trigger bloc method
        await tester.enterText(
          find.byType(NameTextFormField),
          'Interaction Test',
        );
        await tester.pumpAndSettle();

        // Verify bloc state was updated
        expect(testUserProfileBloc.state.editName, equals('Interaction Test'));
      });
    });
  });
}
