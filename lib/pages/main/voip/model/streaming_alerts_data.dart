import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'streaming_alerts_data.g.dart';

abstract class StreamingAlertsData
    implements Built<StreamingAlertsData, StreamingAlertsDataBuilder> {
  factory StreamingAlertsData([
    void Function(StreamingAlertsDataBuilder) updates,
  ]) = _$StreamingAlertsData;
  StreamingAlertsData._();

  static Serializer<StreamingAlertsData> get serializer =>
      _$streamingAlertsDataSerializer;

  @BuiltValueField(wireName: 'fileUrl')
  String? get fileUrl;

  String get fileStartTime;

  @BuiltValueField(wireName: 'duration')
  int? get duration;

  @BuiltValueField(wireName: 'aiAlert')
  BuiltList<AiAlert>? get aiAlert;

  /// Compares the `startDateTime` of an alert with the range [i, i+2] seconds from calendarDate
  static bool comparison(AiAlert e, int counter, DateTime calendarDate) {
    final DateTime localTime = e.startDateTime;
    final DateTime base = calendarDate.add(Duration(seconds: counter));
    final bool isAfter =
        localTime.isAfter(base.subtract(const Duration(seconds: 1)));
    final bool isBefore =
        localTime.isBefore(base.add(const Duration(seconds: 3)));
    return isAfter && isBefore;

    // final DateTime localTime = e.startDateTime;
    // final DateTime twoSec = calendarDate.add(Duration(seconds: counter + 2));
    // final DateTime oneSec = calendarDate.add(Duration(seconds: counter + 1));
    // final bool compare = localTime.second == twoSec.second ||
    //     localTime.second == calendarDate.second ||
    //     localTime.second == oneSec.second;
    // return compare;
  }

  /// Deserialize and insert original + placeholder items every 3 seconds
  static StreamingAlertsData fromDynamic(
    Map<String, dynamic> json,
    DateTime calendarDate,
  ) {
    if (json["fileStartTime"] == null) {
      json["fileStartTime"] = calendarDate.toIso8601String();
    }
    if (json['duration'] is double) {
      json['duration'] = double.parse(json['duration'].toString()).toInt();
    }

    // final int duration = json['duration'] ?? 0;
    // final List<dynamic> alertsJson = json['aiAlert'] ?? [];
    //
    // final List<AiAlert> tempList = [];
    // final List<AiAlert> realAlerts =
    //     alertsJson.map(AiAlert.fromDynamic).toList();
    //
    // for (int i = 0; i < duration; i += 1) {
    //   final currentTime = calendarDate.add(Duration(seconds: i));
    //
    //   final AiAlert? match = realAlerts.firstWhereOrNull(
    //     (alert) =>
    //         comparison(alert, i, calendarDate) &&
    //         !tempList.any((a) => a.createdAt == alert.createdAt),
    //   );
    //
    //   if (match != null) {
    //     final jsonObject = Map<String, dynamic>.from(
    //       alertsJson.firstWhere(
    //         (e) => AiAlert.fromDynamic(e).createdAt == match.createdAt,
    //       ),
    //     );
    //     jsonObject['created_at'] = match.startDateTime.toIso8601String();
    //     tempList.add(AiAlert.fromDynamic(jsonObject));
    //   } else {
    //     final emptyJson = {
    //       'created_at': currentTime.toIso8601String(),
    //       'title': 'empty',
    //     };
    //     tempList.add(AiAlert.fromDynamic(emptyJson));
    //   }
    // }
    //
    // // ✅ Convert AiAlert objects to raw maps for deserialization
    // json['aiAlert'] = tempList
    //     .map((e) => serializers.serializeWith(AiAlert.serializer, e))
    //     .toList();

    return serializers.deserializeWith(
      StreamingAlertsData.serializer,
      json,
    )!;
  }
}

abstract class AiAlert implements Built<AiAlert, AiAlertBuilder> {
  factory AiAlert([void Function(AiAlertBuilder) updates]) = _$AiAlert;
  AiAlert._();

  static Serializer<AiAlert> get serializer => _$aiAlertSerializer;

  int? get id;

  @BuiltValueField(wireName: 'device_id')
  String? get deviceId;

  @BuiltValueField(wireName: 'entity_id')
  String? get entityId;

  String? get title;

  String? get image;

  String? get text;

  @BuiltValueField(wireName: 'created_at')
  String? get createdAt;

  DateTime get startDateTime =>
      DateTime.parse(createdAt ?? DateTime.now().toIso8601String()).toLocal();

  static AiAlert fromDynamic(json) {
    return serializers.deserializeWith(AiAlert.serializer, json)!;
  }

  static BuiltList<AiAlert> fromDynamics(final List<dynamic> list) {
    return BuiltList<AiAlert>(list.map(fromDynamic));
    // return BuiltList<AiAlert>(list.map(fromDynamic));
  }
}

class LocalImage {
  LocalImage({required this.id, required this.image});
  String id;
  String image;
}
