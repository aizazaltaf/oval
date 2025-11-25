import 'package:admin/core/images.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/material.dart' as material;
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'room_items_model.g.dart';

abstract class RoomItemsModel
    implements Built<RoomItemsModel, RoomItemsModelBuilder> {
  factory RoomItemsModel([void Function(RoomItemsModelBuilder) updates]) =
      _$RoomItemsModel;

  /// **Named Constructor for JSON Parsing**
  factory RoomItemsModel.fromDynamic(Map<String, dynamic> json) {
    return RoomItemsModel(
      (b) => b
        ..roomId = json["id"] as int? ?? 0
        ..roomName = json["name"] as String?
        ..roomType = json["type"] as String?
        ..selectedValue = false
        ..image ??= getImage(json["type"] as String?)
        ..color = ListBuilder([material.Colors.white, material.Colors.white])
        ..svgColor = material.Colors.grey,
    );
  }

  RoomItemsModel._();

  static Serializer<RoomItemsModel> get serializer =>
      _$roomItemsModelSerializer;

  @BuiltValueField(wireName: 'id')
  int get roomId;

  @BuiltValueField(wireName: 'type')
  String? get roomType;

  @BuiltValueField(wireName: 'name')
  String? get roomName;

  String? get image;

  @BlocUpdateField()
  bool get selectedValue;

  BuiltList<material.Color>? get color;

  @BuiltValueField(wireName: 'svg_color')
  material.Color? get svgColor;

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final RoomItemsModelBuilder b) =>
      b..selectedValue = false;

  /// **BuiltValue Hook to Initialize Defaults**
  @BuiltValueHook(finalizeBuilder: true)
  static void _finalize(final RoomItemsModelBuilder b) {
    b.image ??= getImage(b.roomType);
  }

  /// **Named Constructor for List Parsing**
  static BuiltList<RoomItemsModel> fromDynamics(List<dynamic> list) {
    return BuiltList<RoomItemsModel>(
      list.map((item) => RoomItemsModel.fromDynamic(item)),
    ).toBuilder().build();
  }

  /// **Static Helper Method to Get Default Image**
  static String? getImage(String? type) {
    switch (type) {
      case "living-room":
        return DefaultIcons.LIVINGROOM;
      case "bed-room":
        return DefaultIcons.BEDROOM;
      case "kitchen":
        return DefaultIcons.FRIDGE;
      case "backyard":
        return DefaultIcons.BACKYARD;
      case "bath-room":
        return DefaultIcons.BATHROOM;
      case "garage":
        return DefaultIcons.GARAGE;
      case "store-room":
        return DefaultIcons.STOREROOM;
      case "guest-room":
        return DefaultIcons.GUESTROOM;
      case "drawing-room":
        return DefaultIcons.DRAWINGROOM;
      default:
        return DefaultIcons.LIVINGROOM; // Default fallback
    }
  }
}
