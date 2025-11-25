// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GuideModel> _$guideModelSerializer = _$GuideModelSerializer();

class _$GuideModelSerializer implements StructuredSerializer<GuideModel> {
  @override
  final Iterable<Type> types = const [GuideModel, _$GuideModel];
  @override
  final String wireName = 'GuideModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, GuideModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.mapsGuide;
    if (value != null) {
      result
        ..add('maps_guide')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.visitorGuide;
    if (value != null) {
      result
        ..add('visitor_guide')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.statisticsGuide;
    if (value != null) {
      result
        ..add('statistics_guide')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.notificationGuide;
    if (value != null) {
      result
        ..add('notification_guide')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.manageDevicesGuide;
    if (value != null) {
      result
        ..add('manage_devices_guide')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.visitorHistoryGuide;
    if (value != null) {
      result
        ..add('visitor_history_guide')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.threeDotMenuGuide;
    if (value != null) {
      result
        ..add('three_dot_menu_guide')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  GuideModel deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = GuideModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'maps_guide':
          result.mapsGuide = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'visitor_guide':
          result.visitorGuide = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'statistics_guide':
          result.statisticsGuide = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'notification_guide':
          result.notificationGuide = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'manage_devices_guide':
          result.manageDevicesGuide = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'visitor_history_guide':
          result.visitorHistoryGuide = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'three_dot_menu_guide':
          result.threeDotMenuGuide = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
      }
    }

    return result.build();
  }
}

class _$GuideModel extends GuideModel {
  @override
  final int? mapsGuide;
  @override
  final int? visitorGuide;
  @override
  final int? statisticsGuide;
  @override
  final int? notificationGuide;
  @override
  final int? manageDevicesGuide;
  @override
  final int? visitorHistoryGuide;
  @override
  final int? threeDotMenuGuide;

  factory _$GuideModel([void Function(GuideModelBuilder)? updates]) =>
      (GuideModelBuilder()..update(updates))._build();

  _$GuideModel._(
      {this.mapsGuide,
      this.visitorGuide,
      this.statisticsGuide,
      this.notificationGuide,
      this.manageDevicesGuide,
      this.visitorHistoryGuide,
      this.threeDotMenuGuide})
      : super._();
  @override
  GuideModel rebuild(void Function(GuideModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GuideModelBuilder toBuilder() => GuideModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GuideModel &&
        mapsGuide == other.mapsGuide &&
        visitorGuide == other.visitorGuide &&
        statisticsGuide == other.statisticsGuide &&
        notificationGuide == other.notificationGuide &&
        manageDevicesGuide == other.manageDevicesGuide &&
        visitorHistoryGuide == other.visitorHistoryGuide &&
        threeDotMenuGuide == other.threeDotMenuGuide;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mapsGuide.hashCode);
    _$hash = $jc(_$hash, visitorGuide.hashCode);
    _$hash = $jc(_$hash, statisticsGuide.hashCode);
    _$hash = $jc(_$hash, notificationGuide.hashCode);
    _$hash = $jc(_$hash, manageDevicesGuide.hashCode);
    _$hash = $jc(_$hash, visitorHistoryGuide.hashCode);
    _$hash = $jc(_$hash, threeDotMenuGuide.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GuideModel')
          ..add('mapsGuide', mapsGuide)
          ..add('visitorGuide', visitorGuide)
          ..add('statisticsGuide', statisticsGuide)
          ..add('notificationGuide', notificationGuide)
          ..add('manageDevicesGuide', manageDevicesGuide)
          ..add('visitorHistoryGuide', visitorHistoryGuide)
          ..add('threeDotMenuGuide', threeDotMenuGuide))
        .toString();
  }
}

class GuideModelBuilder implements Builder<GuideModel, GuideModelBuilder> {
  _$GuideModel? _$v;

  int? _mapsGuide;
  int? get mapsGuide => _$this._mapsGuide;
  set mapsGuide(int? mapsGuide) => _$this._mapsGuide = mapsGuide;

  int? _visitorGuide;
  int? get visitorGuide => _$this._visitorGuide;
  set visitorGuide(int? visitorGuide) => _$this._visitorGuide = visitorGuide;

  int? _statisticsGuide;
  int? get statisticsGuide => _$this._statisticsGuide;
  set statisticsGuide(int? statisticsGuide) =>
      _$this._statisticsGuide = statisticsGuide;

  int? _notificationGuide;
  int? get notificationGuide => _$this._notificationGuide;
  set notificationGuide(int? notificationGuide) =>
      _$this._notificationGuide = notificationGuide;

  int? _manageDevicesGuide;
  int? get manageDevicesGuide => _$this._manageDevicesGuide;
  set manageDevicesGuide(int? manageDevicesGuide) =>
      _$this._manageDevicesGuide = manageDevicesGuide;

  int? _visitorHistoryGuide;
  int? get visitorHistoryGuide => _$this._visitorHistoryGuide;
  set visitorHistoryGuide(int? visitorHistoryGuide) =>
      _$this._visitorHistoryGuide = visitorHistoryGuide;

  int? _threeDotMenuGuide;
  int? get threeDotMenuGuide => _$this._threeDotMenuGuide;
  set threeDotMenuGuide(int? threeDotMenuGuide) =>
      _$this._threeDotMenuGuide = threeDotMenuGuide;

  GuideModelBuilder();

  GuideModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mapsGuide = $v.mapsGuide;
      _visitorGuide = $v.visitorGuide;
      _statisticsGuide = $v.statisticsGuide;
      _notificationGuide = $v.notificationGuide;
      _manageDevicesGuide = $v.manageDevicesGuide;
      _visitorHistoryGuide = $v.visitorHistoryGuide;
      _threeDotMenuGuide = $v.threeDotMenuGuide;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GuideModel other) {
    _$v = other as _$GuideModel;
  }

  @override
  void update(void Function(GuideModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GuideModel build() => _build();

  _$GuideModel _build() {
    final _$result = _$v ??
        _$GuideModel._(
          mapsGuide: mapsGuide,
          visitorGuide: visitorGuide,
          statisticsGuide: statisticsGuide,
          notificationGuide: notificationGuide,
          manageDevicesGuide: manageDevicesGuide,
          visitorHistoryGuide: visitorHistoryGuide,
          threeDotMenuGuide: threeDotMenuGuide,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
