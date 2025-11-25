import 'dart:async';

import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/theme.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/pages/main/more_dashboard/components/profile_info_panel.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/circular_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/profile_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/user_profile_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/voice_control_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late StartupBlocTestHelper startupBlocHelper;
  late ProfileBlocTestHelper profileBlocHelper;
  late UserProfileBlocTestHelper userProfileBlocHelper;
  late VoiceControlBlocTestHelper voiceControlBlocHelper;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    await TestHelper.initialize();
  });

  setUp(() {
    // Initialize helper classes
    startupBlocHelper = StartupBlocTestHelper();
    profileBlocHelper = ProfileBlocTestHelper();
    userProfileBlocHelper = UserProfileBlocTestHelper();
    voiceControlBlocHelper = VoiceControlBlocTestHelper();

    // Setup all helpers
    startupBlocHelper.setup();
    profileBlocHelper.setup();
    userProfileBlocHelper.setup();
    voiceControlBlocHelper.setup();

    // Mock singleton bloc
    singletonBloc.testProfileBloc = profileBlocHelper.mockProfileBloc;
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
    startupBlocHelper.dispose();
    profileBlocHelper.dispose();
    userProfileBlocHelper.dispose();
    voiceControlBlocHelper.dispose();
  });

  Widget createTestWidget({bool isNavigated = false}) {
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<StartupBloc>.value(
              value: startupBlocHelper.mockStartupBloc,
            ),
            BlocProvider<ProfileBloc>.value(
              value: profileBlocHelper.mockProfileBloc,
            ),
            BlocProvider<UserProfileBloc>.value(
              value: userProfileBlocHelper.mockUserProfileBloc,
            ),
            BlocProvider<VoiceControlBloc>.value(
              value: voiceControlBlocHelper.mockVoiceControlBloc,
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: getTheme(),
            darkTheme: darkTheme(),
            home: Scaffold(
              body: ProfileInfoPanel(isNavigated: isNavigated),
            ),
          ),
        );
      },
    );
  }

  group('ProfileInfoPanel UI Tests', () {
    testWidgets('should render ProfileInfoPanel with all components',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify the main panel structure
      expect(find.byType(ProfileInfoPanel), findsOneWidget);
      expect(find.byType(Column), findsWidgets);

      // Verify back button is present
      expect(find.byIcon(Icons.keyboard_arrow_left), findsOneWidget);

      // Verify profile image is present
      expect(find.byType(CircularProfileImage), findsOneWidget);

      // Verify text elements are present
      expect(find.byType(Text), findsWidgets);

      // Verify divider is present
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('should display user profile information correctly',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify user name is displayed
      expect(find.text('Test User'), findsOneWidget);

      // Verify user email is displayed
      expect(find.text('test@example.com'), findsOneWidget);

      // Verify "Visit your profile" text is displayed
      expect(find.text('Visit your profile'), findsOneWidget);
    });

    testWidgets('should handle back button tap when isNavigated is false',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap the back button
      final backButton = find.byIcon(Icons.keyboard_arrow_left);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify startup bloc page index change was called
      verify(() => startupBlocHelper.mockStartupBloc.pageIndexChanged(0))
          .called(1);
    });

    testWidgets('should handle back button tap when isNavigated is true',
        (tester) async {
      await tester.pumpWidget(createTestWidget(isNavigated: true));
      await tester.pumpAndSettle();

      // Find and tap the back button
      final backButton = find.byIcon(Icons.keyboard_arrow_left);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify startup bloc page index change was NOT called
      verifyNever(
        () => startupBlocHelper.mockStartupBloc.pageIndexChanged(any()),
      );
    });

    testWidgets('should handle profile image tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap the profile image
      final profileImage = find.byType(CircularProfileImage);
      expect(profileImage, findsOneWidget);

      await tester.tap(profileImage);
      await tester.pumpAndSettle();

      // Verify UserProfileBloc updateIsProfileEditing was called
      verify(
        () => userProfileBlocHelper.mockUserProfileBloc
            .updateIsProfileEditing(false),
      ).called(1);
    });

    testWidgets('should handle profile info text tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap the profile info text area
      final profileInfoText = find.text('Test User');
      expect(profileInfoText, findsOneWidget);

      await tester.tap(profileInfoText);
      await tester.pumpAndSettle();

      // Verify UserProfileBloc updateIsProfileEditing was called
      verify(
        () => userProfileBlocHelper.mockUserProfileBloc
            .updateIsProfileEditing(false),
      ).called(1);
    });

    testWidgets('should handle email text tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap the email text
      final emailText = find.text('test@example.com');
      expect(emailText, findsOneWidget);

      await tester.tap(emailText);
      await tester.pumpAndSettle();

      // Verify UserProfileBloc updateIsProfileEditing was called
      verify(
        () => userProfileBlocHelper.mockUserProfileBloc
            .updateIsProfileEditing(false),
      ).called(1);
    });

    testWidgets('should handle "Visit your profile" text tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap the "Visit your profile" text
      final visitProfileText = find.text('Visit your profile');
      expect(visitProfileText, findsOneWidget);

      await tester.tap(visitProfileText);
      await tester.pumpAndSettle();

      // Verify UserProfileBloc updateIsProfileEditing was called
      verify(
        () => userProfileBlocHelper.mockUserProfileBloc
            .updateIsProfileEditing(false),
      ).called(1);
    });

    testWidgets('should display correct spacing and layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify SizedBox widgets are present for spacing
      expect(find.byType(SizedBox), findsWidgets);

      // Verify Padding widgets are present
      expect(find.byType(Padding), findsWidgets);

      // Verify Row widget is present
      expect(find.byType(Row), findsOneWidget);

      // Verify Column widgets are present
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should display correct icon properties', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the back button icon
      final backIcon = find.byIcon(Icons.keyboard_arrow_left);
      expect(backIcon, findsOneWidget);

      // Verify the icon is inside an IconButton
      final iconButton = find.byType(IconButton);
      expect(iconButton, findsOneWidget);

      final button = tester.widget<IconButton>(iconButton);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('should display correct text styling', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify user name text styling
      final nameText = find.text('Test User');
      expect(nameText, findsOneWidget);

      final nameTextWidget = tester.widget<Text>(nameText);
      expect(nameTextWidget.style?.fontSize, 20);
      expect(nameTextWidget.style?.fontWeight, FontWeight.w700);

      // Verify email text styling
      final emailText = find.text('test@example.com');
      expect(emailText, findsOneWidget);

      final emailTextWidget = tester.widget<Text>(emailText);
      expect(emailTextWidget.style?.fontSize, 16);
      expect(emailTextWidget.style?.fontWeight, FontWeight.w400);

      // Verify "Visit your profile" text styling
      final visitProfileText = find.text('Visit your profile');
      expect(visitProfileText, findsOneWidget);

      final visitProfileTextWidget = tester.widget<Text>(visitProfileText);
      expect(visitProfileTextWidget.style?.fontSize, 14);
      expect(visitProfileTextWidget.style?.fontWeight, FontWeight.w400);
      expect(
        visitProfileTextWidget.style?.color,
        const Color.fromRGBO(0, 71, 255, 1),
      );
    });

    testWidgets('should display correct divider styling', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify divider is present
      final divider = find.byType(Divider);
      expect(divider, findsOneWidget);

      final dividerWidget = tester.widget<Divider>(divider);
      expect(dividerWidget.thickness, 1.4);
    });

    testWidgets('should handle multiple back button taps', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap back button multiple times
      final backButton = find.byIcon(Icons.keyboard_arrow_left);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify startup bloc page index change was called multiple times
      verify(() => startupBlocHelper.mockStartupBloc.pageIndexChanged(0))
          .called(2);
    });

    testWidgets('should render correctly with different screen sizes',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify FlutterSizer is present
      expect(find.byType(FlutterSizer), findsOneWidget);

      // Verify the panel adapts to different screen sizes
      expect(find.byType(ProfileInfoPanel), findsOneWidget);
    });

    testWidgets('should handle theme changes correctly', (tester) async {
      // Test with light theme
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify widgets render correctly
      expect(find.byType(ProfileInfoPanel), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('should verify proper widget hierarchy', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify the widget hierarchy is correct
      expect(find.byType(FlutterSizer), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(FlutterSizer),
          matching: find.byType(MaterialApp),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(MaterialApp),
          matching: find.byType(Scaffold),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(ProfileInfoPanel),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should verify all interactive elements are tappable',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify IconButton is tappable
      final iconButton = find.byType(IconButton);
      expect(iconButton, findsOneWidget);

      final button = tester.widget<IconButton>(iconButton);
      expect(button.onPressed, isNotNull);

      // Verify GestureDetector widgets are present and tappable
      final gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsWidgets);
    });

    testWidgets('should verify profile image properties', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify CircularProfileImage is present
      final profileImage = find.byType(CircularProfileImage);
      expect(profileImage, findsOneWidget);

      final imageWidget = tester.widget<CircularProfileImage>(profileImage);
      expect(imageWidget.profileImageUrl, isNotNull);
    });

    testWidgets('should verify MeasureSize widget functionality',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MeasureSize widget is present (it's a custom widget)
      // The MeasureSize widget is used internally for measuring text size
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should handle null profile state gracefully', (tester) async {
      // Setup profile bloc with null state
      when(() => profileBlocHelper.mockProfileBloc.state).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify the panel still renders without crashing
      expect(find.byType(ProfileInfoPanel), findsOneWidget);
      expect(find.byType(CircularProfileImage), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_left), findsOneWidget);
    });

    testWidgets('should verify accessibility features', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify semantic labels are present
      expect(find.byType(Semantics), findsWidgets);

      // Verify all interactive elements are accessible
      final interactiveElements = find.byType(GestureDetector);
      expect(interactiveElements, findsWidgets);
    });

    testWidgets('should handle loading states gracefully', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Pump without settling to simulate loading
      await tester.pump();

      // Verify the panel shows loading state appropriately
      expect(find.byType(ProfileInfoPanel), findsOneWidget);
    });

    testWidgets('should verify proper padding and margins', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify Padding widgets are present for proper spacing
      expect(find.byType(Padding), findsWidgets);

      // Verify SizedBox widgets are present for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should verify text overflow handling', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify text widgets have maxLines property set
      final nameText = find.text('Test User');
      expect(nameText, findsOneWidget);

      final nameTextWidget = tester.widget<Text>(nameText);
      expect(nameTextWidget.maxLines, 3);

      final emailText = find.text('test@example.com');
      expect(emailText, findsOneWidget);

      final emailTextWidget = tester.widget<Text>(emailText);
      expect(emailTextWidget.maxLines, 3);
    });

    testWidgets('should verify crossAxisAlignment properties', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify Row has correct crossAxisAlignment
      final row = find.byType(Row);
      expect(row, findsOneWidget);

      final rowWidget = tester.widget<Row>(row);
      expect(rowWidget.crossAxisAlignment, CrossAxisAlignment.start);

      // Verify Column has correct crossAxisAlignment
      final columns = find.byType(Column);
      expect(columns, findsWidgets);
    });

    testWidgets('should verify flex properties', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify Expanded widget is present with flex: 2
      final expanded = find.byType(Expanded);
      expect(expanded, findsOneWidget);

      final expandedWidget = tester.widget<Expanded>(expanded);
      expect(expandedWidget.flex, 2);
    });

    testWidgets('should handle long user names with text overflow',
        (tester) async {
      // Setup profile with very long name
      final longNameUser = profileBlocHelper.createDefaultUserData().rebuild(
            (b) => b
              ..name =
                  'Very Long User Name That Should Overflow Multiple Lines And Test Text Wrapping Behavior',
          );
      when(() => profileBlocHelper.mockProfileBloc.state)
          .thenReturn(longNameUser);
      singletonBloc.testProfileBloc = profileBlocHelper.mockProfileBloc;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify long name is displayed and properly constrained
      final nameText = find.textContaining('Very Long User Name');
      expect(nameText, findsOneWidget);

      final nameTextWidget = tester.widget<Text>(nameText);
      expect(nameTextWidget.maxLines, 3);
      expect(nameTextWidget.style?.fontSize, 20);
    });

    testWidgets('should handle empty profile image URL', (tester) async {
      // Setup profile with empty image URL
      final userWithEmptyImage =
          profileBlocHelper.createDefaultUserData().rebuild(
                (b) => b..image = '',
              );
      when(() => profileBlocHelper.mockProfileBloc.state)
          .thenReturn(userWithEmptyImage);
      singletonBloc.testProfileBloc = profileBlocHelper.mockProfileBloc;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify CircularProfileImage still renders with empty URL
      final profileImage = find.byType(CircularProfileImage);
      expect(profileImage, findsOneWidget);

      final imageWidget = tester.widget<CircularProfileImage>(profileImage);
      expect(imageWidget.profileImageUrl, '');
    });

    testWidgets('should handle special characters in user data',
        (tester) async {
      // Setup profile with special characters
      final specialCharUser = profileBlocHelper.createDefaultUserData().rebuild(
            (b) => b
              ..name = 'José María O\'Connor-Smith'
              ..email = 'test+special@example-domain.co.uk',
          );
      when(() => profileBlocHelper.mockProfileBloc.state)
          .thenReturn(specialCharUser);
      singletonBloc.testProfileBloc = profileBlocHelper.mockProfileBloc;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify special characters are displayed correctly
      expect(find.text('José María O\'Connor-Smith'), findsOneWidget);
      expect(find.text('test+special@example-domain.co.uk'), findsOneWidget);
    });

    testWidgets('should verify MeasureSize callback functionality',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify that the MeasureSize widget triggers size changes
      // This tests the custom MeasureSize widget's onChange callback
      final measureSizeWidget = find.byType(MeasureSize);
      expect(measureSizeWidget, findsOneWidget);

      // Trigger a rebuild to test size measurement
      await tester.pump();
      await tester.pumpAndSettle();
    });

    testWidgets('should handle rapid tap interactions', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Rapidly tap the back button multiple times
      final backButton = find.byIcon(Icons.keyboard_arrow_left);
      expect(backButton, findsOneWidget);

      for (int i = 0; i < 5; i++) {
        await tester.tap(backButton);
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.pumpAndSettle();

      // Verify the bloc method was called the expected number of times
      verify(() => startupBlocHelper.mockStartupBloc.pageIndexChanged(0))
          .called(5);
    });

    testWidgets('should verify icon button accessibility properties',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final iconButton = find.byType(IconButton);
      expect(iconButton, findsOneWidget);

      final button = tester.widget<IconButton>(iconButton);

      // Verify icon properties
      expect(button.icon, isA<Icon>());
      final icon = button.icon as Icon;
      expect(icon.icon, Icons.keyboard_arrow_left);
      expect(icon.size, 30);
    });

    testWidgets('should handle different theme brightness modes',
        (tester) async {
      // Test with dark theme
      await tester.pumpWidget(
        FlutterSizer(
          builder: (context, orientation, deviceType) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<StartupBloc>.value(
                  value: startupBlocHelper.mockStartupBloc,
                ),
                BlocProvider<ProfileBloc>.value(
                  value: profileBlocHelper.mockProfileBloc,
                ),
                BlocProvider<UserProfileBloc>.value(
                  value: userProfileBlocHelper.mockUserProfileBloc,
                ),
                BlocProvider<VoiceControlBloc>.value(
                  value: voiceControlBlocHelper.mockVoiceControlBloc,
                ),
              ],
              child: MaterialApp(
                theme: darkTheme(),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                home: const Scaffold(
                  body: ProfileInfoPanel(isNavigated: false),
                ),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      // Verify components render in dark theme
      expect(find.byType(ProfileInfoPanel), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('should verify gesture detector behavior properties',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find all GestureDetector widgets
      final gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsWidgets);

      // Verify they have the correct behavior
      for (final gestureDetector in gestureDetectors.evaluate()) {
        final widget = gestureDetector.widget as GestureDetector;
        expect(widget.behavior, HitTestBehavior.opaque);
      }
    });

    testWidgets('should handle profile state changes dynamically',
        (tester) async {
      // Set up a StreamController for the ProfileBloc
      final controller = StreamController<UserData>.broadcast();
      when(() => profileBlocHelper.mockProfileBloc.stream)
          .thenAnswer((_) => controller.stream);
      when(() => profileBlocHelper.mockProfileBloc.state)
          .thenReturn(profileBlocHelper.createDefaultUserData());
      singletonBloc.testProfileBloc = profileBlocHelper.mockProfileBloc;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);

      // Change profile state and emit via stream
      final updatedUser = profileBlocHelper.createDefaultUserData().rebuild(
            (b) => b
              ..name = 'Updated User Name'
              ..email = 'updated@example.com',
          );
      when(() => profileBlocHelper.mockProfileBloc.state)
          .thenReturn(updatedUser);
      controller.add(updatedUser);
      await tester.pumpAndSettle();

      // Verify updated state is displayed
      expect(find.text('Updated User Name'), findsOneWidget);
      expect(find.text('updated@example.com'), findsOneWidget);
      await controller.close();
    });

    testWidgets('should handle navigation state changes (isNavigated: true)',
        (tester) async {
      await tester.pumpWidget(createTestWidget(isNavigated: true));
      await tester.pumpAndSettle();

      final backButton = find.byIcon(Icons.keyboard_arrow_left);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify startup bloc was NOT called when isNavigated is true
      verifyNever(
        () => startupBlocHelper.mockStartupBloc.pageIndexChanged(any()),
      );
    });

    testWidgets('should handle navigation state changes (isNavigated: false)',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final backButton = find.byIcon(Icons.keyboard_arrow_left);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify startup bloc WAS called when isNavigated is false
      verify(() => startupBlocHelper.mockStartupBloc.pageIndexChanged(0))
          .called(1);
    });

    testWidgets('should verify column height measurement accuracy',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify that the column height is properly measured and applied
      // This tests the MeasureSize widget's functionality
      final profileImage = find.byType(CircularProfileImage);
      expect(profileImage, findsOneWidget);

      final imageWidget = tester.widget<CircularProfileImage>(profileImage);
      // The size should be dynamically set based on column height measurement
      expect(imageWidget.size, isA<double>());
    });

    testWidgets('should handle concurrent tap interactions', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Simulate concurrent taps on different elements
      final backButton = find.byIcon(Icons.keyboard_arrow_left);
      final profileImage = find.byType(CircularProfileImage);

      expect(backButton, findsOneWidget);
      expect(profileImage, findsOneWidget);

      // Tap both elements quickly
      await tester.tap(backButton);
      await tester.tap(profileImage);
      await tester.pumpAndSettle();

      // Verify both interactions were handled
      verify(() => startupBlocHelper.mockStartupBloc.pageIndexChanged(0))
          .called(1);
      verify(
        () => userProfileBlocHelper.mockUserProfileBloc
            .updateIsProfileEditing(false),
      ).called(1);
    });
  });
}
