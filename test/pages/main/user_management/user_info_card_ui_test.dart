import 'package:admin/pages/main/user_management/components/user_info_card.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserInfoCard UI Tests', () {
    Widget makeTestableWidget(Widget child) {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            home: Scaffold(body: child),
          );
        },
      );
    }

    testWidgets('displays phone number with country code and masked number',
        (tester) async {
      const phoneNumber = '+1234567890';
      await tester.pumpWidget(
        makeTestableWidget(
          const UserInfoCard(
            title: 'Phone Number',
            value: phoneNumber,
          ),
        ),
      );
      // Should show CountryCodePicker
      expect(find.byType(CountryCodePicker), findsOneWidget);
      // Should show masked phone number
      expect(find.textContaining('***'), findsOneWidget);
      // Should not show an SVG icon
      expect(find.byType(SvgPicture), findsNothing);
    });

    testWidgets('displays role with correct icon and width', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const UserInfoCard(
            title: 'Role',
            value: 'Admin',
            icon: 'assets/icons/accountTypeBig2.svg',
          ),
        ),
      );
      // Should show SVG icon
      final svgFinder = find.byType(SvgPicture);
      expect(svgFinder, findsOneWidget);
      // Should show the value
      expect(find.text('Admin'), findsOneWidget);
      // Should not show CountryCodePicker
      expect(find.byType(CountryCodePicker), findsNothing);
    });

    testWidgets('displays generic value with icon', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const UserInfoCard(
            title: 'Full Name',
            value: 'John Doe',
            icon: 'assets/icons/accountTypeBig2.svg',
          ),
        ),
      );
      // Should show SVG icon
      expect(find.byType(SvgPicture), findsOneWidget);
      // Should show the value
      expect(find.text('John Doe'), findsOneWidget);
      // Should not show CountryCodePicker
      expect(find.byType(CountryCodePicker), findsNothing);
    });
  });
}
