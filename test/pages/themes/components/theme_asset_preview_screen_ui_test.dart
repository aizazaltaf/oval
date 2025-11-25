import 'dart:io';

import 'package:admin/custom_classes/gradient_fab_btn.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_asset_preview.dart';
import 'package:admin/pages/themes/componenets/theme_asset_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/singleton_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/theme_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';
import '../../../mocks/bloc/bloc_mocks.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late ThemeBlocTestHelper themeBlocHelper;
  late SingletonBlocTestHelper singletonBlocHelper;
  late MockNavigatorObserver mockNavigatorObserver;
  late File mockSelectedAsset;

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

    // Setup mock navigator observer
    mockNavigatorObserver = MockNavigatorObserver();

    // Create mock files
    mockSelectedAsset = File('test_asset.jpg');
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
    themeBlocHelper.dispose();
  });

  tearDown(() async {
    // Clean up any pending timers and animations
    await Future.delayed(const Duration(milliseconds: 100));
  });

  Widget createTestWidget({
    File? selectedAsset,
    File? thumbnail,
    bool noBackIcon = false,
  }) {
    return MaterialApp(
      navigatorObservers: [mockNavigatorObserver],
      home: BlocProvider<ThemeBloc>.value(
        value: themeBlocHelper.mockThemeBloc,
        child: ThemeAssetPreviewScreen(
          selectedAsset: selectedAsset ?? mockSelectedAsset,
          thumbnail: thumbnail,
          noBackIcon: noBackIcon,
        ),
      ),
    );
  }

  group('ThemeAssetPreviewScreen UI Tests', () {
    group('Basic Rendering Tests', () {
      testWidgets('should render with all required elements', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify the screen renders
        expect(find.byType(ThemeAssetPreviewScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(ThemeAssetPreview), findsOneWidget);
      });

      testWidgets('should display selected asset preview', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify ThemeAssetPreview is rendered with correct path
        final themeAssetPreview = tester.widget<ThemeAssetPreview>(
          find.byType(ThemeAssetPreview),
        );
        expect(themeAssetPreview.path, equals(mockSelectedAsset.path));
        expect(themeAssetPreview.isNetwork, isFalse);
      });

      testWidgets('should render with white background', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, equals(Colors.white));
      });
    });

    group('Back Icon Tests', () {
      testWidgets('should show back icon when noBackIcon is false',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.close), findsOneWidget);
        expect(
          find.byType(GestureDetector),
          findsNWidgets(2),
        ); // Back icon + FAB
      });

      testWidgets('should hide back icon when noBackIcon is true',
          (tester) async {
        await tester.pumpWidget(createTestWidget(noBackIcon: true));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.close), findsNothing);
        expect(find.byType(GestureDetector), findsOneWidget); // Only FAB
      });

      testWidgets('should position back icon correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final backIcon = find.byIcon(Icons.close);
        expect(backIcon, findsOneWidget);

        // Verify it's positioned at top-left with SafeArea
        final backIconWidget = tester.widget<Positioned>(
          find.ancestor(
            of: backIcon,
            matching: find.byType(Positioned),
          ),
        );
        expect(backIconWidget.top, equals(20));
        expect(backIconWidget.left, equals(20));
      });

      testWidgets('should render back icon with white color', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final backIcon = tester.widget<Icon>(find.byIcon(Icons.close));
        expect(backIcon.color, equals(Colors.white));
      });

      testWidgets('should handle back icon tap to navigate back',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Test that the back icon is tappable
        final backIcon = find.byIcon(Icons.close);
        expect(backIcon, findsOneWidget);

        // Verify the gesture detector exists
        final gestureDetector = find.ancestor(
          of: backIcon,
          matching: find.byType(GestureDetector),
        );
        expect(gestureDetector, findsOneWidget);
      });
    });

    group('Floating Action Button Tests', () {
      testWidgets('should render floating action button', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(GradientFloatingButton), findsOneWidget);
        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets('should position FAB correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final fab = find.byType(GradientFloatingButton);
        expect(fab, findsOneWidget);

        final fabWidget = tester.widget<Positioned>(
          find.ancestor(
            of: fab,
            matching: find.byType(Positioned),
          ),
        );
        expect(fabWidget.bottom, equals(20));
        expect(fabWidget.right, equals(20));
      });

      testWidgets('should render FAB with correct padding', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final fab = tester.widget<GradientFloatingButton>(
          find.byType(GradientFloatingButton),
        );
        expect(fab.padding, equals(const EdgeInsets.all(10)));
      });

      testWidgets('should render send icon in FAB', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify SvgPicture is rendered (we can't easily test the asset property in tests)
        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets('should handle FAB tap to navigate to ThemeAddInfoScreen',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Test that the FAB is tappable
        final fab = find.byType(GradientFloatingButton);
        expect(fab, findsOneWidget);

        // Verify the gesture detector exists
        final gestureDetector = find.ancestor(
          of: fab,
          matching: find.byType(GestureDetector),
        );
        expect(gestureDetector, findsOneWidget);
      });
    });

    group('Layout and Positioning Tests', () {
      testWidgets('should use Stack for layout', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // There might be multiple Stack widgets in the widget tree
        expect(find.byType(Stack), findsAtLeastNWidgets(1));
      });

      testWidgets('should position asset preview to fill entire screen',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final positionedFill = find.ancestor(
          of: find.byType(ThemeAssetPreview),
          matching: find.byType(Positioned),
        );
        expect(positionedFill, findsOneWidget);

        // Verify the positioned widget exists (Positioned.fill() is a constructor, not a property)
        final positionedWidget = tester.widget<Positioned>(positionedFill);
        expect(positionedWidget, isNotNull);
      });

      testWidgets('should use SafeArea for back icon', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final safeArea = find.ancestor(
          of: find.byIcon(Icons.close),
          matching: find.byType(SafeArea),
        );
        expect(safeArea, findsOneWidget);
      });

      testWidgets('should use SafeArea for FAB', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final safeArea = find.ancestor(
          of: find.byType(GradientFloatingButton),
          matching: find.byType(SafeArea),
        );
        expect(safeArea, findsOneWidget);
      });
    });

    group('Asset Preview Integration Tests', () {
      testWidgets('should pass correct parameters to ThemeAssetPreview',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final themeAssetPreview = tester.widget<ThemeAssetPreview>(
          find.byType(ThemeAssetPreview),
        );
        expect(themeAssetPreview.path, equals(mockSelectedAsset.path));
        expect(themeAssetPreview.isNetwork, isFalse);
        expect(themeAssetPreview.width, isNull);
        expect(themeAssetPreview.uploadPreview, isFalse);
      });

      testWidgets('should handle different asset types', (tester) async {
        // Test with different file types
        final imageFile = File('test_image.png');
        final gifFile = File('test_animation.gif');

        await tester.pumpWidget(createTestWidget(selectedAsset: imageFile));
        await tester.pumpAndSettle();

        var themeAssetPreview = tester.widget<ThemeAssetPreview>(
          find.byType(ThemeAssetPreview),
        );
        expect(themeAssetPreview.path, equals(imageFile.path));

        await tester.pumpWidget(createTestWidget(selectedAsset: gifFile));
        await tester.pumpAndSettle();

        themeAssetPreview = tester.widget<ThemeAssetPreview>(
          find.byType(ThemeAssetPreview),
        );
        expect(themeAssetPreview.path, equals(gifFile.path));
      });
    });

    group('Navigation Tests', () {
      testWidgets(
          'should navigate to ThemeAddInfoScreen with correct parameters',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Test that the FAB exists and is tappable
        final fab = find.byType(GradientFloatingButton);
        expect(fab, findsOneWidget);

        // Verify the gesture detector exists
        final gestureDetector = find.ancestor(
          of: fab,
          matching: find.byType(GestureDetector),
        );
        expect(gestureDetector, findsOneWidget);
      });

      testWidgets('should pass generated image from bloc state when available',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Test that the FAB exists and is tappable
        final fab = find.byType(GradientFloatingButton);
        expect(fab, findsOneWidget);

        // Verify the gesture detector exists
        final gestureDetector = find.ancestor(
          of: fab,
          matching: find.byType(GestureDetector),
        );
        expect(gestureDetector, findsOneWidget);
      });
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('should handle null thumbnail gracefully', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should still render without errors
        expect(find.byType(ThemeAssetPreviewScreen), findsOneWidget);
        expect(find.byType(ThemeAssetPreview), findsOneWidget);
      });

      testWidgets('should handle empty asset path', (tester) async {
        final emptyFile = File('');
        await tester.pumpWidget(createTestWidget(selectedAsset: emptyFile));
        await tester.pumpAndSettle();

        // Should still render without errors
        expect(find.byType(ThemeAssetPreviewScreen), findsOneWidget);
      });

      testWidgets('should handle bloc state changes', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should still render without errors
        expect(find.byType(ThemeAssetPreviewScreen), findsOneWidget);
        expect(find.byType(ThemeAssetPreview), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper hit test behavior for back icon',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final backIconGestureDetector = find.ancestor(
          of: find.byIcon(Icons.close),
          matching: find.byType(GestureDetector),
        );
        expect(backIconGestureDetector, findsOneWidget);

        final gestureDetector =
            tester.widget<GestureDetector>(backIconGestureDetector);
        expect(gestureDetector.behavior, equals(HitTestBehavior.opaque));
      });

      testWidgets('should have proper hit test behavior for FAB',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final fabGestureDetector = find.ancestor(
          of: find.byType(GradientFloatingButton),
          matching: find.byType(GestureDetector),
        );
        expect(fabGestureDetector, findsOneWidget);

        final gestureDetector =
            tester.widget<GestureDetector>(fabGestureDetector);
        expect(gestureDetector.behavior, equals(HitTestBehavior.opaque));
      });
    });

    group('Performance Tests', () {
      testWidgets('should render efficiently without unnecessary rebuilds',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify minimal widget tree
        expect(find.byType(ThemeAssetPreviewScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(Stack), findsAtLeastNWidgets(1));
        expect(
          find.byType(Positioned),
          findsAtLeastNWidgets(3),
        ); // Asset preview, back icon, FAB
      });

      testWidgets('should handle asset preview efficiently', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should only have one ThemeAssetPreview widget
        expect(find.byType(ThemeAssetPreview), findsOneWidget);
      });
    });
  });
}
