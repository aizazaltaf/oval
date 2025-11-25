import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/bottom_navigation/visitor_history_add_remove_unwanted_dialog.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/bloc/bloc_mocks.dart';

void main() {
  late VisitorManagementBloc bloc;
  setUp(() {
    bloc = MockVisitorManagementBloc();
  });

  testWidgets('renders dialog and buttons', (tester) async {
    await tester.pumpWidget(
      FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => VisitorHistoryAddRemoveUnwantedDialog(
                      bloc: bloc,
                      confirmButtonTap: () {},
                      isWanted: 0,
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          );
        },
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(VisitorHistoryAddRemoveUnwantedDialog), findsOneWidget);
    expect(find.byType(ElevatedButton), findsWidgets);
  });

  testWidgets('calls confirmButtonTap when confirm is tapped', (tester) async {
    bool confirmed = false;
    await tester.pumpWidget(
      FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => VisitorHistoryAddRemoveUnwantedDialog(
                      bloc: bloc,
                      confirmButtonTap: () {
                        confirmed = true;
                      },
                      isWanted: 0,
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          );
        },
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    final context =
        tester.element(find.byType(VisitorHistoryAddRemoveUnwantedDialog));
    final localizations = AppLocalizations.of(context)!;
    final confirmButton =
        find.widgetWithText(CustomGradientButton, localizations.general_yes);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();
    expect(confirmed, isTrue);
  });
}
