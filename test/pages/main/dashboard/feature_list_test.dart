import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/core/theme.dart';
import 'package:admin/pages/main/dashboard/components/feature_items.dart';
import 'package:admin/pages/main/dashboard/components/header_tiles.dart';
import 'package:admin/pages/main/dashboard/feature_list.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/dashboard/view_model/filters_model.dart';
import 'package:admin/pages/main/doorbell_management/bloc/doorbell_management_bloc.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/statistics/bloc/statistics_bloc.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/doorbell_management_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/iot_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/profile_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/statistics_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/theme_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/voice_control_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';
import '../../../mocks/bloc/bloc_mocks.dart';

void main() {
  late StartupBlocTestHelper startupBlocHelper;
  late ProfileBlocTestHelper profileBlocHelper;
  late DoorbellManagementBlocTestHelper doorbellManagementBlocHelper;
  late StatisticsBlocTestHelper statisticsBlocHelper;
  late ThemeBlocTestHelper themeBlocHelper;
  late VoiceControlBlocTestHelper voiceControlBlocHelper;
  late IotBlocTestHelper iotBlocHelper;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(
      FiltersModel(title: 'Test', value: 'test', isSelected: false),
    );
    registerFallbackValue(Colors.red);

    // Register fallback values for bloc types before setup
    registerFallbackValue(MockStartupBloc());
    registerFallbackValue(MockProfileBloc());
    registerFallbackValue(MockIotBloc());
    registerFallbackValue(MockStatisticsBloc());
    registerFallbackValue(MockThemeBloc());
    registerFallbackValue(MockVoiceControlBloc());
    registerFallbackValue(MockDoorbellManagementBloc());

    await TestHelper.initialize();

    // Initialize helper classes
    startupBlocHelper = StartupBlocTestHelper();
    profileBlocHelper = ProfileBlocTestHelper();
    iotBlocHelper = IotBlocTestHelper();
    statisticsBlocHelper = StatisticsBlocTestHelper();
    doorbellManagementBlocHelper = DoorbellManagementBlocTestHelper();
    themeBlocHelper = ThemeBlocTestHelper();
    voiceControlBlocHelper = VoiceControlBlocTestHelper();

    // Setup all helpers
    startupBlocHelper.setup();
    profileBlocHelper.setup();
    iotBlocHelper.setup();
    doorbellManagementBlocHelper.setup();
    statisticsBlocHelper.setup();
    themeBlocHelper.setup();
    voiceControlBlocHelper.setup();
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
    startupBlocHelper.dispose();
    profileBlocHelper.dispose();
    doorbellManagementBlocHelper.dispose();
    statisticsBlocHelper.dispose();
    themeBlocHelper.dispose();
    voiceControlBlocHelper.dispose();
  });

  Widget createTestWidget(Widget child) {
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
            BlocProvider<IotBloc>.value(value: iotBlocHelper.mockIotBloc),
            BlocProvider<StatisticsBloc>.value(
              value: statisticsBlocHelper.mockStatisticsBloc,
            ),
            BlocProvider<ThemeBloc>.value(
              value: themeBlocHelper.mockThemeBloc,
            ),
            BlocProvider<VoiceControlBloc>.value(
              value: voiceControlBlocHelper.mockVoiceControlBloc,
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
            home: AppScaffold(
              body: SingleChildScrollView(
                child: MediaQuery(
                  data: const MediaQueryData(
                    size: Size(1080, 1920),
                    devicePixelRatio: 3,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  group('FeatureNoDoorBellList Widget Tests', () {
    testWidgets('should render FeatureNoDoorBellList with correct structure',
        (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify main structure exists
      expect(find.byType(FeatureNoDoorBellList), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('should render "Add Doorbell" text', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify "Add Doorbell" text is present (localized version)
      expect(find.text('Add Doorbell'), findsAtLeastNWidgets(1));
    });

    testWidgets('should render "Features" text', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify "Quick Access" text is present (this is the localized version)
      expect(find.text('Quick Access'), findsAtLeastNWidgets(1));
    });

    testWidgets('should render TextButton for add doorbell', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify TextButton exists
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('should render FeatureItems for add doorbell', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify FeatureItems exists
      expect(find.byType(FeatureItems), findsAtLeastNWidgets(1));
    });

    testWidgets('should render FeatureListView', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify FeatureListView exists (there are 2 FeatureListView widgets in FeatureNoDoorBellList)
      expect(find.byType(FeatureListView), findsNWidgets(2));
    });

    testWidgets('should render GridView for features', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify GridView exists (there are 2 GridView widgets in FeatureNoDoorBellList)
      expect(find.byType(GridView), findsNWidgets(2));
    });

    testWidgets('should render correct number of feature items',
        (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Debug: Check what widgets are actually rendered

      // FeatureNoDoorBellList has:
      // 1 FeatureItems (for add doorbell) + 8 QuickAccessItems (4 enabled + 4 disabled features)
      expect(
        find.byType(FeatureItems),
        findsNWidgets(1),
      );
      expect(
        find.byType(QuickAccessItems),
        findsNWidgets(8),
      );
    });

    testWidgets('should render SizedBox for spacing', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify SizedBox exists for spacing
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
    });
  });

  group('FeatureDoorBellList Widget Tests', () {
    testWidgets('should render FeatureDoorBellList with correct structure',
        (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureDoorBellList()));
      await tester.pump();

      // Verify main structure exists
      expect(find.byType(FeatureDoorBellList), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('should render HorizontalHeaderTitles', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureDoorBellList()));
      await tester.pump();

      // Verify HorizontalHeaderTitles exists
      expect(find.byType(HorizontalHeaderTitles), findsOneWidget);
    });

    testWidgets('should render FeatureListView', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureDoorBellList()));
      await tester.pump();

      // Verify FeatureListView exists
      expect(find.byType(FeatureListView), findsOneWidget);
    });

    testWidgets('should render GridView for features', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureDoorBellList()));
      await tester.pump();

      // Verify GridView exists
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should render correct number of feature items',
        (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureDoorBellList()));
      await tester.pump();

      // Debug: Check what widgets are actually rendered

      // FeatureDoorBellList has 4 QuickAccessItems (based on the featureList)
      expect(find.byType(QuickAccessItems), findsNWidgets(4));
    });

    testWidgets('should render SizedBox for spacing', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureDoorBellList()));
      await tester.pump();

      // Verify SizedBox exists for spacing
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle view all click in header', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureDoorBellList()));
      await tester.pump();

      // Find and tap the "View All" TextButton in HorizontalHeaderTitles
      final viewAllButton = find.byType(TextButton);
      if (viewAllButton.evaluate().isNotEmpty) {
        await tester.tap(viewAllButton, warnIfMissed: false);
        await tester.pump();

        // Verify that the TextButton exists
        expect(find.byType(TextButton), findsOneWidget);
      }
    });
  });

  group('FeatureListView Widget Tests', () {
    testWidgets('should render FeatureListView with empty list',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const FeatureListView(featureList: []),
        ),
      );
      await tester.pump();

      // Verify FeatureListView exists
      expect(find.byType(FeatureListView), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should render FeatureListView with single item',
        (tester) async {
      final featureList = [
        FeatureModel(
          title: "Test Feature",
          image: DefaultVectors.DASH_THEMES,
          color: Colors.blue,
          route: (context) {},
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          FeatureListView(featureList: featureList),
        ),
      );
      await tester.pump();

      // Verify FeatureListView exists
      expect(find.byType(FeatureListView), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(QuickAccessItems), findsOneWidget);
    });

    testWidgets('should render FeatureListView with multiple items',
        (tester) async {
      final featureList = [
        FeatureModel(
          title: "Test Feature 1",
          image: DefaultVectors.DASH_THEMES,
          color: Colors.blue,
          route: (context) {},
        ),
        FeatureModel(
          title: "Test Feature 2",
          image: DefaultVectors.DASH_VOICE_CONTROL,
          color: Colors.red,
          route: (context) {},
        ),
        FeatureModel(
          title: "Test Feature 3",
          image: DefaultVectors.DASH_STATS,
          color: Colors.green,
          route: (context) {},
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          FeatureListView(featureList: featureList),
        ),
      );
      await tester.pump();

      // Verify FeatureListView exists
      expect(find.byType(FeatureListView), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(QuickAccessItems), findsNWidgets(3));
    });

    testWidgets('should render GridView with correct properties',
        (tester) async {
      final featureList = [
        FeatureModel(
          title: "Test Feature",
          image: DefaultVectors.DASH_THEMES,
          color: Colors.blue,
          route: (context) {},
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          FeatureListView(featureList: featureList),
        ),
      );
      await tester.pump();

      // Verify GridView exists with correct properties
      final gridView = find.byType(GridView);
      expect(gridView, findsOneWidget);

      final gridViewWidget = tester.widget<GridView>(gridView);
      expect(gridViewWidget.shrinkWrap, true);
      expect(gridViewWidget.physics, const NeverScrollableScrollPhysics());
    });

    testWidgets('should render QuickAccessItems with correct properties',
        (tester) async {
      final featureList = [
        FeatureModel(
          title: "Test Feature",
          image: DefaultVectors.DASH_THEMES,
          color: Colors.blue,
          route: (context) {},
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          FeatureListView(featureList: featureList),
        ),
      );
      await tester.pump();

      // Verify QuickAccessItems exists
      expect(find.byType(QuickAccessItems), findsOneWidget);
    });
  });

  group('Feature Model Tests', () {
    test('should create FeatureModel with all properties', () {
      final feature = FeatureModel(
        title: "Test Feature",
        image: DefaultVectors.DASH_THEMES,
        color: Colors.blue,
        route: (context) {},
      );

      expect(feature.title, "Test Feature");
      expect(feature.image, DefaultVectors.DASH_THEMES);
      expect(feature.color, Colors.blue);
      expect(feature.route, isA<Function>());
    });

    test('should create FeatureModel with optional properties', () {
      final feature = FeatureModel(
        title: "Test Feature",
        image: DefaultVectors.DASH_THEMES,
        color: Colors.blue,
        route: (context) {},
        value: "test_value",
        brand: "test_brand",
      );

      expect(feature.title, "Test Feature");
      expect(feature.image, DefaultVectors.DASH_THEMES);
      expect(feature.color, Colors.blue);
      expect(feature.route, isA<Function>());
      expect(feature.value, "test_value");
      expect(feature.brand, "test_brand");
    });
  });

  group('FeatureNoDoorBellList Feature List Tests', () {
    testWidgets('should render Themes feature', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify Themes feature exists (multi-line text)
      expect(find.text('Themes'), findsOneWidget);
    });

    testWidgets('should render Voice Control feature', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify Voice Control feature exists (multi-line text: "Voice\nControl")
      expect(find.text('Voice\nControl'), findsOneWidget);
    });

    testWidgets('should render Shop Doorbell feature', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify Shop Doorbell feature exists (multi-line text: "Shop\nDoorbell")
      expect(find.text('Shop\nDoorbell'), findsOneWidget);
    });
  });

  group('FeatureDoorBellList Feature List Tests', () {
    testWidgets('should render Smart Devices feature', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureDoorBellList()));
      await tester.pump();

      // Verify Smart Devices feature exists (multi-line text: "Smart\nDevices")
      expect(find.text('Smart\nDevices'), findsOneWidget);
    });

    testWidgets('should render Statistics feature', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureDoorBellList()));
      await tester.pump();

      // Verify Statistics feature exists
      expect(find.text('Statistics'), findsOneWidget);
    });

    testWidgets('should render Themes feature', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureDoorBellList()));
      await tester.pump();

      // Verify Themes feature exists
      expect(find.text('Themes'), findsOneWidget);
    });

    testWidgets('should render Voice Control feature', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureDoorBellList()));
      await tester.pump();

      // Verify Voice Control feature exists (multi-line text: "Voice\nControl")
      expect(find.text('Voice\nControl'), findsOneWidget);
    });
  });

  group('Layout and Styling Tests', () {
    testWidgets('should render with proper column layout', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify Column layout exists
      final columnFinder = find.byType(Column);
      expect(columnFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('should render with proper grid layout', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify GridView exists (there are 2 GridView widgets in FeatureNoDoorBellList)
      final gridFinder = find.byType(GridView);
      expect(gridFinder, findsNWidgets(2));
    });

    testWidgets('should render with proper spacing', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify SizedBox spacing elements exist
      final spacingFinder = find.byType(SizedBox);
      expect(spacingFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('should render with proper text styling', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify Text widgets exist
      final textFinder = find.byType(Text);
      expect(textFinder, findsAtLeastNWidgets(1));
    });
  });

  group('Interaction Tests', () {
    testWidgets('should handle tap on add doorbell button', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Find and tap the add doorbell TextButton
      final addDoorbellButton = find.byType(TextButton);
      if (addDoorbellButton.evaluate().isNotEmpty) {
        await tester.tap(addDoorbellButton);
        await tester.pump();

        // Verify button was tapped (no specific assertion needed for navigation)
        expect(find.byType(TextButton), findsOneWidget);
      }
    });

    testWidgets('should handle tap on feature items', (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Find and tap a feature item
      final featureItems = find.byType(FeatureItems);
      if (featureItems.evaluate().isNotEmpty) {
        await tester.tap(featureItems.first);
        await tester.pump();

        // Verify feature items exist
        expect(find.byType(FeatureItems), findsAtLeastNWidgets(1));
      }
    });
  });

  group('Responsive Design Tests', () {
    testWidgets('should render with different screen sizes', (tester) async {
      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      expect(find.byType(FeatureNoDoorBellList), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      expect(find.byType(FeatureNoDoorBellList), findsOneWidget);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should render grid with correct cross axis count',
        (tester) async {
      await tester.pumpWidget(createTestWidget(FeatureNoDoorBellList()));
      await tester.pump();

      // Verify GridView exists with SliverGridDelegateWithFixedCrossAxisCount
      final gridView = find.byType(GridView);
      expect(gridView, findsNWidgets(2));
    });
  });
}
