import 'package:admin/pages/main/visitor_management/component/visitor_history_components/bottom_navigation/bottom_nav_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders icon and text', (tester) async {
    await tester.pumpWidget(
      FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            home: Scaffold(
              body: BottomNavItem(
                icon: Icons.home,
                title: 'Home',
                onTap: () {},
              ),
            ),
          );
        },
      ),
    );
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            home: Scaffold(
              body: BottomNavItem(
                icon: Icons.home,
                title: 'Home',
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          );
        },
      ),
    );
    await tester.tap(find.byType(BottomNavItem));
    expect(tapped, isTrue);
  });

  testWidgets('shows disabled state', (tester) async {
    await tester.pumpWidget(
      FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            home: Scaffold(
              body: BottomNavItem(
                icon: Icons.home,
                title: 'Home',
                needDisabled: true,
                onTap: () {},
              ),
            ),
          );
        },
      ),
    );
    expect(find.byType(BottomNavItem), findsOneWidget);
  });
}
