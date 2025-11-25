import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_management_clear_filters.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/bloc/bloc_mocks.dart';

void main() {
  late VisitorManagementBloc bloc;
  late bool tapped;

  setUp(() {
    bloc = MockVisitorManagementBloc();
    tapped = false;
  });

  Widget buildTestWidget(Widget child) {
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: child),
        );
      },
    );
  }

  testWidgets('should render Clear Filter text and respond to tap',
      (tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        VisitorManagementClearFilters(
          bloc: bloc,
          onTap: () => tapped = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Check for the localized text
    expect(find.text('Clear Filter'), findsOneWidget);

    // Tap and verify callback
    await tester.tap(find.byType(VisitorManagementClearFilters));
    expect(tapped, isTrue);
  });

  testWidgets('should use correct text color in light theme', (tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        VisitorManagementClearFilters(
          bloc: bloc,
          onTap: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final textWidget = tester.widget<Text>(find.text('Clear Filter'));
    final textStyle = textWidget.style;
    expect(textStyle, isNotNull);
    expect(textStyle!.color, AppColors.darkBlueColor);
  });
}
