import 'dart:async';

import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/subscription_location_model.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/bloc/bloc_mocks.dart';

class ProfileBlocTestHelper {
  late MockProfileBloc mockProfileBloc;
  late UserData currentUserData;

  void setup() {
    mockProfileBloc = MockProfileBloc();
    currentUserData = createDefaultUserData();

    when(() => mockProfileBloc.stream).thenAnswer((_) => Stream.value(currentUserData));
    when(() => mockProfileBloc.state).thenReturn(currentUserData);
  }

  UserData createDefaultUserData() {
    return UserData(
      (b) => b
        ..id = 1
        ..name = "Test User"
        ..email = "test@example.com"
        ..phone = "1234567890"
        ..image = "https://example.com/image.jpg"
        ..aiThemeCounter = 0
        ..userRole = "user"
        ..phoneVerified = true
        ..emailVerified = true
        ..canPinned = true
        ..sectionList = ListBuilder<String>([])
        ..selectedDoorBell = (UserDeviceModelBuilder()
          ..id = 1
          ..deviceId = "test_device_1"
          ..callUserId = "test_uuid_1"
          ..name = "Test Doorbell"
          ..locationId = 1
          ..isDefault = 1
          ..isStreaming = 0
          ..doorbellLocations = (DoorbellLocationsBuilder()
            ..id = 1
            ..name = "Test Location"
            ..city = "Test City"
            ..state = "Test State"
            ..country = "Test Country"
            ..latitude = 0.0
            ..longitude = 0.0
            ..createdAt = "2024-01-01"
            ..updatedAt = "2024-01-01"
            ..roles = ListBuilder<String>(["Admin"])
            ..subscription = createDefaultSubscription()))
        ..locations = ListBuilder<DoorbellLocations>([
          DoorbellLocations(
            (b) => b
              ..id = 1
              ..name = "Test Location"
              ..city = "Test City"
              ..state = "Test State"
              ..country = "Test Country"
              ..latitude = 0.0
              ..longitude = 0.0
              ..createdAt = "2024-01-01"
              ..updatedAt = "2024-01-01"
              ..roles = ListBuilder<String>(["Admin"])
              ..subscription = createDefaultSubscription(),
          ),
        ]),
    );
  }

  UserDeviceModel createDefaultDoorBell() {
    return UserDeviceModel(
      (b) => b
        ..id = 1
        ..deviceId = "test_device_1"
        ..callUserId = "test_uuid_1"
        ..name = "Test Doorbell"
        ..locationId = 1
        ..isDefault = 1
        ..isStreaming = 0
        ..doorbellLocations = createDefaultLocation(),
    );
  }

  DoorbellLocationsBuilder createDefaultLocation() {
    return DoorbellLocationsBuilder()
      ..id = 1
      ..name = "Test Location"
      ..city = "Test City"
      ..state = "Test State"
      ..country = "Test Country"
      ..latitude = 0.0
      ..longitude = 0.0
      ..createdAt = "2024-01-01"
      ..updatedAt = "2024-01-01"
      ..roles = ListBuilder<String>(["Admin"])
      ..subscription = createDefaultSubscription();
  }

  SubscriptionLocationModelBuilder createDefaultSubscription() {
    return SubscriptionLocationModelBuilder()
      ..name = "Test Plan"
      ..expiresAt = "2025-12-31T23:59:59Z"
      ..paymentStatus = "active"
      ..subscriptionStatus = "active"
      ..amount = "29.99";
  }

  void setupWithMultipleLocations() {
    currentUserData = UserData(
      (b) => b
        ..id = 1
        ..name = "Test User"
        ..email = "test@example.com"
        ..phone = "1234567890"
        ..image = "https://example.com/image.jpg"
        ..aiThemeCounter = 0
        ..userRole = "user"
        ..phoneVerified = true
        ..emailVerified = true
        ..canPinned = true
        ..sectionList = ListBuilder<String>([])
        ..selectedDoorBell = (UserDeviceModelBuilder()
          ..id = 1
          ..deviceId = "test_device_1"
          ..callUserId = "test_uuid_1"
          ..name = "Test Doorbell"
          ..locationId = 1
          ..isDefault = 1
          ..isStreaming = 0
          ..doorbellLocations = (DoorbellLocationsBuilder()
            ..id = 1
            ..name = "Test Location"
            ..city = "Test City"
            ..state = "Test State"
            ..country = "Test Country"
            ..latitude = 0.0
            ..longitude = 0.0
            ..createdAt = "2024-01-01"
            ..updatedAt = "2024-01-01"
            ..roles = ListBuilder<String>(["Admin"])
            ..subscription = createDefaultSubscription()))
        ..locations = ListBuilder<DoorbellLocations>([
          DoorbellLocations(
            (b) => b
              ..id = 1
              ..name = "Test Location"
              ..city = "Test City"
              ..state = "Test State"
              ..country = "Test Country"
              ..latitude = 0.0
              ..longitude = 0.0
              ..createdAt = "2024-01-01"
              ..updatedAt = "2024-01-01"
              ..roles = ListBuilder<String>(["Admin"])
              ..subscription = createDefaultSubscription(),
          ),
          DoorbellLocations(
            (b) => b
              ..id = 2
              ..name = "Second Location"
              ..city = "Second City"
              ..state = "Second State"
              ..country = "Second Country"
              ..latitude = 1.0
              ..longitude = 1.0
              ..createdAt = "2024-01-02"
              ..updatedAt = "2024-01-02"
              ..roles = ListBuilder<String>(["User"])
              ..subscription = createDefaultSubscription(),
          ),
        ]),
    );
    when(() => mockProfileBloc.state).thenReturn(currentUserData);
  }

  void setupWithMultipleDoorBells() {
    currentUserData = UserData(
      (b) => b
        ..id = 1
        ..name = "Test User"
        ..email = "test@example.com"
        ..phone = "1234567890"
        ..image = "https://example.com/image.jpg"
        ..aiThemeCounter = 0
        ..userRole = "user"
        ..phoneVerified = true
        ..emailVerified = true
        ..canPinned = true
        ..sectionList = ListBuilder<String>([])
        ..selectedDoorBell = (UserDeviceModelBuilder()
          ..id = 1
          ..deviceId = "test_device_1"
          ..callUserId = "test_uuid_1"
          ..name = "Test Doorbell"
          ..locationId = 1
          ..isDefault = 1
          ..isStreaming = 0
          ..doorbellLocations = (DoorbellLocationsBuilder()
            ..id = 1
            ..name = "Test Location"
            ..city = "Test City"
            ..state = "Test State"
            ..country = "Test Country"
            ..latitude = 0.0
            ..longitude = 0.0
            ..createdAt = "2024-01-01"
            ..updatedAt = "2024-01-01"
            ..roles = ListBuilder<String>(["Admin"])
            ..subscription = createDefaultSubscription()))
        ..locations = ListBuilder<DoorbellLocations>([
          DoorbellLocations(
            (b) => b
              ..id = 1
              ..name = "Test Location"
              ..city = "Test City"
              ..state = "Test State"
              ..country = "Test Country"
              ..latitude = 0.0
              ..longitude = 0.0
              ..createdAt = "2024-01-01"
              ..updatedAt = "2024-01-01"
              ..roles = ListBuilder<String>(["Admin"])
              ..subscription = createDefaultSubscription(),
          ),
        ]),
    );
    when(() => mockProfileBloc.state).thenReturn(currentUserData);
  }

  void setupWithoutSelectedDoorBell() {
    currentUserData = UserData(
      (b) => b
        ..id = 1
        ..name = "Test User"
        ..email = "test@example.com"
        ..phone = "1234567890"
        ..image = "https://example.com/image.jpg"
        ..aiThemeCounter = 0
        ..userRole = "user"
        ..phoneVerified = true
        ..emailVerified = true
        ..canPinned = true
        ..sectionList = ListBuilder<String>([])
        ..selectedDoorBell = null
        ..locations = ListBuilder<DoorbellLocations>([]),
    );
    when(() => mockProfileBloc.state).thenReturn(currentUserData);
  }

  void dispose() {
    // No stream controller to dispose
  }
}
