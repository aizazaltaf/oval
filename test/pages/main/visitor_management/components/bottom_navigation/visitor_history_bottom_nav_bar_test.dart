import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_state.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/bottom_navigation/visitor_history_bottom_nav_bar.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/bloc_helpers/visitor_management_bloc_test_helper.dart';
import '../../../../../helpers/fake_build_context.dart';
import '../../../../../helpers/test_helper.dart';

void main() {
  late VisitorManagementBlocTestHelper visitorManagementBlocTestHelper;
  late VisitorsModel visitor;

  setUpAll(() {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(VisitorsModelFake());
    visitorManagementBlocTestHelper = VisitorManagementBlocTestHelper();
    visitor = VisitorsModel(
      (b) => b
        ..id = 1
        ..name = 'John Doe'
        ..imageUrl = 'http://example.com/image.png'
        ..isWanted = 0
        ..lastVisit = '2024-06-01T10:00:00.000Z',
    );
    VisitorManagementState(
      (b) => b..deleteVisitorHistoryIdsList = ListBuilder<String>([]),
    );
    registerFallbackValue(
      VisitorManagementState(
        (b) => b..deleteVisitorHistoryIdsList = ListBuilder<String>([]),
      ),
    );
  });

  setUp(() {
    visitorManagementBlocTestHelper.setup();
    when(
      () => visitorManagementBlocTestHelper.mockVisitorManagementBloc
          .updateDeleteVisitorHistoryIdsList(any()),
    ).thenReturn(null);
    visitorManagementBlocTestHelper.mockVisitorManagementBloc
        .setMockCallEditVisitorName(
      (id, {fromVisitorHistory = false}) async {},
    );
    // Ensure the cancel button is rendered by stubbing deleteVisitorHistoryIdsList
    when(
      () => visitorManagementBlocTestHelper
          .currentVisitorManagementState.deleteVisitorHistoryIdsList,
    ).thenReturn(BuiltList<String>(["dummy"]));
  });

  Widget buildTestableWidget(Widget child) {
    return FlutterSizer(
      builder: (context, orientation, deviceType) => MultiBlocProvider(
        providers: [
          BlocProvider<VisitorManagementBloc>.value(
            value: visitorManagementBlocTestHelper.mockVisitorManagementBloc,
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
            Locale('en'),
          ],
          home: BlocProvider<VisitorManagementBloc>.value(
            value: visitorManagementBlocTestHelper.mockVisitorManagementBloc,
            child: child,
          ),
        ),
      ),
    );
  }

  testWidgets('renders bottom nav bar', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        Builder(
          builder: (context) {
            return VisitorHistoryBottomNavBar(
              visitor: visitor,
              bloc: visitorManagementBlocTestHelper.mockVisitorManagementBloc,
              parentContext: context,
              innerContext: context,
            );
          },
        ),
      ),
    );
    expect(find.byType(VisitorHistoryBottomNavBar), findsOneWidget);
  });

  testWidgets('cancel button calls bloc method', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        Builder(
          builder: (context) {
            return VisitorHistoryBottomNavBar(
              visitor: visitor,
              bloc: visitorManagementBlocTestHelper.mockVisitorManagementBloc,
              parentContext: context,
              innerContext: context,
            );
          },
        ),
      ),
    );
    await tester.tap(find.textContaining('Cancel'));
    verify(
      () => visitorManagementBlocTestHelper.mockVisitorManagementBloc
          .updateDeleteVisitorHistoryIdsList(null),
    ).called(1);
  });
}
