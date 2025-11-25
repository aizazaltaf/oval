import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/notifications/guides/audio_call_guide.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../../helpers/test_helper.dart';
import '../../../../mocks/bloc/bloc_mocks.dart';

void main() {
  group('AudioCallGuide UI Tests', () {
    late MockNotificationBloc mockNotificationBloc;
    late StartupBlocTestHelper startupBlocTestHelper;

    setUpAll(() async {
      await TestHelper.initialize();

      startupBlocTestHelper = StartupBlocTestHelper()..setup();

      mockNotificationBloc = MockNotificationBloc();
      startupBlocTestHelper.mockStartupBloc = MockStartupBloc();

      // Setup default mock behaviors
      when(() => mockNotificationBloc.updateNotificationGuideShow(any()))
          .thenAnswer((_) async {});
      when(() => mockNotificationBloc.updateCurrentGuideKey(any()))
          .thenAnswer((_) async {});
      when(
        () => startupBlocTestHelper.mockStartupBloc
            .callUpdateGuide(guideKey: any(named: 'guideKey')),
      ).thenAnswer((_) async {});
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget createTestWidgetWithContext() {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<NotificationBloc>.value(
                value: mockNotificationBloc,
              ),
              BlocProvider<StartupBloc>.value(
                value: startupBlocTestHelper.mockStartupBloc,
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''),
              ],
              home: Scaffold(
                body: ShowCaseWidget(
                  builder: (context) => Builder(
                    builder: (context) => SingleChildScrollView(
                      child: SizedBox(
                        height: 1200, // Ensure enough height for the widget
                        child: AudioCallGuide(
                          innerContext: context,
                          bloc: mockNotificationBloc,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    testWidgets('should build without errors', (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();
      expect(find.byType(AudioCallGuide), findsOneWidget);
    });

    testWidgets('renders all UI elements', (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      // Arrow icon
      expect(find.byType(SvgPicture), findsOneWidget);

      // OK button
      expect(find.byType(CustomGradientButton), findsOneWidget);

      // Title and description should be present (as Text widgets)
      expect(find.byType(Text), findsAtLeastNWidgets(3));

      // Back and Skip buttons
      expect(find.byType(TextButton), findsNWidgets(2));
    });

    testWidgets('pressing OK calls updateCurrentGuideKey("video")',
        (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      // Find and tap the OK button
      final okButton = find.byType(CustomGradientButton);
      expect(okButton, findsOneWidget);

      await tester.tap(okButton);
      await tester.pump();

      verify(() => mockNotificationBloc.updateCurrentGuideKey("video"))
          .called(1);
    });

    testWidgets('pressing Back calls updateCurrentGuideKey("filter")',
        (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      // Find and tap the Back button (first TextButton)
      final backButton = find.byType(TextButton).first;
      expect(backButton, findsOneWidget);

      // Use ensureVisible to make sure the button is visible
      await tester.ensureVisible(backButton);
      await tester.pumpAndSettle();

      await tester.tap(backButton);
      await tester.pump();

      verify(() => mockNotificationBloc.updateCurrentGuideKey("filter"))
          .called(1);
    });

    testWidgets('pressing Skip updates guide show and calls update guide',
        (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      // Find and tap the Skip button (second TextButton)
      final skipButton = find.byType(TextButton).last;
      expect(skipButton, findsOneWidget);

      // Use ensureVisible to make sure the button is visible
      await tester.ensureVisible(skipButton);
      await tester.pumpAndSettle();

      await tester.tap(skipButton);
      await tester.pump();

      verify(() => mockNotificationBloc.updateNotificationGuideShow(true))
          .called(1);
      verify(
        () => startupBlocTestHelper.mockStartupBloc.callUpdateGuide(
          guideKey: Constants.notificationGuideKey,
        ),
      ).called(1);
    });

    testWidgets('displays correct button labels', (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(AudioCallGuide));
      final localizations = AppLocalizations.of(context)!;

      // Check OK button label
      expect(find.text(localizations.general_ok), findsOneWidget);

      // Check Back button label
      expect(find.text(localizations.general_back), findsOneWidget);

      // Check Skip button label
      expect(find.text(localizations.general_skip), findsOneWidget);
    });

    testWidgets('displays correct guide title and description', (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(AudioCallGuide));
      final localizations = AppLocalizations.of(context)!;

      // Check title
      expect(
        find.text(localizations.visitor_notification_guide_title),
        findsOneWidget,
      );

      // Check description
      expect(
        find.text(localizations.audio_call_guide_desc),
        findsOneWidget,
      );
    });

    testWidgets('integrates properly with ShowCaseWidget', (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      // Verify ShowCaseWidget integration
      expect(find.byType(ShowCaseWidget), findsOneWidget);
      expect(find.byType(AudioCallGuide), findsOneWidget);
    });

    testWidgets('has correct layout structure', (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      // Check that the main structure is correct
      expect(find.byType(Padding), findsAtLeastNWidgets(2));
      expect(find.byType(Column), findsAtLeastNWidgets(2));
      expect(find.byType(Row), findsAtLeastNWidgets(2));

      // Check for the arrow icon with correct dimensions
      final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(svgPicture.height, equals(60));
      expect(svgPicture.width, equals(60));
    });

    testWidgets('handles button interactions correctly', (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      // Test OK button interaction
      await tester.tap(find.byType(CustomGradientButton));
      await tester.pump();
      verify(() => mockNotificationBloc.updateCurrentGuideKey("video"))
          .called(1);

      // Test Back button interaction - ensure it's visible first
      final backButton = find.byType(TextButton).first;
      await tester.ensureVisible(backButton);
      await tester.pumpAndSettle();
      await tester.tap(backButton);
      await tester.pump();
      verify(() => mockNotificationBloc.updateCurrentGuideKey("filter"))
          .called(1);

      // Test Skip button interaction - ensure it's visible first
      final skipButton = find.byType(TextButton).last;
      await tester.ensureVisible(skipButton);
      await tester.pumpAndSettle();
      await tester.tap(skipButton);
      await tester.pump();
      verify(() => mockNotificationBloc.updateNotificationGuideShow(true))
          .called(1);
      verify(
        () => startupBlocTestHelper.mockStartupBloc.callUpdateGuide(
          guideKey: Constants.notificationGuideKey,
        ),
      ).called(1);
    });
  });
}
