import 'package:admin/models/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'voice_control_model.g.dart';

abstract class VoiceControlModel
    implements Built<VoiceControlModel, VoiceControlModelBuilder> {
  factory VoiceControlModel([void Function(VoiceControlModelBuilder) updates]) =
      _$VoiceControlModel;

  VoiceControlModel._();

  static Serializer<VoiceControlModel> get serializer =>
      _$voiceControlModelSerializer;

  @BuiltValueField(wireName: 'user_id')
  String get userId;

  String? get command;

  // @BuiltValueField(wireName: 'generated_theme_s3_url')
  String get text;
  String get userQuery;

  @BuiltValueField(wireName: 'location_id')
  String get locationId;

  VoiceNotificationModel? get notifications;
  VoiceVisitorModel? get visitors;
  VoiceThemeModel? get theme;
  CallModel? get call;
  VoiceStatisticModel? get statistics;

  static VoiceControlModel fromDynamic(Map<String, dynamic> json) {
    if (json["user_id"] != null) {
      json["user_id"] = json["user_id"].toString();
    }
    if (json["location_id"] != null) {
      json["location_id"] = json["location_id"].toString();
    }
    if (json["themes"] != null) {
      json["theme"] = json["themes"];
    }
    if (json["visitor"] != null) {
      json["visitors"] = json["visitor"];
    }
    // Fix custom_date and custom_name formatting
    for (final section in ['notifications', 'visitors', 'statistics']) {
      if (json[section] != null) {
        if (json[section]['custom_date'] != null) {
          json[section]['custom_date'] =
              json[section]['custom_date'].toString();
        }
        if (json[section]['custom_name'] != null) {
          json[section]['custom_name'] =
              json[section]['custom_name'].toString();
        }
      }
    }

    final model =
        serializers.deserializeWith(VoiceControlModel.serializer, json)!;

    // Apply default-fixing extensions
    return model.rebuild((b) {
      b
        ..notifications = model.notifications?.withDefaults().toBuilder()
        ..visitors = model.visitors?.withDefaults().toBuilder()
        ..statistics = model.statistics?.withDefaults().toBuilder()
        ..theme = model.theme?.withDefaults().toBuilder()
        ..call = model.call?.withDefaults().toBuilder();
    });
  }
}

abstract class VoiceNotificationModel
    implements Built<VoiceNotificationModel, VoiceNotificationModelBuilder> {
  factory VoiceNotificationModel([
    void Function(VoiceNotificationModelBuilder) updates,
  ]) = _$VoiceNotificationModel;

  VoiceNotificationModel._();

  static Serializer<VoiceNotificationModel> get serializer =>
      _$voiceNotificationModelSerializer;

  bool? get today;
  bool? get yesterday;

  @BuiltValueField(wireName: 'this_week')
  bool? get thisWeek;

  @BuiltValueField(wireName: 'this_month')
  bool? get thisMonth;

  @BuiltValueField(wireName: 'last_week')
  bool? get lastWeek;

  @BuiltValueField(wireName: 'last_month')
  bool? get lastMonth;

  @BuiltValueField(wireName: 'custom_name')
  String? get customName;

  @BuiltValueField(wireName: 'custom_date')
  String? get customDate;

  @BuiltValueField(wireName: 'subscription_alerts')
  bool? get subscriptionAlerts;

  @BuiltValueField(wireName: 'spam_alerts')
  bool? get spamAlerts;

  @BuiltValueField(wireName: 'neighbourhood_alerts')
  bool? get neighbourhoodAlerts;

  @BuiltValueField(wireName: 'iot_alerts')
  bool? get iotAlerts;

  @BuiltValueField(wireName: 'ai_alerts')
  bool? get aiAlerts;

  @BuiltValueField(wireName: 'visitor_alert')
  bool? get visitorAlert;

  @BuiltValueField(wireName: 'baby_running_away')
  bool? get babyRunningAway;

  @BuiltValueField(wireName: 'pet_running_away')
  bool? get petRunningAway;

  @BuiltValueField(wireName: 'fire_alert')
  bool? get fireAlert;

  @BuiltValueField(wireName: 'intruder_alert')
  bool? get intruderAlert;

  bool? get weapon;

  @BuiltValueField(wireName: 'parcel_alert')
  bool? get parcelAlert;

  @BuiltValueField(wireName: 'eavesdropper')
  bool? get eavesdropper;

  @BuiltValueField(wireName: 'dog_poop')
  bool? get dogPoop;

  @BuiltValueField(wireName: 'human_fall')
  bool? get humanFall;

  @BuiltValueField(wireName: 'boundary_breach')
  bool? get boundaryBreach;

  @BuiltValueField(wireName: 'three_months')
  bool? get threeMonths;

  @BuiltValueField(wireName: 'doorbell_theft_alerts')
  bool? get doorbellTheftAlerts;

  @BuiltValueField(wireName: 'drowning_alert')
  bool? get drowningAlert;

  static VoiceNotificationModel fromDynamic(Map<String, dynamic> json) {
    if (json['custom_date'] != null) {
      // json = Map.from(json);
      json['custom_date'] = json["custom_date"].toString();
    }
    if (json['custom_name'] != null) {
      // json = Map.from(json);
      json['custom_name'] = json["custom_name"].toString();
    }
    return serializers.deserializeWith(
      VoiceNotificationModel.serializer,
      json,
    )!;
  }
}

abstract class VoiceVisitorModel
    implements Built<VoiceVisitorModel, VoiceVisitorModelBuilder> {
  factory VoiceVisitorModel([
    void Function(VoiceVisitorModelBuilder) updates,
  ]) = _$VoiceVisitorModel;

  VoiceVisitorModel._();

  static Serializer<VoiceVisitorModel> get serializer =>
      _$voiceVisitorModelSerializer;

  bool? get today;
  bool? get yesterday;

  @BuiltValueField(wireName: 'this_week')
  bool? get thisWeek;

  @BuiltValueField(wireName: 'this_month')
  bool? get thisMonth;

  @BuiltValueField(wireName: 'custom_name')
  String? get customName;

  @BuiltValueField(wireName: 'last_week')
  bool? get lastWeek;

  @BuiltValueField(wireName: 'last_month')
  bool? get lastMonth;

  @BuiltValueField(wireName: 'custom_date')
  String? get customDate;

  static VoiceVisitorModel fromDynamic(Map<String, dynamic> json) {
    if (json['custom_date'] != null) {
      // json = Map.from(json);
      json['custom_date'] = json["custom_date"].toString();
    }
    if (json['custom_name'] != null) {
      // json = Map.from(json);
      json['custom_name'] = json["custom_name"].toString();
    }
    return serializers.deserializeWith(
      VoiceVisitorModel.serializer,
      json,
    )!;
  }
}

abstract class VoiceThemeModel
    implements Built<VoiceThemeModel, VoiceThemeModelBuilder> {
  factory VoiceThemeModel([
    void Function(VoiceThemeModelBuilder) updates,
  ]) = _$VoiceThemeModel;

  VoiceThemeModel._();

  static Serializer<VoiceThemeModel> get serializer =>
      _$voiceThemeModelSerializer;

  bool? get dark;
  bool? get anime;
  bool? get space;

  @BuiltValueField(wireName: 'cars_and_vehicles')
  bool? get carsVehicles;

  bool? get pets;
  bool? get animals;
  bool? get technology;
  bool? get kids;
  bool? get mood;
  bool? get holidays;

  @BuiltValueField(wireName: 'special_events/days')
  bool? get specialEvents;

  bool? get sports;

  @BuiltValueField(wireName: 'neon_lights')
  bool? get neonLights;

  bool? get vaporwave;
  bool? get sayings;
  bool? get comics;
  bool? get nature;
  bool? get love;
}

abstract class CallModel implements Built<CallModel, CallModelBuilder> {
  factory CallModel([void Function(CallModelBuilder) updates]) = _$CallModel;
  CallModel._();

  static Serializer<CallModel> get serializer => _$callModelSerializer;

  @BuiltValueField(wireName: 'custom_name')
  bool? get customName;

  @BuiltValueField(wireName: 'unknown_visitor')
  bool? get unknownVisitor;

  @BuiltValueField(wireName: 'new_visitor')
  bool? get newVisitor;
}

abstract class VoiceStatisticModel
    implements Built<VoiceStatisticModel, VoiceStatisticModelBuilder> {
  factory VoiceStatisticModel([
    void Function(VoiceStatisticModelBuilder) updates,
  ]) = _$VoiceStatisticModel;

  VoiceStatisticModel._();

  static Serializer<VoiceStatisticModel> get serializer =>
      _$voiceStatisticModelSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final VoiceStatisticModelBuilder b) => b
    ..thisWeek = false
    ..lastWeek = false
    ..thisMonth = false
    ..threeMonths = false
    ..daysOfTheWeek = false
    ..peakVisitingHours = false
    ..frequencyOfVisits = false
    ..unknownVisitors = false
    ..customName = ""
    ..customDate = "";

  @BuiltValueField(wireName: 'this_week')
  bool get thisWeek;

  @BuiltValueField(wireName: 'last_week')
  bool get lastWeek;

  @BuiltValueField(wireName: 'this_month')
  bool get thisMonth;

  @BuiltValueField(wireName: 'three_months')
  bool get threeMonths;

  @BuiltValueField(wireName: 'days_of_the_week')
  bool get daysOfTheWeek;

  @BuiltValueField(wireName: 'peak_visiting_hours')
  bool get peakVisitingHours;

  @BuiltValueField(wireName: 'frequency_of_visits')
  bool get frequencyOfVisits;

  @BuiltValueField(wireName: 'unknown_visitors')
  bool get unknownVisitors;

  @BuiltValueField(wireName: 'custom_name')
  String get customName;

  @BuiltValueField(wireName: 'custom_date')
  String get customDate;

  static VoiceStatisticModel fromDynamic(Map<String, dynamic> json) {
    if (json['custom_date'] != null) {
      // json = Map.from(json);
      json['custom_date'] = json["custom_date"].toString();
    }
    if (json['custom_name'] != null) {
      // json = Map.from(json);
      json['custom_name'] = json["custom_name"].toString();
    }
    return serializers.deserializeWith(
      VoiceStatisticModel.serializer,
      json,
    )!;
  }
}

extension BoolFixer on VoiceNotificationModel {
  VoiceNotificationModel withDefaults() {
    return rebuild((b) {
      b
        ..today ??= false
        ..yesterday ??= false
        ..thisWeek ??= false
        ..thisMonth ??= false
        ..customDate ??= "false"
        ..lastWeek ??= false
        ..lastMonth ??= false
        ..subscriptionAlerts ??= false
        ..spamAlerts ??= false
        ..neighbourhoodAlerts ??= false
        ..iotAlerts ??= false
        ..aiAlerts ??= false
        ..visitorAlert ??= false
        ..babyRunningAway ??= false
        ..petRunningAway ??= false
        ..fireAlert ??= false
        ..intruderAlert ??= false
        ..weapon ??= false
        ..parcelAlert ??= false
        ..eavesdropper ??= false
        ..dogPoop ??= false
        ..humanFall ??= false
        ..boundaryBreach ??= false
        ..threeMonths ??= false
        ..doorbellTheftAlerts ??= false
        ..drowningAlert ??= false;
    });
  }
}

extension VisitorBoolFixer on VoiceVisitorModel {
  VoiceVisitorModel withDefaults() {
    return rebuild((b) {
      b
        ..today ??= false
        ..yesterday ??= false
        ..thisWeek ??= false
        ..customDate ??= "false"
        ..thisMonth ??= false
        ..lastWeek ??= false
        ..lastMonth ??= false;
    });
  }
}

extension StatisticBoolFixer on VoiceStatisticModel {
  VoiceStatisticModel withDefaults() {
    return rebuild((b) {
      b
        ..thisWeek = thisWeek
        ..lastWeek = lastWeek
        ..thisMonth = thisMonth
        ..customDate ??= "false"
        ..threeMonths = threeMonths
        ..daysOfTheWeek = daysOfTheWeek
        ..peakVisitingHours = peakVisitingHours
        ..frequencyOfVisits = frequencyOfVisits
        ..unknownVisitors = unknownVisitors;
    });
  }
}

extension ThemeBoolFixer on VoiceThemeModel {
  VoiceThemeModel withDefaults() {
    return rebuild((b) {
      b
        ..dark ??= false
        ..anime ??= false
        ..space ??= false
        ..carsVehicles ??= false
        ..pets ??= false
        ..animals ??= false
        ..technology ??= false
        ..kids ??= false
        ..mood ??= false
        ..holidays ??= false
        ..specialEvents ??= false
        ..sports ??= false
        ..neonLights ??= false
        ..vaporwave ??= false
        ..sayings ??= false
        ..comics ??= false
        ..nature ??= false
        ..love ??= false;
    });
  }
}

extension CallBoolFixer on CallModel {
  CallModel withDefaults() {
    return rebuild((b) {
      b
        ..customName ??= false
        ..unknownVisitor ??= false
        ..newVisitor ??= false;
    });
  }
}
