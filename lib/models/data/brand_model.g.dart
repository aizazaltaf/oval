// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Brands> _$brandsSerializer = _$BrandsSerializer();

class _$BrandsSerializer implements StructuredSerializer<Brands> {
  @override
  final Iterable<Type> types = const [Brands, _$Brands];
  @override
  final String wireName = 'Brands';

  @override
  Iterable<Object?> serialize(Serializers serializers, Brands object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.macAddressHex;
    if (value != null) {
      result
        ..add('mac_address_hex')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.macAddressBase16;
    if (value != null) {
      result
        ..add('mac_address_base_16')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.companyName;
    if (value != null) {
      result
        ..add('company_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.brand;
    if (value != null) {
      result
        ..add('brand')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.type;
    if (value != null) {
      result
        ..add('type')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.isActive;
    if (value != null) {
      result
        ..add('is_active')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.createdAt;
    if (value != null) {
      result
        ..add('created_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.updatedAt;
    if (value != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.isSelected;
    if (value != null) {
      result
        ..add('isSelected')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  Brands deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = BrandsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'mac_address_hex':
          result.macAddressHex = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'mac_address_base_16':
          result.macAddressBase16 = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'company_name':
          result.companyName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'brand':
          result.brand = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'is_active':
          result.isActive = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'isSelected':
          result.isSelected = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
      }
    }

    return result.build();
  }
}

class _$Brands extends Brands {
  @override
  final int? id;
  @override
  final String? macAddressHex;
  @override
  final String? macAddressBase16;
  @override
  final String? companyName;
  @override
  final String? brand;
  @override
  final String? type;
  @override
  final int? isActive;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final bool? isSelected;

  factory _$Brands([void Function(BrandsBuilder)? updates]) =>
      (BrandsBuilder()..update(updates))._build();

  _$Brands._(
      {this.id,
      this.macAddressHex,
      this.macAddressBase16,
      this.companyName,
      this.brand,
      this.type,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.isSelected})
      : super._();
  @override
  Brands rebuild(void Function(BrandsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BrandsBuilder toBuilder() => BrandsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Brands &&
        id == other.id &&
        macAddressHex == other.macAddressHex &&
        macAddressBase16 == other.macAddressBase16 &&
        companyName == other.companyName &&
        brand == other.brand &&
        type == other.type &&
        isActive == other.isActive &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        isSelected == other.isSelected;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, macAddressHex.hashCode);
    _$hash = $jc(_$hash, macAddressBase16.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, isSelected.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Brands')
          ..add('id', id)
          ..add('macAddressHex', macAddressHex)
          ..add('macAddressBase16', macAddressBase16)
          ..add('companyName', companyName)
          ..add('brand', brand)
          ..add('type', type)
          ..add('isActive', isActive)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('isSelected', isSelected))
        .toString();
  }
}

class BrandsBuilder implements Builder<Brands, BrandsBuilder> {
  _$Brands? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _macAddressHex;
  String? get macAddressHex => _$this._macAddressHex;
  set macAddressHex(String? macAddressHex) =>
      _$this._macAddressHex = macAddressHex;

  String? _macAddressBase16;
  String? get macAddressBase16 => _$this._macAddressBase16;
  set macAddressBase16(String? macAddressBase16) =>
      _$this._macAddressBase16 = macAddressBase16;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  int? _isActive;
  int? get isActive => _$this._isActive;
  set isActive(int? isActive) => _$this._isActive = isActive;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  bool? _isSelected;
  bool? get isSelected => _$this._isSelected;
  set isSelected(bool? isSelected) => _$this._isSelected = isSelected;

  BrandsBuilder() {
    Brands._initializeBuilder(this);
  }

  BrandsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _macAddressHex = $v.macAddressHex;
      _macAddressBase16 = $v.macAddressBase16;
      _companyName = $v.companyName;
      _brand = $v.brand;
      _type = $v.type;
      _isActive = $v.isActive;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _isSelected = $v.isSelected;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Brands other) {
    _$v = other as _$Brands;
  }

  @override
  void update(void Function(BrandsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Brands build() => _build();

  _$Brands _build() {
    final _$result = _$v ??
        _$Brands._(
          id: id,
          macAddressHex: macAddressHex,
          macAddressBase16: macAddressBase16,
          companyName: companyName,
          brand: brand,
          type: type,
          isActive: isActive,
          createdAt: createdAt,
          updatedAt: updatedAt,
          isSelected: isSelected,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
