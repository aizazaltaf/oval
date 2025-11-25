import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/main/statistics/components/guides/statistics_calendar_guide.dart';
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
      () => startupBlocTestHelper.mockStartupBloc
          .callUpdateGuide(guideKey: any(named: 'guideKey')),
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
                    child: StatisticsCalendarGuide(
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
    expect(find.text('Visitor Statistics'), findsOneWidget);
    // Description
    expect(
      find.text(
        'Select a range to quickly\nmonitor visitor activity \nthroughout the time frame specified.',
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
    expect(
      find.byType(SizedBox),
      findsWidgets,
    ); // Arrow is inside a Row with SizedBox, but asset is SvgPicture
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('OK button triggers updateCurrentGuideKey("chips")',
      (tester) async {
    when(() => mockBloc.updateCurrentGuideKey(any())).thenReturn(null);
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pump();
    verify(() => mockBloc.updateCurrentGuideKey("chips")).called(1);
  });

  testWidgets('Back button triggers updateCurrentGuideKey("dropdown")',
      (tester) async {
    when(() => mockBloc.updateCurrentGuideKey(any())).thenReturn(null);
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back'));
    await tester.pump();
    verify(() => mockBloc.updateCurrentGuideKey("dropdown")).called(1);
  });

  testWidgets('Skip button triggers updateStatisticsGuideShow(true)',
      (tester) async {
    when(() => mockBloc.updateStatisticsGuideShow(any())).thenReturn(null);
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
    await tester.pump();
    verify(() => mockBloc.updateStatisticsGuideShow(true)).called(1);
  });
}
