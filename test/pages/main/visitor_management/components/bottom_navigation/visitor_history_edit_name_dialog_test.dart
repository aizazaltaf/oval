import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/bottom_navigation/visitor_history_edit_name_dialog.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/bloc/bloc_mocks.dart';

void main() {
  late MockVisitorManagementBloc bloc;
  late VisitorsModel visitor;

  setUp(() {
    bloc = MockVisitorManagementBloc();
    visitor = VisitorsModel(
      (b) => b
        ..id = 1
        ..name = "John Doe"
        ..uniqueId = "john_123"
        ..isWanted = 0
        ..locationId = 1
        ..lastVisit = "2024-01-01T10:00:00Z",
    );
  });

  Widget buildTestDialog() {
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => VisitorHistoryEditNameDialog(
                    bloc: bloc,
                    visitor: visitor,
                    imageUrl: visitor.imageUrl ?? "",
                    visitorId: visitor.id.toString(),
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        );
      },
    );
  }

  testWidgets('renders dialog and fields', (tester) async {
    await tester.pumpWidget(buildTestDialog());
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(VisitorHistoryEditNameDialog), findsOneWidget);
    expect(find.byType(NameTextFormField), findsOneWidget);
    expect(find.byType(CustomGradientButton), findsOneWidget);
    expect(find.textContaining('Save', findRichText: true), findsOneWidget);
    expect(find.textContaining('Cancel', findRichText: true), findsOneWidget);
  });

  testWidgets('pre-fills name field with visitor name', (tester) async {
    await tester.pumpWidget(buildTestDialog());
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final nameField = find.byType(NameTextFormField);
    expect(nameField, findsOneWidget);
    final textField = tester.widget<TextFormField>(
      find.descendant(of: nameField, matching: find.byType(TextFormField)),
    );
    expect(textField.controller?.text ?? textField.initialValue, "John Doe");
  });

  testWidgets('Save button calls bloc and closes dialog', (tester) async {
    bool called = false;
    // Use the custom mock setter to mock the bloc's callEditVisitorName method
    await bloc.setMockCallEditVisitorName((
      visitorId, {
      fromVisitorHistory = false,
      c,
    }) async {
      called = true;
    });

    await tester.pumpWidget(buildTestDialog());
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Simulate valid name input and enable Save button
    await tester.enterText(find.byType(NameTextFormField), "Jane Smith");
    bloc.updateVisitorNameSaveButtonEnabled(true);
    await tester.pumpAndSettle();

    final saveButton = find.widgetWithText(
      CustomGradientButton,
      AppLocalizations.of(tester.element(find.byType(CustomGradientButton)))!
          .general_save,
    );
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(called, isTrue);
    expect(find.byType(VisitorHistoryEditNameDialog), findsNothing);
  });

  testWidgets('Cancel button closes dialog', (tester) async {
    await tester.pumpWidget(buildTestDialog());
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final cancelButton = find.textContaining('Cancel', findRichText: true);
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();

    expect(find.byType(VisitorHistoryEditNameDialog), findsNothing);
  });
}
