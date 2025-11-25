import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/notifications/guides/video_call_guide.dart';
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
  group('VideoCallGuide UI Tests', () {
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
                        height: 1200,
                        child: VideoCallGuide(
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
      expect(find.byType(VideoCallGuide), findsOneWidget);
    });

    testWidgets('renders all UI elements', (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      // Arrow icon
      expect(find.byType(SvgPicture), findsOneWidget);

      // OK button
      expect(find.byType(CustomGradientButton), findsOneWidget);

      // Title and description
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              w.data == 'Interact with Visitors from Notifications',
        ),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              w.data == 'Tap the video call option to see the visitor live.',
        ),
        findsOneWidget,
      );

      // Back and Skip buttons
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('pressing OK calls updateCurrentGuideKey("chat")',
        (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      // Find and tap the OK button
      final okButton = find.byType(CustomGradientButton);
      expect(okButton, findsOneWidget);

      await tester.tap(okButton);
      await tester.pump();

      verify(() => mockNotificationBloc.updateCurrentGuideKey("chat"))
          .called(1);
    });

    testWidgets('pressing Back calls updateCurrentGuideKey("audio")',
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

      verify(() => mockNotificationBloc.updateCurrentGuideKey("audio"))
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

      final context = tester.element(find.byType(VideoCallGuide));
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

      final context = tester.element(find.byType(VideoCallGuide));
      final localizations = AppLocalizations.of(context)!;

      // Check title
      expect(
        find.text(localizations.visitor_notification_guide_title),
        findsOneWidget,
      );

      // Check description
      expect(
        find.text(localizations.video_call_guide_desc),
        findsOneWidget,
      );
    });

    testWidgets('integrates properly with ShowCaseWidget', (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      // Verify ShowCaseWidget integration
      expect(find.byType(ShowCaseWidget), findsOneWidget);
      expect(find.byType(VideoCallGuide), findsOneWidget);
    });
  });
}
