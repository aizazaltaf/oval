import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/bloc/states/startup_state.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/notifications/guides/notification_filter_guide.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../helpers/test_helper.dart';

class MockNotificationBloc extends Mock implements NotificationBloc {}

class MockStartupBloc extends Mock implements StartupBloc {}

void main() {
  group('NotificationFilterGuide UI Tests', () {
    late MockNotificationBloc mockNotificationBloc;
    late MockStartupBloc mockStartupBloc;

    setUpAll(() async {
      await TestHelper.initialize();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    setUp(() {
      mockNotificationBloc = MockNotificationBloc();
      mockStartupBloc = MockStartupBloc();

      // Setup default mock behaviors
      when(() => mockNotificationBloc.updateNotificationGuideShow(any()))
          .thenAnswer((_) async {});
      when(() => mockNotificationBloc.updateCurrentGuideKey(any()))
          .thenAnswer((_) async {});
      when(
        () => mockStartupBloc.callUpdateGuide(guideKey: any(named: 'guideKey')),
      ).thenAnswer((_) async {});

      // Mock StartupBloc stream and state
      when(() => mockStartupBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(() => mockStartupBloc.state).thenReturn(
        StartupState(
          (b) => b
            ..everythingApi.replace(ApiState<void>())
            ..doorbellApi.replace(ApiState<BuiltList<UserDeviceModel>>())
            ..doorbellNameEdit = false
            ..doorbellImageVersion = 0
            ..noDoorbellCarouselIndex = 0
            ..monitorCamerasCarouselIndex = 0
            ..refreshSnapshots = false
            ..monitorCameraPinnedList.replace(BuiltList<String>())
            ..canUpdateDoorbellName = false
            ..newDoorbellName = ''
            ..index = 0
            ..isDoorbellConnected = false
            ..splashEnd = false
            ..bottomNavIndexValues.replace(BuiltList<int>([0]))
            ..needDashboardCall = false
            ..indexedStackValue = 0
            ..moreCustomFeatureTileExpanded = false
            ..moreCustomSettingsTileExpanded = false
            ..releaseDoorbellApi.replace(ApiState<void>())
            ..editDoorbellNameApi.replace(ApiState<void>())
            ..setGuideApi.replace(ApiState<void>())
            ..versionApi.replace(ApiState<void>())
            ..appIsUpdated = false,
        ),
      );
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
                value: mockStartupBloc,
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
                      child: NotificationFilterGuide(
                        innerContext: context,
                        bloc: mockNotificationBloc,
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
      expect(find.byType(NotificationFilterGuide), findsOneWidget);
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
          (w) => w is Text && w.data == 'FILTER',
        ),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              w.data ==
                  'Select the desired filter option\nto filter notifications based\non specific criteria.',
        ),
        findsOneWidget,
      );

      // Back and Skip buttons
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('pressing OK calls updateCurrentGuideKey("audio")',
        (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CustomGradientButton));
      await tester.pump();

      verify(() => mockNotificationBloc.updateCurrentGuideKey("audio"))
          .called(1);
    });

    testWidgets('pressing Back calls updateCurrentGuideKey("audio")',
        (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pump();

      verify(() => mockNotificationBloc.updateCurrentGuideKey("audio"))
          .called(1);
    });

    testWidgets('pressing Skip updates guide show and calls update guide',
        (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Skip'));
      await tester.pump();

      verify(() => mockNotificationBloc.updateNotificationGuideShow(true))
          .called(1);
      verify(
        () => mockStartupBloc.callUpdateGuide(
          guideKey: Constants.notificationGuideKey,
        ),
      ).called(1);
    });

    testWidgets('displays correct button labels', (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(NotificationFilterGuide));
      final localizations = AppLocalizations.of(context)!;

      // Check OK button label
      expect(find.text(localizations.general_ok), findsOneWidget);
    });

    testWidgets('displays correct guide title and description', (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(NotificationFilterGuide));
      final localizations = AppLocalizations.of(context)!;

      // Check title
      expect(
        find.text(localizations.notification_filter_guide_title),
        findsOneWidget,
      );

      // Check description
      expect(
        find.text(localizations.notification_filter_guide_desc),
        findsOneWidget,
      );
    });

    testWidgets('integrates properly with ShowCaseWidget', (tester) async {
      await tester.pumpWidget(createTestWidgetWithContext());
      await tester.pumpAndSettle();

      // Verify ShowCaseWidget integration
      expect(find.byType(ShowCaseWidget), findsOneWidget);
      expect(find.byType(NotificationFilterGuide), findsOneWidget);
    });
  });
}
