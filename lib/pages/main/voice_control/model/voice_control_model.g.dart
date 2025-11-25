// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_control_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<VoiceControlModel> _$voiceControlModelSerializer =
    _$VoiceControlModelSerializer();
Serializer<VoiceNotificationModel> _$voiceNotificationModelSerializer =
    _$VoiceNotificationModelSerializer();
Serializer<VoiceVisitorModel> _$voiceVisitorModelSerializer =
    _$VoiceVisitorModelSerializer();
Serializer<VoiceThemeModel> _$voiceThemeModelSerializer =
    _$VoiceThemeModelSerializer();
Serializer<CallModel> _$callModelSerializer = _$CallModelSerializer();
Serializer<VoiceStatisticModel> _$voiceStatisticModelSerializer =
    _$VoiceStatisticModelSerializer();

class _$VoiceControlModelSerializer
    implements StructuredSerializer<VoiceControlModel> {
  @override
  final Iterable<Type> types = const [VoiceControlModel, _$VoiceControlModel];
  @override
  final String wireName = 'VoiceControlModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, VoiceControlModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'user_id',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'text',
      serializers.serialize(object.text, specifiedType: const FullType(String)),
      'userQuery',
      serializers.serialize(object.userQuery,
          specifiedType: const FullType(String)),
      'location_id',
      serializers.serialize(object.locationId,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.command;
    if (value != null) {
      result
        ..add('command')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.notifications;
    if (value != null) {
      result
        ..add('notifications')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(VoiceNotificationModel)));
    }
    value = object.visitors;
    if (value != null) {
      result
        ..add('visitors')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(VoiceVisitorModel)));
    }
    value = object.theme;
    if (value != null) {
      result
        ..add('theme')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(VoiceThemeModel)));
    }
    value = object.call;
    if (value != null) {
      result
        ..add('call')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(CallModel)));
    }
    value = object.statistics;
    if (value != null) {
      result
        ..add('statistics')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(VoiceStatisticModel)));
    }
    return result;
  }

  @override
  VoiceControlModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = VoiceControlModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'user_id':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'command':
          result.command = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'text':
          result.text = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'userQuery':
          result.userQuery = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'location_id':
          result.locationId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'notifications':
          result.notifications.replace(serializers.deserialize(value,
                  specifiedType: const FullType(VoiceNotificationModel))!
              as VoiceNotificationModel);
          break;
        case 'visitors':
          result.visitors.replace(serializers.deserialize(value,
                  specifiedType: const FullType(VoiceVisitorModel))!
              as VoiceVisitorModel);
          break;
        case 'theme':
          result.theme.replace(serializers.deserialize(value,
                  specifiedType: const FullType(VoiceThemeModel))!
              as VoiceThemeModel);
          break;
        case 'call':
          result.call.replace(serializers.deserialize(value,
              specifiedType: const FullType(CallModel))! as CallModel);
          break;
        case 'statistics':
          result.statistics.replace(serializers.deserialize(value,
                  specifiedType: const FullType(VoiceStatisticModel))!
              as VoiceStatisticModel);
          break;
      }
    }

    return result.build();
  }
}

class _$VoiceNotificationModelSerializer
    implements StructuredSerializer<VoiceNotificationModel> {
  @override
  final Iterable<Type> types = const [
    VoiceNotificationModel,
    _$VoiceNotificationModel
  ];
  @override
  final String wireName = 'VoiceNotificationModel';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, VoiceNotificationModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.today;
    if (value != null) {
      result
        ..add('today')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.yesterday;
    if (value != null) {
      result
        ..add('yesterday')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.thisWeek;
    if (value != null) {
      result
        ..add('this_week')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.thisMonth;
    if (value != null) {
      result
        ..add('this_month')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.lastWeek;
    if (value != null) {
      result
        ..add('last_week')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.lastMonth;
    if (value != null) {
      result
        ..add('last_month')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.customName;
    if (value != null) {
      result
        ..add('custom_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.customDate;
    if (value != null) {
      result
        ..add('custom_date')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.subscriptionAlerts;
    if (value != null) {
      result
        ..add('subscription_alerts')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.spamAlerts;
    if (value != null) {
      result
        ..add('spam_alerts')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.neighbourhoodAlerts;
    if (value != null) {
      result
        ..add('neighbourhood_alerts')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.iotAlerts;
    if (value != null) {
      result
        ..add('iot_alerts')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.aiAlerts;
    if (value != null) {
      result
        ..add('ai_alerts')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.visitorAlert;
    if (value != null) {
      result
        ..add('visitor_alert')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.babyRunningAway;
    if (value != null) {
      result
        ..add('baby_running_away')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.petRunningAway;
    if (value != null) {
      result
        ..add('pet_running_away')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.fireAlert;
    if (value != null) {
      result
        ..add('fire_alert')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.intruderAlert;
    if (value != null) {
      result
        ..add('intruder_alert')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.weapon;
    if (value != null) {
      result
        ..add('weapon')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.parcelAlert;
    if (value != null) {
      result
        ..add('parcel_alert')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.eavesdropper;
    if (value != null) {
      result
        ..add('eavesdropper')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.dogPoop;
    if (value != null) {
      result
        ..add('dog_poop')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.humanFall;
    if (value != null) {
      result
        ..add('human_fall')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.boundaryBreach;
    if (value != null) {
      result
        ..add('boundary_breach')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.threeMonths;
    if (value != null) {
      result
        ..add('three_months')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.doorbellTheftAlerts;
    if (value != null) {
      result
        ..add('doorbell_theft_alerts')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.drowningAlert;
    if (value != null) {
      result
        ..add('drowning_alert')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  VoiceNotificationModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = VoiceNotificationModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'today':
          result.today = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'yesterday':
          result.yesterday = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'this_week':
          result.thisWeek = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'this_month':
          result.thisMonth = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'last_week':
          result.lastWeek = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'last_month':
          result.lastMonth = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'custom_name':
          result.customName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'custom_date':
          result.customDate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'subscription_alerts':
          result.subscriptionAlerts = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'spam_alerts':
          result.spamAlerts = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'neighbourhood_alerts':
          result.neighbourhoodAlerts = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'iot_alerts':
          result.iotAlerts = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'ai_alerts':
          result.aiAlerts = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'visitor_alert':
          result.visitorAlert = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'baby_running_away':
          result.babyRunningAway = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'pet_running_away':
          result.petRunningAway = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'fire_alert':
          result.fireAlert = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'intruder_alert':
          result.intruderAlert = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'weapon':
          result.weapon = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'parcel_alert':
          result.parcelAlert = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'eavesdropper':
          result.eavesdropper = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'dog_poop':
          result.dogPoop = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'human_fall':
          result.humanFall = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'boundary_breach':
          result.boundaryBreach = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'three_months':
          result.threeMonths = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'doorbell_theft_alerts':
          result.doorbellTheftAlerts = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'drowning_alert':
          result.drowningAlert = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
      }
    }

    return result.build();
  }
}

class _$VoiceVisitorModelSerializer
    implements StructuredSerializer<VoiceVisitorModel> {
  @override
  final Iterable<Type> types = const [VoiceVisitorModel, _$VoiceVisitorModel];
  @override
  final String wireName = 'VoiceVisitorModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, VoiceVisitorModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.today;
    if (value != null) {
      result
        ..add('today')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.yesterday;
    if (value != null) {
      result
        ..add('yesterday')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.thisWeek;
    if (value != null) {
      result
        ..add('this_week')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.thisMonth;
    if (value != null) {
      result
        ..add('this_month')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.customName;
    if (value != null) {
      result
        ..add('custom_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.lastWeek;
    if (value != null) {
      result
        ..add('last_week')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.lastMonth;
    if (value != null) {
      result
        ..add('last_month')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.customDate;
    if (value != null) {
      result
        ..add('custom_date')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  VoiceVisitorModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = VoiceVisitorModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'today':
          result.today = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'yesterday':
          result.yesterday = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'this_week':
          result.thisWeek = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'this_month':
          result.thisMonth = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'custom_name':
          result.customName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'last_week':
          result.lastWeek = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'last_month':
          result.lastMonth = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'custom_date':
          result.customDate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$VoiceThemeModelSerializer
    implements StructuredSerializer<VoiceThemeModel> {
  @override
  final Iterable<Type> types = const [VoiceThemeModel, _$VoiceThemeModel];
  @override
  final String wireName = 'VoiceThemeModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, VoiceThemeModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.dark;
    if (value != null) {
      result
        ..add('dark')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.anime;
    if (value != null) {
      result
        ..add('anime')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.space;
    if (value != null) {
      result
        ..add('space')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.carsVehicles;
    if (value != null) {
      result
        ..add('cars_and_vehicles')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.pets;
    if (value != null) {
      result
        ..add('pets')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.animals;
    if (value != null) {
      result
        ..add('animals')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.technology;
    if (value != null) {
      result
        ..add('technology')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.kids;
    if (value != null) {
      result
        ..add('kids')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.mood;
    if (value != null) {
      result
        ..add('mood')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.holidays;
    if (value != null) {
      result
        ..add('holidays')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.specialEvents;
    if (value != null) {
      result
        ..add('special_events/days')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.sports;
    if (value != null) {
      result
        ..add('sports')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.neonLights;
    if (value != null) {
      result
        ..add('neon_lights')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.vaporwave;
    if (value != null) {
      result
        ..add('vaporwave')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.sayings;
    if (value != null) {
      result
        ..add('sayings')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.comics;
    if (value != null) {
      result
        ..add('comics')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.nature;
    if (value != null) {
      result
        ..add('nature')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.love;
    if (value != null) {
      result
        ..add('love')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  VoiceThemeModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = VoiceThemeModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'dark':
          result.dark = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'anime':
          result.anime = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'space':
          result.space = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'cars_and_vehicles':
          result.carsVehicles = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'pets':
          result.pets = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'animals':
          result.animals = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'technology':
          result.technology = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'kids':
          result.kids = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'mood':
          result.mood = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'holidays':
          result.holidays = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'special_events/days':
          result.specialEvents = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'sports':
          result.sports = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'neon_lights':
          result.neonLights = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'vaporwave':
          result.vaporwave = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'sayings':
          result.sayings = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'comics':
          result.comics = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'nature':
          result.nature = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'love':
          result.love = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
      }
    }

    return result.build();
  }
}

class _$CallModelSerializer implements StructuredSerializer<CallModel> {
  @override
  final Iterable<Type> types = const [CallModel, _$CallModel];
  @override
  final String wireName = 'CallModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, CallModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.customName;
    if (value != null) {
      result
        ..add('custom_name')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.unknownVisitor;
    if (value != null) {
      result
        ..add('unknown_visitor')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.newVisitor;
    if (value != null) {
      result
        ..add('new_visitor')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  CallModel deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = CallModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'custom_name':
          result.customName = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'unknown_visitor':
          result.unknownVisitor = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'new_visitor':
          result.newVisitor = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
      }
    }

    return result.build();
  }
}

class _$VoiceStatisticModelSerializer
    implements StructuredSerializer<VoiceStatisticModel> {
  @override
  final Iterable<Type> types = const [
    VoiceStatisticModel,
    _$VoiceStatisticModel
  ];
  @override
  final String wireName = 'VoiceStatisticModel';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, VoiceStatisticModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'this_week',
      serializers.serialize(object.thisWeek,
          specifiedType: const FullType(bool)),
      'last_week',
      serializers.serialize(object.lastWeek,
          specifiedType: const FullType(bool)),
      'this_month',
      serializers.serialize(object.thisMonth,
          specifiedType: const FullType(bool)),
      'three_months',
      serializers.serialize(object.threeMonths,
          specifiedType: const FullType(bool)),
      'days_of_the_week',
      serializers.serialize(object.daysOfTheWeek,
          specifiedType: const FullType(bool)),
      'peak_visiting_hours',
      serializers.serialize(object.peakVisitingHours,
          specifiedType: const FullType(bool)),
      'frequency_of_visits',
      serializers.serialize(object.frequencyOfVisits,
          specifiedType: const FullType(bool)),
      'unknown_visitors',
      serializers.serialize(object.unknownVisitors,
          specifiedType: const FullType(bool)),
      'custom_name',
      serializers.serialize(object.customName,
          specifiedType: const FullType(String)),
      'custom_date',
      serializers.serialize(object.customDate,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  VoiceStatisticModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = VoiceStatisticModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'this_week':
          result.thisWeek = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'last_week':
          result.lastWeek = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'this_month':
          result.thisMonth = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'three_months':
          result.threeMonths = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'days_of_the_week':
          result.daysOfTheWeek = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'peak_visiting_hours':
          result.peakVisitingHours = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'frequency_of_visits':
          result.frequencyOfVisits = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'unknown_visitors':
          result.unknownVisitors = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'custom_name':
          result.customName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'custom_date':
          result.customDate = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$VoiceControlModel extends VoiceControlModel {
  @override
  final String userId;
  @override
  final String? command;
  @override
  final String text;
  @override
  final String userQuery;
  @override
  final String locationId;
  @override
  final VoiceNotificationModel? notifications;
  @override
  final VoiceVisitorModel? visitors;
  @override
  final VoiceThemeModel? theme;
  @override
  final CallModel? call;
  @override
  final VoiceStatisticModel? statistics;

  factory _$VoiceControlModel(
          [void Function(VoiceControlModelBuilder)? updates]) =>
      (VoiceControlModelBuilder()..update(updates))._build();

  _$VoiceControlModel._(
      {required this.userId,
      this.command,
      required this.text,
      required this.userQuery,
      required this.locationId,
      this.notifications,
      this.visitors,
      this.theme,
      this.call,
      this.statistics})
      : super._();
  @override
  VoiceControlModel rebuild(void Function(VoiceControlModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VoiceControlModelBuilder toBuilder() =>
      VoiceControlModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VoiceControlModel &&
        userId == other.userId &&
        command == other.command &&
        text == other.text &&
        userQuery == other.userQuery &&
        locationId == other.locationId &&
        notifications == other.notifications &&
        visitors == other.visitors &&
        theme == other.theme &&
        call == other.call &&
        statistics == other.statistics;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, command.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, userQuery.hashCode);
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, notifications.hashCode);
    _$hash = $jc(_$hash, visitors.hashCode);
    _$hash = $jc(_$hash, theme.hashCode);
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, statistics.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VoiceControlModel')
          ..add('userId', userId)
          ..add('command', command)
          ..add('text', text)
          ..add('userQuery', userQuery)
          ..add('locationId', locationId)
          ..add('notifications', notifications)
          ..add('visitors', visitors)
          ..add('theme', theme)
          ..add('call', call)
          ..add('statistics', statistics))
        .toString();
  }
}

class VoiceControlModelBuilder
    implements Builder<VoiceControlModel, VoiceControlModelBuilder> {
  _$VoiceControlModel? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _command;
  String? get command => _$this._command;
  set command(String? command) => _$this._command = command;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _userQuery;
  String? get userQuery => _$this._userQuery;
  set userQuery(String? userQuery) => _$this._userQuery = userQuery;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  VoiceNotificationModelBuilder? _notifications;
  VoiceNotificationModelBuilder get notifications =>
      _$this._notifications ??= VoiceNotificationModelBuilder();
  set notifications(VoiceNotificationModelBuilder? notifications) =>
      _$this._notifications = notifications;

  VoiceVisitorModelBuilder? _visitors;
  VoiceVisitorModelBuilder get visitors =>
      _$this._visitors ??= VoiceVisitorModelBuilder();
  set visitors(VoiceVisitorModelBuilder? visitors) =>
      _$this._visitors = visitors;

  VoiceThemeModelBuilder? _theme;
  VoiceThemeModelBuilder get theme =>
      _$this._theme ??= VoiceThemeModelBuilder();
  set theme(VoiceThemeModelBuilder? theme) => _$this._theme = theme;

  CallModelBuilder? _call;
  CallModelBuilder get call => _$this._call ??= CallModelBuilder();
  set call(CallModelBuilder? call) => _$this._call = call;

  VoiceStatisticModelBuilder? _statistics;
  VoiceStatisticModelBuilder get statistics =>
      _$this._statistics ??= VoiceStatisticModelBuilder();
  set statistics(VoiceStatisticModelBuilder? statistics) =>
      _$this._statistics = statistics;

  VoiceControlModelBuilder();

  VoiceControlModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _command = $v.command;
      _text = $v.text;
      _userQuery = $v.userQuery;
      _locationId = $v.locationId;
      _notifications = $v.notifications?.toBuilder();
      _visitors = $v.visitors?.toBuilder();
      _theme = $v.theme?.toBuilder();
      _call = $v.call?.toBuilder();
      _statistics = $v.statistics?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VoiceControlModel other) {
    _$v = other as _$VoiceControlModel;
  }

  @override
  void update(void Function(VoiceControlModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VoiceControlModel build() => _build();

  _$VoiceControlModel _build() {
    _$VoiceControlModel _$result;
    try {
      _$result = _$v ??
          _$VoiceControlModel._(
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'VoiceControlModel', 'userId'),
            command: command,
            text: BuiltValueNullFieldError.checkNotNull(
                text, r'VoiceControlModel', 'text'),
            userQuery: BuiltValueNullFieldError.checkNotNull(
                userQuery, r'VoiceControlModel', 'userQuery'),
            locationId: BuiltValueNullFieldError.checkNotNull(
                locationId, r'VoiceControlModel', 'locationId'),
            notifications: _notifications?.build(),
            visitors: _visitors?.build(),
            theme: _theme?.build(),
            call: _call?.build(),
            statistics: _statistics?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'notifications';
        _notifications?.build();
        _$failedField = 'visitors';
        _visitors?.build();
        _$failedField = 'theme';
        _theme?.build();
        _$failedField = 'call';
        _call?.build();
        _$failedField = 'statistics';
        _statistics?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VoiceControlModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$VoiceNotificationModel extends VoiceNotificationModel {
  @override
  final bool? today;
  @override
  final bool? yesterday;
  @override
  final bool? thisWeek;
  @override
  final bool? thisMonth;
  @override
  final bool? lastWeek;
  @override
  final bool? lastMonth;
  @override
  final String? customName;
  @override
  final String? customDate;
  @override
  final bool? subscriptionAlerts;
  @override
  final bool? spamAlerts;
  @override
  final bool? neighbourhoodAlerts;
  @override
  final bool? iotAlerts;
  @override
  final bool? aiAlerts;
  @override
  final bool? visitorAlert;
  @override
  final bool? babyRunningAway;
  @override
  final bool? petRunningAway;
  @override
  final bool? fireAlert;
  @override
  final bool? intruderAlert;
  @override
  final bool? weapon;
  @override
  final bool? parcelAlert;
  @override
  final bool? eavesdropper;
  @override
  final bool? dogPoop;
  @override
  final bool? humanFall;
  @override
  final bool? boundaryBreach;
  @override
  final bool? threeMonths;
  @override
  final bool? doorbellTheftAlerts;
  @override
  final bool? drowningAlert;

  factory _$VoiceNotificationModel(
          [void Function(VoiceNotificationModelBuilder)? updates]) =>
      (VoiceNotificationModelBuilder()..update(updates))._build();

  _$VoiceNotificationModel._(
      {this.today,
      this.yesterday,
      this.thisWeek,
      this.thisMonth,
      this.lastWeek,
      this.lastMonth,
      this.customName,
      this.customDate,
      this.subscriptionAlerts,
      this.spamAlerts,
      this.neighbourhoodAlerts,
      this.iotAlerts,
      this.aiAlerts,
      this.visitorAlert,
      this.babyRunningAway,
      this.petRunningAway,
      this.fireAlert,
      this.intruderAlert,
      this.weapon,
      this.parcelAlert,
      this.eavesdropper,
      this.dogPoop,
      this.humanFall,
      this.boundaryBreach,
      this.threeMonths,
      this.doorbellTheftAlerts,
      this.drowningAlert})
      : super._();
  @override
  VoiceNotificationModel rebuild(
          void Function(VoiceNotificationModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VoiceNotificationModelBuilder toBuilder() =>
      VoiceNotificationModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VoiceNotificationModel &&
        today == other.today &&
        yesterday == other.yesterday &&
        thisWeek == other.thisWeek &&
        thisMonth == other.thisMonth &&
        lastWeek == other.lastWeek &&
        lastMonth == other.lastMonth &&
        customName == other.customName &&
        customDate == other.customDate &&
        subscriptionAlerts == other.subscriptionAlerts &&
        spamAlerts == other.spamAlerts &&
        neighbourhoodAlerts == other.neighbourhoodAlerts &&
        iotAlerts == other.iotAlerts &&
        aiAlerts == other.aiAlerts &&
        visitorAlert == other.visitorAlert &&
        babyRunningAway == other.babyRunningAway &&
        petRunningAway == other.petRunningAway &&
        fireAlert == other.fireAlert &&
        intruderAlert == other.intruderAlert &&
        weapon == other.weapon &&
        parcelAlert == other.parcelAlert &&
        eavesdropper == other.eavesdropper &&
        dogPoop == other.dogPoop &&
        humanFall == other.humanFall &&
        boundaryBreach == other.boundaryBreach &&
        threeMonths == other.threeMonths &&
        doorbellTheftAlerts == other.doorbellTheftAlerts &&
        drowningAlert == other.drowningAlert;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, today.hashCode);
    _$hash = $jc(_$hash, yesterday.hashCode);
    _$hash = $jc(_$hash, thisWeek.hashCode);
    _$hash = $jc(_$hash, thisMonth.hashCode);
    _$hash = $jc(_$hash, lastWeek.hashCode);
    _$hash = $jc(_$hash, lastMonth.hashCode);
    _$hash = $jc(_$hash, customName.hashCode);
    _$hash = $jc(_$hash, customDate.hashCode);
    _$hash = $jc(_$hash, subscriptionAlerts.hashCode);
    _$hash = $jc(_$hash, spamAlerts.hashCode);
    _$hash = $jc(_$hash, neighbourhoodAlerts.hashCode);
    _$hash = $jc(_$hash, iotAlerts.hashCode);
    _$hash = $jc(_$hash, aiAlerts.hashCode);
    _$hash = $jc(_$hash, visitorAlert.hashCode);
    _$hash = $jc(_$hash, babyRunningAway.hashCode);
    _$hash = $jc(_$hash, petRunningAway.hashCode);
    _$hash = $jc(_$hash, fireAlert.hashCode);
    _$hash = $jc(_$hash, intruderAlert.hashCode);
    _$hash = $jc(_$hash, weapon.hashCode);
    _$hash = $jc(_$hash, parcelAlert.hashCode);
    _$hash = $jc(_$hash, eavesdropper.hashCode);
    _$hash = $jc(_$hash, dogPoop.hashCode);
    _$hash = $jc(_$hash, humanFall.hashCode);
    _$hash = $jc(_$hash, boundaryBreach.hashCode);
    _$hash = $jc(_$hash, threeMonths.hashCode);
    _$hash = $jc(_$hash, doorbellTheftAlerts.hashCode);
    _$hash = $jc(_$hash, drowningAlert.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VoiceNotificationModel')
          ..add('today', today)
          ..add('yesterday', yesterday)
          ..add('thisWeek', thisWeek)
          ..add('thisMonth', thisMonth)
          ..add('lastWeek', lastWeek)
          ..add('lastMonth', lastMonth)
          ..add('customName', customName)
          ..add('customDate', customDate)
          ..add('subscriptionAlerts', subscriptionAlerts)
          ..add('spamAlerts', spamAlerts)
          ..add('neighbourhoodAlerts', neighbourhoodAlerts)
          ..add('iotAlerts', iotAlerts)
          ..add('aiAlerts', aiAlerts)
          ..add('visitorAlert', visitorAlert)
          ..add('babyRunningAway', babyRunningAway)
          ..add('petRunningAway', petRunningAway)
          ..add('fireAlert', fireAlert)
          ..add('intruderAlert', intruderAlert)
          ..add('weapon', weapon)
          ..add('parcelAlert', parcelAlert)
          ..add('eavesdropper', eavesdropper)
          ..add('dogPoop', dogPoop)
          ..add('humanFall', humanFall)
          ..add('boundaryBreach', boundaryBreach)
          ..add('threeMonths', threeMonths)
          ..add('doorbellTheftAlerts', doorbellTheftAlerts)
          ..add('drowningAlert', drowningAlert))
        .toString();
  }
}

class VoiceNotificationModelBuilder
    implements Builder<VoiceNotificationModel, VoiceNotificationModelBuilder> {
  _$VoiceNotificationModel? _$v;

  bool? _today;
  bool? get today => _$this._today;
  set today(bool? today) => _$this._today = today;

  bool? _yesterday;
  bool? get yesterday => _$this._yesterday;
  set yesterday(bool? yesterday) => _$this._yesterday = yesterday;

  bool? _thisWeek;
  bool? get thisWeek => _$this._thisWeek;
  set thisWeek(bool? thisWeek) => _$this._thisWeek = thisWeek;

  bool? _thisMonth;
  bool? get thisMonth => _$this._thisMonth;
  set thisMonth(bool? thisMonth) => _$this._thisMonth = thisMonth;

  bool? _lastWeek;
  bool? get lastWeek => _$this._lastWeek;
  set lastWeek(bool? lastWeek) => _$this._lastWeek = lastWeek;

  bool? _lastMonth;
  bool? get lastMonth => _$this._lastMonth;
  set lastMonth(bool? lastMonth) => _$this._lastMonth = lastMonth;

  String? _customName;
  String? get customName => _$this._customName;
  set customName(String? customName) => _$this._customName = customName;

  String? _customDate;
  String? get customDate => _$this._customDate;
  set customDate(String? customDate) => _$this._customDate = customDate;

  bool? _subscriptionAlerts;
  bool? get subscriptionAlerts => _$this._subscriptionAlerts;
  set subscriptionAlerts(bool? subscriptionAlerts) =>
      _$this._subscriptionAlerts = subscriptionAlerts;

  bool? _spamAlerts;
  bool? get spamAlerts => _$this._spamAlerts;
  set spamAlerts(bool? spamAlerts) => _$this._spamAlerts = spamAlerts;

  bool? _neighbourhoodAlerts;
  bool? get neighbourhoodAlerts => _$this._neighbourhoodAlerts;
  set neighbourhoodAlerts(bool? neighbourhoodAlerts) =>
      _$this._neighbourhoodAlerts = neighbourhoodAlerts;

  bool? _iotAlerts;
  bool? get iotAlerts => _$this._iotAlerts;
  set iotAlerts(bool? iotAlerts) => _$this._iotAlerts = iotAlerts;

  bool? _aiAlerts;
  bool? get aiAlerts => _$this._aiAlerts;
  set aiAlerts(bool? aiAlerts) => _$this._aiAlerts = aiAlerts;

  bool? _visitorAlert;
  bool? get visitorAlert => _$this._visitorAlert;
  set visitorAlert(bool? visitorAlert) => _$this._visitorAlert = visitorAlert;

  bool? _babyRunningAway;
  bool? get babyRunningAway => _$this._babyRunningAway;
  set babyRunningAway(bool? babyRunningAway) =>
      _$this._babyRunningAway = babyRunningAway;

  bool? _petRunningAway;
  bool? get petRunningAway => _$this._petRunningAway;
  set petRunningAway(bool? petRunningAway) =>
      _$this._petRunningAway = petRunningAway;

  bool? _fireAlert;
  bool? get fireAlert => _$this._fireAlert;
  set fireAlert(bool? fireAlert) => _$this._fireAlert = fireAlert;

  bool? _intruderAlert;
  bool? get intruderAlert => _$this._intruderAlert;
  set intruderAlert(bool? intruderAlert) =>
      _$this._intruderAlert = intruderAlert;

  bool? _weapon;
  bool? get weapon => _$this._weapon;
  set weapon(bool? weapon) => _$this._weapon = weapon;

  bool? _parcelAlert;
  bool? get parcelAlert => _$this._parcelAlert;
  set parcelAlert(bool? parcelAlert) => _$this._parcelAlert = parcelAlert;

  bool? _eavesdropper;
  bool? get eavesdropper => _$this._eavesdropper;
  set eavesdropper(bool? eavesdropper) => _$this._eavesdropper = eavesdropper;

  bool? _dogPoop;
  bool? get dogPoop => _$this._dogPoop;
  set dogPoop(bool? dogPoop) => _$this._dogPoop = dogPoop;

  bool? _humanFall;
  bool? get humanFall => _$this._humanFall;
  set humanFall(bool? humanFall) => _$this._humanFall = humanFall;

  bool? _boundaryBreach;
  bool? get boundaryBreach => _$this._boundaryBreach;
  set boundaryBreach(bool? boundaryBreach) =>
      _$this._boundaryBreach = boundaryBreach;

  bool? _threeMonths;
  bool? get threeMonths => _$this._threeMonths;
  set threeMonths(bool? threeMonths) => _$this._threeMonths = threeMonths;

  bool? _doorbellTheftAlerts;
  bool? get doorbellTheftAlerts => _$this._doorbellTheftAlerts;
  set doorbellTheftAlerts(bool? doorbellTheftAlerts) =>
      _$this._doorbellTheftAlerts = doorbellTheftAlerts;

  bool? _drowningAlert;
  bool? get drowningAlert => _$this._drowningAlert;
  set drowningAlert(bool? drowningAlert) =>
      _$this._drowningAlert = drowningAlert;

  VoiceNotificationModelBuilder();

  VoiceNotificationModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _today = $v.today;
      _yesterday = $v.yesterday;
      _thisWeek = $v.thisWeek;
      _thisMonth = $v.thisMonth;
      _lastWeek = $v.lastWeek;
      _lastMonth = $v.lastMonth;
      _customName = $v.customName;
      _customDate = $v.customDate;
      _subscriptionAlerts = $v.subscriptionAlerts;
      _spamAlerts = $v.spamAlerts;
      _neighbourhoodAlerts = $v.neighbourhoodAlerts;
      _iotAlerts = $v.iotAlerts;
      _aiAlerts = $v.aiAlerts;
      _visitorAlert = $v.visitorAlert;
      _babyRunningAway = $v.babyRunningAway;
      _petRunningAway = $v.petRunningAway;
      _fireAlert = $v.fireAlert;
      _intruderAlert = $v.intruderAlert;
      _weapon = $v.weapon;
      _parcelAlert = $v.parcelAlert;
      _eavesdropper = $v.eavesdropper;
      _dogPoop = $v.dogPoop;
      _humanFall = $v.humanFall;
      _boundaryBreach = $v.boundaryBreach;
      _threeMonths = $v.threeMonths;
      _doorbellTheftAlerts = $v.doorbellTheftAlerts;
      _drowningAlert = $v.drowningAlert;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VoiceNotificationModel other) {
    _$v = other as _$VoiceNotificationModel;
  }

  @override
  void update(void Function(VoiceNotificationModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VoiceNotificationModel build() => _build();

  _$VoiceNotificationModel _build() {
    final _$result = _$v ??
        _$VoiceNotificationModel._(
          today: today,
          yesterday: yesterday,
          thisWeek: thisWeek,
          thisMonth: thisMonth,
          lastWeek: lastWeek,
          lastMonth: lastMonth,
          customName: customName,
          customDate: customDate,
          subscriptionAlerts: subscriptionAlerts,
          spamAlerts: spamAlerts,
          neighbourhoodAlerts: neighbourhoodAlerts,
          iotAlerts: iotAlerts,
          aiAlerts: aiAlerts,
          visitorAlert: visitorAlert,
          babyRunningAway: babyRunningAway,
          petRunningAway: petRunningAway,
          fireAlert: fireAlert,
          intruderAlert: intruderAlert,
          weapon: weapon,
          parcelAlert: parcelAlert,
          eavesdropper: eavesdropper,
          dogPoop: dogPoop,
          humanFall: humanFall,
          boundaryBreach: boundaryBreach,
          threeMonths: threeMonths,
          doorbellTheftAlerts: doorbellTheftAlerts,
          drowningAlert: drowningAlert,
        );
    replace(_$result);
    return _$result;
  }
}

class _$VoiceVisitorModel extends VoiceVisitorModel {
  @override
  final bool? today;
  @override
  final bool? yesterday;
  @override
  final bool? thisWeek;
  @override
  final bool? thisMonth;
  @override
  final String? customName;
  @override
  final bool? lastWeek;
  @override
  final bool? lastMonth;
  @override
  final String? customDate;

  factory _$VoiceVisitorModel(
          [void Function(VoiceVisitorModelBuilder)? updates]) =>
      (VoiceVisitorModelBuilder()..update(updates))._build();

  _$VoiceVisitorModel._(
      {this.today,
      this.yesterday,
      this.thisWeek,
      this.thisMonth,
      this.customName,
      this.lastWeek,
      this.lastMonth,
      this.customDate})
      : super._();
  @override
  VoiceVisitorModel rebuild(void Function(VoiceVisitorModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VoiceVisitorModelBuilder toBuilder() =>
      VoiceVisitorModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VoiceVisitorModel &&
        today == other.today &&
        yesterday == other.yesterday &&
        thisWeek == other.thisWeek &&
        thisMonth == other.thisMonth &&
        customName == other.customName &&
        lastWeek == other.lastWeek &&
        lastMonth == other.lastMonth &&
        customDate == other.customDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, today.hashCode);
    _$hash = $jc(_$hash, yesterday.hashCode);
    _$hash = $jc(_$hash, thisWeek.hashCode);
    _$hash = $jc(_$hash, thisMonth.hashCode);
    _$hash = $jc(_$hash, customName.hashCode);
    _$hash = $jc(_$hash, lastWeek.hashCode);
    _$hash = $jc(_$hash, lastMonth.hashCode);
    _$hash = $jc(_$hash, customDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VoiceVisitorModel')
          ..add('today', today)
          ..add('yesterday', yesterday)
          ..add('thisWeek', thisWeek)
          ..add('thisMonth', thisMonth)
          ..add('customName', customName)
          ..add('lastWeek', lastWeek)
          ..add('lastMonth', lastMonth)
          ..add('customDate', customDate))
        .toString();
  }
}

class VoiceVisitorModelBuilder
    implements Builder<VoiceVisitorModel, VoiceVisitorModelBuilder> {
  _$VoiceVisitorModel? _$v;

  bool? _today;
  bool? get today => _$this._today;
  set today(bool? today) => _$this._today = today;

  bool? _yesterday;
  bool? get yesterday => _$this._yesterday;
  set yesterday(bool? yesterday) => _$this._yesterday = yesterday;

  bool? _thisWeek;
  bool? get thisWeek => _$this._thisWeek;
  set thisWeek(bool? thisWeek) => _$this._thisWeek = thisWeek;

  bool? _thisMonth;
  bool? get thisMonth => _$this._thisMonth;
  set thisMonth(bool? thisMonth) => _$this._thisMonth = thisMonth;

  String? _customName;
  String? get customName => _$this._customName;
  set customName(String? customName) => _$this._customName = customName;

  bool? _lastWeek;
  bool? get lastWeek => _$this._lastWeek;
  set lastWeek(bool? lastWeek) => _$this._lastWeek = lastWeek;

  bool? _lastMonth;
  bool? get lastMonth => _$this._lastMonth;
  set lastMonth(bool? lastMonth) => _$this._lastMonth = lastMonth;

  String? _customDate;
  String? get customDate => _$this._customDate;
  set customDate(String? customDate) => _$this._customDate = customDate;

  VoiceVisitorModelBuilder();

  VoiceVisitorModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _today = $v.today;
      _yesterday = $v.yesterday;
      _thisWeek = $v.thisWeek;
      _thisMonth = $v.thisMonth;
      _customName = $v.customName;
      _lastWeek = $v.lastWeek;
      _lastMonth = $v.lastMonth;
      _customDate = $v.customDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VoiceVisitorModel other) {
    _$v = other as _$VoiceVisitorModel;
  }

  @override
  void update(void Function(VoiceVisitorModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VoiceVisitorModel build() => _build();

  _$VoiceVisitorModel _build() {
    final _$result = _$v ??
        _$VoiceVisitorModel._(
          today: today,
          yesterday: yesterday,
          thisWeek: thisWeek,
          thisMonth: thisMonth,
          customName: customName,
          lastWeek: lastWeek,
          lastMonth: lastMonth,
          customDate: customDate,
        );
    replace(_$result);
    return _$result;
  }
}

class _$VoiceThemeModel extends VoiceThemeModel {
  @override
  final bool? dark;
  @override
  final bool? anime;
  @override
  final bool? space;
  @override
  final bool? carsVehicles;
  @override
  final bool? pets;
  @override
  final bool? animals;
  @override
  final bool? technology;
  @override
  final bool? kids;
  @override
  final bool? mood;
  @override
  final bool? holidays;
  @override
  final bool? specialEvents;
  @override
  final bool? sports;
  @override
  final bool? neonLights;
  @override
  final bool? vaporwave;
  @override
  final bool? sayings;
  @override
  final bool? comics;
  @override
  final bool? nature;
  @override
  final bool? love;

  factory _$VoiceThemeModel([void Function(VoiceThemeModelBuilder)? updates]) =>
      (VoiceThemeModelBuilder()..update(updates))._build();

  _$VoiceThemeModel._(
      {this.dark,
      this.anime,
      this.space,
      this.carsVehicles,
      this.pets,
      this.animals,
      this.technology,
      this.kids,
      this.mood,
      this.holidays,
      this.specialEvents,
      this.sports,
      this.neonLights,
      this.vaporwave,
      this.sayings,
      this.comics,
      this.nature,
      this.love})
      : super._();
  @override
  VoiceThemeModel rebuild(void Function(VoiceThemeModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VoiceThemeModelBuilder toBuilder() => VoiceThemeModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VoiceThemeModel &&
        dark == other.dark &&
        anime == other.anime &&
        space == other.space &&
        carsVehicles == other.carsVehicles &&
        pets == other.pets &&
        animals == other.animals &&
        technology == other.technology &&
        kids == other.kids &&
        mood == other.mood &&
        holidays == other.holidays &&
        specialEvents == other.specialEvents &&
        sports == other.sports &&
        neonLights == other.neonLights &&
        vaporwave == other.vaporwave &&
        sayings == other.sayings &&
        comics == other.comics &&
        nature == other.nature &&
        love == other.love;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dark.hashCode);
    _$hash = $jc(_$hash, anime.hashCode);
    _$hash = $jc(_$hash, space.hashCode);
    _$hash = $jc(_$hash, carsVehicles.hashCode);
    _$hash = $jc(_$hash, pets.hashCode);
    _$hash = $jc(_$hash, animals.hashCode);
    _$hash = $jc(_$hash, technology.hashCode);
    _$hash = $jc(_$hash, kids.hashCode);
    _$hash = $jc(_$hash, mood.hashCode);
    _$hash = $jc(_$hash, holidays.hashCode);
    _$hash = $jc(_$hash, specialEvents.hashCode);
    _$hash = $jc(_$hash, sports.hashCode);
    _$hash = $jc(_$hash, neonLights.hashCode);
    _$hash = $jc(_$hash, vaporwave.hashCode);
    _$hash = $jc(_$hash, sayings.hashCode);
    _$hash = $jc(_$hash, comics.hashCode);
    _$hash = $jc(_$hash, nature.hashCode);
    _$hash = $jc(_$hash, love.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VoiceThemeModel')
          ..add('dark', dark)
          ..add('anime', anime)
          ..add('space', space)
          ..add('carsVehicles', carsVehicles)
          ..add('pets', pets)
          ..add('animals', animals)
          ..add('technology', technology)
          ..add('kids', kids)
          ..add('mood', mood)
          ..add('holidays', holidays)
          ..add('specialEvents', specialEvents)
          ..add('sports', sports)
          ..add('neonLights', neonLights)
          ..add('vaporwave', vaporwave)
          ..add('sayings', sayings)
          ..add('comics', comics)
          ..add('nature', nature)
          ..add('love', love))
        .toString();
  }
}

class VoiceThemeModelBuilder
    implements Builder<VoiceThemeModel, VoiceThemeModelBuilder> {
  _$VoiceThemeModel? _$v;

  bool? _dark;
  bool? get dark => _$this._dark;
  set dark(bool? dark) => _$this._dark = dark;

  bool? _anime;
  bool? get anime => _$this._anime;
  set anime(bool? anime) => _$this._anime = anime;

  bool? _space;
  bool? get space => _$this._space;
  set space(bool? space) => _$this._space = space;

  bool? _carsVehicles;
  bool? get carsVehicles => _$this._carsVehicles;
  set carsVehicles(bool? carsVehicles) => _$this._carsVehicles = carsVehicles;

  bool? _pets;
  bool? get pets => _$this._pets;
  set pets(bool? pets) => _$this._pets = pets;

  bool? _animals;
  bool? get animals => _$this._animals;
  set animals(bool? animals) => _$this._animals = animals;

  bool? _technology;
  bool? get technology => _$this._technology;
  set technology(bool? technology) => _$this._technology = technology;

  bool? _kids;
  bool? get kids => _$this._kids;
  set kids(bool? kids) => _$this._kids = kids;

  bool? _mood;
  bool? get mood => _$this._mood;
  set mood(bool? mood) => _$this._mood = mood;

  bool? _holidays;
  bool? get holidays => _$this._holidays;
  set holidays(bool? holidays) => _$this._holidays = holidays;

  bool? _specialEvents;
  bool? get specialEvents => _$this._specialEvents;
  set specialEvents(bool? specialEvents) =>
      _$this._specialEvents = specialEvents;

  bool? _sports;
  bool? get sports => _$this._sports;
  set sports(bool? sports) => _$this._sports = sports;

  bool? _neonLights;
  bool? get neonLights => _$this._neonLights;
  set neonLights(bool? neonLights) => _$this._neonLights = neonLights;

  bool? _vaporwave;
  bool? get vaporwave => _$this._vaporwave;
  set vaporwave(bool? vaporwave) => _$this._vaporwave = vaporwave;

  bool? _sayings;
  bool? get sayings => _$this._sayings;
  set sayings(bool? sayings) => _$this._sayings = sayings;

  bool? _comics;
  bool? get comics => _$this._comics;
  set comics(bool? comics) => _$this._comics = comics;

  bool? _nature;
  bool? get nature => _$this._nature;
  set nature(bool? nature) => _$this._nature = nature;

  bool? _love;
  bool? get love => _$this._love;
  set love(bool? love) => _$this._love = love;

  VoiceThemeModelBuilder();

  VoiceThemeModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dark = $v.dark;
      _anime = $v.anime;
      _space = $v.space;
      _carsVehicles = $v.carsVehicles;
      _pets = $v.pets;
      _animals = $v.animals;
      _technology = $v.technology;
      _kids = $v.kids;
      _mood = $v.mood;
      _holidays = $v.holidays;
      _specialEvents = $v.specialEvents;
      _sports = $v.sports;
      _neonLights = $v.neonLights;
      _vaporwave = $v.vaporwave;
      _sayings = $v.sayings;
      _comics = $v.comics;
      _nature = $v.nature;
      _love = $v.love;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VoiceThemeModel other) {
    _$v = other as _$VoiceThemeModel;
  }

  @override
  void update(void Function(VoiceThemeModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VoiceThemeModel build() => _build();

  _$VoiceThemeModel _build() {
    final _$result = _$v ??
        _$VoiceThemeModel._(
          dark: dark,
          anime: anime,
          space: space,
          carsVehicles: carsVehicles,
          pets: pets,
          animals: animals,
          technology: technology,
          kids: kids,
          mood: mood,
          holidays: holidays,
          specialEvents: specialEvents,
          sports: sports,
          neonLights: neonLights,
          vaporwave: vaporwave,
          sayings: sayings,
          comics: comics,
          nature: nature,
          love: love,
        );
    replace(_$result);
    return _$result;
  }
}

class _$CallModel extends CallModel {
  @override
  final bool? customName;
  @override
  final bool? unknownVisitor;
  @override
  final bool? newVisitor;

  factory _$CallModel([void Function(CallModelBuilder)? updates]) =>
      (CallModelBuilder()..update(updates))._build();

  _$CallModel._({this.customName, this.unknownVisitor, this.newVisitor})
      : super._();
  @override
  CallModel rebuild(void Function(CallModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallModelBuilder toBuilder() => CallModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallModel &&
        customName == other.customName &&
        unknownVisitor == other.unknownVisitor &&
        newVisitor == other.newVisitor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, customName.hashCode);
    _$hash = $jc(_$hash, unknownVisitor.hashCode);
    _$hash = $jc(_$hash, newVisitor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallModel')
          ..add('customName', customName)
          ..add('unknownVisitor', unknownVisitor)
          ..add('newVisitor', newVisitor))
        .toString();
  }
}

class CallModelBuilder implements Builder<CallModel, CallModelBuilder> {
  _$CallModel? _$v;

  bool? _customName;
  bool? get customName => _$this._customName;
  set customName(bool? customName) => _$this._customName = customName;

  bool? _unknownVisitor;
  bool? get unknownVisitor => _$this._unknownVisitor;
  set unknownVisitor(bool? unknownVisitor) =>
      _$this._unknownVisitor = unknownVisitor;

  bool? _newVisitor;
  bool? get newVisitor => _$this._newVisitor;
  set newVisitor(bool? newVisitor) => _$this._newVisitor = newVisitor;

  CallModelBuilder();

  CallModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _customName = $v.customName;
      _unknownVisitor = $v.unknownVisitor;
      _newVisitor = $v.newVisitor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallModel other) {
    _$v = other as _$CallModel;
  }

  @override
  void update(void Function(CallModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallModel build() => _build();

  _$CallModel _build() {
    final _$result = _$v ??
        _$CallModel._(
          customName: customName,
          unknownVisitor: unknownVisitor,
          newVisitor: newVisitor,
        );
    replace(_$result);
    return _$result;
  }
}

class _$VoiceStatisticModel extends VoiceStatisticModel {
  @override
  final bool thisWeek;
  @override
  final bool lastWeek;
  @override
  final bool thisMonth;
  @override
  final bool threeMonths;
  @override
  final bool daysOfTheWeek;
  @override
  final bool peakVisitingHours;
  @override
  final bool frequencyOfVisits;
  @override
  final bool unknownVisitors;
  @override
  final String customName;
  @override
  final String customDate;

  factory _$VoiceStatisticModel(
          [void Function(VoiceStatisticModelBuilder)? updates]) =>
      (VoiceStatisticModelBuilder()..update(updates))._build();

  _$VoiceStatisticModel._(
      {required this.thisWeek,
      required this.lastWeek,
      required this.thisMonth,
      required this.threeMonths,
      required this.daysOfTheWeek,
      required this.peakVisitingHours,
      required this.frequencyOfVisits,
      required this.unknownVisitors,
      required this.customName,
      required this.customDate})
      : super._();
  @override
  VoiceStatisticModel rebuild(
          void Function(VoiceStatisticModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VoiceStatisticModelBuilder toBuilder() =>
      VoiceStatisticModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VoiceStatisticModel &&
        thisWeek == other.thisWeek &&
        lastWeek == other.lastWeek &&
        thisMonth == other.thisMonth &&
        threeMonths == other.threeMonths &&
        daysOfTheWeek == other.daysOfTheWeek &&
        peakVisitingHours == other.peakVisitingHours &&
        frequencyOfVisits == other.frequencyOfVisits &&
        unknownVisitors == other.unknownVisitors &&
        customName == other.customName &&
        customDate == other.customDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, thisWeek.hashCode);
    _$hash = $jc(_$hash, lastWeek.hashCode);
    _$hash = $jc(_$hash, thisMonth.hashCode);
    _$hash = $jc(_$hash, threeMonths.hashCode);
    _$hash = $jc(_$hash, daysOfTheWeek.hashCode);
    _$hash = $jc(_$hash, peakVisitingHours.hashCode);
    _$hash = $jc(_$hash, frequencyOfVisits.hashCode);
    _$hash = $jc(_$hash, unknownVisitors.hashCode);
    _$hash = $jc(_$hash, customName.hashCode);
    _$hash = $jc(_$hash, customDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VoiceStatisticModel')
          ..add('thisWeek', thisWeek)
          ..add('lastWeek', lastWeek)
          ..add('thisMonth', thisMonth)
          ..add('threeMonths', threeMonths)
          ..add('daysOfTheWeek', daysOfTheWeek)
          ..add('peakVisitingHours', peakVisitingHours)
          ..add('frequencyOfVisits', frequencyOfVisits)
          ..add('unknownVisitors', unknownVisitors)
          ..add('customName', customName)
          ..add('customDate', customDate))
        .toString();
  }
}

class VoiceStatisticModelBuilder
    implements Builder<VoiceStatisticModel, VoiceStatisticModelBuilder> {
  _$VoiceStatisticModel? _$v;

  bool? _thisWeek;
  bool? get thisWeek => _$this._thisWeek;
  set thisWeek(bool? thisWeek) => _$this._thisWeek = thisWeek;

  bool? _lastWeek;
  bool? get lastWeek => _$this._lastWeek;
  set lastWeek(bool? lastWeek) => _$this._lastWeek = lastWeek;

  bool? _thisMonth;
  bool? get thisMonth => _$this._thisMonth;
  set thisMonth(bool? thisMonth) => _$this._thisMonth = thisMonth;

  bool? _threeMonths;
  bool? get threeMonths => _$this._threeMonths;
  set threeMonths(bool? threeMonths) => _$this._threeMonths = threeMonths;

  bool? _daysOfTheWeek;
  bool? get daysOfTheWeek => _$this._daysOfTheWeek;
  set daysOfTheWeek(bool? daysOfTheWeek) =>
      _$this._daysOfTheWeek = daysOfTheWeek;

  bool? _peakVisitingHours;
  bool? get peakVisitingHours => _$this._peakVisitingHours;
  set peakVisitingHours(bool? peakVisitingHours) =>
      _$this._peakVisitingHours = peakVisitingHours;

  bool? _frequencyOfVisits;
  bool? get frequencyOfVisits => _$this._frequencyOfVisits;
  set frequencyOfVisits(bool? frequencyOfVisits) =>
      _$this._frequencyOfVisits = frequencyOfVisits;

  bool? _unknownVisitors;
  bool? get unknownVisitors => _$this._unknownVisitors;
  set unknownVisitors(bool? unknownVisitors) =>
      _$this._unknownVisitors = unknownVisitors;

  String? _customName;
  String? get customName => _$this._customName;
  set customName(String? customName) => _$this._customName = customName;

  String? _customDate;
  String? get customDate => _$this._customDate;
  set customDate(String? customDate) => _$this._customDate = customDate;

  VoiceStatisticModelBuilder() {
    VoiceStatisticModel._initialize(this);
  }

  VoiceStatisticModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _thisWeek = $v.thisWeek;
      _lastWeek = $v.lastWeek;
      _thisMonth = $v.thisMonth;
      _threeMonths = $v.threeMonths;
      _daysOfTheWeek = $v.daysOfTheWeek;
      _peakVisitingHours = $v.peakVisitingHours;
      _frequencyOfVisits = $v.frequencyOfVisits;
      _unknownVisitors = $v.unknownVisitors;
      _customName = $v.customName;
      _customDate = $v.customDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VoiceStatisticModel other) {
    _$v = other as _$VoiceStatisticModel;
  }

  @override
  void update(void Function(VoiceStatisticModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VoiceStatisticModel build() => _build();

  _$VoiceStatisticModel _build() {
    final _$result = _$v ??
        _$VoiceStatisticModel._(
          thisWeek: BuiltValueNullFieldError.checkNotNull(
              thisWeek, r'VoiceStatisticModel', 'thisWeek'),
          lastWeek: BuiltValueNullFieldError.checkNotNull(
              lastWeek, r'VoiceStatisticModel', 'lastWeek'),
          thisMonth: BuiltValueNullFieldError.checkNotNull(
              thisMonth, r'VoiceStatisticModel', 'thisMonth'),
          threeMonths: BuiltValueNullFieldError.checkNotNull(
              threeMonths, r'VoiceStatisticModel', 'threeMonths'),
          daysOfTheWeek: BuiltValueNullFieldError.checkNotNull(
              daysOfTheWeek, r'VoiceStatisticModel', 'daysOfTheWeek'),
          peakVisitingHours: BuiltValueNullFieldError.checkNotNull(
              peakVisitingHours, r'VoiceStatisticModel', 'peakVisitingHours'),
          frequencyOfVisits: BuiltValueNullFieldError.checkNotNull(
              frequencyOfVisits, r'VoiceStatisticModel', 'frequencyOfVisits'),
          unknownVisitors: BuiltValueNullFieldError.checkNotNull(
              unknownVisitors, r'VoiceStatisticModel', 'unknownVisitors'),
          customName: BuiltValueNullFieldError.checkNotNull(
              customName, r'VoiceStatisticModel', 'customName'),
          customDate: BuiltValueNullFieldError.checkNotNull(
              customDate, r'VoiceStatisticModel', 'customDate'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
