import 'dart:ui';

import 'package:admin/models/data/ai_alert_preferences_model.dart';
import 'package:admin/models/data/api_meta_data.dart';
import 'package:admin/models/data/brand_model.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/guide_data.dart';
import 'package:admin/models/data/login_session_model.dart';
import 'package:admin/models/data/notification_code_model.dart';
import 'package:admin/models/data/notification_data.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/data/participant_model.dart';
import 'package:admin/models/data/payment_methods_model.dart';
import 'package:admin/models/data/plan_features_model.dart';
import 'package:admin/models/data/role_model.dart';
import 'package:admin/models/data/room_items_model.dart';
import 'package:admin/models/data/statistics_model.dart';
import 'package:admin/models/data/sub_user_model.dart';
import 'package:admin/models/data/subscription_location_model.dart';
import 'package:admin/models/data/transaction_history_model.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/data/visit_model.dart';
import 'package:admin/models/data/visitor_chat_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/models/enums/environment.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/pages/main/voice_control/model/voice_control_model.dart';
import 'package:admin/pages/main/voip/model/streaming_alerts_data.dart';
import 'package:admin/pages/themes/model/theme_category_model.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

part 'serializers.g.dart';

@SerializersFor([
  UserData,
  Environment,
  ApiMetaData,
  UserDeviceModel,
  IotDeviceModel,
  DoorbellLocations,
  GuideModel,
  VisitorsModel,
  PaginatedData,
  NotificationData,
  RoomItemsModel,
  StreamingAlertsData,
  AiAlert,
  VisitModel,
  SubUserModel,
  RoleModel,
  LoginSessionModel,
  ThemeDataModel,
  ThemeCategoryModel,
  StatisticsModel,
  Brands,
  VoiceControlModel,
  VoiceNotificationModel,
  VoiceVisitorModel,
  VoiceThemeModel,
  CallModel,
  VoiceStatisticModel,
  SubscriptionLocationModel,
  PaymentMethodsModel,
  TransactionHistoryModel,
  AiAlertPreferencesModel,
  NotificationCodeModel,
  VisitorChatModel,
  ParticipantModel,
  ChatUserModel,
  ChatVisitorModel,
  PlanFeaturesModel,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(Iso8601DateTimeSerializer()))
    .build();

@SerializersFor([
  PaginatedData,
  NotificationData,
])
final Serializers serializersNotification =
    (_$serializersNotification.toBuilder()
          ..addPlugin(StandardJsonPlugin())
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(NotificationData)]),
            ListBuilder<NotificationData>.new,
          )
          ..add(PaginatedData.serializer(NotificationData.serializer))
          ..add(Iso8601DateTimeSerializer()))
        .build();

@SerializersFor([
  PaginatedData,
  VisitorsModel,
])
final Serializers serializersVisitorModel =
    (_$serializersVisitorModel.toBuilder()
          ..addPlugin(StandardJsonPlugin())
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(VisitorsModel)]),
            ListBuilder<VisitorsModel>.new,
          )
          ..add(PaginatedData.serializer(VisitorsModel.serializer))
          ..add(Iso8601DateTimeSerializer()))
        .build();

@SerializersFor([
  PaginatedData,
  VisitModel,
])
final Serializers serializersVisitModel = (_$serializersVisitModel.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(VisitModel)]),
        ListBuilder<VisitModel>.new,
      )
      ..add(PaginatedData.serializer(VisitModel.serializer))
      ..add(Iso8601DateTimeSerializer()))
    .build();

@SerializersFor([
  PaginatedData,
  ThemeDataModel,
])
final Serializers serializersThemeDataModel =
    (_$serializersThemeDataModel.toBuilder()
          ..addPlugin(StandardJsonPlugin())
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ThemeDataModel)]),
            ListBuilder<ThemeDataModel>.new,
          )
          ..add(PaginatedData.serializer(ThemeDataModel.serializer))
          ..add(Iso8601DateTimeSerializer()))
        .build();

@SerializersFor([
  PaginatedData,
  ThemeCategoryModel,
])
final Serializers serializersThemeCategoryModel =
    (_$serializersThemeCategoryModel.toBuilder()
          ..addPlugin(StandardJsonPlugin())
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ThemeCategoryModel)]),
            ListBuilder<ThemeCategoryModel>.new,
          )
          ..add(PaginatedData.serializer(ThemeCategoryModel.serializer))
          ..add(Iso8601DateTimeSerializer()))
        .build();
