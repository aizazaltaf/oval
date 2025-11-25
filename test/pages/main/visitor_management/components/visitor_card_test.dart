import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_management_components/visitor_card.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_build_context.dart';
import '../../../../helpers/test_helper.dart';
import '../../../../mocks/bloc/bloc_mocks.dart';

void main() {
  setUpAll(() {
    // Register fallback values for Mockito null-safety
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(VisitorsModelFake());
  });

  late MockVisitorManagementBloc bloc;
  late VisitorsModel visitor;

  setUp(() {
    bloc = MockVisitorManagementBloc();
    // Mock visitorNameTap to return a Future.value(null)
    when(() => bloc.visitorNameTap(any<BuildContext>(), any<VisitorsModel>()))
        .thenAnswer((_) async {});
    visitor = VisitorsModel(
      (b) => b
        ..id = 1
        ..name = 'John Doe'
        ..imageUrl = 'http://example.com/image.png'
        ..isWanted = 0
        ..lastVisit = DateTime.now().toString(),
    );
  });

  Widget buildTestableWidget(Widget child) {
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

  testWidgets('displays visitor name and profile image', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(VisitorCard(visitor: visitor, bloc: bloc)),
    );
    expect(find.text('John Doe'), findsOneWidget);
    // Optionally check for VisitorProfileImage, etc.
  });

  testWidgets('tapping card calls bloc.visitorNameTap', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(VisitorCard(visitor: visitor, bloc: bloc)),
    );
    // Find the VisitorCard widget and get its context
    final cardFinder = find.byType(VisitorCard);
    expect(cardFinder, findsOneWidget);
    final context = tester.element(cardFinder);
    await tester.tap(cardFinder);
    verify(() => bloc.visitorNameTap(context, visitor)).called(1);
  });

  // testWidgets('edit icon opens VisitorHistoryEditNameDialog', (WidgetTester tester) async {
  //   await tester.pumpWidget(buildTestableWidget(VisitorCard(visitor: visitor, bloc: bloc)));
  //   await tester.tap(find.byIcon(Icons.border_color_outlined));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(VisitorHistoryEditNameDialog), findsOneWidget);
  // });

  testWidgets('more icon opens tooltip menu', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(VisitorCard(visitor: visitor, bloc: bloc)),
    );
    // Use byIcon with the actual icon data
    final moreIcon = find.byIcon(MdiIcons.dotsVertical);
    expect(moreIcon, findsOneWidget);
    await tester.tap(moreIcon);
    await tester.pumpAndSettle();
    // Check for menu options
    expect(find.textContaining('Add in unwanted visitor'), findsOneWidget);
    expect(find.textContaining('Delete Visitor'), findsOneWidget);
    expect(find.textContaining('Share to Neighborhood'), findsOneWidget);
    expect(find.textContaining('Chat history'), findsOneWidget);
  });

  testWidgets("detect Remove from unwanted visitor", (tester) async {
    final visitor2 = VisitorsModel(
      (b) => b
        ..id = 2
        ..name = 'John Doe'
        ..imageUrl = 'http://example.com/image.png'
        ..isWanted = 1
        ..lastVisit = DateTime.now().toString(),
    );
    await tester.pumpWidget(
      buildTestableWidget(VisitorCard(visitor: visitor2, bloc: bloc)),
    );
    final moreIcon = find.byIcon(MdiIcons.dotsVertical);
    expect(moreIcon, findsOneWidget);
    await tester.tap(moreIcon);
    await tester.pumpAndSettle();
    expect(find.textContaining('Remove from unwanted visitor'), findsOneWidget);
  });
}
