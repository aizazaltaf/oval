import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/data/visit_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_state.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/visitor_history_listview.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_build_context.dart';
import '../../../../helpers/test_helper.dart';
import '../../../../mocks/bloc/bloc_mocks.dart';

// Add a test bloc for widget testing

void main() {
  late VisitorsModel visitor;
  late VisitModel visit;
  late PaginatedData<VisitModel> paginatedData;
  late MockVisitorManagementBloc mockBloc;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(VisitorsModelFake());
    await TestHelper.initialize();
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
  });

  setUp(() {
    visitor = VisitorsModel(
      (b) => b
        ..id = 1
        ..name = 'John Doe'
        ..imageUrl = 'http://example.com/image.png'
        ..isWanted = 0
        ..lastVisit = '2024-06-01T10:00:00.000Z',
    );
    visit = VisitModel(
      (b) => b
        ..id = 1
        ..visitorId = 1
        ..deviceId = 'device-1'
        ..createdAt = '2024-06-01T10:00:00.000Z'
        ..updatedAt = '2024-06-01T10:00:00.000Z',
    );
    paginatedData = PaginatedData<VisitModel>(
      (b) => b
        ..currentPage = 1
        ..lastPage = 1
        ..nextPageUrl = null
        ..data = ListBuilder<VisitModel>([visit]),
    );

    // Set up the mock bloc and state
    mockBloc = MockVisitorManagementBloc();
    final mockState = VisitorManagementState(
      (b) => b
        ..visitorHistoryApi.update((a) {
          a
            ..isApiInProgress = false
            ..data = paginatedData;
        })
        ..statisticsVisitorApi.update((a) {
          a.isApiInProgress = false;
        })
        ..statisticsList.replace([])
        ..deleteVisitorHistoryIdsList = ListBuilder<String>()
        ..visitorGuideShow = false
        ..historyGuideShow = false
        ..currentGuideKey = ''
        ..visitorName = ''
        ..visitorHistorySelectedFilter = ''
        ..visitHistoryFirstBool = false,
    );
    mockBloc.mockState = mockState;
    when(() => mockBloc.historyListGuideKey).thenReturn(GlobalKey());
    when(() => mockBloc.updateVisitHistoryFirstBool(any()))
        .thenAnswer((_) async {});
    when(() => mockBloc.getAppliedFilterTitle(any(), any())).thenReturn('');
    when(() => mockBloc.visitorHistoryScrollController)
        .thenReturn(ScrollController());
  });

  Widget buildTestableWidget(Widget child, VisitorManagementBloc bloc) {
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<VisitorManagementBloc>.value(
                value: bloc,
              ),
            ],
            child: Scaffold(
              body: Column(
                children: [
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  testWidgets('shows loading indicator when loading', (tester) async {
    final mockState = VisitorManagementState(
      (b) => b
        ..visitorHistoryApi.update((a) {
          a.isApiInProgress = true;
        })
        ..statisticsVisitorApi.update((a) {
          a.isApiInProgress = false;
        }),
    );
    mockBloc.mockState = mockState;
    await tester.pumpWidget(
      buildTestableWidget(
        VisitorHistoryListView(
          bloc: mockBloc,
          visitor: visitor,
          innerContext: FakeBuildContext(),
        ),
        mockBloc,
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(ButtonProgressIndicator), findsOneWidget);
  });

  testWidgets('shows empty state when no data', (tester) async {
    final mockState = VisitorManagementState(
      (b) => b
        ..visitorHistoryApi.update((a) {
          a
            ..isApiInProgress = false
            ..data = null;
        })
        ..statisticsVisitorApi.update((a) {
          a.isApiInProgress = false;
        }),
    );
    mockBloc.mockState = mockState;
    await tester.pumpWidget(
      buildTestableWidget(
        VisitorHistoryListView(
          bloc: mockBloc,
          visitor: visitor,
          innerContext: FakeBuildContext(),
        ),
        mockBloc,
      ),
    );
    expect(find.textContaining('No records available'), findsWidgets);
  });

  // testWidgets('renders list when data is present', (tester) async {
  //   final mockState = VisitorManagementState(
  //     (b) => b
  //       ..visitorHistoryApi.update((a) {
  //         a
  //           ..isApiInProgress = false
  //           ..data = paginatedData;
  //       })
  //       ..statisticsVisitorApi.update((a) {
  //         a.isApiInProgress = false;
  //       })
  //       ..statisticsList.replace([])
  //       ..deleteVisitorHistoryIdsList = ListBuilder<String>()
  //       ..visitorGuideShow = false
  //       ..historyGuideShow = false
  //       ..currentGuideKey = ''
  //       ..visitorName = ''
  //       ..visitorHistorySelectedFilter = ''
  //       ..visitHistoryFirstBool = false,
  //   );
  //   final testBloc = TestVisitorManagementBloc(mockState);
  //   await tester.pumpWidget(
  //     buildTestableWidget(
  //       VisitorHistoryListView(
  //         bloc: testBloc,
  //         visitor: visitor,
  //         innerContext: FakeBuildContext(),
  //       ),
  //       testBloc,
  //     ),
  //   );
  //   await tester.pumpAndSettle();
  //   expect(find.byType(VisitorHistoryCard), findsWidgets);
  // });
}
