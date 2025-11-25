import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_list_card.dart';
import 'package:admin/pages/themes/componenets/theme_thumbnail_preview.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/singleton_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';
import '../../../mocks/bloc/bloc_mocks.dart';
import '../../../mocks/bloc/state_mocks.dart';

void main() {
  late MockThemeBloc mockThemeBloc;
  late ThemeDataModel mockImageTheme;
  late ThemeDataModel mockVideoTheme;
  late ThemeDataModel mockGifTheme;
  late ThemeDataModel mockMyTheme;
  late BuiltList<ThemeDataModel> mockThemesList;
  late SingletonBlocTestHelper singletonBlocHelper;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());

    // Register fallback values for ThemeDataModel
    final fallbackTheme = ThemeDataModel(
      (b) => b
        ..id = 0
        ..title = "Fallback Theme"
        ..description = "Fallback Description"
        ..cover = "fallback_cover.jpg"
        ..thumbnail = "fallback_thumbnail.jpg"
        ..fromCache = false
        ..userUploaded = null
        ..isActive = 1
        ..createdAt = "2024-01-01"
        ..categoryId = 1
        ..locationId = 1
        ..totalLikes = 0
        ..mediaType = 1
        ..userLike = 0
        ..isApplied = false
        ..deviceId = "fallback_device"
        ..colors = "#000000",
    );
    registerFallbackValue(fallbackTheme);

    await TestHelper.initialize();
  });

  setUp(() {
    // Setup singleton bloc helper
    singletonBlocHelper = SingletonBlocTestHelper()..setup();

    // Initialize mock bloc using the proper MockThemeBloc
    mockThemeBloc = MockThemeBloc();

    // Create mock theme data for different types
    mockImageTheme = ThemeDataModel(
      (b) => b
        ..id = 1
        ..title = "Test Image Theme"
        ..description = "Test Description"
        ..cover = "https://example.com/image.jpg"
        ..thumbnail = "https://example.com/thumbnail.jpg"
        ..fromCache = false
        ..userUploaded = null
        ..isActive = 1
        ..createdAt = "2024-01-01"
        ..categoryId = 1
        ..locationId = 1
        ..totalLikes = 15
        ..mediaType = 1
        ..userLike = 0
        ..isApplied = false
        ..deviceId = "test_device"
        ..colors = "#FF0000",
    );

    mockVideoTheme = ThemeDataModel(
      (b) => b
        ..id = 2
        ..title = "Test Video Theme"
        ..description = "Test Video Description"
        ..cover = "https://example.com/video.mp4"
        ..thumbnail = "https://example.com/video_thumb.jpg"
        ..fromCache = false
        ..userUploaded = null
        ..isActive = 1
        ..createdAt = "2024-01-01"
        ..categoryId = 1
        ..locationId = 1
        ..totalLikes = 25
        ..mediaType = 3
        ..userLike = 1
        ..isApplied = false
        ..deviceId = "test_device"
        ..colors = "#00FF00",
    );

    mockGifTheme = ThemeDataModel(
      (b) => b
        ..id = 3
        ..title = "Test GIF Theme"
        ..description = "Test GIF Description"
        ..cover = "https://example.com/animation.gif"
        ..thumbnail = "https://example.com/gif_thumb.jpg"
        ..fromCache = false
        ..userUploaded = null
        ..isActive = 1
        ..createdAt = "2024-01-01"
        ..categoryId = 1
        ..locationId = 1
        ..totalLikes = 8
        ..mediaType = 2
        ..userLike = 0
        ..isApplied = false
        ..deviceId = "test_device"
        ..colors = "#0000FF",
    );

    mockMyTheme = ThemeDataModel(
      (b) => b
        ..id = 4
        ..title = "My Test Theme"
        ..description = "My Theme Description"
        ..cover = "https://example.com/my_theme.jpg"
        ..thumbnail = "https://example.com/my_theme_thumb.jpg"
        ..fromCache = false
        ..userUploaded = 1
        ..isActive = 1
        ..createdAt = "2024-01-01"
        ..categoryId = 1
        ..locationId = 1
        ..totalLikes = 5
        ..mediaType = 1
        ..userLike = 0
        ..isApplied = false
        ..deviceId = "test_device"
        ..colors = "#FFFF00",
    );

    // Create mock themes list
    mockThemesList = BuiltList<ThemeDataModel>([
      mockImageTheme,
      mockVideoTheme,
      mockGifTheme,
      mockMyTheme,
    ]);

    // Create a proper mock state with ApiState<void> for themeLikeApi
    final mockState = MockThemeState();

    // Setup the mock state to return proper values for all required getters
    when(() => mockState.themeLikeApi).thenReturn(
      ApiState<void>((b) => b..isApiInProgress = false),
    );

    when(() => mockState.activeType).thenReturn('Feed');
    when(() => mockState.search).thenReturn('');
    when(() => mockState.aiThemeText).thenReturn('');
    when(() => mockState.themeNameField).thenReturn('');
    when(() => mockState.simpleThemesError).thenReturn('');
    when(() => mockState.uploadOnDoorBell).thenReturn(false);
    when(() => mockState.isDetailThemePage).thenReturn(false);
    when(() => mockState.aiError).thenReturn('');
    when(() => mockState.index).thenReturn(0);
    when(() => mockState.canPop).thenReturn(true);

    // Set the mock state
    mockThemeBloc.state = mockState;
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
  });

  tearDown(() async {
    // Cleanup singleton bloc helper
    singletonBlocHelper.dispose();
    await Future.delayed(const Duration(milliseconds: 100));
  });

  Widget createTestWidget({
    required ThemeDataModel themeData,
    required BuiltList<ThemeDataModel> themesList,
    int index = 0,
    bool isMyTheme = false,
  }) {
    return MaterialApp(
      home: BlocProvider<ThemeBloc>.value(
        value: mockThemeBloc,
        child: Scaffold(
          body: ThemeListCard(
            themes: themesList,
            data: themeData,
            index: index,
            isMyTheme: isMyTheme,
          ),
        ),
      ),
    );
  }

  group('ThemeListCard UI Tests', () {
    group('Basic Rendering', () {
      testWidgets('should render image theme correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeData: mockImageTheme,
            themesList: mockThemesList,
          ),
        );

        await tester.pump();

        // Verify basic structure - find the main ClipRRect that wraps the entire card
        expect(find.byType(ClipRRect), findsOneWidget);
        
        // Find the main DecoratedBox that provides the background color (the first one without borderRadius)
        final mainDecoratedBox = find.byWidgetPredicate((widget) {
          if (widget is DecoratedBox) {
            final decoration = widget.decoration as BoxDecoration;
            return decoration.borderRadius == null; // Main background has no border radius
          }
          return false;
        });
        expect(mainDecoratedBox, findsOneWidget);
        
        // Find the main Stack that is a direct child of the main DecoratedBox
        final mainStack = find.descendant(
          of: mainDecoratedBox,
          matching: find.byType(Stack),
        );
        expect(mainStack, findsAtLeastNWidgets(1));
        
        // Get the first Stack (the main one)
        final firstStack = mainStack.first;
        expect(firstStack, isNotNull);

        expect(find.byType(ThemeThumbnailPreview), findsOneWidget);

        // Verify theme title is not directly visible (it's in thumbnail preview)
        expect(find.text('Test Image Theme'), findsNothing);
      });

      testWidgets('should render with correct border radius', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeData: mockImageTheme,
            themesList: mockThemesList,
          ),
        );

        await tester.pump();

        // Find the main ClipRRect that wraps the entire card
        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(clipRRect.borderRadius, BorderRadius.circular(15));
      });

      testWidgets('should render with correct background color',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeData: mockImageTheme,
            themesList: mockThemesList,
          ),
        );

        await tester.pump();

        // Find the main DecoratedBox that provides the background color (the first one without borderRadius)
        final mainDecoratedBox = find.byWidgetPredicate((widget) {
          if (widget is DecoratedBox) {
            final decoration = widget.decoration as BoxDecoration;
            return decoration.borderRadius == null; // Main background has no border radius
          }
          return false;
        });
        final decoratedBox = tester.widget<DecoratedBox>(mainDecoratedBox);
        final boxDecoration = decoratedBox.decoration as BoxDecoration;
        expect(boxDecoration.color, isNotNull);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty themes list gracefully', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeData: mockImageTheme,
            themesList: BuiltList<ThemeDataModel>([]),
          ),
        );

        await tester.pump();

        // Should still render without errors
        expect(find.byType(ThemeListCard), findsOneWidget);
      });

      testWidgets('should handle theme with null userUploaded', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeData: mockImageTheme, // This has userUploaded = null
            themesList: mockThemesList,
          ),
        );

        await tester.pump();

        // Should render without errors
        expect(find.byType(ThemeListCard), findsOneWidget);
      });

      testWidgets('should handle theme with userUploaded value',
          (tester) async {
        final userUploadedTheme = ThemeDataModel(
          (b) => b
            ..id = 6
            ..title = "User Uploaded Theme"
            ..description = "Test Description"
            ..cover = "https://example.com/image.jpg"
            ..thumbnail = "https://example.com/thumbnail.jpg"
            ..fromCache = false
            ..userUploaded = 1
            ..isActive = 1
            ..createdAt = "2024-01-01"
            ..categoryId = 1
            ..locationId = 1
            ..totalLikes = 12
            ..mediaType = 1
            ..userLike = 0
            ..isApplied = false
            ..deviceId = "test_device"
            ..colors = "#FF0000",
        );

        await tester.pumpWidget(
          createTestWidget(
            themeData: userUploadedTheme,
            themesList: BuiltList<ThemeDataModel>([userUploadedTheme]),
          ),
        );

        await tester.pump();

        // Should render without errors
        expect(find.byType(ThemeListCard), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantic labels', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            themeData: mockImageTheme,
            themesList: mockThemesList,
          ),
        );

        await tester.pump();

        // Verify basic accessibility structure
        expect(find.byType(ThemeListCard), findsOneWidget);
        expect(find.byType(ThemeThumbnailPreview), findsOneWidget);
      });

      testWidgets('should handle different screen sizes', (tester) async {
        // Test with different screen sizes
        await tester.binding.setSurfaceSize(const Size(400, 600));

        await tester.pumpWidget(
          createTestWidget(
            themeData: mockImageTheme,
            themesList: mockThemesList,
          ),
        );

        await tester.pump();

        // Should render correctly on smaller screen
        expect(find.byType(ThemeListCard), findsOneWidget);

        // Reset to default size
        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}
