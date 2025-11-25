import 'package:admin/models/data/statistics_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_state.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/visitor_info_card.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/bloc_helpers/visitor_management_bloc_test_helper.dart';
import '../../../../helpers/fake_build_context.dart';
import '../../../../helpers/test_helper.dart';
import '../../../../mocks/bloc/bloc_mocks.dart';

void main() {
  late MockVisitorManagementBloc bloc;
  late VisitorsModel visitor;
  late BuiltList<StatisticsModel> statisticsList;
  late VisitorManagementBlocTestHelper visitorManagementBlocHelper;

  setUpAll(() {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(VisitorsModelFake());
    visitorManagementBlocHelper = VisitorManagementBlocTestHelper();
  });

  setUp(() {
    bloc = MockVisitorManagementBloc();
    visitorManagementBlocHelper.setup();

    visitor = VisitorsModel(
      (b) => b
        ..id = 1
        ..name = 'John Doe'
        ..imageUrl = 'http://example.com/image.png'
        ..isWanted = 0
        ..lastVisit = DateTime.now().toString(),
    );
    statisticsList = BuiltList<StatisticsModel>([
      StatisticsModel(
        (b) => b
          ..title = 'Visit 1'
          ..visitCount = 2,
      ),
      StatisticsModel(
        (b) => b
          ..title = 'Visit 2'
          ..visitCount = 3,
      ),
    ]);
  });

  Widget buildTestableWidget(Widget child) {
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<VisitorManagementBloc>.value(
                value: visitorManagementBlocHelper.mockVisitorManagementBloc,
              ),
            ],
            child: Scaffold(body: child),
          ),
        );
      },
    );
  }

  testWidgets('displays visitor name', (tester) async {
    final mockState = VisitorManagementState(
      (b) => b..statisticsList.replace(statisticsList),
    );
    bloc.mockState = mockState;
    await tester.pumpWidget(
      buildTestableWidget(VisitorInfoCard(visitor: visitor, bloc: bloc)),
    );
    expect(find.text('John Doe'), findsOneWidget);
  });

  testWidgets('displays total visits', (tester) async {
    final mockState = VisitorManagementState(
      (b) => b..statisticsList.replace(statisticsList),
    );
    bloc.mockState = mockState;
    await tester.pumpWidget(
      buildTestableWidget(VisitorInfoCard(visitor: visitor, bloc: bloc)),
    );
    expect(find.textContaining('Total Visits: 5'), findsOneWidget);
  });

  testWidgets('calendar button is present', (tester) async {
    final mockState = VisitorManagementState(
      (b) => b..statisticsList.replace(statisticsList),
    );
    bloc.mockState = mockState;
    await tester.pumpWidget(
      buildTestableWidget(VisitorInfoCard(visitor: visitor, bloc: bloc)),
    );
    expect(find.byIcon(MdiIcons.calendarOutline), findsWidgets);
  });
}
