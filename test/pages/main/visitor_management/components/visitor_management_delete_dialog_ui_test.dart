import 'package:admin/core/images.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_management_delete_dialog.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 600,
                height: 800,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  // Mock callback functions for testing
  bool confirmButtonTapped = false;
  bool cancelButtonTapped = false;

  void resetCallbacks() {
    confirmButtonTapped = false;
    cancelButtonTapped = false;
  }

  void mockConfirmButtonTap() {
    confirmButtonTapped = true;
  }

  void mockCancelButtonTap() {
    cancelButtonTapped = true;
  }

  group('VisitorManagementDeleteDialog Widget Tests', () {
    setUp(resetCallbacks);

    testWidgets('should build without errors with all required parameters',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(VisitorManagementDeleteDialog), findsOneWidget);
      expect(find.byType(AppDialogPopup), findsOneWidget);
    });

    testWidgets('should display correct title', (tester) async {
      const testTitle = 'Delete Visitor Record';

      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: testTitle,
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();
      expect(find.text(testTitle), findsOneWidget);
    });

    testWidgets('should display description when provided', (tester) async {
      const testDescription = 'Are you sure you want to delete this visitor?';

      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            deleteDialogDesc: testDescription,
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();
      expect(find.text(testDescription), findsOneWidget);
    });

    testWidgets('should not display description when not provided',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();
      // Should not find any description text
      expect(find.text('Are you sure'), findsNothing);
    });

    testWidgets('should display correct confirm button title', (tester) async {
      const testConfirmTitle = 'Confirm Delete';

      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: testConfirmTitle,
          ),
        ),
      );

      await tester.pump();
      expect(find.text(testConfirmTitle), findsOneWidget);
    });

    testWidgets('should display warning image', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should have correct image properties', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();

      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.height, equals(120));
      expect(imageWidget.width, equals(160));
    });

    testWidgets('should use correct warning image asset', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();

      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.image, isA<AssetImage>());

      final assetImage = imageWidget.image as AssetImage;
      expect(assetImage.assetName, equals(DefaultImages.WARNING_IMAGE));
    });

    testWidgets(
        'should call confirm button callback when confirm button is tapped',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();

      // Find and tap the confirm button
      final confirmButton = find.text('Delete');
      expect(confirmButton, findsOneWidget);

      await tester.tap(confirmButton);
      await tester.pump();

      expect(confirmButtonTapped, isTrue);
      expect(cancelButtonTapped, isFalse);
    });

    testWidgets(
        'should call cancel button callback when cancel button is tapped',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();

      // Find and tap the cancel button
      final cancelButton = find.text('Cancel');
      expect(cancelButton, findsOneWidget);

      await tester.tap(cancelButton);
      await tester.pump();

      expect(cancelButtonTapped, isTrue);
      expect(confirmButtonTapped, isFalse);
    });

    testWidgets('should handle multiple button taps correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();

      // Tap confirm button multiple times
      final confirmButton = find.text('Delete');
      await tester.tap(confirmButton);
      await tester.tap(confirmButton);
      await tester.pump();

      expect(confirmButtonTapped, isTrue);
      expect(cancelButtonTapped, isFalse);
    });

    testWidgets('should render with different title lengths', (tester) async {
      const shortTitle = 'Deleting Visitor';
      const longTitle =
          'This is a very long title that might wrap to multiple lines';

      // Test with short title
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: shortTitle,
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();
      expect(find.text(shortTitle), findsOneWidget);

      // Test with long title
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: longTitle,
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();
      expect(find.text(longTitle), findsOneWidget);
    });

    testWidgets('should render with different confirm button titles',
        (tester) async {
      const testTitles = ['Delete', 'Remove', 'Confirm', 'OK', 'Yes'];

      for (final title in testTitles) {
        await tester.pumpWidget(
          buildTestWidget(
            VisitorManagementDeleteDialog(
              deleteDialogTitle: 'Delete Visitor',
              confirmButtonTap: mockConfirmButtonTap,
              cancelButtonTap: mockCancelButtonTap,
              confirmButtonTitle: title,
            ),
          ),
        );

        await tester.pump();
        expect(find.text(title), findsOneWidget);
        resetCallbacks();
      }
    });

    testWidgets('should handle widget rebuilds correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(VisitorManagementDeleteDialog), findsOneWidget);

      // Rebuild with different title
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Remove Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Remove',
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Remove Visitor'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);
    });

    testWidgets('should render in different screen sizes', (tester) async {
      // Test with medium screen size
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(VisitorManagementDeleteDialog), findsOneWidget);

      // Test with large screen size
      tester.view.physicalSize = const Size(1200, 900);
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(VisitorManagementDeleteDialog), findsOneWidget);

      // Reset screen size
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('should handle widget disposal correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(VisitorManagementDeleteDialog), findsOneWidget);

      // Dispose widget
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox.shrink(),
        ),
      );

      await tester.pump();
      expect(find.byType(VisitorManagementDeleteDialog), findsNothing);
    });

    testWidgets('should have correct AppDialogPopup properties',
        (tester) async {
      const testTitle = 'Delete Visitor';
      const testDescription = 'Are you sure?';
      const testConfirmTitle = 'Delete';

      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: testTitle,
            deleteDialogDesc: testDescription,
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: testConfirmTitle,
          ),
        ),
      );

      await tester.pump();

      final appDialogPopup =
          tester.widget<AppDialogPopup>(find.byType(AppDialogPopup));

      // Verify that AppDialogPopup is called with correct parameters
      expect(appDialogPopup.title, equals(testTitle));
      expect(appDialogPopup.description, equals(testDescription));
      expect(appDialogPopup.confirmButtonLabel, equals(testConfirmTitle));
      expect(appDialogPopup.cancelButtonOnTap, equals(mockCancelButtonTap));
      expect(appDialogPopup.confirmButtonOnTap, equals(mockConfirmButtonTap));
    });

    testWidgets('should handle empty title gracefully', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: '',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(VisitorManagementDeleteDialog), findsOneWidget);
      expect(find.byType(AppDialogPopup), findsOneWidget);
    });

    testWidgets('should handle empty confirm button title gracefully',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: '',
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(VisitorManagementDeleteDialog), findsOneWidget);
      expect(find.byType(AppDialogPopup), findsOneWidget);
    });

    testWidgets('should maintain accessibility features', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VisitorManagementDeleteDialog(
            deleteDialogTitle: 'Delete Visitor',
            confirmButtonTap: mockConfirmButtonTap,
            cancelButtonTap: mockCancelButtonTap,
            confirmButtonTitle: 'Delete',
          ),
        ),
      );

      await tester.pump();

      // Verify that buttons are tappable
      final confirmButton = find.text('Delete');
      final cancelButton = find.text('Cancel');

      expect(confirmButton, findsOneWidget);
      expect(cancelButton, findsOneWidget);

      // Verify buttons can be tapped
      expect(tester.getSemantics(find.byType(AppDialogPopup)), isNotNull);
    });
  });
}
