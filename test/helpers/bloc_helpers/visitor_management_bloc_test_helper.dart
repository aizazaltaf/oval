import 'package:admin/models/data/api_meta_data.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/data/statistics_model.dart';
import 'package:admin/models/data/visit_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../mocks/bloc/bloc_mocks.dart';
import '../../mocks/bloc/state_mocks.dart';

class VisitorManagementBlocTestHelper {
  late MockVisitorManagementBloc mockVisitorManagementBloc;
  late VisitorManagementState currentVisitorManagementState;
  late ScrollController mockScrollController;

  void setup() {
    mockVisitorManagementBloc = MockVisitorManagementBloc();
    currentVisitorManagementState = MockVisitorManagementState();
    mockScrollController = MockScrollController();

    // Directly assign the state to the mock's _state field for compatibility with the real getter
    mockVisitorManagementBloc.mockState = currentVisitorManagementState;

    when(() => mockVisitorManagementBloc.historyFilterScrollController)
        .thenReturn(mockScrollController);
    // Add this line to mock visitorManagementScrollController as well
    when(() => mockVisitorManagementBloc.visitorManagementScrollController)
        .thenReturn(mockScrollController);
    // Add this line to mock historyFilterScrollController as well
    when(() => mockVisitorManagementBloc.historyFilterScrollController)
        .thenReturn(mockScrollController);

    setupDefaultState();
    setupScrollController();

    // Mock bloc methods
    when(
      () => mockVisitorManagementBloc.initialCall(
        isRefresh: any(named: 'isRefresh'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockVisitorManagementBloc.updateSearch(any()))
        .thenAnswer((_) async {});
    when(() => mockVisitorManagementBloc.callFilters())
        .thenAnswer((_) async {});
    when(() => mockVisitorManagementBloc.onVisitorManagementScroll())
        .thenAnswer((_) async {});
    when(() => mockVisitorManagementBloc.getAppliedFilterTitle(any(), any()))
        .thenReturn("Today");
    when(() => mockVisitorManagementBloc.updateVisitorGuideShow(any()))
        .thenAnswer((_) async {});
    when(() => mockVisitorManagementBloc.updateCurrentGuideKey(any()))
        .thenAnswer((_) async {});

    // Add mock for visitorNameTap method
    when(() => mockVisitorManagementBloc.visitorNameTap(any(), any()))
        .thenAnswer((_) async {});
  }

  void setupDefaultState() {
    // Stub all required VisitorManagementState properties
    when(() => currentVisitorManagementState.search).thenReturn(null);
    when(() => currentVisitorManagementState.filterValue).thenReturn(null);
    when(() => currentVisitorManagementState.visitHistoryFirstBool)
        .thenReturn(false);
    when(() => currentVisitorManagementState.visitorHistorySelectedFilter)
        .thenReturn(null);
    when(() => currentVisitorManagementState.visitorGuideShow)
        .thenReturn(false);
    when(() => currentVisitorManagementState.historyGuideShow)
        .thenReturn(false);
    when(() => currentVisitorManagementState.currentGuideKey).thenReturn("");
    when(() => currentVisitorManagementState.visitorNewNotification)
        .thenReturn(false);
    when(() => currentVisitorManagementState.visitorNameSaveButtonEnabled)
        .thenReturn(false);
    when(() => currentVisitorManagementState.historyFilterValue)
        .thenReturn(null);
    when(() => currentVisitorManagementState.visitorName).thenReturn("");
    when(() => currentVisitorManagementState.deleteVisitorHistoryIdsList)
        .thenReturn(null);
    when(() => currentVisitorManagementState.selectedVisitor).thenReturn(null);
    when(() => currentVisitorManagementState.statisticsList)
        .thenReturn(BuiltList<StatisticsModel>([]));
    when(() => currentVisitorManagementState.superToolTipController)
        .thenReturn(SuperTooltipController());

    // API states
    when(() => currentVisitorManagementState.visitorManagementApi)
        .thenReturn(ApiState<PaginatedData<VisitorsModel>>());
    when(() => currentVisitorManagementState.visitorHistoryApi)
        .thenReturn(ApiState<PaginatedData<VisitModel>>());
    when(() => currentVisitorManagementState.visitorManagementDeleteApi)
        .thenReturn(ApiState<void>());
    when(() => currentVisitorManagementState.visitorHistoryDeleteApi)
        .thenReturn(ApiState<void>());
    when(() => currentVisitorManagementState.markWantedOrUnwantedVisitorApi)
        .thenReturn(ApiState<void>());
    when(() => currentVisitorManagementState.editVisitorNameApi)
        .thenReturn(ApiState<void>());
    when(() => currentVisitorManagementState.statisticsVisitorApi)
        .thenReturn(ApiState<void>());
  }

  void disableShowcaseFeatures() {
    when(() => currentVisitorManagementState.visitorGuideShow)
        .thenReturn(true); // Set to true to disable showcase
    when(() => currentVisitorManagementState.historyGuideShow)
        .thenReturn(false);
    when(() => currentVisitorManagementState.currentGuideKey).thenReturn("");
  }

  void setupWithSearch(String search) {
    when(() => currentVisitorManagementState.search).thenReturn(search);
  }

  void setupWithFilter(String filter) {
    when(() => currentVisitorManagementState.filterValue).thenReturn(filter);
  }

  void setupWithNewNotification() {
    when(() => currentVisitorManagementState.visitorNewNotification)
        .thenReturn(true);
  }

  void setupWithVisitorGuide() {
    when(() => currentVisitorManagementState.visitorGuideShow).thenReturn(true);
    when(() => currentVisitorManagementState.currentGuideKey)
        .thenReturn("filter");
  }

  void setupWithVisitorsData(List<VisitorsModel> visitors) {
    final paginatedData = PaginatedData<VisitorsModel>(
      (b) => b
        ..data = ListBuilder<VisitorsModel>(visitors)
        ..currentPage = 1
        ..lastPage = 1,
    );

    final apiState = ApiState<PaginatedData<VisitorsModel>>(
      (b) => b
        ..data = paginatedData
        ..isApiInProgress = false
        ..currentPage = 1
        ..totalCount = visitors.length,
    );

    when(() => currentVisitorManagementState.visitorManagementApi)
        .thenReturn(apiState);
  }

  void setupWithEmptyVisitorsData() {
    final paginatedData = PaginatedData<VisitorsModel>(
      (b) => b
        ..data = ListBuilder<VisitorsModel>([])
        ..currentPage = 1
        ..lastPage = 1,
    );

    final apiState = ApiState<PaginatedData<VisitorsModel>>(
      (b) => b
        ..data = paginatedData
        ..isApiInProgress = false
        ..currentPage = 1
        ..totalCount = 0,
    );

    when(() => currentVisitorManagementState.visitorManagementApi)
        .thenReturn(apiState);
  }

  void setupWithNullVisitorsData() {
    final apiState = ApiState<PaginatedData<VisitorsModel>>(
      (b) => b
        ..data = null
        ..isApiInProgress = false
        ..currentPage = 1
        ..totalCount = 0,
    );
    when(() => currentVisitorManagementState.visitorManagementApi)
        .thenReturn(apiState);
  }

  void setupLoadingState() {
    final apiState = ApiState<PaginatedData<VisitorsModel>>(
      (b) => b
        ..isApiInProgress = true
        ..data = null,
    );

    when(() => currentVisitorManagementState.visitorManagementApi)
        .thenReturn(apiState);
  }

  void setupErrorState() {
    final mockError = ApiMetaData(
      (b) => b
        ..message = "Test error"
        ..statusCode = 400,
    );

    final apiState = ApiState<PaginatedData<VisitorsModel>>(
      (b) => b
        ..isApiInProgress = false
        ..data = null
        ..error = mockError.toBuilder(),
    );

    when(() => currentVisitorManagementState.visitorManagementApi)
        .thenReturn(apiState);
  }

  void setupWithSelectedVisitor(VisitorsModel visitor) {
    when(() => currentVisitorManagementState.selectedVisitor)
        .thenReturn(visitor);
  }

  void setupWithVisitorNameSaveButtonEnabled() {
    when(() => currentVisitorManagementState.visitorNameSaveButtonEnabled)
        .thenReturn(true);
  }

  void setupWithVisitorName(String name) {
    when(() => currentVisitorManagementState.visitorName).thenReturn(name);
  }

  void setupScrollController() {
    final mockScrollController = MockScrollController();
    final mockPosition = MockScrollPosition();

    // Mock scroll controller properties
    when(() => mockScrollController.hasClients).thenReturn(true);
    when(() => mockScrollController.position).thenReturn(mockPosition);
    when(() => mockScrollController.positions).thenReturn([mockPosition]);

    // Mock scroll position properties
    when(() => mockPosition.pixels).thenReturn(0);
    when(() => mockPosition.maxScrollExtent).thenReturn(100);
    when(() => mockPosition.minScrollExtent).thenReturn(0);
    when(() => mockPosition.viewportDimension).thenReturn(100);
    when(() => mockPosition.haveDimensions).thenReturn(true);
    when(() => mockPosition.hasPixels).thenReturn(true);
    when(() => mockPosition.hasViewportDimension).thenReturn(true);

    // Set the mock scroll controller
    when(() => mockVisitorManagementBloc.historyFilterScrollController)
        .thenReturn(mockScrollController);
  }

  void dispose() {
    // No stream controller to dispose
  }
}

class MockScrollController extends Mock implements ScrollController {
  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    final mockPosition = MockScrollPosition();
    when(() => mockPosition.pixels).thenReturn(0);
    when(() => mockPosition.maxScrollExtent).thenReturn(100);
    when(() => mockPosition.minScrollExtent).thenReturn(0);
    when(() => mockPosition.viewportDimension).thenReturn(100);
    when(() => mockPosition.haveDimensions).thenReturn(true);
    when(() => mockPosition.hasPixels).thenReturn(true);
    when(() => mockPosition.hasViewportDimension).thenReturn(true);
    return mockPosition;
  }
}

class MockScrollPosition extends Mock implements ScrollPosition {
  @override
  bool applyViewportDimension(double viewportDimension) {
    return true;
  }
}
