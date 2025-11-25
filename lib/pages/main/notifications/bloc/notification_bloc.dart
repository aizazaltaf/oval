import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/data/notification_data.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/serializers.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/notifications/bloc/notification_state.dart';
import 'package:admin/pages/main/voice_control/model/voice_control_model.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'notification_bloc.bloc.g.dart';

final _logger = Logger('notification_bloc.dart');

@BlocGen()
class NotificationBloc
    extends BVCubit<NotificationState, NotificationStateBuilder>
    with _NotificationBlocMixin {
  NotificationBloc() : super(NotificationState()) {
    if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
      callNotificationApi();
      callDevicesApi();
      // if (singletonBloc.profileBloc.state!.locationId != null) {
      if (singletonBloc.profileBloc.state?.selectedDoorBell?.locationId !=
          null) {
        callStatusApi();
      }
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
          callNotificationApi();
          callDevicesApi();
          // if (singletonBloc.profileBloc.state!.locationId != null) {
          if (singletonBloc.profileBloc.state?.selectedDoorBell?.locationId !=
              null) {
            callStatusApi();
          }
        }
      });
    }
  }

  factory NotificationBloc.of(final BuildContext context) =>
      BlocProvider.of<NotificationBloc>(context);

  // Initialize ScrollController
  final ScrollController _scrollController = ScrollController();
  bool _isScrollControllerAttached = false;

  ScrollController get scrollController => _scrollController;

  Timer? _debounceTimer;
  bool isOnNotificationPage = false;

  //Guides Global keys
  final notificationFilterGuideKey = GlobalKey();
  final audioCallGuideKey = GlobalKey();
  final videoCallGuideKey = GlobalKey();
  final chatGuideKey = GlobalKey();

  void attachScrollController() {
    if (!_isScrollControllerAttached) {
      _scrollController.addListener(onScroll);
      _isScrollControllerAttached = true;
    }
  }

  void detachScrollController() {
    if (_isScrollControllerAttached) {
      _scrollController.removeListener(onScroll);
      _isScrollControllerAttached = false;
    }
  }

  @override
  Future<void> close() {
    detachScrollController();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    return super.close();
  }

  GlobalKey getCurrentGuide() {
    switch (state.currentGuideKey) {
      case "audio":
        return audioCallGuideKey;

      case "video":
        return videoCallGuideKey;

      case "chat":
        return chatGuideKey;

      default:
        return notificationFilterGuideKey;
    }
  }

  void onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    try {
      final position = _scrollController.position;

      if (position.pixels >= position.maxScrollExtent - 200) {
        // Check API state to avoid duplicate calls
        final apiState = state.notificationApi;

        // Cancel any existing debounce timer
        _debounceTimer?.cancel();

        // Start a new timer with a delay of 300ms (adjust as needed)
        _debounceTimer = Timer(const Duration(milliseconds: 300), () {
          if (!apiState.isApiInProgress &&
              apiState.currentPage < apiState.totalCount) {
            callNotificationApi(justPaginate: true);
          }
        });
      }
    } catch (e) {
      _logger.severe('Error in onScroll: $e');
    }
  }

  List<FeatureModel> dateFiltersTemp = [];
  List<FeatureModel> aiAlertsFiltersTemp = [];
  List<FeatureModel> aiAlertsSubFiltersTemp = [];
  List<FeatureModel> deviceFiltersTemp = [];

  void voiceControlEmit(VoiceControlModel model) {
    final dateFilters = [
      FeatureModel(
        isSelected: model.notifications!.today ?? false,
        title: Constants.today,
        value: "today",
      ),
      FeatureModel(
        isSelected: model.notifications!.yesterday ?? false,
        title: Constants.yesterday,
        value: "yesterday",
      ),
      FeatureModel(
        isSelected: model.notifications!.thisWeek ?? false,
        title: Constants.thisWeek,
        value: "this_week",
      ),
      FeatureModel(
        isSelected: model.notifications!.thisMonth ?? false,
        title: Constants.thisMonth,
        value: "this_month",
      ),
      FeatureModel(
        isSelected: model.notifications!.lastWeek ?? false,
        title: Constants.lastWeek,
        value: "last_week",
      ),
      FeatureModel(
        isSelected: model.notifications!.lastMonth ?? false,
        title: Constants.lastMonth,
        value: "last_month",
      ),
      FeatureModel(
        isSelected: model.notifications!.customDate != "false",
        title: Constants.custom,
        value: "custom",
      ),
    ];

    final aiAlertsFilters = [
      FeatureModel(
        isSelected: model.notifications!.subscriptionAlerts ?? false,
        title: Constants.subscriptionAlerts,
        value: "payment,subscription,credit,reminder,subscribe",
      ),
      FeatureModel(
        isSelected: model.notifications!.spamAlerts ?? false,
        title: Constants.spamAlerts,
        value: "spam",
      ),
      FeatureModel(
        isSelected: model.notifications!.neighbourhoodAlerts ?? false,
        title: Constants.neighbourhoodAlerts,
        value: "request,watch",
      ),
      FeatureModel(
        isSelected: model.notifications!.doorbellTheftAlerts ?? false,
        title: Constants.doorbellAlerts,
        value: "theft",
      ),
      FeatureModel(
        isSelected: model.notifications!.iotAlerts ?? false,
        title: Constants.ioTAlerts,
        value: "gas,movement,motion,monitoring,door lock,flashlight",
      ),
      FeatureModel(
        isSelected: model.notifications!.aiAlerts ?? false,
        title: Constants.aIAlerts,
        value: "",
      ),
    ];

    final aiAlertsSubFilters = [
      FeatureModel(
        isSelected: model.notifications!.aiAlerts == true
            ? true
            : model.notifications!.visitorAlert ?? false,
        title: Constants.visitorAlert,
        value: "visitor,unwanted,a new",
      ),
      FeatureModel(
        isSelected: model.notifications!.aiAlerts == true
            ? true
            : model.notifications!.babyRunningAway ?? false,
        title: Constants.babyRunningAway,
        value: "baby",
      ),
      FeatureModel(
        isSelected: model.notifications!.aiAlerts == true
            ? true
            : model.notifications!.petRunningAway ?? false,
        title: Constants.petRunningAway,
        value: "pet",
      ),
      FeatureModel(
        isSelected: model.notifications!.aiAlerts == true
            ? true
            : model.notifications!.fireAlert ?? false,
        title: Constants.fireAlert,
        value: "fire",
      ),
      FeatureModel(
        isSelected: model.notifications!.aiAlerts == true
            ? true
            : model.notifications!.intruderAlert ?? false,
        title: Constants.intruderAlert,
        value: "intruder",
      ),
      FeatureModel(
        isSelected: model.notifications!.aiAlerts == true
            ? true
            : model.notifications!.weapon ?? false,
        title: Constants.weapon,
        value: "weapon",
      ),
      FeatureModel(
        isSelected: model.notifications!.aiAlerts == true
            ? true
            : model.notifications!.parcelAlert ?? false,
        title: Constants.parcelAlert,
        value: "parcel",
      ),
      FeatureModel(
        isSelected: model.notifications!.aiAlerts == true
            ? true
            : model.notifications!.eavesdropper ?? false,
        title: Constants.eavesdropper,
        value: "eavesdropper",
      ),
      FeatureModel(
        isSelected: model.notifications!.aiAlerts == true
            ? true
            : model.notifications!.dogPoop ?? false,
        title: Constants.dogPoop,
        value: "poop",
      ),
      FeatureModel(
        isSelected: model.notifications!.aiAlerts == true
            ? true
            : model.notifications!.humanFall ?? false,
        title: Constants.humanFall,
        value: "human",
      ),
      FeatureModel(
        isSelected: model.notifications!.aiAlerts == true
            ? true
            : model.notifications!.boundaryBreach ?? false,
        title: Constants.boundaryBreach,
        value: "boundary",
      ),
      FeatureModel(
        isSelected: model.notifications!.aiAlerts == true
            ? true
            : model.notifications!.drowningAlert ?? false,
        title: Constants.drowningAlert,
        value: "drowning",
      ),
    ];

    /// Check if any `isSelected` value is true
    final bool hasSelectedFilters = dateFilters.any((f) => f.isSelected) ||
        aiAlertsFilters.any((f) => f.isSelected) ||
        aiAlertsSubFilters.any((f) => f.isSelected);

    final updatedFilters = List.of(aiAlertsFilters);
    emit(
      state.rebuild(
        (b) => b
          ..filter = hasSelectedFilters
          ..dateFilters.replace(dateFilters)
          ..aiAlertsFilters.replace(updatedFilters)
          ..aiAlertsSubFilters.replace(aiAlertsSubFilters),
      ),
    );

  }

  Future<void> callNotificationApi({
    justPaginate = false,
    refresh = false,
    int? isRead,
    isExternalCamera = false,
  }) {
    if (refresh) {
      emit(
        state.rebuild(
          (b) => b
            ..notificationApi.replace(ApiState())
            ..notificationApi.totalCount = 0
            ..notificationApi.isApiInProgress = true
            ..newNotification = false
            ..notificationApi.currentPage = 0,
        ),
      );
    }
    if (!justPaginate) {
      if (state.filter) {
        emit(
          state.rebuild(
            (b) => b
              ..notificationApi.replace(ApiState())
              ..notificationApi.totalCount = 0
              ..notificationApi.isApiInProgress = true
              ..notificationApi.currentPage = 0,
          ),
        );
        String filterParam = '';
        for (final e in state.dateFilters) {
          if (e.isSelected) {
            filterParam = "$filterParam${e.value},";
          }
        }
        for (final e in state.aiAlertsFilters) {
          if (e.isSelected) {
            filterParam = "$filterParam${e.value},";
          }
        }
        for (final e in state.aiAlertsSubFilters) {
          if (e.isSelected) {
            filterParam = "$filterParam${e.value},";
          }
        }
        for (final e in state.deviceFilters) {
          if (e.isSelected) {
            updateDeviceId(e.value!);
            break;
          }
        }
        updateFilterParam(filterParam);
      } else {
        updateFilterParam("");
        resetFilters();
      }
      dateFiltersTemp = state.dateFilters.toList();
      aiAlertsFiltersTemp = state.aiAlertsFilters.toList();
      aiAlertsSubFiltersTemp = state.aiAlertsSubFilters.toList();
      deviceFiltersTemp = state.deviceFilters.toList();
    }
    if (isRead == 0) {
      emit(
        state.rebuild(
          (b) => b
            ..unReadNotificationApi.replace(ApiState())
            ..unReadNotificationApi.totalCount = 0
            ..unReadNotificationApi.isApiInProgress = true
            ..unReadNotificationApi.currentPage = 0,
        ),
      );
      return CubitUtils.makePaginatedApiCall<NotificationState,
          NotificationStateBuilder, PaginatedData<NotificationData>>(
        cubit: this,
        apiState: state.unReadNotificationApi,
        updateApiState: (final b, final apiState) =>
            b.unReadNotificationApi.replace(apiState),
        callApi: (final page) async {
          final paginatedData = await apiService.getNotifications(
            page: page,
            filterParam: state.filterParam,
            startDate: state.customDate,
            isRead: isRead,
            noDeviceAvailable: state.noDeviceAvailable.isNotEmpty,
            deviceId: state.deviceId.contains("camera") ? "" : state.deviceId,
            cameraId: state.deviceId.contains("camera") ? state.deviceId : "",
          );
          final paginatedDataNotifications = PaginatedData.fromDynamic(
            paginatedData,
            NotificationData.serializer,
            serializersNotification,
          );
          final unreadItems = (paginatedData['data'] as List)
              .where((item) => item['is_read'] == 0)
              .map(NotificationData.fromDynamic)
              .map((e) => e.rebuild((b) => b..isRead = 1))
              .toList();
          unawaited(markAllAsRead());
          final updatedNotificationList = BuiltList<NotificationData>([
            ...unreadItems,
            ...state.notificationApi.data!.data,
          ]);

          final updatedPaginatedData = state.notificationApi.data!.rebuild(
            (b) => b..data = updatedNotificationList.toBuilder(),
          );
          _logger.fine(state.notificationApi.data);
          emit(
            state.rebuild(
              (b) => b
                ..notificationApi.data = b.notificationApi.data?.rebuild(
                  (n) => n..data = updatedPaginatedData.data.toBuilder(),
                )
                ..newNotification = false,
            ),
          );
          _logger.fine(state.notificationApi.data);
          if (_scrollController.hasClients) {
            unawaited(
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              ),
            );
          }

          return paginatedDataNotifications;
        },
        currentPage: state.unReadNotificationApi.currentPage,
        totalPages: state.unReadNotificationApi.totalCount,
        onPageUpdate: (final newPage) {
          _logger.fine('Updating Page to: $newPage');
          emit(
            state
                .rebuild((b) => b..unReadNotificationApi.currentPage = newPage),
          );
        },
      );
    }
    return CubitUtils.makePaginatedApiCall<NotificationState,
        NotificationStateBuilder, PaginatedData<NotificationData>>(
      cubit: this,
      apiState: state.notificationApi,
      updateApiState: (final b, final apiState) =>
          b.notificationApi.replace(apiState),
      callApi: (final page) async {
        final paginatedData = await apiService.getNotifications(
          page: page,
          filterParam: state.filterParam,
          isRead: 1,
          startDate: state.customDate,
          noDeviceAvailable: state.noDeviceAvailable.isNotEmpty,
          deviceId: state.deviceId.contains("camera") ? "" : state.deviceId,
          cameraId: state.deviceId.contains("camera") ? state.deviceId : "",
        );
        unawaited(markAllAsRead());
        return PaginatedData.fromDynamic(
          paginatedData,
          NotificationData.serializer,
          serializersNotification,
        );
      },
      currentPage: state.notificationApi.currentPage,
      totalPages: state.notificationApi.totalCount,
      onPageUpdate: (final newPage) {
        _logger.fine('Updating Page to: $newPage');
        emit(state.rebuild((b) => b..notificationApi.currentPage = newPage));
      },
    );
  }

  int? _previousIndex; // Tracks the previously expanded notification

  void lastUpdated(int originalIndex) {
    if ((_previousIndex ?? 0) > state.notificationApi.data!.data.length) {
      _previousIndex = null;
    }
    emit(
      state.rebuild(
        (b) {
          // Collapse the previously expanded notification, if it exists and is different
          if (_previousIndex != null && _previousIndex != originalIndex) {
            b.notificationApi.data = b.notificationApi.data?.rebuild(
              (d) => d.data[_previousIndex!] = d.data[_previousIndex!].rebuild(
                (n) => n.expanded = false,
              ),
            );
          }

          // Toggle the current notification's expanded state
          b.notificationApi.data = b.notificationApi.data?.rebuild(
            (d) => d.data[originalIndex] = d.data[originalIndex].rebuild(
              (n) => n.expanded = !(n.expanded ?? false),
            ),
          );

          // Update `_previousIndex` to the currently expanded notification
          _previousIndex = originalIndex;
        },
      ),
    );
  }

  void resetFilters() {
    final updatedDateFilters = List.of(state.dateFilters);
    final updatedAiFilters = List.of(state.aiAlertsFilters);
    final updatedAiSubFilters = List.of(state.aiAlertsSubFilters);
    final updatedDeviceSubFilters = List.of(state.deviceFilters);

    updateNoDeviceAvailable("");
    for (int i = 0; i < updatedDateFilters.length; i++) {
      updatedDateFilters[i] = updatedDateFilters[i].copyWith(isSelected: false);
    }
    for (int i = 0; i < updatedAiFilters.length; i++) {
      updatedAiFilters[i] = updatedAiFilters[i].copyWith(isSelected: false);
    }
    for (int i = 0; i < updatedAiSubFilters.length; i++) {
      updatedAiSubFilters[i] =
          updatedAiSubFilters[i].copyWith(isSelected: false);
    }
    for (int i = 0; i < updatedDeviceSubFilters.length; i++) {
      updatedDeviceSubFilters[i] =
          updatedDeviceSubFilters[i].copyWith(isSelected: false);
    }
    emit(
      state.rebuild(
        (e) => e
          ..dateFilters.replace(updatedDateFilters)
          ..aiAlertsFilters.replace(updatedAiFilters)
          ..deviceFilters.replace(updatedDeviceSubFilters)
          ..customDate = null
          ..filter = false
          ..filterParam = ""
          ..deviceId = ""
          ..aiAlertsSubFilters.replace(updatedAiSubFilters),
      ),
    );
  }

  void resetFiltersWithoutFilterParam() {
    final updatedDateFilters = List.of(state.dateFilters);
    final updatedAiFilters = List.of(state.aiAlertsFilters);
    final updatedAiSubFilters = List.of(state.aiAlertsSubFilters);
    final updatedDeviceSubFilters = List.of(state.deviceFilters);

    for (int i = 0; i < updatedDateFilters.length; i++) {
      updatedDateFilters[i] = updatedDateFilters[i].copyWith(isSelected: false);
    }
    for (int i = 0; i < updatedAiFilters.length; i++) {
      updatedAiFilters[i] = updatedAiFilters[i].copyWith(isSelected: false);
    }
    for (int i = 0; i < updatedAiSubFilters.length; i++) {
      updatedAiSubFilters[i] =
          updatedAiSubFilters[i].copyWith(isSelected: false);
    }
    for (int i = 0; i < updatedDeviceSubFilters.length; i++) {
      updatedDeviceSubFilters[i] =
          updatedDeviceSubFilters[i].copyWith(isSelected: false);
    }
    emit(
      state.rebuild(
        (e) => e
          ..dateFilters.replace(updatedDateFilters)
          ..aiAlertsFilters.replace(updatedAiFilters)
          ..deviceFilters.replace(updatedDeviceSubFilters)
          ..customDate = null
          ..deviceId = ""
          ..aiAlertsSubFilters.replace(updatedAiSubFilters),
      ),
    );
  }

  void updateDateFilter(
    int index,
    bool isSelected,
  ) {
    // Create a new list from the existing filters
    final updatedFilters = List.of(state.dateFilters);

    // If selecting an item, deselect all other items
    if (isSelected) {
      // Deselect all filters first
      for (int i = 0; i < updatedFilters.length; i++) {
        updatedFilters[i] = updatedFilters[i].copyWith(isSelected: false);
      }
      // Then select the current one
      updatedFilters[index] = updatedFilters[index].copyWith(isSelected: true);
    } else {
      // If unselecting, just update the current item
      updatedFilters[index] = updatedFilters[index].copyWith(isSelected: false);
    }

    // Emit the new state with the updated filters list
    emit(state.rebuild((e) => e.dateFilters.replace(updatedFilters)));
  }

  void updateAiFilter(
    int index,
    bool isSelected,
  ) {
    // Create a new list from the existing filters
    final updatedFilters = List.of(state.aiAlertsFilters);

    // If selecting an item, deselect all other items
    if (isSelected) {
      if (index == state.aiAlertsFilters.length - 1) {
        final updatedFilters = List.of(state.aiAlertsSubFilters);

        for (int i = 0; i < updatedFilters.length; i++) {
          updatedFilters[i] = updatedFilters[i].copyWith(isSelected: true);
        }
        emit(
          state.rebuild((e) => e.aiAlertsSubFilters.replace(updatedFilters)),
        );
      }
      updatedFilters[index] = updatedFilters[index].copyWith(isSelected: true);
    } else {
      // If unselecting, just update the current item
      if (index == state.aiAlertsFilters.length - 1) {
        final updatedFilters = List.of(state.aiAlertsSubFilters);

        for (int i = 0; i < updatedFilters.length; i++) {
          updatedFilters[i] = updatedFilters[i].copyWith(isSelected: false);
        }
        emit(
          state.rebuild((e) => e.aiAlertsSubFilters.replace(updatedFilters)),
        );
      }
      updatedFilters[index] = updatedFilters[index].copyWith(isSelected: false);
    }

    // Emit the new state with the updated filters list
    emit(state.rebuild((e) => e.aiAlertsFilters.replace(updatedFilters)));
  }

  void updateAiSubFilter(
    int index,
    bool isSelected,
  ) {
    // Create a new list from the existing filters
    final updatedFilters = List.of(state.aiAlertsSubFilters);

    // If selecting an item, deselect all other items
    if (isSelected) {
      updatedFilters[index] = updatedFilters[index].copyWith(isSelected: true);
    } else {
      // If unselecting, just update the current item
      updatedFilters[index] = updatedFilters[index].copyWith(isSelected: false);
    }
    if (updatedFilters.any((filter) => !filter.isSelected)) {
      final updatedAiFilters = List.of(state.aiAlertsFilters);
      updatedAiFilters[state.aiAlertsFilters.length - 1] =
          updatedAiFilters[state.aiAlertsFilters.length - 1]
              .copyWith(isSelected: false);
      emit(state.rebuild((e) => e.aiAlertsFilters.replace(updatedAiFilters)));
    }
    // Emit the new state with the updated filters list
    emit(state.rebuild((e) => e.aiAlertsSubFilters.replace(updatedFilters)));
  }

  void updateDevicesFilter(
    int index,
    bool isSelected,
  ) {
    // Create a new list from the existing filters
    final updatedFilters = List.of(state.deviceFilters);

    // If selecting an item, deselect all other items
    if (isSelected) {
      // Deselect all filters first
      for (int i = 0; i < updatedFilters.length; i++) {
        updatedFilters[i] = updatedFilters[i].copyWith(isSelected: false);
      }
      // Then select the current one
      updatedFilters[index] = updatedFilters[index].copyWith(isSelected: true);
    } else {
      // If unselecting, just update the current item
      updatedFilters[index] = updatedFilters[index].copyWith(isSelected: false);
    }

    // Emit the new state with the updated filters list
    emit(state.rebuild((e) => e.deviceFilters.replace(updatedFilters)));
  }

  ///TODO: Mahboob need to fix this
  Future<void> callDevicesApi({context}) async {
    try {
      List<UserDeviceModel> list = [];

      if (context == null) {
        final BuiltList<UserDeviceModel> userDoorbell =
            await apiService.getUserDoorbells();
        list = userDoorbell.toList()
          ..removeWhere(
            (e) =>
                e.locationId.toString() !=
                // singletonBloc.profileBloc.state!.locationId,
                singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
                    .toString(),
          );
      } else {
        final startupBloc = StartupBloc.of(context);
        list = startupBloc.state.userDeviceModel!.toList()
          ..removeWhere(
            (e) =>
                e.locationId.toString() !=
                // singletonBloc.profileBloc.state!.locationId,
                singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
                    .toString(),
          );
      }

// ✅ Convert API data to FeatureModel list
      final newDevices = list
          .toBuiltList()
          .map(
            (e) => FeatureModel(
              title: e.name ?? "",
              value: e.isExternalCamera == true ? e.entityId : e.deviceId,
            ),
          )
          .toList();

// ✅ Extract IDs for quick lookup
      final newDeviceIds = newDevices.map((e) => e.value).toSet();
      final existingDeviceIds = deviceFiltersTemp.map((e) => e.value).toSet();

// ✅ Identify removed devices
      final removedDevices = deviceFiltersTemp
          .where((device) => !newDeviceIds.contains(device.value))
          .toList();

// ✅ Check if any removed device was selected
      final bool shouldCallNotificationApi =
          removedDevices.any((device) => device.isSelected);

// ✅ Remove missing devices
      deviceFiltersTemp
          .removeWhere((device) => !newDeviceIds.contains(device.value));

// ✅ Update devices with changed names
      for (final device in deviceFiltersTemp) {
        final newDevice = newDevices.firstWhereOrNull(
          (newDevice) => newDevice.value == device.value,
        );
        if (newDevice != null && newDevice.title != device.title) {
          device.title = newDevice.title; // Update the title
        }
      }

// ✅ Add only new devices
      for (final device in newDevices) {
        if (!existingDeviceIds.contains(device.value)) {
          deviceFiltersTemp.add(device);
        }
      }

// ✅ Emit updated state
      emit(
        state.rebuild((e) {
          e.deviceFilters.replace(deviceFiltersTemp);
        }),
      );

// ✅ Call Notification API if a selected device was removed
      if (shouldCallNotificationApi) {
        await callNotificationApi(refresh: true);
      }
    } catch (e) {
      _logger.severe(e.toString());
    }
  }

  Future<void> callStatusApi({
    bool shouldNew = true,
  }) async {
    final status = await apiService.getNotificationStatus();
    emit(state.rebuild((e) => e..notificationDeviceStatus = status));
    for (final entry in status.entries) {
      if (entry.value) {
        if (shouldNew) {
          updateNewNotification(true);
        }
        break; // Stop iteration as soon as one true is found
      }
    }
  }

  Future<void> markAllAsRead({bool shouldNew = true}) async {
    await apiService.markAllAsRead();
    await callStatusApi(shouldNew: shouldNew);
  }

  void setTempList() {
    emit(
      state.rebuild(
        (e) => e
          ..dateFilters.replace(dateFiltersTemp)
          ..aiAlertsFilters.replace(aiAlertsFiltersTemp)
          ..aiAlertsSubFilters.replace(aiAlertsSubFiltersTemp)
          ..deviceFilters.replace(deviceFiltersTemp),
      ),
    );
  }

  void updateScheduleOfDoorbell({String? deviceId, required DateTime time}) {
    CubitUtils.makeApiCall<NotificationState, NotificationStateBuilder, void>(
      cubit: this,
      apiState: state.updateDoorbellSchedule,
      updateApiState: (final b, final apiState) =>
          b.updateDoorbellSchedule.replace(apiState),
      callApi: () async {
        await apiService.updateDoorbellSchedule(deviceId: deviceId, time: time);
        unawaited(
          singletonBloc.socketEmitter(
            roomName: Constants.doorbell,
            request: Constants.otaSchedule,
            deviceId:
                singletonBloc.profileBloc.state?.selectedDoorBell?.deviceId,
            message: {"time_stamp": time.millisecondsSinceEpoch},
          ),
        );
      },
    );
  }
}
