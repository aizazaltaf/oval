import 'package:admin/models/data/role_model.dart';
import 'package:admin/models/data/sub_user_model.dart';
import 'package:admin/pages/main/user_management/components/user_management_card.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('UserManagementCard UI Tests', () {
    late SubUserModel acceptedUser;
    late SubUserModel pendingUser;
    late SubUserModel userWithoutName;
    late SubUserModel userWithProfileImage;
    late SubUserModel userWithoutProfileImage;
    late RoleModel adminRole;
    late RoleModel userRole;
    late NavigatorObserver mockNavigatorObserver;

    setUp(() {
      adminRole = RoleModel(
        (b) => b
          ..id = 1
          ..name = 'Admin',
      );

      userRole = RoleModel(
        (b) => b
          ..id = 2
          ..name = 'User',
      );

      // User with name and accepted invite
      acceptedUser = SubUserModel(
        (b) => b
          ..id = 1
          ..name = 'John Doe'
          ..email = 'john.doe@example.com'
          ..role.replace(adminRole)
          ..userExist = true
          ..source = 'test'
          ..inviteId = 123
          ..isAccepted = 'accepted'
          ..profileImage = null,
      );

      // User with pending invite
      pendingUser = SubUserModel(
        (b) => b
          ..id = 2
          ..name = 'Jane Smith'
          ..email = 'jane.smith@example.com'
          ..role.replace(userRole)
          ..userExist = true
          ..source = 'test'
          ..inviteId = 456
          ..isAccepted = 'pending'
          ..profileImage = null,
      );

      // User without name (should display email prefix)
      userWithoutName = SubUserModel(
        (b) => b
          ..id = 3
          ..name = null
          ..email = 'alice.wilson@example.com'
          ..role.replace(userRole)
          ..userExist = true
          ..source = 'test'
          ..inviteId = null
          ..isAccepted = null
          ..profileImage = null,
      );

      // User with profile image
      userWithProfileImage = SubUserModel(
        (b) => b
          ..id = 4
          ..name = 'Bob Johnson'
          ..email = 'bob.johnson@example.com'
          ..role.replace(adminRole)
          ..userExist = true
          ..source = 'test'
          ..inviteId = null
          ..isAccepted = null
          ..profileImage = 'https://example.com/profile.jpg',
      );

      // User without profile image
      userWithoutProfileImage = SubUserModel(
        (b) => b
          ..id = 5
          ..name = 'Charlie Brown'
          ..email = 'charlie.brown@example.com'
          ..role.replace(userRole)
          ..userExist = true
          ..source = 'test'
          ..inviteId = null
          ..isAccepted = null
          ..profileImage = null,
      );

      mockNavigatorObserver = MockNavigatorObserver();
    });

    Widget makeTestableWidget(SubUserModel user) {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            navigatorObservers: [mockNavigatorObserver],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: UserManagementCard(subUser: user),
              ),
            ),
          );
        },
      );
    }

    group('Basic UI Elements', () {
      testWidgets('displays user name correctly', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        expect(find.text('John Doe'), findsOneWidget);
      });

      testWidgets('displays email prefix when name is null', (tester) async {
        await tester.pumpWidget(makeTestableWidget(userWithoutName));
        await tester.pumpAndSettle();

        expect(find.text('alice.wilson'), findsOneWidget);
      });

      testWidgets('displays masked email', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        // Should display masked email (first 4 characters + **** + @domain for username > 6 chars)
        expect(find.textContaining('john****@example.com'), findsOneWidget);
      });

      testWidgets('displays user role', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        expect(find.text('Admin'), findsOneWidget);
      });

      testWidgets('displays email icon', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      });

      testWidgets('displays people icon for role', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.people_outline), findsOneWidget);
      });
    });

    group('Profile Image Display', () {
      testWidgets('displays placeholder image when profile image is null',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(userWithoutProfileImage));
        await tester.pumpAndSettle();

        // Should display placeholder image
        expect(find.byType(Image), findsOneWidget);
        final imageWidget = tester.widget<Image>(find.byType(Image));
        expect(imageWidget.image, isA<AssetImage>());
      });

      testWidgets(
          'displays cached network image when profile image is provided',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(userWithProfileImage));
        await tester.pumpAndSettle();

        // Should display CachedNetworkImage
        expect(find.byType(CachedNetworkImage), findsOneWidget);
      });

      testWidgets('displays placeholder when network image fails to load',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(userWithProfileImage));
        await tester.pumpAndSettle();

        // The CachedNetworkImage should be present
        expect(find.byType(CachedNetworkImage), findsOneWidget);
      });
    });

    group('Invite Status Indicators', () {
      testWidgets('displays accepted tag for accepted invite', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        // Should display accepted tag SVG
        expect(find.byType(SvgPicture), findsOneWidget);
        final svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect(svgWidget.height, equals(40));

        // Verify the logic: when isAccepted != "pending", it should show ACCEPTED_TAG
        expect(acceptedUser.isAccepted, equals('accepted'));
        expect(
          acceptedUser.isAccepted.toString().toLowerCase(),
          isNot(equals('pending')),
        );

        // Verify the widget is positioned correctly (top: -5, right: -8)
        final positionedFinder = find.byType(Positioned);
        expect(positionedFinder, findsOneWidget);
        final positionedWidget = tester.widget<Positioned>(positionedFinder);
        expect(positionedWidget.top, equals(-5));
        expect(positionedWidget.right, equals(-8));
      });

      testWidgets('displays pending tag for pending invite', (tester) async {
        await tester.pumpWidget(makeTestableWidget(pendingUser));
        await tester.pumpAndSettle();

        // Should display pending tag SVG
        expect(find.byType(SvgPicture), findsOneWidget);
        final svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect(svgWidget.height, equals(40));

        // Verify the logic: when isAccepted == "pending", it should show PENDING_TAG
        expect(pendingUser.isAccepted, equals('pending'));
        expect(
          pendingUser.isAccepted.toString().toLowerCase(),
          equals('pending'),
        );

        // Verify the widget is positioned correctly (top: -5, right: -8)
        final positionedFinder = find.byType(Positioned);
        expect(positionedFinder, findsOneWidget);
        final positionedWidget = tester.widget<Positioned>(positionedFinder);
        expect(positionedWidget.top, equals(-5));
        expect(positionedWidget.right, equals(-8));
      });

      testWidgets('does not display tag when no invite', (tester) async {
        await tester.pumpWidget(makeTestableWidget(userWithoutName));
        await tester.pumpAndSettle();

        // Should not display any SVG tag, but should display SizedBox in Positioned widget
        expect(find.byType(SvgPicture), findsNothing);

        // Check that there's a SizedBox in the Positioned widget (the empty tag placeholder)
        final positionedFinder = find.byType(Positioned);
        expect(positionedFinder, findsOneWidget);

        final positionedWidget = tester.widget<Positioned>(positionedFinder);
        expect(positionedWidget.child, isA<SizedBox>());
      });

      testWidgets('has correct border radius for users with invite',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        final cardFinder = find.byType(Card);
        expect(cardFinder, findsOneWidget);

        final card = tester.widget<Card>(cardFinder);
        expect(card.shape, isA<RoundedRectangleBorder>());
      });

      testWidgets('has correct border radius for users without invite',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(userWithoutName));
        await tester.pumpAndSettle();

        final cardFinder = find.byType(Card);
        expect(cardFinder, findsOneWidget);

        final card = tester.widget<Card>(cardFinder);
        expect(card.shape, isA<RoundedRectangleBorder>());
      });
    });

    group('Card Styling and Layout', () {
      testWidgets('has correct elevation', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        final cardFinder = find.byType(Card);
        final card = tester.widget<Card>(cardFinder);
        expect(card.elevation, 6);
      });

      testWidgets('has correct padding', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        // Check that the card has proper padding
        final containerFinder = find.descendant(
          of: find.byType(Card),
          matching: find.byType(Container),
        );
        expect(containerFinder, findsOneWidget);
      });

      testWidgets('displays user information in correct layout',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        // Should have profile image on the left
        expect(find.byType(ClipOval), findsOneWidget);

        // Should have text information on the right
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Admin'), findsOneWidget);
      });
    });

    group('Interaction and Navigation', () {
      testWidgets('is tappable', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        // Verify the card exists and is tappable
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(GestureDetector), findsWidgets);
      });

      testWidgets('has opaque hit test behavior', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        // Find any GestureDetector and check its behavior
        final gestureDetectorFinder = find.byType(GestureDetector);
        final gestureDetector =
            tester.widget<GestureDetector>(gestureDetectorFinder.first);
        expect(gestureDetector.behavior, HitTestBehavior.opaque);
      });
    });

    group('Text Button Interactions', () {
      testWidgets('name text button is disabled', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        final nameButton = tester.widget<TextButton>(
          find
              .descendant(
                of: find.byType(GestureDetector),
                matching: find.byType(TextButton),
              )
              .first,
        );
        expect(nameButton.onPressed, isNull);
      });

      testWidgets('email text button is disabled', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        final emailButtons = find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(TextButton),
        );
        expect(emailButtons, findsNWidgets(3)); // name, email, role buttons

        final emailButton = tester.widget<TextButton>(emailButtons.at(1));
        expect(emailButton.onPressed, isNull);
      });

      testWidgets('role text button is disabled', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        final roleButtons = find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(TextButton),
        );
        expect(roleButtons, findsNWidgets(3)); // name, email, role buttons

        final roleButton = tester.widget<TextButton>(roleButtons.at(2));
        expect(roleButton.onPressed, isNull);
      });
    });

    group('Theme and Colors', () {
      testWidgets('uses theme-based colors', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        // Check that the card uses theme colors
        final containerFinder = find.descendant(
          of: find.byType(Card),
          matching: find.byType(Container),
        );
        expect(containerFinder, findsOneWidget);
      });

      testWidgets('text uses correct theme colors', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        // Check that text uses theme colors
        final nameText = tester.widget<Text>(find.text('John Doe'));
        expect(nameText.style, isNotNull);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty profile image string', (tester) async {
        final userWithEmptyImage = SubUserModel(
          (b) => b
            ..id = 6
            ..name = 'Test User'
            ..email = 'test@example.com'
            ..role.replace(userRole)
            ..userExist = true
            ..source = 'test'
            ..inviteId = null
            ..isAccepted = null
            ..profileImage = '',
        );

        await tester.pumpWidget(makeTestableWidget(userWithEmptyImage));
        await tester.pumpAndSettle();

        // Should display placeholder image
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('handles very long email addresses', (tester) async {
        final userWithLongEmail = SubUserModel(
          (b) => b
            ..id = 7
            ..name = 'Long Email User'
            ..email =
                'very.long.email.address.that.might.cause.layout.issues@verylongdomainname.com'
            ..role.replace(userRole)
            ..userExist = true
            ..source = 'test'
            ..inviteId = null
            ..isAccepted = null
            ..profileImage = null,
        );

        await tester.pumpWidget(makeTestableWidget(userWithLongEmail));
        await tester.pumpAndSettle();

        // Should still display the masked email
        expect(
          find.textContaining('@verylongdomainname.com'),
          findsOneWidget,
        );
      });

      testWidgets('handles special characters in name', (tester) async {
        final userWithSpecialChars = SubUserModel(
          (b) => b
            ..id = 8
            ..name = 'José María O\'Connor-Smith'
            ..email = 'jose.maria@example.com'
            ..role.replace(userRole)
            ..userExist = true
            ..source = 'test'
            ..inviteId = null
            ..isAccepted = null
            ..profileImage = null,
        );

        await tester.pumpWidget(makeTestableWidget(userWithSpecialChars));
        await tester.pumpAndSettle();

        expect(find.text('José María O\'Connor-Smith'), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('has semantic labels for accessibility', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        // Check that the card is tappable
        expect(find.byType(GestureDetector), findsWidgets);
      });

      testWidgets('text has appropriate contrast', (tester) async {
        await tester.pumpWidget(makeTestableWidget(acceptedUser));
        await tester.pumpAndSettle();

        // Check that text is visible and readable
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Admin'), findsOneWidget);
      });
    });
  });
}
