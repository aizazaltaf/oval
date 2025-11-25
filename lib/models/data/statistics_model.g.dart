// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<StatisticsModel> _$statisticsModelSerializer =
    _$StatisticsModelSerializer();

class _$StatisticsModelSerializer
    implements StructuredSerializer<StatisticsModel> {
  @override
  final Iterable<Type> types = const [StatisticsModel, _$StatisticsModel];
  @override
  final String wireName = 'StatisticsModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, StatisticsModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'visit_count',
      serializers.serialize(object.visitCount,
          specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  StatisticsModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = StatisticsModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'visit_count':
          result.visitCount = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$StatisticsModel extends StatisticsModel {
  @override
  final String title;
  @override
  final int visitCount;

  factory _$StatisticsModel([void Function(StatisticsModelBuilder)? updates]) =>
      (StatisticsModelBuilder()..update(updates))._build();

  _$StatisticsModel._({required this.title, required this.visitCount})
      : super._();
  @override
  StatisticsModel rebuild(void Function(StatisticsModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatisticsModelBuilder toBuilder() => StatisticsModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatisticsModel &&
        title == other.title &&
        visitCount == other.visitCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, visitCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatisticsModel')
          ..add('title', title)
          ..add('visitCount', visitCount))
        .toString();
  }
}

class StatisticsModelBuilder
    implements Builder<StatisticsModel, StatisticsModelBuilder> {
  _$StatisticsModel? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  int? _visitCount;
  int? get visitCount => _$this._visitCount;
  set visitCount(int? visitCount) => _$this._visitCount = visitCount;

  StatisticsModelBuilder();

  StatisticsModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _visitCount = $v.visitCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatisticsModel other) {
    _$v = other as _$StatisticsModel;
  }

  @override
  void update(void Function(StatisticsModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatisticsModel build() => _build();

  _$StatisticsModel _build() {
    final _$result = _$v ??
        _$StatisticsModel._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'StatisticsModel', 'title'),
          visitCount: BuiltValueNullFieldError.checkNotNull(
              visitCount, r'StatisticsModel', 'visitCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
