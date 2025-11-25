import 'package:admin/models/data/subscription_location_model.dart';
import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'doorbell_locations.g.dart';

abstract class DoorbellLocations
    implements Built<DoorbellLocations, DoorbellLocationsBuilder> {
  factory DoorbellLocations([void Function(DoorbellLocationsBuilder) updates]) =
      _$DoorbellLocations;

  DoorbellLocations._();

  static Serializer<DoorbellLocations> get serializer =>
      _$doorbellLocationsSerializer;

  int? get id;

  @BuiltValueField(wireName: 'owner_id')
  int? get ownerId;

  double? get latitude;

  double? get longitude;

  @BuiltValueField(wireName: 'house_no')
  String? get houseNo;

  String? get street;

  String? get state;

  String? get city;

  String? get country;

  @BuiltValueField(wireName: 'device_id')
  String? get deviceId;

  @BuiltValueField(wireName: 'created_at')
  String? get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  String? get updatedAt;

  String? get name;

  BuiltList<String> get roles;

  SubscriptionLocationModel? get subscription;

  static DoorbellLocations fromDynamic(json) {
    if (json['location_id'] != null) {
      json['id'] = json['location_id'];
    }
    if (json["latitude"] is String) {
      json["latitude"] = double.parse(json["latitude"]);
    }
    if (json["longitude"] is String) {
      json["longitude"] = double.parse(json["longitude"]);
    }

    return serializers.deserializeWith(
      DoorbellLocations.serializer,
      json,
    )!;
  }
}
