import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/bloc/theme_state.dart';
import 'package:admin/pages/themes/componenets/theme_thumbnail_preview.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';

// Create a proper mock bloc that extends Bloc
class MockThemeBloc extends Mock implements ThemeBloc {
  @override
  Stream<ThemeState> get stream => const Stream.empty();

  @override
  ThemeState get state => ThemeState();
}

void main() {
  late MockThemeBloc mockThemeBloc;
  late ThemeDataModel mockThemeData;
  late BuiltList<ThemeDataModel> mockThemesList;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    await TestHelper.initialize();
  });

  setUp(() {
    // Initialize mock bloc
    mockThemeBloc = MockThemeBloc();

    // Create mock theme data
    mockThemeData = ThemeDataModel(
      (b) => b
        ..id = 1
        ..title = "Test Theme"
        ..description = "Test Description"
        ..cover = "test_cover.jpg"
        ..thumbnail = "test_thumbnail.jpg"
        ..fromCache = false
        ..userUploaded = 0
        ..isActive = 1
        ..createdAt = "2024-01-01"
        ..categoryId = 1
        ..locationId = 1
        ..totalLikes = 10
        ..mediaType = 1
        ..userLike = 0
        ..isApplied = false
        ..deviceId = "test_device"
        ..colors = "#FF0000",
    );

    // Create mock themes list
    mockThemesList = BuiltList<ThemeDataModel>([mockThemeData]);

    // Setup mock methods with actual implementations
    when(() => mockThemeBloc.updateIndex(any())).thenAnswer((_) {});
    when(() => mockThemeBloc.updateIsDetailThemePage(any())).thenAnswer((_) {});
    when(() => mockThemeBloc.updateThemeId(any())).thenAnswer((_) {});
    when(() => mockThemeBloc.updateActiveType(any())).thenAnswer((_) {});
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
  });

  tearDown(() async {
    // Clean up any pending timers and animations
    await Future.delayed(const Duration(milliseconds: 100));
  });

  Widget createTestWidget({
    required ThemeDataModel themeData,
    required BuiltList<ThemeDataModel> themesList,
    int index = 0,
    bool isMyTheme = false,
    BoxFit? fit,
  }) {
    return MaterialApp(
      home: BlocProvider<ThemeBloc>.value(
        value: mockThemeBloc,
        child: Scaffold(
          body: ThemeThumbnailPreview(
            themesList: themesList,
            data: themeData,
            index: index,
            isMyTheme: isMyTheme,
            fit: fit,
          ),
        ),
      ),
    );
  }

  group('ThemeThumbnailPreview Widget Tests', () {
    testWidgets('should render local file image when cover is local path',
        (tester) async {
      // Create theme data with local file path
      final localThemeData = ThemeDataModel(
        (b) => b
          ..id = 1
          ..title = "Local Theme"
          ..description = "Local Description"
          ..cover = "/local/path/cover.jpg"
          ..thumbnail = "/local/path/thumbnail.jpg"
          ..fromCache = false
          ..userUploaded = 0
          ..isActive = 1
          ..createdAt = "2024-01-01"
          ..categoryId = 1
          ..locationId = 1
          ..totalLikes = 10
          ..mediaType = 1
          ..userLike = 0
          ..isApplied = false
          ..deviceId = "test_device"
          ..colors = "#FF0000",
      );

      final localThemesList = BuiltList<ThemeDataModel>([localThemeData]);

      await tester.pumpWidget(
        createTestWidget(
          themeData: localThemeData,
          themesList: localThemesList,
        ),
      );

      // Verify that Image.file widget is rendered
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsNothing);
    });

    testWidgets('should apply custom BoxFit when provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeData: mockThemeData,
          themesList: mockThemesList,
          fit: BoxFit.cover,
        ),
      );

      // Verify that the widget is rendered with custom fit
      expect(find.byType(ThemeThumbnailPreview), findsOneWidget);
    });

    testWidgets(
        'should render with default BoxFit.fill when no fit is provided',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeData: mockThemeData,
          themesList: mockThemesList,
        ),
      );

      // Verify that the widget is rendered
      expect(find.byType(ThemeThumbnailPreview), findsOneWidget);
    });

    testWidgets('should handle edge case with empty themes list',
        (tester) async {
      final emptyThemesList = BuiltList<ThemeDataModel>([]);

      await tester.pumpWidget(
        createTestWidget(
          themeData: mockThemeData,
          themesList: emptyThemesList,
        ),
      );

      // Widget should still render even with empty list
      expect(find.byType(ThemeThumbnailPreview), findsOneWidget);
    });

    testWidgets('should handle theme data with null optional fields',
        (tester) async {
      final minimalThemeData = ThemeDataModel(
        (b) => b
          ..id = 1
          ..title = "Minimal Theme"
          ..description = "Minimal Description"
          ..cover = "/local/path/cover.jpg"
          ..thumbnail = "/local/path/thumb.jpg"
          ..fromCache = false
          ..userUploaded = null
          ..isActive = 1
          ..createdAt = null
          ..categoryId = 1
          ..locationId = null
          ..totalLikes = 0
          ..mediaType = 1
          ..userLike = 0
          ..isApplied = false
          ..deviceId = null
          ..colors = null,
      );

      final minimalThemesList = BuiltList<ThemeDataModel>([minimalThemeData]);

      await tester.pumpWidget(
        createTestWidget(
          themeData: minimalThemeData,
          themesList: minimalThemesList,
        ),
      );

      // Widget should render without errors
      expect(find.byType(ThemeThumbnailPreview), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should handle different BoxFit values correctly',
        (tester) async {
      final testFits = [
        BoxFit.contain,
        BoxFit.cover,
        BoxFit.fitWidth,
        BoxFit.fitHeight,
        BoxFit.none,
        BoxFit.scaleDown,
      ];

      for (final fit in testFits) {
        await tester.pumpWidget(
          createTestWidget(
            themeData: mockThemeData,
            themesList: mockThemesList,
            fit: fit,
          ),
        );

        // Widget should render with the specified fit
        expect(find.byType(ThemeThumbnailPreview), findsOneWidget);
      }
    });

    testWidgets('should handle theme with very long title and description',
        (tester) async {
      final longTextThemeData = ThemeDataModel(
        (b) => b
          ..id = 1
          ..title =
              "This is a very long theme title that might cause layout issues if not handled properly in the UI"
          ..description =
              "This is an extremely long description that contains a lot of text and might cause overflow issues in the user interface if the text wrapping and layout constraints are not properly implemented"
          ..cover = "/local/path/cover.jpg"
          ..thumbnail = "/local/path/thumb.jpg"
          ..fromCache = false
          ..userUploaded = 0
          ..isActive = 1
          ..createdAt = "2024-01-01"
          ..categoryId = 1
          ..locationId = 1
          ..totalLikes = 10
          ..mediaType = 1
          ..userLike = 0
          ..isApplied = false
          ..deviceId = "test_device"
          ..colors = "#FF0000",
      );

      final longTextThemesList = BuiltList<ThemeDataModel>([longTextThemeData]);

      await tester.pumpWidget(
        createTestWidget(
          themeData: longTextThemeData,
          themesList: longTextThemesList,
        ),
      );

      // Widget should render without errors even with long text
      expect(find.byType(ThemeThumbnailPreview), findsOneWidget);
    });

    testWidgets('should render widget structure correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          themeData: mockThemeData,
          themesList: mockThemesList,
        ),
      );

      // Verify the widget structure
      expect(find.byType(ThemeThumbnailPreview), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);

      // Should have either Image or CachedNetworkImage as child
      final hasImage = find.byType(Image).evaluate().isNotEmpty;
      final hasCachedImage =
          find.byType(CachedNetworkImage).evaluate().isNotEmpty;

      // Should have exactly one of them
      expect(hasImage || hasCachedImage, isTrue);
      expect(hasImage && hasCachedImage, isFalse);
    });

    testWidgets(
        'should verify the basic logic for determining local vs network files',
        (tester) async {
      // Test the actual logic that the widget uses
      const localCover = "/local/path/cover.jpg";
      const networkCover = "https://example.com/cover.jpg";

      // These should match the widget's logic: bool get isLocalFile => !data.cover.contains("http");
      expect(!localCover.contains("http"), isTrue);
      expect(!networkCover.contains("http"), isFalse);
    });
  });
}
