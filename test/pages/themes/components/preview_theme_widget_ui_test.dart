import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/preview_theme_widget.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/singleton_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/theme_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';
import '../../../mocks/bloc/bloc_mocks.dart';
import '../../../mocks/bloc/state_mocks.dart';

void main() {
  late ThemeBlocTestHelper themeBlocHelper;
  late SingletonBlocTestHelper singletonBlocHelper;
  late MockProfileBloc mockProfileBloc;
  late UserData mockUserData;
  late MockThemeBloc mockThemeBloc;
  late MockThemeState mockThemeState;

  // Sample doorbell data for testing
  late UserDeviceModel testDoorbell;
  late UserDeviceModel testDoorbellWithLongName;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(MockStartupBloc());
    registerFallbackValue(Colors.red);
    await TestHelper.initialize();

    // Initialize helper classes
    themeBlocHelper = ThemeBlocTestHelper();
    singletonBlocHelper = SingletonBlocTestHelper();

    // Setup all helpers
    themeBlocHelper.setup();
    singletonBlocHelper.setup();

    // Setup profile bloc mock
    mockProfileBloc = MockProfileBloc();

    mockThemeBloc = themeBlocHelper.getMockThemeBloc();
    mockThemeState = MockThemeState();

    // Setup default theme state
    when(() => mockThemeState.themeNameField).thenReturn('Test Theme');
    when(() => mockThemeState.categorySelectedValue).thenReturn('Nature');
    when(() => mockThemeState.uploadOnDoorBell).thenReturn(false);
    when(() => mockThemeState.selectedDoorBell).thenReturn(null);

    // Set the state on the mock bloc using the setter
    mockThemeBloc.state = mockThemeState;

    mockUserData = UserData(
      (b) => b
        ..id = 1
        ..name = "Test User"
        ..email = "test@example.com"
        ..phone = "1234567890"
        ..aiThemeCounter = 5
        ..userRole = "user"
        ..phoneVerified = true
        ..emailVerified = true
        ..canPinned = true
        ..sectionList = ListBuilder<String>([])
        ..selectedDoorBell = null
        ..locations = ListBuilder([]),
    );

    when(() => mockProfileBloc.state).thenReturn(mockUserData);
    // when(() => mockStartupBloc.state).thenReturn(StartupState());

    // Set the test profile bloc in singleton
    singletonBloc.testProfileBloc = mockProfileBloc;

    // Create test doorbell data
    testDoorbell = UserDeviceModel(
      (b) => b
        ..id = 1
        ..deviceId = "device_001"
        ..entityId = "entity_001"
        ..locationId = 1
        ..roomId = 1
        ..isStreaming = 0
        ..deviceToken = "token_001"
        ..callUserId = "uuid_001"
        ..image = "https://example.com/doorbell.jpg"
        ..name = "Front Door"
        ..isExternalCamera = false
        ..isDefault = 1
        ..details = "Front door camera",
    );

    testDoorbellWithLongName = UserDeviceModel(
      (b) => b
        ..id = 2
        ..deviceId = "device_002"
        ..entityId = "entity_002"
        ..locationId = 2
        ..roomId = 2
        ..isStreaming = 0
        ..deviceToken = "token_002"
        ..callUserId = "uuid_002"
        ..image = "https://example.com/doorbell2.jpg"
        ..name = "Very Long Doorbell Name That Should Be Displayed Properly"
        ..isExternalCamera = false
        ..isDefault = 0
        ..details = "Backyard camera with very long name",
    );
  });

  // setUp(() {
  //   // Get fresh mocks for each test
  //
  // });

  tearDownAll(() async {
    await TestHelper.cleanup();
  });

  Widget createTestWidget({
    UserDeviceModel? selectedDoorBell,
    String themeName = 'Test Theme',
    String category = 'Nature',
    bool uploadOnDoorBell = false,
    UserDeviceModel? stateDoorBell,
  }) {
    // Create a new mock state for this test
    final testState = MockThemeState();

    // Set up all required fields
    when(() => testState.themeNameField).thenReturn(themeName);
    when(() => testState.categorySelectedValue).thenReturn(category);
    when(() => testState.uploadOnDoorBell).thenReturn(uploadOnDoorBell);
    when(() => testState.selectedDoorBell).thenReturn(stateDoorBell);

    // Set default values for other required fields
    when(() => testState.activeType).thenReturn('Feed');
    when(() => testState.canPop).thenReturn(true);
    when(() => testState.isDetailThemePage).thenReturn(false);
    when(() => testState.search).thenReturn('');
    when(() => testState.aiError).thenReturn('');
    when(() => testState.aiThemeText).thenReturn('');
    when(() => testState.simpleThemesError).thenReturn('');
    when(() => testState.generatedImage).thenReturn(null);
    when(() => testState.themeId).thenReturn(null);
    when(() => testState.categoryId).thenReturn(null);
    when(() => testState.apiCategoryId).thenReturn(null);
    when(() => testState.index).thenReturn(0);

    // Set the state on the mock bloc
    mockThemeBloc.state = testState;

    return MaterialApp(
      home: BlocProvider<ThemeBloc>(
        create: (context) => mockThemeBloc,
        child: Scaffold(
          body: PreviewThemeWidget(selectedDoorBell: selectedDoorBell),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      builder: (context, child) {
        return FlutterSizer(
          builder: (context, orientation, screenType) {
            return child!;
          },
        );
      },
    );
  }

  group('PreviewThemeWidget UI Tests', () {
    testWidgets('should display all required sections with default values',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify all section headers are displayed
      expect(find.text('Theme Name'), findsOneWidget);
      expect(find.text('Theme Category'), findsOneWidget);
      expect(find.text('Apply on doorbell'), findsOneWidget);

      // Verify default values are displayed
      expect(find.text('Test Theme'), findsOneWidget);
      expect(find.text('Nature'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('should display theme name correctly', (tester) async {
      const testThemeName = 'My Custom AI Theme';
      await tester.pumpWidget(createTestWidget(themeName: testThemeName));
      await tester.pumpAndSettle();

      expect(find.text('Theme Name'), findsOneWidget);
      expect(find.text(testThemeName), findsOneWidget);
    });

    testWidgets('should display empty theme name correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(themeName: ''));
      await tester.pumpAndSettle();

      expect(find.text('Theme Name'), findsOneWidget);
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('should display theme name with whitespace correctly',
        (tester) async {
      const testThemeName = '  Theme with spaces  ';
      await tester.pumpWidget(createTestWidget(themeName: testThemeName));
      await tester.pumpAndSettle();

      expect(find.text('Theme Name'), findsOneWidget);
      expect(find.text(testThemeName.trim()), findsOneWidget);
    });

    testWidgets('should display category correctly', (tester) async {
      const testCategory = 'Technology';
      await tester.pumpWidget(createTestWidget(category: testCategory));
      await tester.pumpAndSettle();

      expect(find.text('Theme Category'), findsOneWidget);
      expect(find.text(testCategory), findsOneWidget);
    });

    testWidgets('should display null category as empty string', (tester) async {
      await tester.pumpWidget(createTestWidget(category: ''));
      await tester.pumpAndSettle();

      expect(find.text('Theme Category'), findsOneWidget);
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('should display upload on doorbell as No when false',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Apply on doorbell'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets(
        'should display upload on doorbell as Yes when true without doorbell',
        (tester) async {
      await tester.pumpWidget(createTestWidget(uploadOnDoorBell: true));
      await tester.pumpAndSettle();

      expect(find.text('Apply on doorbell'), findsOneWidget);
      expect(find.text('Yes '), findsOneWidget);
    });

    testWidgets(
        'should display upload on doorbell as Yes with doorbell name when selectedDoorBell is provided',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          uploadOnDoorBell: true,
          selectedDoorBell: testDoorbell,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Apply on doorbell'), findsOneWidget);
      expect(find.text('Yes  (Front Door)'), findsOneWidget);
    });

    testWidgets(
        'should display upload on doorbell as Yes with long doorbell name',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          uploadOnDoorBell: true,
          selectedDoorBell: testDoorbellWithLongName,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Apply on doorbell'), findsOneWidget);
      expect(
        find.text(
          'Yes  (Very Long Doorbell Name That Should Be Displayed Properly)',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'should display upload on doorbell as Yes when state has doorbell but no selectedDoorBell param',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          uploadOnDoorBell: true,
          stateDoorBell: testDoorbell,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Apply on doorbell'), findsOneWidget);
      expect(find.text('Yes '), findsOneWidget);
    });

    testWidgets(
        'should prioritize selectedDoorBell parameter over state doorbell',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          uploadOnDoorBell: true,
          selectedDoorBell: testDoorbell,
          stateDoorBell: testDoorbellWithLongName,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Apply on doorbell'), findsOneWidget);
      expect(find.text('Yes  (Front Door)'), findsOneWidget);
    });

    testWidgets('should handle null selectedDoorBell parameter gracefully',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Apply on doorbell'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('should display all text with correct styling', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find all Text widgets
      final textWidgets = find.byType(Text);
      expect(textWidgets, findsNWidgets(6)); // 3 headers + 3 values

      // Verify all required text elements are present
      expect(find.text('Theme Name'), findsOneWidget);
      expect(find.text('Theme Category'), findsOneWidget);
      expect(find.text('Apply on doorbell'), findsOneWidget);
      expect(find.text('Test Theme'), findsOneWidget);
      expect(find.text('Nature'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('should maintain proper spacing between sections',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify SizedBox widgets are present for spacing
      final sizedBoxes = find.byType(SizedBox);
      expect(
        sizedBoxes,
        findsNWidgets(2),
      ); // 2 spacing widgets between 3 sections

      // Verify the height of spacing widgets - check each SizedBox individually
      final sizedBox1 = sizedBoxes.at(0);
      final sizedBox2 = sizedBoxes.at(1);

      final sizedBoxWidget1 = tester.widget<SizedBox>(sizedBox1);
      final sizedBoxWidget2 = tester.widget<SizedBox>(sizedBox2);

      expect(sizedBoxWidget1.height, equals(20));
      expect(sizedBoxWidget2.height, equals(20));
    });

    testWidgets('should use CrossAxisAlignment.stretch for proper layout',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the main Column widget
      final columnFinder = find.byType(Column);
      expect(columnFinder, findsOneWidget);

      final columnWidget = tester.widget<Column>(columnFinder);
      expect(
        columnWidget.crossAxisAlignment,
        equals(CrossAxisAlignment.stretch),
      );
    });

    testWidgets('should handle very long theme names without breaking layout',
        (tester) async {
      const longThemeName =
          'This is a very long theme name that should be handled properly by the UI without causing any layout issues or text overflow problems';
      await tester.pumpWidget(createTestWidget(themeName: longThemeName));
      await tester.pumpAndSettle();

      expect(find.text('Theme Name'), findsOneWidget);
      expect(find.text(longThemeName.trim()), findsOneWidget);
    });

    testWidgets(
        'should handle very long category names without breaking layout',
        (tester) async {
      const longCategoryName =
          'This is a very long category name that should be handled properly by the UI without causing any layout issues or text overflow problems';
      await tester.pumpWidget(createTestWidget(category: longCategoryName));
      await tester.pumpAndSettle();

      expect(find.text('Theme Category'), findsOneWidget);
      expect(find.text(longCategoryName), findsOneWidget);
    });

    testWidgets('should handle special characters in theme name',
        (tester) async {
      const specialThemeName =
          'Theme with special chars: !@#\$%^&*()_+-=[]{}|;:,.<>?';
      await tester.pumpWidget(createTestWidget(themeName: specialThemeName));
      await tester.pumpAndSettle();

      expect(find.text('Theme Name'), findsOneWidget);
      expect(find.text(specialThemeName.trim()), findsOneWidget);
    });

    testWidgets('should handle special characters in category name',
        (tester) async {
      const specialCategoryName =
          'Category with special chars: !@#\$%^&*()_+-=[]{}|;:,.<>?';
      await tester.pumpWidget(createTestWidget(category: specialCategoryName));
      await tester.pumpAndSettle();

      expect(find.text('Theme Category'), findsOneWidget);
      expect(find.text(specialCategoryName), findsOneWidget);
    });

    testWidgets('should handle empty strings for all fields', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeName: '',
          category: '',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Theme Name'), findsOneWidget);
      expect(find.text(''), findsNWidgets(2)); // theme name and category
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('should handle whitespace-only strings for all fields',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeName: '   ',
          category: '  ',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Theme Name'), findsOneWidget);
      expect(find.text(''), findsOneWidget); // trimmed theme name
      expect(
        find.text('  '),
        findsOneWidget,
      ); // untrimmed category (two spaces)
      expect(find.text('No'), findsOneWidget);
    });
  });
}
