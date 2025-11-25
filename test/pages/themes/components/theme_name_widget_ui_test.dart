import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_name_widget.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_helper.dart';
import '../../../mocks/bloc/bloc_mocks.dart';
import '../../../mocks/bloc/state_mocks.dart';

void main() {
  late MockThemeBloc mockThemeBloc;
  late MockThemeState mockThemeState;
  late ThemeDataModel mockTheme;
  late ThemeDataModel mockThemeWithHyphen;

  setUpAll(() async {
    await TestHelper.initialize();
  });

  setUp(() {
    mockThemeBloc = MockThemeBloc();
    mockThemeState = MockThemeState();

    // Create mock theme data
    mockTheme = ThemeDataModel(
      (b) => b
        ..id = 1
        ..title = "Test Theme"
        ..description =
            "This is a test theme description that should be displayed properly with multiple lines of text to test the maxLines property"
        ..cover = "https://example.com/theme.jpg"
        ..thumbnail = "https://example.com/theme_thumb.jpg"
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

    mockThemeWithHyphen = ThemeDataModel(
      (b) => b
        ..id = 3
        ..title = "Test-Theme-With-Hyphens"
        ..description = "This theme has hyphens in the title"
        ..cover = "https://example.com/hyphen_theme.jpg"
        ..thumbnail = "https://example.com/hyphen_theme_thumb.jpg"
        ..fromCache = false
        ..userUploaded = null
        ..isActive = 1
        ..createdAt = "2024-01-01"
        ..categoryId = 1
        ..locationId = 1
        ..totalLikes = 20
        ..mediaType = 1
        ..userLike = 0
        ..isApplied = false
        ..deviceId = "hyphen_device"
        ..colors = "#0000FF",
    );

    // Set up the mock bloc state
    mockThemeBloc.state = mockThemeState;
    
    // Mock the bloc state properties
    when(() => mockThemeState.activeType).thenReturn('Feed');
    when(() => mockThemeState.index).thenReturn(0);
    
    // Mock the getThemeApiType method to return a proper ApiState
    when(() => mockThemeBloc.getThemeApiType(any())).thenReturn(
      ApiState<PaginatedData<ThemeDataModel>>(
        (b) => b
          ..data = PaginatedData<ThemeDataModel>(
            (b) => b
              ..data = ListBuilder<ThemeDataModel>([mockTheme])
              ..currentPage = 1
              ..lastPage = 1,
          ),
      ),
    );
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
  });

  Widget createTestWidget({
    required ThemeDataModel theme,
  }) {
    return MaterialApp(
      home: BlocProvider<ThemeBloc>(
        create: (context) => mockThemeBloc,
        child: Scaffold(
          body: ThemeNameWidget(theme: theme),
        ),
      ),
    );
  }

  group('ThemeNameWidget UI Tests', () {
    testWidgets('should display theme title correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(theme: mockTheme));

      expect(find.text('Test Theme'), findsOneWidget);
      expect(
        find.text(
          'This is a test theme description that should be displayed properly with multiple lines of text to test the maxLines property',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'should display theme title without hyphens when title contains hyphens',
        (tester) async {
      await tester.pumpWidget(createTestWidget(theme: mockThemeWithHyphen));

      expect(find.text('Test'), findsOneWidget);
      expect(find.text('This theme has hyphens in the title'), findsOneWidget);
    });

    testWidgets('should display theme description with proper styling',
        (tester) async {
      await tester.pumpWidget(createTestWidget(theme: mockTheme));

      final descriptionFinder = find.text(
        'This is a test theme description that should be displayed properly with multiple lines of text to test the maxLines property',
      );
      expect(descriptionFinder, findsOneWidget);

      final descriptionWidget = tester.widget<Text>(descriptionFinder);
      expect(descriptionWidget.maxLines, equals(5));
      expect(descriptionWidget.style?.fontSize, equals(16));
      expect(descriptionWidget.style?.fontWeight, equals(FontWeight.w400));
    });

    testWidgets('should display theme title with proper styling',
        (tester) async {
      await tester.pumpWidget(createTestWidget(theme: mockTheme));

      final titleFinder = find.text('Test Theme');
      expect(titleFinder, findsOneWidget);

      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style?.fontSize, equals(20));
      expect(titleWidget.style?.fontWeight, equals(FontWeight.w600));
    });

    testWidgets('should display proper spacing between elements',
        (tester) async {
      await tester.pumpWidget(createTestWidget(theme: mockTheme));

      // Check that there's proper padding around the widget
      final paddingFinder = find.byType(Padding);
      expect(paddingFinder, findsOneWidget);

      final paddingWidget = tester.widget<Padding>(paddingFinder);
      expect(paddingWidget.padding, equals(const EdgeInsets.all(8)));
    });

    testWidgets('should handle theme with long title and description',
        (tester) async {
      final longTheme = ThemeDataModel(
        (b) => b
          ..id = 6
          ..title =
              "This is a very long theme title that should be handled properly by the widget without breaking the layout"
          ..description =
              "This is an extremely long description that contains many words and should test the widget's ability to handle long text content without causing any layout issues or overflow problems"
          ..cover = "https://example.com/long_theme.jpg"
          ..thumbnail = "https://example.com/long_theme_thumb.jpg"
          ..fromCache = false
          ..userUploaded = null
          ..isActive = 1
          ..createdAt = "2024-01-01"
          ..categoryId = 1
          ..locationId = 1
          ..totalLikes = 100
          ..mediaType = 1
          ..userLike = 0
          ..isApplied = false
          ..deviceId = "long_device"
          ..colors = "#FFFF00",
      );

      await tester.pumpWidget(createTestWidget(theme: longTheme));

      // Should display long title and description without errors
      expect(
        find.textContaining('This is a very long theme title'),
        findsOneWidget,
      );
      expect(
        find.textContaining('This is an extremely long description'),
        findsOneWidget,
      );
    });

    testWidgets('should handle theme with special characters in title',
        (tester) async {
      final specialTheme = ThemeDataModel(
        (b) => b
          ..id = 7
          ..title = "Theme with special characters"
          ..description = "Description with special chars"
          ..cover = "https://example.com/special_theme.jpg"
          ..thumbnail = "https://example.com/special_theme_thumb.jpg"
          ..fromCache = false
          ..userUploaded = null
          ..isActive = 1
          ..createdAt = "2024-01-01"
          ..categoryId = 1
          ..locationId = 1
          ..totalLikes = 50
          ..mediaType = 1
          ..userLike = 0
          ..isApplied = false
          ..deviceId = "special_device"
          ..colors = "#00FFFF",
      );

      await tester.pumpWidget(createTestWidget(theme: specialTheme));

      // Should display special characters correctly
      expect(find.text('Theme with special characters'), findsOneWidget);
      expect(find.text('Description with special chars'), findsOneWidget);
    });

    testWidgets('should handle theme with empty title and description',
        (tester) async {
      final emptyTheme = ThemeDataModel(
        (b) => b
          ..id = 8
          ..title = ""
          ..description = ""
          ..cover = "https://example.com/empty_theme.jpg"
          ..thumbnail = "https://example.com/empty_theme_thumb.jpg"
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
          ..deviceId = "empty_device"
          ..colors = "#FF00FF",
      );

      await tester.pumpWidget(createTestWidget(theme: emptyTheme));

      // Should handle empty strings gracefully
      expect(
        find.text(''),
        findsNWidgets(2),
      ); // Both title and description are empty
    });

    testWidgets('should handle theme with very long title and description',
        (tester) async {
      final veryLongTheme = ThemeDataModel(
        (b) => b
          ..id = 9
          ..title = "A" * 200 // Long but reasonable title
          ..description = "B" * 500 // Long but reasonable description
          ..cover = "https://example.com/very_long_theme.jpg"
          ..thumbnail = "https://example.com/very_long_theme_thumb.jpg"
          ..fromCache = false
          ..userUploaded = null
          ..isActive = 1
          ..createdAt = "2024-01-01"
          ..categoryId = 1
          ..locationId = 1
          ..totalLikes = 999999
          ..mediaType = 1
          ..userLike = 0
          ..isApplied = false
          ..deviceId = "very_long_device"
          ..colors = "#FFFF00",
      );

      await tester.pumpWidget(createTestWidget(theme: veryLongTheme));

      // Should display long content without errors
      expect(find.textContaining('A' * 50), findsOneWidget);
      expect(find.textContaining('B' * 50), findsOneWidget);
    });
  });
}
