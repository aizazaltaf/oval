// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const Environment _$test = const Environment._('test');
const Environment _$production = const Environment._('production');
const Environment _$uat = const Environment._('uat');
const Environment _$develop = const Environment._('develop');
const Environment _$developTest = const Environment._('developTest');
const Environment _$developUat = const Environment._('developUat');
const Environment _$preprod = const Environment._('preprod');
const Environment _$developPreprod = const Environment._('developPreprod');

Environment _$valueOf(String name) {
  switch (name) {
    case 'test':
      return _$test;
    case 'production':
      return _$production;
    case 'uat':
      return _$uat;
    case 'develop':
      return _$develop;
    case 'developTest':
      return _$developTest;
    case 'developUat':
      return _$developUat;
    case 'preprod':
      return _$preprod;
    case 'developPreprod':
      return _$developPreprod;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<Environment> _$values =
    BuiltSet<Environment>(const <Environment>[
  _$test,
  _$production,
  _$uat,
  _$develop,
  _$developTest,
  _$developUat,
  _$preprod,
  _$developPreprod,
]);

Serializer<Environment> _$environmentSerializer = _$EnvironmentSerializer();

class _$EnvironmentSerializer implements PrimitiveSerializer<Environment> {
  @override
  final Iterable<Type> types = const <Type>[Environment];
  @override
  final String wireName = 'Environment';

  @override
  Object serialize(Serializers serializers, Environment object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  Environment deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      Environment.valueOf(serialized as String);
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
