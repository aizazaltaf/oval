import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:built_value/built_value.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'doorbell_management_state.g.dart';

abstract class DoorbellManagementState
    implements Built<DoorbellManagementState, DoorbellManagementStateBuilder> {
  factory DoorbellManagementState([
    final void Function(DoorbellManagementStateBuilder) updates,
  ]) = _$DoorbellManagementState;

  DoorbellManagementState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final DoorbellManagementStateBuilder b) => b
    ..center = const LatLng(37.7749, -122.4194)
    ..markerPosition = const LatLng(37.7749, -122.4194)
    ..mapGuideShow = false
    ..doorbellNameSaveLoading = false
    ..currentGuideKey = ""
    ..radiusInMeters = 10
    ..locationName = ""
    ..backPress = false
    ..proceedButtonEnabled = false
    ..companyAddress = ""
    ..streetBlockName = ""
    ..customDoorbellName = ""
    ..doorbellName = "Front Door"
    ..superToolTipController = SuperTooltipController();

  @BlocUpdateField()
  LatLng? get center;

  @BlocUpdateField()
  bool get mapGuideShow;

  @BlocUpdateField()
  String get currentGuideKey;

  @BlocUpdateField()
  bool get doorbellNameSaveLoading;

  @BlocUpdateField()
  LatLng? get markerPosition;

  double get radiusInMeters;

  @BlocUpdateField()
  bool get backPress;

  @BlocUpdateField()
  bool get proceedButtonEnabled;

  @BlocUpdateField()
  String get locationName;

  @BlocUpdateField()
  String? get deviceId;

  @BlocUpdateField()
  String? get doorbellName;

  @BlocUpdateField()
  String get customDoorbellName;

  @BlocUpdateField()
  DoorbellLocations? get selectedLocation;

  @BlocUpdateField()
  String get companyAddress;

  @BlocUpdateField()
  String get streetBlockName;

  @BlocUpdateField()
  Placemark? get placeMark;

  SuperTooltipController get superToolTipController;

  ApiState<void> get createLocationApi;

  ApiState<void> get assignDoorbellApi;

  @BlocUpdateField()
  ApiState<void> get scanDoorBellApi;

  ApiState<void> get updateLocationApi;
}
