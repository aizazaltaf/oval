import 'dart:math';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/doorbell_management/bloc/doorbell_management_state.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/dio.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'doorbell_management_bloc.bloc.g.dart';

// final _logger = Logger("doorbell_bloc.dart");

@BlocGen()
class DoorbellManagementBloc
    extends BVCubit<DoorbellManagementState, DoorbellManagementStateBuilder>
    with _DoorbellManagementBlocMixin {
  DoorbellManagementBloc() : super(DoorbellManagementState());

  factory DoorbellManagementBloc.of(final BuildContext context) =>
      BlocProvider.of<DoorbellManagementBloc>(context);

  // Barcode? result;
  // QRViewController? controller;
  bool isDetected = false;

  //Guides Global keys
  final mapAddressGuideKey = GlobalKey();
  final circleMarkerGuideKey = GlobalKey();
  final pinMarkerGuideKey = GlobalKey();

  GlobalKey getCurrentGuide() {
    switch (state.currentGuideKey) {
      case "pin_marker":
        return pinMarkerGuideKey;

      case "map_address":
        return mapAddressGuideKey;

      default:
        return circleMarkerGuideKey;
    }
  }

  double calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000;
    final double dLat = (end.latitude - start.latitude) * pi / 180.0;
    final double dLng = (end.longitude - start.longitude) * pi / 180.0;
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(start.latitude * pi / 180.0) *
            cos(end.latitude * pi / 180.0) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c;
    return distance;
  }

  void onCheckProceed() {
    if (state.locationName.isEmpty ||
        state.companyAddress.isEmpty ||
        state.streetBlockName.isEmpty) {
      updateProceedButtonEnabled(false);
    } else {
      updateProceedButtonEnabled(true);
    }
  }

  Future<void> getLocationCoordinates() async {
    await placemarkFromCoordinates(
      state.markerPosition!.latitude,
      state.markerPosition!.longitude,
    ).then((value) {
      updatePlaceMark(value.first);
    });
  }

  void updatePosition(LatLng newPosition, LatLng currentLatLng, message) {
    final double distance = calculateDistance(currentLatLng, newPosition);
    if (distance <= 10) {
      updateMarkerPosition(newPosition);
      updatePlaceMark(null);
      getLocationCoordinates();
    } else {
      ToastUtils.errorToast(message);
    }
  }

  Future<void> callUpdateLocation({
    required int locationId,
    required double latitude,
    required VoidCallback successFunction,
    required double longitude,
    required String houseNo,
    required String street,
    required String locationName,
    required Placemark address,
  }) {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.updateLocationApi,
      updateApiState: (final b, final apiState) =>
          b.updateLocationApi.replace(apiState),
      onError: (exception) {
        if (exception is DioException && exception.response != null) {
          ToastUtils.errorToast(exception.response!.data["message"]);
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
      callApi: () async {
        final response = await apiService.getUpdateLocation(
          locationId: locationId,
          latitude: latitude,
          longitude: longitude,
          houseNo: houseNo,
          street: street,
          locationName: locationName,
          address: address,
        );
        if (response.data['success'] == true) {
          ToastUtils.successToast(response.data["message"]);
          successFunction();
        } else {
          ToastUtils.errorToast(response.data["message"]);
        }
      },
    );
  }

  Future<void> callLocation(VoidCallback navigationFuntion) {
    return CubitUtils.makeApiCall<DoorbellManagementState,
        DoorbellManagementStateBuilder, void>(
      cubit: this,
      apiState: state.createLocationApi,
      onError: (err) {
        updateDoorbellNameSaveLoading(false);
      },
      updateApiState: (final b, final apiState) =>
          b.createLocationApi.replace(apiState),
      callApi: () async {
        final response = await apiService.createLocation(
          name: state.locationName.trim(),
          houseNo: state.companyAddress.trim(),
          address: state.placeMark,
          street: state.streetBlockName.trim(),
          coordinates: state.markerPosition,
        );
        if (response.statusCode == 200) {
          updateSelectedLocation(
            DoorbellLocations.fromDynamic(response.data["data"]),
          );
          singletonBloc.profileBloc.emit(
            singletonBloc.profileBloc.state!
                .rebuild((e) => e.locations.add(state.selectedLocation!)),
          );
          navigationFuntion();
        } else {
          ToastUtils.infoToast("Warning", "Wrong QR code");
        }
      },
    );
  }

  Future<void> scanDoorBell(
    String deviceId,
    Future<void> Function() navigationFunction,
  ) async {
    return CubitUtils.makeApiCall<DoorbellManagementState,
        DoorbellManagementStateBuilder, void>(
      cubit: this,
      apiState: state.scanDoorBellApi,
      updateApiState: (final b, final apiState) =>
          b.scanDoorBellApi.replace(apiState),
      callApi: () async {
        final response = await apiService.scanDoorbell(deviceId, 1);
        if (response.statusCode == 200) {
          await navigationFunction(); // ✅ Await the navigation function
          return;
        } else {
          ToastUtils.infoToast("Warning", "Wrong QR code");
          return;
        }
      },
    );
  }

  void onUpdateDoorbellName(String? doorbellName) {
    emit(state.rebuild((final b) => b..doorbellName = null));
    emit(state.rebuild((final b) => b..doorbellName = doorbellName));
  }

  Future assignDoorbell({required VoidCallback navigationFunction}) async {
    await apiService.scanDoorbell(state.deviceId!, 1);
    return CubitUtils.makeApiCall<DoorbellManagementState,
        DoorbellManagementStateBuilder, void>(
      cubit: this,
      apiState: state.assignDoorbellApi,
      onError: (err) {
        updateDoorbellNameSaveLoading(false);
      },
      updateApiState: (final b, final apiState) =>
          b.assignDoorbellApi.replace(apiState),
      callApi: () async {
        final response = await apiService.assignDoorbell(
          name: state.doorbellName == "Custom"
              ? state.customDoorbellName
              : state.doorbellName,
          deviceId: state.deviceId,
          locationId: state.selectedLocation!.id,
        );
        if (response.statusCode == 200) {
          navigationFunction.call();
        }
      },
    );
  }

  String getAddress(Placemark placeMark) {
    return "${(placeMark.subLocality == null || placeMark.subLocality.toString().isEmpty) ? '' : '${placeMark.subLocality!},'} "
        "${(placeMark.locality == null || placeMark.locality.toString().isEmpty) ? '' : '${placeMark.locality!},'} "
        "${(placeMark.administrativeArea == null || placeMark.administrativeArea.toString().isEmpty) ? '' : '${placeMark.administrativeArea!},'} "
        "${(placeMark.postalCode == null || placeMark.postalCode.toString().isEmpty) ? '' : '${placeMark.postalCode!},'} "
        "${(placeMark.country == null || placeMark.country.toString().isEmpty) ? '' : placeMark.country}";
  }
}
