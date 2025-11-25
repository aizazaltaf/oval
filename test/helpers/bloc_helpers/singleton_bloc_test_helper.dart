import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/bloc/bloc_mocks.dart';

class MockFlutterTts extends Mock implements FlutterTts {}

class MockGetStorage extends Mock implements GetStorage {}

class SingletonBlocTestHelper {
  late ProfileBloc mockProfileBloc;
  late StartupBloc mockStartupBloc;
  late UserData mockUserData;
  late UserDeviceModel mockSelectedDoorBell;
  late MockFlutterTts mockTextToSpeech;
  late MockGetStorage mockGetStorage;

  void setup() {
    mockProfileBloc = MockProfileBloc();
    mockStartupBloc = MockStartupBloc();
    mockTextToSpeech = MockFlutterTts();
    mockGetStorage = MockGetStorage();
    mockSelectedDoorBell = createDefaultDoorBell();
    mockUserData = createDefaultUserData();

    // Setup the profile bloc state
    when(() => mockProfileBloc.state).thenReturn(mockUserData);

    // Setup textToSpeech mock to prevent timer creation
    when(() => mockTextToSpeech.stop()).thenAnswer((_) async {});

    // Setup GetStorage mock to prevent timer creation
    when(() => mockGetStorage.read(any())).thenReturn(null);
    when(() => mockGetStorage.write(any(), any())).thenAnswer((_) async {});
    when(() => mockGetStorage.remove(any())).thenAnswer((_) async {});
    when(() => mockGetStorage.erase()).thenAnswer((_) async {});
    when(() => mockGetStorage.hasData(any())).thenReturn(false);

    // Set the test profile bloc, textToSpeech, and getBox in singleton
    singletonBloc.testProfileBloc = mockProfileBloc;
    singletonBloc.testTextToSpeech = mockTextToSpeech;
    singletonBloc.getBox = mockGetStorage;
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
        ..isStreaming = 1
        ..isExternalCamera = false
        ..entityId = "1"
        ..image = "https://example.com/image.jpg"
        ..doorbellLocations.replace(createDefaultLocation()),
    );
  }

  DoorbellLocations createDefaultLocation() {
    return DoorbellLocations(
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
        ..roles = ListBuilder<String>(["Admin"]),
    );
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
        ..selectedDoorBell.replace(mockSelectedDoorBell)
        ..locations = ListBuilder<DoorbellLocations>([
          createDefaultLocation(),
        ]),
    );
  }

  void setupWithMultipleCameras() {
    final camera1 = UserDeviceModel(
      (b) => b
        ..id = 1
        ..deviceId = "camera_1"
        ..callUserId = "uuid_1"
        ..name = "Front Camera"
        ..locationId = 1
        ..isDefault = 1
        ..isStreaming = 1
        ..isExternalCamera = false
        ..entityId = "1"
        ..image = "https://example.com/camera1.jpg",
    );

    mockSelectedDoorBell = camera1;
    mockUserData = createDefaultUserData();
    when(() => mockProfileBloc.state).thenReturn(mockUserData);
  }

  void setupWithOfflineCameras() {
    final offlineCamera = UserDeviceModel(
      (b) => b
        ..id = 1
        ..deviceId = "offline_camera"
        ..callUserId = "uuid_offline"
        ..name = "Offline Camera"
        ..locationId = 1
        ..isDefault = 1
        ..isStreaming = 0
        ..isExternalCamera = false
        ..entityId = "1"
        ..image = "https://example.com/offline.jpg",
    );

    mockSelectedDoorBell = offlineCamera;
    mockUserData = createDefaultUserData();
    when(() => mockProfileBloc.state).thenReturn(mockUserData);
  }

  void dispose() {
    // Reset the singleton bloc
    singletonBloc.testProfileBloc = ProfileBloc();
  }
}
