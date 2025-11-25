import 'package:admin/constants.dart';
import 'package:admin/models/data/notification_data.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'notification_state.g.dart';

abstract class NotificationState
    implements Built<NotificationState, NotificationStateBuilder> {
  factory NotificationState([
    final void Function(NotificationStateBuilder) updates,
  ]) = _$NotificationState;

  NotificationState._();
  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final NotificationStateBuilder b) {
    b
      ..notificationApi.isApiPaginationEnabled = true
      ..filter = false
      ..notificationGuideShow = false
      ..currentGuideKey = "filter"
      ..noDeviceAvailable = ""
      ..newNotification = false
      ..filterParam = ""
      ..deviceId = ""
      ..customDate = DateTime.now()
      ..dateFilters.replace([
        FeatureModel(
          title: Constants.today,
          value: "today",
        ),
        FeatureModel(
          title: Constants.yesterday,
          value: "yesterday",
        ),
        FeatureModel(
          title: Constants.thisWeek,
          value: "this_week",
        ),
        FeatureModel(
          title: Constants.thisMonth,
          value: "this_month",
        ),
        FeatureModel(
          title: Constants.lastWeek,
          value: "last_week",
        ),
        FeatureModel(
          title: Constants.lastMonth,
          value: "last_month",
        ),
        FeatureModel(
          title: Constants.custom,
          value: "custom",
        ),
      ])
      ..aiAlertsFilters.replace([
        FeatureModel(
          title: Constants.subscriptionAlerts,
          value: "payment,subscription,credit,reminder,subscribe",
        ),
        FeatureModel(
          title: Constants.spamAlerts,
          value: "spam",
        ),
        FeatureModel(
          title: Constants.neighbourhoodAlerts,
          value: "request,watch",
        ),
        FeatureModel(
          title: Constants.doorbellAlerts,
          value: "theft",
        ),
        FeatureModel(
          title: Constants.ioTAlerts,
          value: "gas,movement,motion,monitoring,door lock,flashlight",
        ),
        FeatureModel(
          title: Constants.aIAlerts,
          value: "",
        ),
      ])
      ..aiAlertsSubFilters.replace([
        FeatureModel(
          title: Constants.visitorAlert,
          value: "visitor,unwanted,a new",
        ),
        FeatureModel(
          title: Constants.babyRunningAway,
          value: "baby",
        ),
        FeatureModel(
          title: Constants.petRunningAway,
          value: "pet",
        ),
        FeatureModel(
          title: Constants.fireAlert,
          value: "fire",
        ),
        FeatureModel(
          title: Constants.intruderAlert,
          value: "intruder",
        ),
        FeatureModel(
          title: Constants.weapon,
          value: "weapon",
        ),
        FeatureModel(
          title: Constants.parcelAlert,
          value: "parcel",
        ),
        FeatureModel(
          title: Constants.eavesdropper,
          value: "eavesdropper",
        ),
        FeatureModel(
          title: Constants.dogPoop,
          value: "poop",
        ),
        FeatureModel(
          title: Constants.humanFall,
          value: "human",
        ),
        FeatureModel(
          title: Constants.boundaryBreach,
          value: "boundary",
        ),
        FeatureModel(
          title: Constants.drowningAlert,
          value: "drowning",
        ),
      ]);
  }

  BuiltList<FeatureModel> get dateFilters;

  BuiltList<FeatureModel> get aiAlertsFilters;

  BuiltList<FeatureModel> get aiAlertsSubFilters;

  BuiltList<FeatureModel> get deviceFilters;

  @BlocUpdateField()
  bool get notificationGuideShow;

  @BlocUpdateField()
  String get currentGuideKey;

  @BlocUpdateField()
  String get noDeviceAvailable;

  @BlocUpdateField()
  DateTime? get customDate;

  @BlocUpdateField()
  bool get filter;

  @BlocUpdateField()
  bool get newNotification;

  @BlocUpdateField()
  String get filterParam;

  @BlocUpdateField()
  String get deviceId;

  ApiState<PaginatedData<NotificationData>> get notificationApi;

  ApiState<void> get updateDoorbellSchedule;

  ApiState<PaginatedData<NotificationData>> get unReadNotificationApi;

  Map<String, bool>? get notificationDeviceStatus;
}
