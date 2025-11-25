import 'dart:convert';

import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/models/data/room_items_model.dart';
import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'iot_device_model.g.dart';

final _logger = Logger('iot_device_model.dart');

abstract class IotDeviceModel
    implements Built<IotDeviceModel, IotDeviceModelBuilder> {
  factory IotDeviceModel([void Function(IotDeviceModelBuilder) updates]) =
      _$IotDeviceModel;

  IotDeviceModel._();

  static Serializer<IotDeviceModel> get serializer =>
      _$iotDeviceModelSerializer;

  static void _initializeBuilder(IotDeviceModelBuilder b) {
    b
      ..stateAvailable = 3
      ..brightness = 0
      ..isStreaming = 0
      ..usageCount = 0
      ..thermostatTemperatureUnit = "°F"
      ..superTooltipController = SuperTooltipController()
      ..detailsJson = '{}';
  }

  int get id;

  @BuiltValueField(wireName: 'entity_id')
  String? get entityId;

  @BuiltValueField(wireName: 'room_id')
  int? get roomId;

  @BuiltValueField(wireName: 'name')
  String? get deviceName;

  @BuiltValueField(wireName: 'created_at')
  String? get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  String? get updatedAt;

  @BuiltValueField(wireName: 'uuid')
  String? get callUserId;

  @BuiltValueField(wireName: 'usage_count')
  int get usageCount;

  @BuiltValueField(wireName: 'doorbell_id')
  int? get doorbellId;

  @BuiltValueField(wireName: 'details')
  String get detailsJson;

  Map<String, dynamic>? get details => detailsJson.isEmpty
      ? null
      : json.decode(detailsJson) as Map<String, dynamic>;

  String? get imagePreview;

  @BuiltValueField(wireName: 'location_id')
  int? get locationId;

  @BuiltValueField(wireName: 'is_streaming')
  int get isStreaming;

  int? get status;

  RoomItemsModel? get room;

  int get stateAvailable;

  double get brightness;

  String? get configuration;

  String? get temperature;

  String? get thermostatTemperatureUnit;

  String? get mode;

  String? get presetMode;

  String? get fanMode;

  String? get curtainDeviceId;

  String? get curtainPosition;

  String? get blindDirection;

  SuperTooltipController? get superTooltipController;

  @BuiltValueHook(finalizeBuilder: true)
  static void _finalize(final IotDeviceModelBuilder b) {
    b.imagePreview = getIcon(b.entityId);
  }

  static String? getIcon(String? entityId) {
    if (entityId == null) {
      return DefaultVectors.IOT_BULB;
    }
    final image = entityId.split(".").first;
    switch (image) {
      case Constants.climate:
        return DefaultVectors.THERMOSTAT_ICON;

      case Constants.light:
        return DefaultVectors.IOT_BULB;

      case Constants.camera:
        return DefaultVectors.CAMERA;

      case Constants.curtain:
        return DefaultVectors.CURTAIN_ICON_SVG;

      case Constants.smartLock:
        return DefaultVectors.DOORBELL_LOCK;

      default:
        return DefaultVectors.IOT_BULB;
    }
  }

  static IotDeviceModel? fromDynamic(json) {
    try {
      final Map<String, dynamic> processedJson =
          Map<String, dynamic>.from(json);

      // Handle details
      if (json['details'] != null) {
        processedJson['details'] = json['details'] is String
            ? json['details']
            : jsonEncode(json['details']);

        // Extract usage_count from details if available
        final details = json['details'] is String
            ? jsonDecode(json['details'])
            : json['details'];

        if (details is Map && details.containsKey('usage_count')) {
          processedJson['usage_count'] = details['usage_count'];
        }
      }

      return serializers.deserializeWith(
        IotDeviceModel.serializer,
        processedJson,
      );
    } catch (e) {
      _logger.severe('Error deserializing IotDeviceModel: $e');
      return null;
    }
  }

  static BuiltList<IotDeviceModel> fromDynamics(final List<dynamic> list) {
    return BuiltList<IotDeviceModel>(list.map(fromDynamic));
  }
}
