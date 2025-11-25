import 'dart:io';

import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/data/statistics_model.dart';
import 'package:admin/models/data/visit_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/models/serializers.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_state.dart';
import 'package:admin/pages/main/visitor_management/visitor_history_page.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/dio.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'visitor_management_bloc.bloc.g.dart';

final _logger = Logger('visitor_management_bloc.dart');

@BlocGen()
class VisitorManagementBloc
    extends BVCubit<VisitorManagementState, VisitorManagementStateBuilder>
    with _VisitorManagementBlocMixin {
  VisitorManagementBloc() : super(VisitorManagementState()) {
    /// removing to prevent multiple api calls and data does not set properly on login or refresh because location id is not set
    // callVisitorManagement();
    // if (singletonBloc.profileBloc.state?.locationId != null) {
    //   initialCall();
    // }
  }

  factory VisitorManagementBloc.of(final BuildContext context) =>
      BlocProvider.of<VisitorManagementBloc>(context);

  final ScrollController visitorManagementScrollController = ScrollController();
  final ScrollController visitorHistoryScrollController = ScrollController();

  final ScrollController historyFilterScrollController = ScrollController();

  double animate(index, context, targetOffset) {
    const int length = 5;
    if (index == 0 || index == 1) {
      return historyFilterScrollController.position.minScrollExtent;
    } else if (index == length - 1 || index == length - 2) {
      return historyFilterScrollController.position.maxScrollExtent;
    }
    return targetOffset;
  }

  void scrollToIndex(int index, context) {
    if (!historyFilterScrollController.hasClients) {
      return;
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double centerOffset = (screenWidth - 90) / 2; // Center position
    final double targetOffset = (index * 90) - centerOffset;

    historyFilterScrollController.animateTo(
      animate(index, context, targetOffset),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  //Guides Global keys
  final chartGuideKey = GlobalKey();
  final historyListGuideKey = GlobalKey();
  final historyEditNameGuideKey = GlobalKey();
  final historyUnwantedGuideKey = GlobalKey();
  final historyNeighbourhoodGuideKey = GlobalKey();
  final historyMessageGuideKey = GlobalKey();

  GlobalKey getCurrentGuide() {
    switch (state.currentGuideKey) {
      case "chart":
        return chartGuideKey;

      case "history_list":
        return historyListGuideKey;

      case "history_edit_name":
        return historyEditNameGuideKey;

      case "history_unwanted":
        return historyUnwantedGuideKey;

      case "history_neighbourhood":
        return historyNeighbourhoodGuideKey;

      default:
        return historyMessageGuideKey;
    }
  }

  String getAppliedFilterTitle(String? filterVal, BuildContext context) {
    if (filterVal == null) {
      return "";
    } else if (filterVal == 'today') {
      return context.appLocalizations.today;
    } else if (filterVal == "yesterday") {
      return context.appLocalizations.yesterday;
    } else if (filterVal == "this_week") {
      return context.appLocalizations.this_week;
    } else if (filterVal == "this_month") {
      return context.appLocalizations.this_month;
    } else if (filterVal == "last_month") {
      return context.appLocalizations.last_month;
    } else if (filterVal == "three_months") {
      return context.appLocalizations.this_month;
    }
    return DateFormat('MM-dd-yyyy')
        .format(DateFormat("dd-MM-yyyy").parse(filterVal));
  }

  void getNameEditValidations({
    required String changedName,
    required String visitorName,
  }) {
    if (changedName.isEmpty ||
        !Constants.noNumberSpecialCharacterRegex.hasMatch(changedName.trim())) {
      updateVisitorNameSaveButtonEnabled(false);
    } else if (changedName.trim().length < 3) {
      updateVisitorNameSaveButtonEnabled(false);
    } else if (changedName.trim() == visitorName ||
        changedName.trim().toLowerCase() == "unknown") {
      updateVisitorNameSaveButtonEnabled(false);
    } else {
      updateVisitorNameSaveButtonEnabled(true);
      emit(state.rebuild((final b) => b.editVisitorNameApi.error = null));
    }
  }

  Timer? _debounceTimer;
  Timer? _debounceHistoryTimer;
  void onVisitorManagementScroll() {
    if (visitorManagementScrollController.position.pixels >=
        visitorManagementScrollController.position.maxScrollExtent -
            (Platform.isAndroid ? 200 : 0)) {
      _logger
        ..severe(visitorManagementScrollController.position.maxScrollExtent)
        ..severe(visitorManagementScrollController.position.pixels);
      // Check API state to avoid duplicate calls
      final apiState = state.visitorManagementApi;
      _debounceTimer?.cancel();

      // Start a new timer with a delay of 300ms (adjust as needed)
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        if (!apiState.isApiInProgress &&
            apiState.currentPage < apiState.totalCount) {
          callVisitorManagement();
        }
      });
    }
  }

  void onVisitorHistoryScroll(String? visitorId) {
    if (visitorHistoryScrollController.position.pixels >=
        visitorHistoryScrollController.position.maxScrollExtent - 200) {
      // Check API state to avoid duplicate calls
      final apiState = state.visitorHistoryApi;
      _debounceHistoryTimer?.cancel();

      // Start a new timer with a delay of 300ms (adjust as needed)
      _debounceHistoryTimer = Timer(const Duration(milliseconds: 300), () {
        if (!apiState.isApiInProgress &&
            apiState.currentPage < apiState.totalCount) {
          callVisitorHistory(visitorId!);
        }
      });
    }
  }

  void reinitializeVisitorHistoryApi() {
    emit(
      state.rebuild(
        (b) => b
          ..visitorHistoryApi.replace(ApiState())
          ..visitorManagementApi.replace(ApiState())
          ..visitorManagementApi.totalCount = 0
          ..visitorManagementApi.isApiInProgress = true
          ..visitorNewNotification = false
          ..visitorManagementApi.currentPage = 0,
      ),
    );
  }

  Future<void> callFilters({
    String? visitorId,
    String? filterValue,
    bool forVisitorHistoryPage = false,
  }) async {
    if (forVisitorHistoryPage) {
      emit(
        state.rebuild(
          (b) => b
            ..visitorHistoryApi.replace(ApiState())
            ..deleteVisitorHistoryIdsList = null
            ..historyFilterValue = filterValue,
        ),
      );
      unawaited(callIndividualVisitorStats(visitorId: visitorId!));
      unawaited(callVisitorHistory(visitorId));
    } else {
      emit(
        state.rebuild(
          (b) => b
            ..visitorManagementApi.currentPage = -1
            ..filterValue = filterValue
            ..search = null
            ..visitorManagementApi.data = null,
        ),
      );
      await callVisitorManagement();
    }
  }

  void removeSearch() {
    emit(state.rebuild((b) => b..search = null));
  }

  Future<void> initialCall({bool isRefresh = false}) {
    emit(
      state.rebuild(
        (b) => b
          ..visitorManagementApi.currentPage = -1
          ..filterValue = null
          ..search = null,
      ),
    );
    return callVisitorManagement(isRefresh: isRefresh);
  }

  Future<void> visitorNameTap(
    BuildContext context,
    VisitorsModel visitor, {
    String? date,
  }) async {
    emit(
      state.rebuild(
        (b) => b
          ..visitHistoryFirstBool = false
          ..visitorHistoryApi.replace(ApiState())
          ..search = null
          ..historyFilterValue = null
          ..selectedVisitor.replace(visitor)
          ..deleteVisitorHistoryIdsList = null,
      ),
    );
    unawaited(
      callFilters(
        visitorId: visitor.id.toString(),
        forVisitorHistoryPage: true,
        filterValue: date == null
            ? null
            : DateFormat("dd-MM-yyyy").format(
                DateFormat("yyyy-MM-dd").parse(date),
              ),
      ),
    );
    unawaited(VisitorHistoryPage.push(context));
  }

  void getUnWantedVisitorApiError(VisitorsModel visitor) {
    ToastUtils.warningToast(
        "${visitor.name.contains("A new") ? "Unknown" : visitor.name} "
        "could not be ${visitor.isWanted != 0 ? "added" : "removed"} in unwanted list successfully..");
  }

  Future<void> callMarkWantedOrUnwantedVisitor(VisitorsModel visitor) {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.markWantedOrUnwantedVisitorApi,
      updateApiState: (final b, final apiState) =>
          b.markWantedOrUnwantedVisitorApi.replace(apiState),
      onError: (dioError) {
        getUnWantedVisitorApiError(visitor);
      },
      callApi: () async {
        final bool apiResponse = await apiService
            .getMarkWantedOrUnwantedVisitor(visitor.id.toString());
        if (!apiResponse) {
          getUnWantedVisitorApiError(visitor);
        } else {
          ToastUtils.successToast(
              "${visitor.name.contains("A new") ? "Unknown" : visitor.name} "
              "has been ${visitor.isWanted == 0 ? "added in" : "removed from"} "
              "unwanted list successfully.");
          // callFilters(
          //     forVisitorHistoryPage: true, visitorId: visitor.id.toString());
          // callFilters();
          emit(
            state.rebuild((b) {
              // b.selectedVisitor.isWanted = visitor.isWanted == 0 ? 1 : 0;
              final int? index = b.visitorManagementApi.data?.data
                  .indexWhere((e) => e.id.toString() == visitor.id.toString());
              b.visitorManagementApi.data =
                  b.visitorManagementApi.data?.rebuild(
                (d) => d.data[index!] = d.data[index].rebuild(
                  (v) => v.isWanted = visitor.isWanted == 0 ? 1 : 0,
                ),
              );
            }),
          );
        }
      },
    );
  }

  void getDeleteVisitorApiError(VisitorsModel visitor) {
    ToastUtils.errorToast(
        "${visitor.name.contains("A new") ? "Unknown" : visitor.name} "
        "could not be deleted.");
  }

  Future<void> callEditVisitorName(
    String visitorId, {
    bool fromVisitorHistory = false,
  }) {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.editVisitorNameApi,
      updateApiState: (final b, final apiState) =>
          b.editVisitorNameApi.replace(apiState),
      onError: (dioError) {
        ToastUtils.errorToast("Name could not be updated.");
      },
      callApi: () async {
        final apiResponse = await apiService.editVisitorName(
          visitorId,
          state.visitorName,
        );
        if (apiResponse == null || apiResponse['success'] == false) {
          ToastUtils.errorToast(
            apiResponse['message'] ?? "Name could not be updated.",
          );
        } else {
          ToastUtils.successToast("Name has been updated successfully.");
          // callFilters(
          //     forVisitorHistoryPage: true, visitorId: visitorId.toString());
          // callFilters();
          emit(
            state.rebuild((b) {
              if (fromVisitorHistory) {
                b.selectedVisitor.name = state.visitorName;
              }
              final int? index = b.visitorManagementApi.data?.data
                  .indexWhere((e) => e.id.toString() == visitorId);
              b.visitorManagementApi.data =
                  b.visitorManagementApi.data?.rebuild(
                (d) => d.data[index!] =
                    d.data[index].rebuild((v) => v.name = state.visitorName),
              );
            }),
          );
        }
      },
    );
  }

  Future<void> callDeleteVisitor(VisitorsModel visitor) {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.visitorManagementDeleteApi,
      updateApiState: (final b, final apiState) =>
          b.visitorManagementDeleteApi.replace(apiState),
      onError: (dioError) {
        getDeleteVisitorApiError(visitor);
      },
      callApi: () async {
        final bool apiResponse =
            await apiService.getDeleteVisitor(visitor.id.toString());
        if (!apiResponse) {
          getDeleteVisitorApiError(visitor);
        } else {
          ToastUtils.successToast(
              "${visitor.name.contains("A new") ? "Unknown" : visitor.name} "
              "has been removed successfully.");
          // callFilters();
          emit(
            state.rebuild((b) {
              final int? index = b.visitorManagementApi.data?.data
                  .indexWhere((e) => e.id.toString() == visitor.id.toString());
              b.visitorManagementApi.data = b.visitorManagementApi.data
                  ?.rebuild((d) => d.data.removeAt(index!));
            }),
          );
        }
      },
    );
  }

  Future<void> callDeleteVisitorHistory({
    required VisitorsModel visitor,
    required VoidCallback visitorPagePopup,
  }) {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.visitorHistoryDeleteApi,
      updateApiState: (final b, final apiState) =>
          b.visitorHistoryDeleteApi.replace(apiState),
      onError: (dioError) {
        if (dioError is DioException && dioError.response != null) {
          ToastUtils.errorToast(
            dioError.message ?? "Visitor records could not be deleted.",
          );
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
      callApi: () async {
        final bool apiResponse = await apiService
            .getDeleteVisits(state.deleteVisitorHistoryIdsList!);
        if (!apiResponse) {
          ToastUtils.errorToast("Visitor records could not be deleted.");
        } else {
          ToastUtils.successToast(
              "${state.deleteVisitorHistoryIdsList!.length > 1 ? "Visitor records have" : "Visitor record has"} "
              "been deleted successfully.");
          final bool isDeleteVisitorNeeded =
              state.visitorHistoryApi.data!.data.length ==
                  state.deleteVisitorHistoryIdsList!.length;
          await callFilters(
            forVisitorHistoryPage: true,
            visitorId: visitor.id.toString(),
          );
          updateDeleteVisitorHistoryIdsList(null);
          if (isDeleteVisitorNeeded) {
            emit(
              state.rebuild((b) {
                final int? index = b.visitorManagementApi.data?.data.indexWhere(
                  (e) => e.id.toString() == visitor.id.toString(),
                );
                b.visitorManagementApi.data = b.visitorManagementApi.data
                    ?.rebuild((d) => d.data.removeAt(index!));
              }),
            );
            visitorPagePopup();
          }
        }
      },
    );
  }

  Future<void> callVisitorHistory(String visitorId) {
    return CubitUtils.makePaginatedApiCall<VisitorManagementState,
        VisitorManagementStateBuilder, PaginatedData<VisitModel>>(
      cubit: this,
      apiState: state.visitorHistoryApi,
      updateApiState: (final b, final apiState) =>
          b.visitorHistoryApi.replace(apiState),
      callApi: (page) async {
        final paginatedData = await apiService.getVisitorHistory(
          page: page,
          visitorId: visitorId,
          filterVal: state.historyFilterValue,
        );
        return PaginatedData.fromDynamic(
          paginatedData,
          VisitModel.serializer,
          serializersVisitModel,
        );
      },
      currentPage: state.visitorHistoryApi.currentPage,
      totalPages: state.visitorHistoryApi.totalCount,
      onPageUpdate: (final newPage) {
        _logger.fine('Updating Page to: $newPage');
        emit(state.rebuild((b) => b..visitorHistoryApi.currentPage = newPage));
      },
    );
  }

  Future<void> callIndividualVisitorStats({required String visitorId}) {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.statisticsVisitorApi,
      updateApiState: (final b, final apiState) =>
          b.statisticsVisitorApi.replace(apiState),
      callApi: () async {
        final BuiltList<StatisticsModel> individualStatsResponse =
            await apiService.getIndividualVisitorStats(
          visitorId: visitorId,
          timeInterval: state.historyFilterValue,
        );
        updateStatisticsList(individualStatsResponse);
      },
    );
  }

  Future<void> callVisitorManagement({bool isRefresh = false}) {
    if (isRefresh) {
      reinitializeVisitorHistoryApi();
    }
    return CubitUtils.makePaginatedApiCall<VisitorManagementState,
        VisitorManagementStateBuilder, PaginatedData<VisitorsModel>>(
      cubit: this,
      apiState: state.visitorManagementApi,
      updateApiState: (final b, final apiState) =>
          b.visitorManagementApi.replace(apiState),
      callApi: (page) async {
        final paginatedData =
            await apiService.getVisitorManagement(page, state.filterValue);
        final PaginatedData list = PaginatedData.fromDynamic(
          paginatedData.data,
          VisitorsModel.serializer,
          serializersVisitorModel,
        );
        if (state.visitorManagementApi.data != null) {
          final PaginatedData<VisitorsModel> updatedList1 = list.rebuild(
            (b) => b
              ..data.replace(
                list.data.where(
                  (item) => !state.visitorManagementApi.data!.data
                      .any((other) => other.id == item.id),
                ),
              ),
          ) as PaginatedData<VisitorsModel>;

          return updatedList1;
        }
        return PaginatedData.fromDynamic(
          paginatedData.data,
          VisitorsModel.serializer,
          serializersVisitorModel,
        );
      },
      currentPage: state.visitorManagementApi.currentPage,
      totalPages: state.visitorManagementApi.totalCount,
      onPageUpdate: (final newPage) {
        _logger.fine('Updating Page to: $newPage');
        emit(
          state.rebuild((b) => b..visitorManagementApi.currentPage = newPage),
        );
      },
    );
  }
}
