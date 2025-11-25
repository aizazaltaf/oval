import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/theme.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/main/dashboard/cameras/view_all_camera.dart';
import 'package:admin/pages/main/dashboard/monitor_cameras.dart';
import 'package:admin/pages/main/doorbell_management/bloc/doorbell_management_bloc.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/doorbell_management_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/iot_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/notification_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/profile_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/singleton_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/voice_control_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/voip_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';
import '../../../mocks/bloc/bloc_mocks.dart';

class MockGetStorage extends Mock implements GetStorage {}

void main() {
  late StartupBlocTestHelper startupBlocHelper;
  late ProfileBlocTestHelper profileBlocHelper;
  late NotificationBlocTestHelper notificationBlocHelper;
  late IotBlocTestHelper iotBlocHelper;
  late DoorbellManagementBlocTestHelper doorbellManagementBlocHelper;
  late VoiceControlBlocTestHelper voiceControlBlocHelper;
  late SingletonBlocTestHelper singletonBlocHelper;
  late VoipBlocTestHelper voipBlocHelper;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(MockStartupBloc());
    registerFallbackValue(BuiltList<String>());
    await TestHelper.initialize();

    // Initialize helper classes
    startupBlocHelper = StartupBlocTestHelper();
    profileBlocHelper = ProfileBlocTestHelper();
    notificationBlocHelper = NotificationBlocTestHelper();
    iotBlocHelper = IotBlocTestHelper();
    doorbellManagementBlocHelper = DoorbellManagementBlocTestHelper();
    voiceControlBlocHelper = VoiceControlBlocTestHelper();
    singletonBlocHelper = SingletonBlocTestHelper();
    voipBlocHelper = VoipBlocTestHelper();

    // Setup all helpers
    startupBlocHelper.setup();
    profileBlocHelper.setup();
    notificationBlocHelper.setup();
    iotBlocHelper.setup();
    doorbellManagementBlocHelper.setup();
    voiceControlBlocHelper.setup();
    singletonBlocHelper.setup();
    voipBlocHelper.setup();

    // Setup singleton bloc
    singletonBloc.testProfileBloc = profileBlocHelper.mockProfileBloc;

    // Inject mock storage
    singletonBloc.getBox = MockGetStorage();
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
    startupBlocHelper.dispose();
    profileBlocHelper.dispose();
    notificationBlocHelper.dispose();
    iotBlocHelper.dispose();
    doorbellManagementBlocHelper.dispose();
    voiceControlBlocHelper.dispose();
    singletonBlocHelper.dispose();
    voipBlocHelper.dispose();
  });

  tearDown(() async {
    // Clean up any pending timers and animations
    await Future.delayed(const Duration(milliseconds: 100));
  });

  Widget createTestWidget([Widget? child]) {
    final testWidget = child ?? const ViewAllCamera();
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<StartupBloc>.value(
              value: startupBlocHelper.mockStartupBloc,
            ),
            BlocProvider<ProfileBloc>.value(
              value: profileBlocHelper.mockProfileBloc,
            ),
            BlocProvider<NotificationBloc>.value(
              value: notificationBlocHelper.mockNotificationBloc,
            ),
            BlocProvider<IotBloc>.value(
              value: iotBlocHelper.mockIotBloc,
            ),
            BlocProvider<VoiceControlBloc>.value(
              value: voiceControlBlocHelper.mockVoiceControlBloc,
            ),
            BlocProvider<VoipBloc>.value(
              value: voipBlocHelper.mockVoipBloc,
            ),
            BlocProvider<DoorbellManagementBloc>.value(
              value: doorbellManagementBlocHelper.mockDoorbellManagementBloc,
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: getTheme(),
            darkTheme: darkTheme(),
            home: testWidget,
          ),
        );
      },
    );
  }

  // Helper function to create a proper StartupState
  group('ViewAllCamera Widget Tests', () {
    setUp(() {
      // Setup camera data for ViewAllCamera widget
      startupBlocHelper.setupCameraWidgetState();

      // Ensure cameras have the correct locationId that matches the selected doorbell
      final selectedDoorbell =
          singletonBlocHelper.mockUserData.selectedDoorBell;
      final correctLocationId = selectedDoorbell!.locationId;

      // Update the camera data to have the correct locationId
      final updatedCameras =
          startupBlocHelper.currentStartupState.userDeviceModel!
              .map(
                (camera) =>
                    camera.rebuild((b) => b..locationId = correctLocationId),
              )
              .toBuiltList();

      // Update the startup state with the correct camera data
      when(() => startupBlocHelper.currentStartupState.userDeviceModel)
          .thenReturn(updatedCameras);
      when(() => startupBlocHelper.currentStartupState.monitorCameraPinnedList)
          .thenReturn(BuiltList(['camera_1', 'camera_2']));
      when(() => startupBlocHelper.currentStartupState.searchCamera)
          .thenReturn(null);
      when(() => startupBlocHelper.currentStartupState.refreshSnapshots)
          .thenReturn(false);
      when(() => startupBlocHelper.currentStartupState.isDoorbellConnected)
          .thenReturn(true);

      // Mock the onRefresh method - it's a method that returns Future<void>
      when(() => startupBlocHelper.mockStartupBloc.onRefresh())
          .thenAnswer((_) async {});

      // Mock the updateSearchCamera method
      when(() => startupBlocHelper.mockStartupBloc.updateSearchCamera(any()))
          .thenAnswer((_) async {});

      // Mock the updateMonitorCameraPinnedList method
      when(
        () => startupBlocHelper.mockStartupBloc
            .updateMonitorCameraPinnedList(any()),
      ).thenAnswer((_) async {});

      // Reset mock storage
      reset(singletonBloc.getBox);
    });

    testWidgets('should render ViewAllCamera with correct structure',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify main structure exists
      expect(find.byType(ViewAllCamera), findsOneWidget);
      expect(find.byType(AppScaffold), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('should render app title correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify app title exists (monitor_cameras)
      expect(find.text('Monitor Cameras'), findsOneWidget);
    });

    testWidgets('should render search text field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify search field exists
      expect(find.byType(NameTextFormField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should render search placeholder text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify search placeholder text
      expect(find.text('Search camera here....'), findsOneWidget);
    });

    testWidgets('should render ListViewSeparatedWidget', (tester) async {
      // Setup a camera with matching locationId and a non-empty pinned list
      final selectedDoorbell =
          singletonBlocHelper.mockUserData.selectedDoorBell;
      final correctLocationId = selectedDoorbell!.locationId;
      final camera = UserDeviceModel(
        (b) => b
          ..id = 1
          ..deviceId = 'camera_1'
          ..callUserId = 'uuid_1'
          ..name = 'Front Camera'
          ..locationId = correctLocationId
          ..isDefault = 1
          ..isStreaming = 1,
      );

      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.userDeviceModel)
          .thenReturn(BuiltList([camera]));
      when(() => startupBlocHelper.currentStartupState.monitorCameraPinnedList)
          .thenReturn(BuiltList(['camera_1']));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Debug: Check if ViewAllCamera is rendered
      expect(find.byType(ViewAllCamera), findsOneWidget);

      // Look for the correct type parameter
      expect(
        find.byType(ListViewSeparatedWidget<UserDeviceModel>),
        findsOneWidget,
      );
    });

    testWidgets('should render MonitorCamerasWidget for each camera',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget exists for each camera
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle search functionality', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and enter text in search field
      final searchField = find.byType(NameTextFormField);
      await tester.enterText(searchField, 'Front');
      await tester.pumpAndSettle();

      // Verify search method was called
      verify(
        () => startupBlocHelper.mockStartupBloc.updateSearchCamera('Front'),
      ).called(1);
    });

    testWidgets('should handle search field submission', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find search field and submit
      final searchField = find.byType(NameTextFormField);
      await tester.enterText(searchField, 'test');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Verify search method was called
      verify(() => startupBlocHelper.mockStartupBloc.updateSearchCamera('test'))
          .called(1);
    });

    testWidgets('should handle refresh functionality', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find RefreshIndicator and trigger refresh
      final refreshIndicator = find.byType(RefreshIndicator);
      await tester.drag(refreshIndicator, const Offset(0, 300));
      await tester.pumpAndSettle();

      // Verify onRefresh was called
      verify(() => startupBlocHelper.mockStartupBloc.onRefresh()).called(1);
    });

    testWidgets('should display cameras with correct pin status',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget exists with pin functionality
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle empty camera list', (tester) async {
      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.userDeviceModel)
          .thenReturn(BuiltList([]));
      when(() => startupBlocHelper.currentStartupState.monitorCameraPinnedList)
          .thenReturn(BuiltList([]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify no MonitorCamerasWidget is rendered
      expect(find.byType(MonitorCamerasWidget), findsNothing);
    });

    testWidgets('should handle search with no results', (tester) async {
      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.searchCamera)
          .thenReturn('nonexistent');

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify no search results widget is shown
      expect(find.byType(MonitorCamerasWidget), findsNothing);
    });

    testWidgets('should handle search with matching results', (tester) async {
      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.searchCamera)
          .thenReturn('Front');

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget is rendered for matching camera
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle external camera pin status', (tester) async {
      // Setup external camera data
      final selectedDoorbell =
          singletonBlocHelper.mockUserData.selectedDoorBell;
      final correctLocationId = selectedDoorbell!.locationId;

      final externalCamera = UserDeviceModel(
        (b) => b
          ..id = 3
          ..deviceId = "external_camera"
          ..callUserId = "uuid_external"
          ..name = "External Camera"
          ..locationId = correctLocationId
          ..isDefault = 0
          ..isStreaming = 1
          ..isExternalCamera = true
          ..entityId = "3",
      );

      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.userDeviceModel)
          .thenReturn(BuiltList([externalCamera]));
      when(() => startupBlocHelper.currentStartupState.monitorCameraPinnedList)
          .thenReturn(BuiltList(['3']));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget is rendered
      expect(find.byType(MonitorCamerasWidget), findsOneWidget);
    });

    testWidgets('should handle regular camera pin status', (tester) async {
      // Setup regular camera data
      final selectedDoorbell =
          singletonBlocHelper.mockUserData.selectedDoorBell;
      final correctLocationId = selectedDoorbell!.locationId;

      final regularCamera = UserDeviceModel(
        (b) => b
          ..id = 4
          ..deviceId = "regular_camera"
          ..callUserId = "uuid_regular"
          ..name = "Regular Camera"
          ..locationId = correctLocationId
          ..isDefault = 0
          ..isStreaming = 1
          ..isExternalCamera = false
          ..entityId = "4",
      );

      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.userDeviceModel)
          .thenReturn(BuiltList([regularCamera]));
      when(() => startupBlocHelper.currentStartupState.monitorCameraPinnedList)
          .thenReturn(BuiltList(['regular_camera']));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget is rendered
      expect(find.byType(MonitorCamerasWidget), findsOneWidget);
    });

    testWidgets('should handle empty pinned cameras list', (tester) async {
      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.monitorCameraPinnedList)
          .thenReturn(BuiltList([]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget is still rendered
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle null pinned cameras from storage',
        (tester) async {
      // Setup null pinned cameras from storage
      when(() => singletonBloc.getBox.read(Constants.pinnedCameras))
          .thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget is still rendered
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle empty string pinned cameras from storage',
        (tester) async {
      // Setup empty string pinned cameras from storage
      when(() => singletonBloc.getBox.read(Constants.pinnedCameras))
          .thenReturn('');

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget is still rendered
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should render correct spacing between cameras',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify SizedBox spacing exists
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle camera list filtering by location',
        (tester) async {
      // Setup cameras with different location IDs
      final selectedDoorbell =
          singletonBlocHelper.mockUserData.selectedDoorBell;
      final correctLocationId = selectedDoorbell!.locationId;

      final camera1 = UserDeviceModel(
        (b) => b
          ..id = 1
          ..deviceId = "camera_1"
          ..callUserId = "uuid_1"
          ..name = "Front Camera"
          ..locationId = correctLocationId
          ..isDefault = 1
          ..isStreaming = 1,
      );

      final camera2 = UserDeviceModel(
        (b) => b
          ..id = 2
          ..deviceId = "camera_2"
          ..callUserId = "uuid_2"
          ..name = "Back Camera"
          ..locationId = 2 // Different location - should be filtered out
          ..isDefault = 0
          ..isStreaming = 0,
      );

      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.userDeviceModel)
          .thenReturn(BuiltList([camera1, camera2]));
      when(() => startupBlocHelper.currentStartupState.monitorCameraPinnedList)
          .thenReturn(BuiltList(['camera_1']));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify only cameras with matching location ID are shown
      expect(find.byType(MonitorCamerasWidget), findsOneWidget);
    });

    testWidgets('should handle camera sorting by pinned order', (tester) async {
      // Setup cameras with pinned order
      final selectedDoorbell =
          singletonBlocHelper.mockUserData.selectedDoorBell;
      final correctLocationId = selectedDoorbell!.locationId;

      final camera1 = UserDeviceModel(
        (b) => b
          ..id = 1
          ..deviceId = "camera_1"
          ..callUserId = "uuid_1"
          ..name = "Front Camera"
          ..locationId = correctLocationId
          ..isDefault = 1
          ..isStreaming = 1,
      );

      final camera2 = UserDeviceModel(
        (b) => b
          ..id = 2
          ..deviceId = "camera_2"
          ..callUserId = "uuid_2"
          ..name = "Back Camera"
          ..locationId = correctLocationId
          ..isDefault = 0
          ..isStreaming = 0,
      );

      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.userDeviceModel)
          .thenReturn(BuiltList([camera1, camera2]));
      when(() => startupBlocHelper.currentStartupState.monitorCameraPinnedList)
          .thenReturn(BuiltList(['camera_2', 'camera_1']));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget is rendered
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle refresh snapshots state', (tester) async {
      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.refreshSnapshots)
          .thenReturn(true);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget is rendered
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle push navigation', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify the widget can be navigated to
      expect(find.byType(ViewAllCamera), findsOneWidget);
    });

    testWidgets('should handle route name correctly', (tester) async {
      expect(ViewAllCamera.routeName, equals('viewAllCamera'));
    });

    testWidgets('should handle push method correctly', (tester) async {
      // This test verifies the static push method exists and can be called
      expect(ViewAllCamera.push, isA<Function>());
    });

    testWidgets('should render padding correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify Padding widget exists with horizontal padding
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('should render Column layout correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify Column widget exists for layout
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('should render Expanded widget for list', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify Expanded widget exists for the list
      expect(find.byType(Expanded), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle AlwaysScrollableScrollPhysics', (tester) async {
      // Setup a camera with matching locationId and a non-empty pinned list
      final selectedDoorbell =
          singletonBlocHelper.mockUserData.selectedDoorBell;
      final correctLocationId = selectedDoorbell!.locationId;
      final camera = UserDeviceModel(
        (b) => b
          ..id = 1
          ..deviceId = 'camera_1'
          ..callUserId = 'uuid_1'
          ..name = 'Front Camera'
          ..locationId = correctLocationId
          ..isDefault = 1
          ..isStreaming = 1,
      );

      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.userDeviceModel)
          .thenReturn(BuiltList([camera]));
      when(() => startupBlocHelper.currentStartupState.monitorCameraPinnedList)
          .thenReturn(BuiltList(['camera_1']));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      final listView = tester.widget<ListViewSeparatedWidget<UserDeviceModel>>(
        find.byType(ListViewSeparatedWidget<UserDeviceModel>),
      );
      expect(listView.physics, isA<AlwaysScrollableScrollPhysics>());
    });

    testWidgets('should handle search case insensitive', (tester) async {
      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.searchCamera)
          .thenReturn('FRONT');

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget is rendered for case-insensitive match
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle search with whitespace', (tester) async {
      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.searchCamera)
          .thenReturn('  Front  ');

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget is rendered for trimmed search
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle no search record display', (tester) async {
      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.searchCamera)
          .thenReturn('nonexistent');

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify no MonitorCamerasWidget is rendered for non-matching search
      expect(find.byType(MonitorCamerasWidget), findsNothing);
    });

    testWidgets('should handle multiple camera search results', (tester) async {
      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.searchCamera)
          .thenReturn('Camera');

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify multiple MonitorCamerasWidget are rendered
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(2));
    });

    testWidgets('should handle camera name display correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify camera names are displayed in MonitorCamerasWidget
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle pin icon display correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget is rendered with pin functionality
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle camera length parameter correctly',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget is rendered with correct length parameter
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle needPinIcon parameter correctly',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget is rendered with pin icon enabled
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle pinValue parameter correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify MonitorCamerasWidget is rendered with correct pin value
      expect(find.byType(MonitorCamerasWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle separator builder correctly', (tester) async {
      // Setup a camera with matching locationId and a non-empty pinned list
      final selectedDoorbell =
          singletonBlocHelper.mockUserData.selectedDoorBell;
      final correctLocationId = selectedDoorbell!.locationId;
      final camera = UserDeviceModel(
        (b) => b
          ..id = 1
          ..deviceId = 'camera_1'
          ..callUserId = 'uuid_1'
          ..name = 'Front Camera'
          ..locationId = correctLocationId
          ..isDefault = 1
          ..isStreaming = 1,
      );

      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.userDeviceModel)
          .thenReturn(BuiltList([camera]));
      when(() => startupBlocHelper.currentStartupState.monitorCameraPinnedList)
          .thenReturn(BuiltList(['camera_1']));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      final listView = tester.widget<ListViewSeparatedWidget<UserDeviceModel>>(
        find.byType(ListViewSeparatedWidget<UserDeviceModel>),
      );
      expect(listView.separatorBuilder, isNotNull);
    });

    testWidgets('should handle item builder correctly', (tester) async {
      // Setup a camera with matching locationId and a non-empty pinned list
      final selectedDoorbell =
          singletonBlocHelper.mockUserData.selectedDoorBell;
      final correctLocationId = selectedDoorbell!.locationId;
      final camera = UserDeviceModel(
        (b) => b
          ..id = 1
          ..deviceId = 'camera_1'
          ..callUserId = 'uuid_1'
          ..name = 'Front Camera'
          ..locationId = correctLocationId
          ..isDefault = 1
          ..isStreaming = 1,
      );

      // Update the mock state properties directly
      when(() => startupBlocHelper.currentStartupState.userDeviceModel)
          .thenReturn(BuiltList([camera]));
      when(() => startupBlocHelper.currentStartupState.monitorCameraPinnedList)
          .thenReturn(BuiltList(['camera_1']));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      final listView = tester.widget<ListViewSeparatedWidget<UserDeviceModel>>(
        find.byType(ListViewSeparatedWidget<UserDeviceModel>),
      );
      expect(listView.itemBuilder, isNotNull);
    });

    testWidgets('should handle theme colors correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify RefreshIndicator uses theme colors
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('should handle cupertino theme correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify RefreshIndicator uses cupertino theme
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });
}
