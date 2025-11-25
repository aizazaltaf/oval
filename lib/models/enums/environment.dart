import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'environment.enum.g.dart';
part 'environment.g.dart';

@EnumGen()
class Environment extends EnumClass {
  const Environment._(super.name);
  static Serializer<Environment> get serializer => _$environmentSerializer;

  static BuiltSet<Environment> get values => _$values;

  static Environment valueOf(String name) => _$valueOf(name);

  static const Environment test = _$test;
  static const Environment production = _$production;
  static const Environment uat = _$uat;
  static const Environment develop = _$develop;
  static const Environment developTest = _$developTest;
  static const Environment developUat = _$developUat;
  static const Environment preprod = _$preprod;
  static const Environment developPreprod = _$developPreprod;
}
