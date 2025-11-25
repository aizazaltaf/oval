import 'dart:async';

import 'package:admin/models/data/api_meta_data.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/pages/main/doorbell_management/bloc/doorbell_management_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../mocks/bloc/bloc_mocks.dart';
import '../../mocks/bloc/state_mocks.dart';

class DoorbellManagementBlocTestHelper {
  late MockDoorbellManagementBloc mockDoorbellManagementBloc;
  late DoorbellManagementState currentDoorbellManagementState;

  void setup() {
    mockDoorbellManagementBloc = MockDoorbellManagementBloc();
    currentDoorbellManagementState = MockDoorbellManagementState();

    when(() => mockDoorbellManagementBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockDoorbellManagementBloc.state)
        .thenReturn(currentDoorbellManagementState);

    // Setup default state properties
    setupDefaultState();
  }

  void setupDefaultState() {
    // Stub all required DoorbellManagementState properties
    when(() => currentDoorbellManagementState.center)
        .thenReturn(const LatLng(37.7749, -122.4194));
    when(() => currentDoorbellManagementState.mapGuideShow).thenReturn(false);
    when(() => currentDoorbellManagementState.currentGuideKey).thenReturn("");
    when(() => currentDoorbellManagementState.doorbellNameSaveLoading)
        .thenReturn(false);
    when(() => currentDoorbellManagementState.markerPosition)
        .thenReturn(const LatLng(37.7749, -122.4194));
    when(() => currentDoorbellManagementState.radiusInMeters).thenReturn(10);
    when(() => currentDoorbellManagementState.backPress).thenReturn(false);
    when(() => currentDoorbellManagementState.proceedButtonEnabled)
        .thenReturn(false);
    when(() => currentDoorbellManagementState.locationName).thenReturn("");
    when(() => currentDoorbellManagementState.deviceId).thenReturn(null);
    when(() => currentDoorbellManagementState.doorbellName)
        .thenReturn("Front Door");
    when(() => currentDoorbellManagementState.customDoorbellName)
        .thenReturn("");
    when(() => currentDoorbellManagementState.selectedLocation)
        .thenReturn(null);
    when(() => currentDoorbellManagementState.companyAddress).thenReturn("");
    when(() => currentDoorbellManagementState.streetBlockName).thenReturn("");
    when(() => currentDoorbellManagementState.superToolTipController)
        .thenReturn(SuperTooltipController());

    // Setup API state properties with proper stubbing
    final mockState = currentDoorbellManagementState as MockDoorbellManagementState;
    
    // Stub scanDoorBellApi properties
    when(() => mockState.scanDoorBellApiMock.isApiInProgress).thenReturn(false);
    when(() => mockState.scanDoorBellApiMock.isApiPaginationEnabled).thenReturn(false);
    when(() => mockState.scanDoorBellApiMock.totalCount).thenReturn(0);
    when(() => mockState.scanDoorBellApiMock.currentPage).thenReturn(0);
    when(() => mockState.scanDoorBellApiMock.data).thenReturn(null);
    when(() => mockState.scanDoorBellApiMock.error).thenReturn(null);
    when(() => mockState.scanDoorBellApiMock.message).thenReturn(null);
    when(() => mockState.scanDoorBellApiMock.pagination).thenReturn(null);
    when(() => mockState.scanDoorBellApiMock.uploadProgress).thenReturn(null);

    // Stub createLocationApi properties
    when(() => mockState.createLocationApiMock.isApiInProgress).thenReturn(false);
    when(() => mockState.createLocationApiMock.isApiPaginationEnabled).thenReturn(false);
    when(() => mockState.createLocationApiMock.totalCount).thenReturn(0);
    when(() => mockState.createLocationApiMock.currentPage).thenReturn(0);
    when(() => mockState.createLocationApiMock.data).thenReturn(null);
    when(() => mockState.createLocationApiMock.error).thenReturn(null);
    when(() => mockState.createLocationApiMock.message).thenReturn(null);
    when(() => mockState.createLocationApiMock.pagination).thenReturn(null);
    when(() => mockState.createLocationApiMock.uploadProgress).thenReturn(null);

    // Stub assignDoorbellApi properties
    when(() => mockState.assignDoorbellApiMock.isApiInProgress).thenReturn(false);
    when(() => mockState.assignDoorbellApiMock.isApiPaginationEnabled).thenReturn(false);
    when(() => mockState.assignDoorbellApiMock.totalCount).thenReturn(0);
    when(() => mockState.assignDoorbellApiMock.currentPage).thenReturn(0);
    when(() => mockState.assignDoorbellApiMock.data).thenReturn(null);
    when(() => mockState.assignDoorbellApiMock.error).thenReturn(null);
    when(() => mockState.assignDoorbellApiMock.message).thenReturn(null);
    when(() => mockState.assignDoorbellApiMock.pagination).thenReturn(null);
    when(() => mockState.assignDoorbellApiMock.uploadProgress).thenReturn(null);

    // Stub updateLocationApi properties
    when(() => mockState.updateLocationApiMock.isApiInProgress).thenReturn(false);
    when(() => mockState.updateLocationApiMock.isApiPaginationEnabled).thenReturn(false);
    when(() => mockState.updateLocationApiMock.totalCount).thenReturn(0);
    when(() => mockState.updateLocationApiMock.currentPage).thenReturn(0);
    when(() => mockState.updateLocationApiMock.data).thenReturn(null);
    when(() => mockState.updateLocationApiMock.error).thenReturn(null);
    when(() => mockState.updateLocationApiMock.message).thenReturn(null);
    when(() => mockState.updateLocationApiMock.pagination).thenReturn(null);
    when(() => mockState.updateLocationApiMock.uploadProgress).thenReturn(null);
  }

  void setupWithLocation() {
    // Setup state with a selected location
    final mockLocation = DoorbellLocations(
      (b) => b
        ..id = 1
        ..name = "Test Location"
        ..street = "Test Street"
        ..state = "Test State"
        ..city = "Test City"
        ..houseNo = "Test house no"
        ..country = "Test Country"
        ..latitude = 37.7749
        ..longitude = -122.4194
        ..roles = ListBuilder<String>(["Admin"]),
    );

    when(() => currentDoorbellManagementState.selectedLocation)
        .thenReturn(mockLocation);
    when(() => currentDoorbellManagementState.locationName)
        .thenReturn("Test Location");
    when(() => currentDoorbellManagementState.proceedButtonEnabled)
        .thenReturn(true);
  }

  void setupWithDeviceId() {
    // Setup state with a device ID
    when(() => currentDoorbellManagementState.deviceId)
        .thenReturn("test_device_123");
  }

  void setupWithCustomDoorbellNameDefault() {
    // Setup state with a custom doorbell name
    when(() => currentDoorbellManagementState.doorbellName)
        .thenReturn("Custom");
    when(() => currentDoorbellManagementState.customDoorbellName)
        .thenReturn("My Custom Doorbell");
  }

  void setupWithMapGuideDefault() {
    // Setup state with map guide active
    when(() => currentDoorbellManagementState.mapGuideShow).thenReturn(true);
    when(() => currentDoorbellManagementState.currentGuideKey)
        .thenReturn("map_address");
  }

  void setupWithBackPress() {
    // Setup state with back press active
    when(() => currentDoorbellManagementState.backPress).thenReturn(true);
  }

  void setupWithDoorbellNameSaveLoading() {
    // Setup state with doorbell name save loading
    when(() => currentDoorbellManagementState.doorbellNameSaveLoading)
        .thenReturn(true);
  }

  void setupWithDifferentCenter() {
    // Setup state with different center coordinates
    when(() => currentDoorbellManagementState.center)
        .thenReturn(const LatLng(40.7128, -74.0060));
    when(() => currentDoorbellManagementState.markerPosition)
        .thenReturn(const LatLng(40.7128, -74.0060));
  }

  void setupLoadingState() {
    // Setup loading state for APIs - now using the concrete mock instances
    final mockState =
        currentDoorbellManagementState as MockDoorbellManagementState;
    when(() => mockState.createLocationApiMock.isApiInProgress)
        .thenReturn(true);
    when(() => mockState.assignDoorbellApiMock.isApiInProgress)
        .thenReturn(true);
    when(() => mockState.scanDoorBellApiMock.isApiInProgress).thenReturn(true);
    when(() => mockState.updateLocationApiMock.isApiInProgress)
        .thenReturn(true);
  }

  void setupErrorState() {
    // Setup error state for APIs
    final mockError = ApiMetaData(
      (b) => b
        ..message = "Test error"
        ..statusCode = 400,
    );
    when(() => currentDoorbellManagementState.createLocationApi.error)
        .thenReturn(mockError);
  }

  void setupSuccessState() {
    // Setup success state for APIs - ApiState doesn't have isSuccess property
    // We can check if data is not null or error is null
    when(() => currentDoorbellManagementState.createLocationApi.data)
        .thenReturn(null);
    when(() => currentDoorbellManagementState.createLocationApi.error)
        .thenReturn(null);
    when(() => currentDoorbellManagementState.assignDoorbellApi.data)
        .thenReturn(null);
    when(() => currentDoorbellManagementState.assignDoorbellApi.error)
        .thenReturn(null);
    when(() => currentDoorbellManagementState.scanDoorBellApi.data)
        .thenReturn(null);
    when(() => currentDoorbellManagementState.scanDoorBellApi.error)
        .thenReturn(null);
    when(() => currentDoorbellManagementState.updateLocationApi.data)
        .thenReturn(null);
    when(() => currentDoorbellManagementState.updateLocationApi.error)
        .thenReturn(null);
  }

  void setupWithPlaceMark() {
    // Setup state with a placemark
    const mockPlaceMark = Placemark(
      street: "Test Street",
      locality: "Test City",
      administrativeArea: "Test State",
      country: "Test Country",
      postalCode: "12345",
      subLocality: "Test SubLocality",
    );

    when(() => currentDoorbellManagementState.placeMark)
        .thenReturn(mockPlaceMark);
  }

  void setupWithApiInProgress() {
    // Setup state with API in progress - now using the concrete mock instances
    final mockState =
        currentDoorbellManagementState as MockDoorbellManagementState;
    when(() => mockState.scanDoorBellApiMock.isApiInProgress).thenReturn(true);
    when(() => mockState.createLocationApiMock.isApiInProgress)
        .thenReturn(true);
    when(() => mockState.assignDoorbellApiMock.isApiInProgress)
        .thenReturn(true);
    when(() => mockState.updateLocationApiMock.isApiInProgress)
        .thenReturn(true);
  }

  void setupWithApiError() {
    // Setup state with API error - now using the concrete mock instances
    final mockState =
        currentDoorbellManagementState as MockDoorbellManagementState;
    final mockError = ApiMetaData(
      (b) => b
        ..message = "Test API Error"
        ..statusCode = 400,
    );

    when(() => mockState.scanDoorBellApiMock.isApiInProgress).thenReturn(false);
    when(() => mockState.scanDoorBellApiMock.error).thenReturn(mockError);
    when(() => mockState.createLocationApiMock.isApiInProgress)
        .thenReturn(false);
    when(() => mockState.createLocationApiMock.error).thenReturn(mockError);
    when(() => mockState.assignDoorbellApiMock.isApiInProgress)
        .thenReturn(false);
    when(() => mockState.assignDoorbellApiMock.error).thenReturn(mockError);
    when(() => mockState.updateLocationApiMock.isApiInProgress)
        .thenReturn(false);
    when(() => mockState.updateLocationApiMock.error).thenReturn(mockError);
  }

  void setupWithApiSuccess() {
    // Setup state with API success - now using the concrete mock instances
    final mockState =
        currentDoorbellManagementState as MockDoorbellManagementState;

    when(() => mockState.scanDoorBellApiMock.isApiInProgress).thenReturn(false);
    when(() => mockState.scanDoorBellApiMock.data).thenReturn(null);
    when(() => mockState.scanDoorBellApiMock.error).thenReturn(null);
    when(() => mockState.createLocationApiMock.isApiInProgress)
        .thenReturn(false);
    when(() => mockState.createLocationApiMock.data).thenReturn(null);
    when(() => mockState.createLocationApiMock.error).thenReturn(null);
    when(() => mockState.assignDoorbellApiMock.isApiInProgress)
        .thenReturn(false);
    when(() => mockState.assignDoorbellApiMock.data).thenReturn(null);
    when(() => mockState.assignDoorbellApiMock.error).thenReturn(null);
    when(() => mockState.updateLocationApiMock.isApiInProgress)
        .thenReturn(false);
    when(() => mockState.updateLocationApiMock.data).thenReturn(null);
    when(() => mockState.updateLocationApiMock.error).thenReturn(null);
  }

  void setupWithProceedButtonEnabled() {
    // Setup state with proceed button enabled
    when(() => currentDoorbellManagementState.proceedButtonEnabled)
        .thenReturn(true);
    when(() => currentDoorbellManagementState.locationName)
        .thenReturn("Test Location");
    when(() => currentDoorbellManagementState.companyAddress)
        .thenReturn("123 Test St");
    when(() => currentDoorbellManagementState.streetBlockName)
        .thenReturn("Test Block");
  }

  void setupWithFormValidation() {
    // Setup state with form validation data
    when(() => currentDoorbellManagementState.locationName).thenReturn("Home");
    when(() => currentDoorbellManagementState.companyAddress).thenReturn("123");
    when(() => currentDoorbellManagementState.streetBlockName)
        .thenReturn("Main St");
    when(() => currentDoorbellManagementState.proceedButtonEnabled)
        .thenReturn(true);
  }

  void setupWithCustomDoorbellName(String customName) {
    // Setup state with custom doorbell name
    when(() => currentDoorbellManagementState.doorbellName)
        .thenReturn("Custom");
    when(() => currentDoorbellManagementState.customDoorbellName)
        .thenReturn(customName);
  }

  void setupWithDifferentDoorbellName(String doorbellName) {
    // Setup state with different doorbell name
    when(() => currentDoorbellManagementState.doorbellName)
        .thenReturn(doorbellName);
  }

  void setupWithMapGuide(String guideKey) {
    // Setup state with map guide
    when(() => currentDoorbellManagementState.mapGuideShow).thenReturn(true);
    when(() => currentDoorbellManagementState.currentGuideKey)
        .thenReturn(guideKey);
  }

  void setupWithLocationData() {
    // Setup state with complete location data
    final mockLocation = DoorbellLocations(
      (b) => b
        ..id = 1
        ..name = "Test Home"
        ..street = "Main Street"
        ..state = "CA"
        ..city = "San Francisco"
        ..houseNo = "123"
        ..country = "USA"
        ..latitude = 37.7749
        ..longitude = -122.4194
        ..roles = ListBuilder<String>(["Admin"]),
    );

    const mockPlaceMark = Placemark(
      street: "Main Street",
      locality: "San Francisco",
      administrativeArea: "CA",
      country: "USA",
      postalCode: "94102",
      subLocality: "Downtown",
    );

    when(() => currentDoorbellManagementState.selectedLocation)
        .thenReturn(mockLocation);
    when(() => currentDoorbellManagementState.placeMark)
        .thenReturn(mockPlaceMark);
    when(() => currentDoorbellManagementState.locationName)
        .thenReturn("Test Home");
    when(() => currentDoorbellManagementState.companyAddress).thenReturn("123");
    when(() => currentDoorbellManagementState.streetBlockName)
        .thenReturn("Main Street");
  }

  void setupWithQRCodeData() {
    // Setup state with QR code data
    when(() => currentDoorbellManagementState.deviceId)
        .thenReturn("device_123");
    when(() => currentDoorbellManagementState.center)
        .thenReturn(const LatLng(37.7749, -122.4194));
    when(() => currentDoorbellManagementState.markerPosition)
        .thenReturn(const LatLng(37.7749, -122.4194));
  }

  void setupWithLocationServices() {
    // Setup state for location services testing
    when(() => currentDoorbellManagementState.center)
        .thenReturn(const LatLng(0, 0));
    when(() => currentDoorbellManagementState.markerPosition)
        .thenReturn(const LatLng(0, 0));
  }

  void setupWithBackPressEnabled() {
    // Setup state with back press enabled
    when(() => currentDoorbellManagementState.backPress).thenReturn(true);
  }

  void setupWithDoorbellNameLoading() {
    // Setup state with doorbell name save loading
    when(() => currentDoorbellManagementState.doorbellNameSaveLoading)
        .thenReturn(true);
  }

  void setupWithDifferentCoordinates() {
    // Setup state with different coordinates
    when(() => currentDoorbellManagementState.center)
        .thenReturn(const LatLng(40.7128, -74.0060));
    when(() => currentDoorbellManagementState.markerPosition)
        .thenReturn(const LatLng(40.7128, -74.0060));
  }

  void setupWithRadiusValidation() {
    // Setup state for radius validation testing
    when(() => currentDoorbellManagementState.radiusInMeters).thenReturn(10);
    when(() => currentDoorbellManagementState.center)
        .thenReturn(const LatLng(37.7749, -122.4194));
  }

  void setupWithEmptyLocationData() {
    // Setup state with empty location data
    when(() => currentDoorbellManagementState.locationName).thenReturn("");
    when(() => currentDoorbellManagementState.companyAddress).thenReturn("");
    when(() => currentDoorbellManagementState.streetBlockName).thenReturn("");
    when(() => currentDoorbellManagementState.proceedButtonEnabled)
        .thenReturn(false);
  }

  void setupWithInvalidQRCode() {
    // Setup state for invalid QR code testing
    when(() => currentDoorbellManagementState.deviceId).thenReturn(null);
  }

  void setupWithLocationPermissionDenied() {
    // Setup state for location permission denied testing
    when(() => currentDoorbellManagementState.center)
        .thenReturn(const LatLng(0, 0));
    when(() => currentDoorbellManagementState.markerPosition)
        .thenReturn(const LatLng(0, 0));
  }

  void setupWithInternetConnection() {
    // Setup state assuming internet connection is available
    // This is handled by the Services.isInternetWorking() mock
  }

  void setupWithNoInternetConnection() {
    // Setup state assuming no internet connection
    // This is handled by the Services.isInternetWorking() mock
  }

  void setupWithValidQRCodeResponse() {
    // Setup state with valid QR code response
    when(() => currentDoorbellManagementState.deviceId)
        .thenReturn("valid_device_123");
    when(() => currentDoorbellManagementState.center)
        .thenReturn(const LatLng(37.7749, -122.4194));
    when(() => currentDoorbellManagementState.markerPosition)
        .thenReturn(const LatLng(37.7749, -122.4194));
  }

  void setupWithInvalidQRCodeResponse() {
    // Setup state with invalid QR code response
    when(() => currentDoorbellManagementState.deviceId)
        .thenReturn("invalid_device");
  }

  void setupWithLocationFromQRCode() {
    // Setup state with location data from QR code
    when(() => currentDoorbellManagementState.deviceId)
        .thenReturn("device_with_location");
    when(() => currentDoorbellManagementState.center)
        .thenReturn(const LatLng(40.7128, -74.0060));
    when(() => currentDoorbellManagementState.markerPosition)
        .thenReturn(const LatLng(40.7128, -74.0060));
  }

  void setupWithNoLocationFromQRCode() {
    // Setup state with no location data from QR code
    when(() => currentDoorbellManagementState.deviceId)
        .thenReturn("device_no_location");
    when(() => currentDoorbellManagementState.center)
        .thenReturn(const LatLng(0, 0));
    when(() => currentDoorbellManagementState.markerPosition)
        .thenReturn(const LatLng(0, 0));
  }

  void setupWithScannerController() {
    // Setup state for scanner controller testing
    when(() => currentDoorbellManagementState.scanDoorBellApi.isApiInProgress)
        .thenReturn(false);
  }

  void setupWithScannerLoading() {
    // Setup state with scanner loading
    when(() => currentDoorbellManagementState.scanDoorBellApi.isApiInProgress)
        .thenReturn(true);
  }

  void setupWithCameraPermission() {
    // Setup state assuming camera permission is granted
    // This is handled by the Permission.camera.request() mock
  }

  void setupWithCameraPermissionDenied() {
    // Setup state assuming camera permission is denied
    // This is handled by the Permission.camera.request() mock
  }

  void setupWithLocationPermissionGranted() {
    // Setup state assuming location permission is granted
    // This is handled by the Geolocator.checkPermission() mock
  }

  void setupWithLocationPermissionDeniedForever() {
    // Setup state assuming location permission is denied forever
    // This is handled by the Geolocator.checkPermission() mock
  }

  void setupWithLocationServicesDisabled() {
    // Setup state assuming location services are disabled
    // This is handled by the Geolocator.isLocationServiceEnabled() mock
  }

  void setupWithLocationServicesEnabled() {
    // Setup state assuming location services are enabled
    // This is handled by the Geolocator.isLocationServiceEnabled() mock
  }

  void setupWithCurrentPosition() {
    // Setup state with current position
    when(() => currentDoorbellManagementState.center)
        .thenReturn(const LatLng(37.7749, -122.4194));
    when(() => currentDoorbellManagementState.markerPosition)
        .thenReturn(const LatLng(37.7749, -122.4194));
  }

  void setupWithDistanceValidation() {
    // Setup state for distance validation testing
    when(() => currentDoorbellManagementState.radiusInMeters).thenReturn(10);
    when(() => currentDoorbellManagementState.center)
        .thenReturn(const LatLng(37.7749, -122.4194));
  }

  void setupWithFormValidationErrors() {
    // Setup state with form validation errors
    when(() => currentDoorbellManagementState.locationName).thenReturn("");
    when(() => currentDoorbellManagementState.companyAddress).thenReturn("");
    when(() => currentDoorbellManagementState.streetBlockName).thenReturn("");
    when(() => currentDoorbellManagementState.proceedButtonEnabled)
        .thenReturn(false);
  }

  void setupWithFormValidationSuccess() {
    // Setup state with form validation success
    when(() => currentDoorbellManagementState.locationName)
        .thenReturn("Test Location");
    when(() => currentDoorbellManagementState.companyAddress)
        .thenReturn("123 Test St");
    when(() => currentDoorbellManagementState.streetBlockName)
        .thenReturn("Test Block");
    when(() => currentDoorbellManagementState.proceedButtonEnabled)
        .thenReturn(true);
  }

  void setupWithUpdateLocationData() {
    // Setup state for update location testing
    final mockLocation = DoorbellLocations(
      (b) => b
        ..id = 1
        ..name = "Updated Location"
        ..street = "Updated Street"
        ..state = "CA"
        ..city = "San Francisco"
        ..houseNo = "456"
        ..country = "USA"
        ..latitude = 37.7749
        ..longitude = -122.4194
        ..roles = ListBuilder<String>(["Admin"]),
    );

    when(() => currentDoorbellManagementState.selectedLocation)
        .thenReturn(mockLocation);
    when(() => currentDoorbellManagementState.locationName)
        .thenReturn("Updated Location");
    when(() => currentDoorbellManagementState.companyAddress).thenReturn("456");
    when(() => currentDoorbellManagementState.streetBlockName)
        .thenReturn("Updated Street");
  }

  void setupWithAssignDoorbellData() {
    // Setup state for assign doorbell testing
    when(() => currentDoorbellManagementState.doorbellName)
        .thenReturn("Front Door");
    when(() => currentDoorbellManagementState.deviceId)
        .thenReturn("device_123");
    when(() => currentDoorbellManagementState.selectedLocation).thenReturn(
      DoorbellLocations(
        (b) => b
          ..id = 1
          ..name = "Test Location"
          ..street = "Test Street"
          ..state = "CA"
          ..city = "San Francisco"
          ..houseNo = "123"
          ..country = "USA"
          ..latitude = 37.7749
          ..longitude = -122.4194
          ..roles = ListBuilder<String>(["Admin"]),
      ),
    );
  }

  void setupWithCustomDoorbellNameValidation() {
    // Setup state for custom doorbell name validation
    when(() => currentDoorbellManagementState.doorbellName)
        .thenReturn("Custom");
    when(() => currentDoorbellManagementState.customDoorbellName)
        .thenReturn("My Custom Doorbell");
  }

  void setupWithDoorbellNameValidation() {
    // Setup state for doorbell name validation
    when(() => currentDoorbellManagementState.doorbellName)
        .thenReturn("Front Door");
    when(() => currentDoorbellManagementState.customDoorbellName)
        .thenReturn("");
  }

  void setupWithLocationNameValidation() {
    // Setup state for location name validation
    when(() => currentDoorbellManagementState.locationName).thenReturn("Home");
  }

  void setupWithHouseNumberValidation() {
    // Setup state for house number validation
    when(() => currentDoorbellManagementState.companyAddress).thenReturn("123");
  }

  void setupWithStreetBlockValidation() {
    // Setup state for street block validation
    when(() => currentDoorbellManagementState.streetBlockName)
        .thenReturn("Main St");
  }

  void setupWithAddressValidation() {
    // Setup state for address validation
    const mockPlaceMark = Placemark(
      street: "Main Street",
      locality: "San Francisco",
      administrativeArea: "CA",
      country: "USA",
      postalCode: "94102",
      subLocality: "Downtown",
    );

    when(() => currentDoorbellManagementState.placeMark)
        .thenReturn(mockPlaceMark);
  }

  void setupWithMapGuideShow() {
    // Setup state with map guide show
    when(() => currentDoorbellManagementState.mapGuideShow).thenReturn(true);
  }

  void setupWithMapGuideHide() {
    // Setup state with map guide hide
    when(() => currentDoorbellManagementState.mapGuideShow).thenReturn(false);
  }

  void setupWithCurrentGuideKey(String guideKey) {
    // Setup state with current guide key
    when(() => currentDoorbellManagementState.currentGuideKey)
        .thenReturn(guideKey);
  }

  void setupWithSuperTooltipController() {
    // Setup state with super tooltip controller
    when(() => currentDoorbellManagementState.superToolTipController)
        .thenReturn(SuperTooltipController());
  }

  void setupWithRadiusInMeters(double radius) {
    // Setup state with radius in meters
    when(() => currentDoorbellManagementState.radiusInMeters)
        .thenReturn(radius);
  }

  void setupWithBackPressDisabled() {
    // Setup state with back press disabled
    when(() => currentDoorbellManagementState.backPress).thenReturn(false);
  }

  void setupWithProceedButtonDisabled() {
    // Setup state with proceed button disabled
    when(() => currentDoorbellManagementState.proceedButtonEnabled)
        .thenReturn(false);
  }

  void setupWithEmptyLocationName() {
    // Setup state with empty location name
    when(() => currentDoorbellManagementState.locationName).thenReturn("");
  }

  void setupWithEmptyCompanyAddress() {
    // Setup state with empty company address
    when(() => currentDoorbellManagementState.companyAddress).thenReturn("");
  }

  void setupWithEmptyStreetBlockName() {
    // Setup state with empty street block name
    when(() => currentDoorbellManagementState.streetBlockName).thenReturn("");
  }

  void setupWithEmptyCustomDoorbellName() {
    // Setup state with empty custom doorbell name
    when(() => currentDoorbellManagementState.customDoorbellName)
        .thenReturn("");
  }

  void setupWithNullDeviceId() {
    // Setup state with null device ID
    when(() => currentDoorbellManagementState.deviceId).thenReturn(null);
  }

  void setupWithNullSelectedLocation() {
    // Setup state with null selected location
    when(() => currentDoorbellManagementState.selectedLocation)
        .thenReturn(null);
  }

  void setupWithNullPlaceMark() {
    // Setup state with null place mark
    when(() => currentDoorbellManagementState.placeMark).thenReturn(null);
  }

  void setupWithNullCenter() {
    // Setup state with null center
    when(() => currentDoorbellManagementState.center).thenReturn(null);
  }

  void setupWithNullMarkerPosition() {
    // Setup state with null marker position
    when(() => currentDoorbellManagementState.markerPosition).thenReturn(null);
  }

  void setupWithNullDoorbellName() {
    // Setup state with null doorbell name
    when(() => currentDoorbellManagementState.doorbellName).thenReturn(null);
  }

  void dispose() {
    // No stream controller to dispose
  }
}
