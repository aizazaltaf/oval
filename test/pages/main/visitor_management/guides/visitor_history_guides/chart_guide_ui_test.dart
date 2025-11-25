import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/guides/visitor_history_guides/chart_guide.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../../../helpers/bloc_helpers/visitor_management_bloc_test_helper.dart';
import '../../../../../helpers/fake_build_context.dart';
import '../../../../../helpers/test_helper.dart';
import '../../../../../mocks/bloc/bloc_mocks.dart';

late VisitorManagementBlocTestHelper visitorManagementBlocHelper;
late StartupBlocTestHelper startupBlocTestHelper;

Widget _buildTestWidget(Widget child) {
  return FlutterSizer(
    builder: (context, orientation, deviceType) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en', 'US'),
        home: Scaffold(
          body: BlocProvider<VisitorManagementBloc>.value(
            value: visitorManagementBlocHelper.mockVisitorManagementBloc,
            child: BlocProvider<StartupBloc>.value(
              value: startupBlocTestHelper.mockStartupBloc,
              child: ShowCaseWidget(
                builder: (context) => child,
              ),
            ),
          ),
        ),
      );
    },
  );
}

void main() {
  setUpAll(() async {
    startupBlocTestHelper = StartupBlocTestHelper()..setup();
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(VisitorsModelFake());
    await TestHelper.initialize();
    visitorManagementBlocHelper = VisitorManagementBlocTestHelper();
    startupBlocTestHelper.mockStartupBloc = MockStartupBloc();
  });

  setUp(() {
    visitorManagementBlocHelper.setup();
    reset(startupBlocTestHelper.mockStartupBloc);
    reset(visitorManagementBlocHelper.mockVisitorManagementBloc);
    when(
      () => startupBlocTestHelper.mockStartupBloc
          .callUpdateGuide(guideKey: any(named: 'guideKey')),
    ).thenAnswer((_) async {});
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
    visitorManagementBlocHelper.dispose();
  });

  group('ChartGuide Widget Tests', () {
    testWidgets('should build without errors', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          Builder(
            builder: (context) => ChartGuide(
              innerContext: context,
              bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ChartGuide), findsOneWidget);
    });

    testWidgets('displays OK button', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          Builder(
            builder: (context) => ChartGuide(
              innerContext: context,
              bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(ChartGuide));
      final localizations = AppLocalizations.of(context)!;
      expect(find.text(localizations.general_ok), findsOneWidget);
      expect(find.byType(CustomGradientButton), findsOneWidget);
    });

    testWidgets('displays skip button', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          Builder(
            builder: (context) => ChartGuide(
              innerContext: context,
              bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(ChartGuide));
      final localizations = AppLocalizations.of(context)!;
      expect(find.text(localizations.general_skip), findsOneWidget);
    });

    testWidgets('displays guide title and description', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          Builder(
            builder: (context) => ChartGuide(
              innerContext: context,
              bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(ChartGuide));
      final localizations = AppLocalizations.of(context)!;
      expect(find.text(localizations.chart_guide_title), findsOneWidget);
      expect(find.text(localizations.chart_guide_desc), findsOneWidget);
    });

    testWidgets('OK button triggers updateCurrentGuideKey', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          Builder(
            builder: (context) => ChartGuide(
              innerContext: context,
              bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(ChartGuide));
      final localizations = AppLocalizations.of(context)!;
      final okButton =
          find.widgetWithText(CustomGradientButton, localizations.general_ok);
      await tester.tap(okButton);
      await tester.pumpAndSettle();
      verify(
        () => visitorManagementBlocHelper.mockVisitorManagementBloc
            .updateCurrentGuideKey("history_list"),
      ).called(1);
    });

    testWidgets('Skip button triggers skip logic', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          Builder(
            builder: (context) => ChartGuide(
              innerContext: context,
              bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(ChartGuide));
      final localizations = AppLocalizations.of(context)!;
      final skipButton =
          find.widgetWithText(TextButton, localizations.general_skip);
      await tester.tap(skipButton);
      await tester.pumpAndSettle();
      verify(
        () => visitorManagementBlocHelper.mockVisitorManagementBloc
            .updateHistoryGuideShow(true),
      ).called(1);
      verify(
        () => startupBlocTestHelper.mockStartupBloc
            .callUpdateGuide(guideKey: any(named: 'guideKey')),
      ).called(1);
    });
  });
}
