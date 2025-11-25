// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_features_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PlanFeaturesModel> _$planFeaturesModelSerializer =
    _$PlanFeaturesModelSerializer();

class _$PlanFeaturesModelSerializer
    implements StructuredSerializer<PlanFeaturesModel> {
  @override
  final Iterable<Type> types = const [PlanFeaturesModel, _$PlanFeaturesModel];
  @override
  final String wireName = 'PlanFeaturesModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, PlanFeaturesModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'code',
      serializers.serialize(object.code, specifiedType: const FullType(String)),
      'category',
      serializers.serialize(object.category,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.feature;
    if (value != null) {
      result
        ..add('feature')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.subFeature;
    if (value != null) {
      result
        ..add('sub_feature')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  PlanFeaturesModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PlanFeaturesModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'code':
          result.code = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'category':
          result.category = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'feature':
          result.feature = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'sub_feature':
          result.subFeature = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$PlanFeaturesModel extends PlanFeaturesModel {
  @override
  final String code;
  @override
  final String category;
  @override
  final String? feature;
  @override
  final String? subFeature;

  factory _$PlanFeaturesModel(
          [void Function(PlanFeaturesModelBuilder)? updates]) =>
      (PlanFeaturesModelBuilder()..update(updates))._build();

  _$PlanFeaturesModel._(
      {required this.code,
      required this.category,
      this.feature,
      this.subFeature})
      : super._();
  @override
  PlanFeaturesModel rebuild(void Function(PlanFeaturesModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlanFeaturesModelBuilder toBuilder() =>
      PlanFeaturesModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlanFeaturesModel &&
        code == other.code &&
        category == other.category &&
        feature == other.feature &&
        subFeature == other.subFeature;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, feature.hashCode);
    _$hash = $jc(_$hash, subFeature.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlanFeaturesModel')
          ..add('code', code)
          ..add('category', category)
          ..add('feature', feature)
          ..add('subFeature', subFeature))
        .toString();
  }
}

class PlanFeaturesModelBuilder
    implements Builder<PlanFeaturesModel, PlanFeaturesModelBuilder> {
  _$PlanFeaturesModel? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _feature;
  String? get feature => _$this._feature;
  set feature(String? feature) => _$this._feature = feature;

  String? _subFeature;
  String? get subFeature => _$this._subFeature;
  set subFeature(String? subFeature) => _$this._subFeature = subFeature;

  PlanFeaturesModelBuilder();

  PlanFeaturesModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _category = $v.category;
      _feature = $v.feature;
      _subFeature = $v.subFeature;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlanFeaturesModel other) {
    _$v = other as _$PlanFeaturesModel;
  }

  @override
  void update(void Function(PlanFeaturesModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlanFeaturesModel build() => _build();

  _$PlanFeaturesModel _build() {
    final _$result = _$v ??
        _$PlanFeaturesModel._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'PlanFeaturesModel', 'code'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'PlanFeaturesModel', 'category'),
          feature: feature,
          subFeature: subFeature,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
