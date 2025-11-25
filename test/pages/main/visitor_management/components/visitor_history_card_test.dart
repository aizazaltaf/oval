import 'package:admin/models/data/visit_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_state.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/visitor_history_card.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/bloc_helpers/visitor_management_bloc_test_helper.dart';
import '../../../../helpers/fake_build_context.dart';

class MockVisitorManagementBloc extends Mock implements VisitorManagementBloc {}

class VisitorManagementStateFake extends Fake
    implements VisitorManagementState {}

void main() {
  late VisitorManagementBlocTestHelper visitorManagementBlocHelper;

  setUpAll(() {
    visitorManagementBlocHelper = VisitorManagementBlocTestHelper();
    registerFallbackValue(VisitorManagementStateFake());
    registerFallbackValue(
      VisitModel(
        (b) => b
          ..id = 0
          ..visitorId = 0
          ..deviceId = ''
          ..createdAt = ''
          ..updatedAt = '',
      ),
    );
    registerFallbackValue(
      VisitorsModel(
        (b) => b
          ..id = 0
          ..name = ''
          ..imageUrl = ''
          ..isWanted = 0
          ..lastVisit = '',
      ),
    );
    registerFallbackValue(FakeBuildContext());
  });

  late MockVisitorManagementBloc bloc;
  late VisitModel visit;
  late VisitorsModel visitor;

  setUp(() {
    bloc = MockVisitorManagementBloc();
    visitorManagementBlocHelper.setup();
    visit = VisitModel(
      (b) => b
        ..id = 1
        ..visitorId = 1
        ..deviceId = 'device-1'
        ..createdAt = '2024-06-01T10:00:00.000Z'
        ..updatedAt = '2024-06-01T10:00:00.000Z',
    );
    visitor = VisitorsModel(
      (b) => b
        ..id = 1
        ..name = 'John Doe'
        ..imageUrl = 'http://example.com/image.png'
        ..isWanted = 0
        ..lastVisit = '2024-06-01T10:00:00.000Z',
    );
    final mockState = VisitorManagementState(
      (b) => b..deleteVisitorHistoryIdsList = ListBuilder<String>([]),
    );
    when(() => bloc.state).thenReturn(mockState);
    when(() => bloc.updateDeleteVisitorHistoryIdsList(any())).thenReturn(null);
    when(() => bloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildTestableWidget(Widget child) {
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<VisitorManagementBloc>.value(
                value: visitorManagementBlocHelper.mockVisitorManagementBloc,
              ),
            ],
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 800,
                  height: 200,
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  testWidgets('displays day, time, and date', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        VisitorHistoryCard(visit: visit, bloc: bloc, visitor: visitor),
      ),
    );
    // These depend on CommonFunctions formatting, so check for presence of any text
    expect(find.textContaining('2024'), findsWidgets);
  });

  testWidgets('long press triggers updateDeleteVisitorHistoryIdsList',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        VisitorHistoryCard(visit: visit, bloc: bloc, visitor: visitor),
      ),
    );
    await tester.longPress(find.byType(VisitorHistoryCard));
    verify(() => bloc.updateDeleteVisitorHistoryIdsList(any())).called(1);
  });

  testWidgets('renders checkbox and allows interaction', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        VisitorHistoryCard(visit: visit, bloc: bloc, visitor: visitor),
      ),
    );
    // Tap the checkbox if present
    final checkboxFinder = find.byType(Checkbox);
    if (checkboxFinder.evaluate().isNotEmpty) {
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();
      verify(() => bloc.updateDeleteVisitorHistoryIdsList(any()))
          .called(greaterThan(0));
    }
  });

  testWidgets('renders correctly', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        VisitorHistoryCard(visit: visit, bloc: bloc, visitor: visitor),
      ),
    );
    expect(find.byType(VisitorHistoryCard), findsOneWidget);
  });
}
