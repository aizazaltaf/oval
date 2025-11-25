import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/main/statistics/components/guides/statistics_dropdown_guide.dart';
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
                    child: StatisticsDropdownGuide(
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
    expect(find.text('Graph Selection'), findsOneWidget);
    // Description
    expect(
      find.text(
        'View your visitor data by\nselecting the graph that\nbest suits your needs.',
      ),
      findsOneWidget,
    );
    // OK button
    expect(find.text('OK'), findsOneWidget);
    // Skip button
    expect(find.text('Skip'), findsOneWidget);
    // Arrow asset
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('OK button triggers updateCurrentGuideKey("calendar")',
      (tester) async {
    when(() => mockBloc.updateCurrentGuideKey(any())).thenReturn(null);
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pump();
    verify(() => mockBloc.updateCurrentGuideKey("calendar")).called(1);
  });

  testWidgets(
      'Skip button triggers updateStatisticsGuideShow(true) and callUpdateGuide',
      (tester) async {
    when(() => mockBloc.updateStatisticsGuideShow(any())).thenReturn(null);
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    final skipButton = find.text('Skip');
    await tester.scrollUntilVisible(
      skipButton,
      100,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    await tester.tap(skipButton);
    await tester.pump();

    verify(() => mockBloc.updateStatisticsGuideShow(true)).called(1);
    verify(
      () => startupBlocTestHelper.mockStartupBloc
          .callUpdateGuide(guideKey: 'statistics_guide'),
    ).called(1);
  });
}
