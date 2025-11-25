import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/main/statistics/components/guides/statistics_chips_guide.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../../mocks/bloc/bloc_mocks.dart';

void main() {
  late MockStatisticsBloc mockBloc;
  late StartupBlocTestHelper startupBlocTestHelper;

  setUp(() {
    startupBlocTestHelper = StartupBlocTestHelper()..setup();
    mockBloc = MockStatisticsBloc();
    startupBlocTestHelper.mockStartupBloc = MockStartupBloc();
    when(
      () => startupBlocTestHelper.mockStartupBloc.callUpdateGuide(
        guideKey: any(named: 'guideKey'),
      ),
    ).thenAnswer((_) async {});
  });

  Widget buildTestWidget() {
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Builder(
            builder: (context) {
              return BlocProvider<StartupBloc>.value(
                value: startupBlocTestHelper.mockStartupBloc,
                child: ShowCaseWidget(
                  builder: (showcaseContext) => SingleChildScrollView(
                    child: StatisticsChipsGuide(
                      innerContext: showcaseContext,
                      bloc: mockBloc,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  testWidgets('renders all expected texts and arrow asset', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Title
    expect(find.text('Filter Visitor Statistics'), findsOneWidget);
    // Description
    expect(
      find.text(
        'Select the desired filter option\nto rapidly observe visitor\nactivity within the given period.',
      ),
      findsOneWidget,
    );
    // OK button
    expect(find.text('OK'), findsOneWidget);
    // Back button
    expect(find.text('Back'), findsOneWidget);
    // Skip button
    expect(find.text('Skip'), findsOneWidget);
    // Arrow asset
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets(
      'OK button triggers updateStatisticsGuideShow(true) and callUpdateGuide',
      (tester) async {
    when(() => mockBloc.updateStatisticsGuideShow(any())).thenReturn(null);
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pump();
    verify(() => mockBloc.updateStatisticsGuideShow(true)).called(1);
    verify(
      () => startupBlocTestHelper.mockStartupBloc
          .callUpdateGuide(guideKey: any(named: 'guideKey')),
    ).called(1);
  });

  testWidgets('Back button triggers updateCurrentGuideKey("calendar")',
      (tester) async {
    when(() => mockBloc.updateCurrentGuideKey(any())).thenReturn(null);
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back'));
    await tester.pump();
    verify(() => mockBloc.updateCurrentGuideKey("calendar")).called(1);
  });

  testWidgets(
      'Skip button triggers updateStatisticsGuideShow(true) and callUpdateGuide',
      (tester) async {
    when(() => mockBloc.updateStatisticsGuideShow(any())).thenReturn(null);
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
    await tester.pump();
    verify(() => mockBloc.updateStatisticsGuideShow(true)).called(1);
    verify(
      () => startupBlocTestHelper.mockStartupBloc
          .callUpdateGuide(guideKey: any(named: 'guideKey')),
    ).called(1);
  });
}
