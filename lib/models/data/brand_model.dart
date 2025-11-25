import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'brand_model.g.dart';

abstract class Brands implements Built<Brands, BrandsBuilder> {
  factory Brands([void Function(BrandsBuilder) updates]) = _$Brands;

  Brands._();

  static Serializer<Brands> get serializer => _$brandsSerializer;

  @BuiltValueField(wireName: 'id')
  int? get id;

  @BuiltValueField(wireName: 'mac_address_hex')
  String? get macAddressHex;

  @BuiltValueField(wireName: 'mac_address_base_16')
  String? get macAddressBase16;

  @BuiltValueField(wireName: 'company_name')
  String? get companyName;

  @BuiltValueField(wireName: 'brand')
  String? get brand;

  @BuiltValueField(wireName: 'type')
  String? get type;

  @BuiltValueField(wireName: 'is_active')
  int? get isActive;

  @BuiltValueField(wireName: 'created_at')
  String? get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  String? get updatedAt;

  bool? get isSelected;

  static void _initializeBuilder(BrandsBuilder b) {
    b.isSelected = false;
  }

  static Brands fromDynamic(json) {
    return serializers.deserializeWith(
      Brands.serializer,
      json,
    )!;
  }

  static BuiltList<Brands> fromDynamics(final List<dynamic> list) {
    return BuiltList<Brands>(list.map(fromDynamic));
  }
}
