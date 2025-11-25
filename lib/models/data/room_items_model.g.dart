// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_items_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<RoomItemsModel> _$roomItemsModelSerializer =
    _$RoomItemsModelSerializer();

class _$RoomItemsModelSerializer
    implements StructuredSerializer<RoomItemsModel> {
  @override
  final Iterable<Type> types = const [RoomItemsModel, _$RoomItemsModel];
  @override
  final String wireName = 'RoomItemsModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, RoomItemsModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.roomId, specifiedType: const FullType(int)),
      'selectedValue',
      serializers.serialize(object.selectedValue,
          specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.roomType;
    if (value != null) {
      result
        ..add('type')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.roomName;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.image;
    if (value != null) {
      result
        ..add('image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.color;
    if (value != null) {
      result
        ..add('color')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                BuiltList, const [const FullType(material.Color)])));
    }
    value = object.svgColor;
    if (value != null) {
      result
        ..add('svg_color')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(material.Color)));
    }
    return result;
  }

  @override
  RoomItemsModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = RoomItemsModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.roomId = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'type':
          result.roomType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'name':
          result.roomName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'selectedValue':
          result.selectedValue = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'color':
          result.color.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(material.Color)]))!
              as BuiltList<Object?>);
          break;
        case 'svg_color':
          result.svgColor = serializers.deserialize(value,
              specifiedType: const FullType(material.Color)) as material.Color?;
          break;
      }
    }

    return result.build();
  }
}

class _$RoomItemsModel extends RoomItemsModel {
  @override
  final int roomId;
  @override
  final String? roomType;
  @override
  final String? roomName;
  @override
  final String? image;
  @override
  final bool selectedValue;
  @override
  final BuiltList<material.Color>? color;
  @override
  final material.Color? svgColor;

  factory _$RoomItemsModel([void Function(RoomItemsModelBuilder)? updates]) =>
      (RoomItemsModelBuilder()..update(updates))._build();

  _$RoomItemsModel._(
      {required this.roomId,
      this.roomType,
      this.roomName,
      this.image,
      required this.selectedValue,
      this.color,
      this.svgColor})
      : super._();
  @override
  RoomItemsModel rebuild(void Function(RoomItemsModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoomItemsModelBuilder toBuilder() => RoomItemsModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoomItemsModel &&
        roomId == other.roomId &&
        roomType == other.roomType &&
        roomName == other.roomName &&
        image == other.image &&
        selectedValue == other.selectedValue &&
        color == other.color &&
        svgColor == other.svgColor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, roomId.hashCode);
    _$hash = $jc(_$hash, roomType.hashCode);
    _$hash = $jc(_$hash, roomName.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, selectedValue.hashCode);
    _$hash = $jc(_$hash, color.hashCode);
    _$hash = $jc(_$hash, svgColor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoomItemsModel')
          ..add('roomId', roomId)
          ..add('roomType', roomType)
          ..add('roomName', roomName)
          ..add('image', image)
          ..add('selectedValue', selectedValue)
          ..add('color', color)
          ..add('svgColor', svgColor))
        .toString();
  }
}

class RoomItemsModelBuilder
    implements Builder<RoomItemsModel, RoomItemsModelBuilder> {
  _$RoomItemsModel? _$v;

  int? _roomId;
  int? get roomId => _$this._roomId;
  set roomId(int? roomId) => _$this._roomId = roomId;

  String? _roomType;
  String? get roomType => _$this._roomType;
  set roomType(String? roomType) => _$this._roomType = roomType;

  String? _roomName;
  String? get roomName => _$this._roomName;
  set roomName(String? roomName) => _$this._roomName = roomName;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  bool? _selectedValue;
  bool? get selectedValue => _$this._selectedValue;
  set selectedValue(bool? selectedValue) =>
      _$this._selectedValue = selectedValue;

  ListBuilder<material.Color>? _color;
  ListBuilder<material.Color> get color =>
      _$this._color ??= ListBuilder<material.Color>();
  set color(ListBuilder<material.Color>? color) => _$this._color = color;

  material.Color? _svgColor;
  material.Color? get svgColor => _$this._svgColor;
  set svgColor(material.Color? svgColor) => _$this._svgColor = svgColor;

  RoomItemsModelBuilder() {
    RoomItemsModel._initialize(this);
  }

  RoomItemsModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _roomId = $v.roomId;
      _roomType = $v.roomType;
      _roomName = $v.roomName;
      _image = $v.image;
      _selectedValue = $v.selectedValue;
      _color = $v.color?.toBuilder();
      _svgColor = $v.svgColor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoomItemsModel other) {
    _$v = other as _$RoomItemsModel;
  }

  @override
  void update(void Function(RoomItemsModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoomItemsModel build() => _build();

  _$RoomItemsModel _build() {
    RoomItemsModel._finalize(this);
    _$RoomItemsModel _$result;
    try {
      _$result = _$v ??
          _$RoomItemsModel._(
            roomId: BuiltValueNullFieldError.checkNotNull(
                roomId, r'RoomItemsModel', 'roomId'),
            roomType: roomType,
            roomName: roomName,
            image: image,
            selectedValue: BuiltValueNullFieldError.checkNotNull(
                selectedValue, r'RoomItemsModel', 'selectedValue'),
            color: _color?.build(),
            svgColor: svgColor,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'color';
        _color?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RoomItemsModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
