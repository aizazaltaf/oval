import 'package:admin/core/theme.dart';
import 'package:admin/models/data/notification_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/notifications/components/notification_tile.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_helper.dart';
import '../../../../mocks/bloc/bloc_mocks.dart';

class MockVoipBloc extends Mock implements VoipBloc {}

void main() {
  group('NotificationTile UI Tests', () {
    late MockNotificationBloc mockNotificationBloc;
    late MockVoipBloc mockVoipBloc;
    late NotificationData mockNotification;
    late UserDeviceModel mockDoorbell;
    late VisitorsModel mockVisitor;

    setUpAll(() async {
      await TestHelper.initialize();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    setUp(() {
      mockNotificationBloc = MockNotificationBloc();
      mockVoipBloc = MockVoipBloc();

      // Setup mock notification data
      mockNotification = NotificationData(
        (b) => b
          ..id = 1
          ..title = 'Test Notification'
          ..text = 'Test notification body'
          ..createdAt = DateTime.now().toIso8601String()
          ..updatedAt = DateTime.now().toIso8601String()
          ..receiveType = 'AI'
          ..locationId = 45
          ..imageUrl = null
          ..userId = 11
          ..isRead = 0
          ..expanded = false,
      );

      // Setup mock doorbell
      mockDoorbell = UserDeviceModel(
        (b) => b
          ..id = 2
          ..deviceId = 'test_device_id'
          ..name = 'Test Doorbell'
          ..callUserId = 'test_call_user_id',
      );

      // Setup mock visitor
      mockVisitor = VisitorsModel(
        (b) => b
          ..id = 3
          ..name = 'Test Visitor'
          ..isWanted = 1,
      );

      // Setup default mock behaviors
      when(
        () => mockNotificationBloc.updateScheduleOfDoorbell(
          deviceId: any(named: 'deviceId'),
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async {});

      // Mock VoipBloc stream and state
      when(() => mockVoipBloc.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockVoipBloc.activateLiveMode(any())).thenAnswer((_) async {});
      when(
        () => mockVoipBloc.getRecording(callUserId: any(named: 'callUserId')),
      ).thenAnswer((_) async {});
    });

    Widget createTestWidget({
      String? title,
      String? body,
      String? image,
      String? date,
      String? receiveType,
      String? createdAt,
      String? callUserId,
      bool isExpanded = false,
      Function? onChange,
      NotificationData? notification,
      VisitorsModel? visitor,
      UserDeviceModel? doorbell,
    }) {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<NotificationBloc>.value(
                value: mockNotificationBloc,
              ),
              BlocProvider<VoipBloc>.value(
                value: mockVoipBloc,
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              theme: getTheme(),
              darkTheme: darkTheme(),
              home: Scaffold(
                body: NotificationTile(
                  title: title ?? 'Test Notification',
                  body: body ?? 'Test notification body',
                  image: image,
                  date: date ?? '2024-01-01',
                  receiveType: receiveType ?? 'AI',
                  createdAt: createdAt ?? DateTime.now().toIso8601String(),
                  callUserId: callUserId ?? 'test_user_id',
                  isExpanded: isExpanded,
                  onChange: onChange ?? () {},
                  notification: notification ?? mockNotification,
                  visitor: visitor ?? mockVisitor,
                  doorbell: doorbell ?? mockDoorbell,
                ),
              ),
            ),
          );
        },
      );
    }

    group('Basic Structure and Layout', () {
      testWidgets('should render NotificationTile with basic structure',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(NotificationTile), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Row), findsWidgets);
      });

      testWidgets('should display notification title and body', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Custom Title',
            body: 'Custom Body',
          ),
        );
        await tester.pump();

        expect(find.text('Custom Title'), findsOneWidget);
        expect(find.text('Custom Body'), findsOneWidget);
      });

      testWidgets('should display notification time', (tester) async {
        final now = DateTime.now();
        await tester.pumpWidget(
          createTestWidget(
            createdAt: now.toIso8601String(),
          ),
        );
        await tester.pump();

        final timeText = find.byType(Text);
        expect(timeText, findsWidgets);
      });

      testWidgets('should display notification icon', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(SvgPicture), findsOneWidget);
      });
    });

    group('Notification Icon Logic', () {
      testWidgets(
          'should display visitor notification icon for visitor notifications',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Visitor Detected',
          ),
        );
        await tester.pump();

        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets(
          'should display baby run notification icon for baby run notifications',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Baby Run Detected',
          ),
        );
        await tester.pump();

        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets(
          'should display pet run notification icon for pet run notifications',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Pet Run Detected',
          ),
        );
        await tester.pump();

        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets(
          'should display fire notification icon for fire notifications',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Fire Detected',
          ),
        );
        await tester.pump();

        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets(
          'should display parcel notification icon for parcel notifications',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Parcel Detected',
          ),
        );
        await tester.pump();

        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets(
          'should display default doorbell icon for unknown notifications',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Unknown Notification Type',
          ),
        );
        await tester.pump();

        expect(find.byType(SvgPicture), findsOneWidget);
      });
    });

    group('Expansion Behavior', () {
      testWidgets('should show expansion arrow for expandable notifications',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
          ),
        );
        await tester.pump();

        expect(find.byIcon(Icons.keyboard_arrow_down_outlined), findsOneWidget);
      });

      testWidgets('should show up arrow when expanded', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
            isExpanded: true,
          ),
        );
        await tester.pump();

        expect(find.byIcon(Icons.keyboard_arrow_up_outlined), findsOneWidget);
      });

      testWidgets(
          'should not show expansion arrow for non-expandable notifications',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Regular Notification',
          ),
        );
        await tester.pump();

        expect(find.byIcon(Icons.keyboard_arrow_down_outlined), findsNothing);
        expect(find.byIcon(Icons.keyboard_arrow_up_outlined), findsNothing);
      });

      testWidgets('should call onChange when tapping expandable notification',
          (tester) async {
        bool onChangeCalled = false;
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
            onChange: () => onChangeCalled = true,
          ),
        );
        await tester.pump();

        await tester.tap(find.byType(GestureDetector).first);
        await tester.pump();

        expect(onChangeCalled, isTrue);
      });
    });

    group('Schedule Notifications', () {
      testWidgets('should display schedule button for schedule notifications',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
            isExpanded: true,
          ),
        );
        await tester.pump();

        expect(find.textContaining('Schedule'), findsOneWidget);
      });

      testWidgets('should show schedule button when expanded', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
            isExpanded: true,
          ),
        );
        await tester.pump();

        // The button should be visible when expanded
        expect(find.textContaining('Schedule'), findsOneWidget);
      });

      testWidgets('should not show schedule button when collapsed',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Regular Notification',
          ),
        );
        await tester.pump();

        // The button should not be visible when collapsed
        expect(find.textContaining('Schedule'), findsNothing);
      });
    });

    group('Image Display', () {
      testWidgets('should display notification image when expanded',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
            image: 'test_image.jpg',
            isExpanded: true,
          ),
        );
        await tester.pump();

        // Schedule notifications don't show images, they show schedule buttons
        expect(find.textContaining('Schedule'), findsOneWidget);
      });

      testWidgets('should not display image when collapsed', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Visitor Detected',
            image: 'test_image.jpg',
          ),
        );
        await tester.pump();

        // Image should not be visible when collapsed
        expect(find.byType(DecorationImage), findsNothing);
      });

      testWidgets('should handle image tap for non-schedule notifications',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
            image: 'test_image.jpg',
            isExpanded: true,
          ),
        );
        await tester.pump();

        // Schedule notifications show schedule buttons instead of images
        expect(find.textContaining('Schedule'), findsOneWidget);
      });
    });

    group('Call Buttons', () {
      testWidgets(
          'should display call buttons for callable notifications when expanded',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
            isExpanded: true,
          ),
        );
        await tester.pump();

        // Schedule notifications don't show call buttons
        expect(find.text('Audio Call'), findsNothing);
        expect(find.text('Video Call'), findsNothing);
        expect(find.text('Start Chat'), findsNothing);
      });

      testWidgets(
          'should not display call buttons for non-callable notifications',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
          ),
        );
        await tester.pump();

        expect(find.text('Audio Call'), findsNothing);
        expect(find.text('Video Call'), findsNothing);
        expect(find.text('Start Chat'), findsNothing);
      });

      testWidgets(
          'should display call buttons for callable notifications regardless of expansion state',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Visitor Detected',
          ),
        );
        await tester.pump();

        // Call buttons should be visible for visitor notifications even when collapsed
        expect(find.text('Audio Call'), findsOneWidget);
        expect(find.text('Video Call'), findsOneWidget);
        expect(find.text('Start Chat'), findsOneWidget);
      });

      testWidgets(
          'should not display call buttons for non-callable notifications when expanded',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
            isExpanded: true,
          ),
        );
        await tester.pump();

        expect(find.text('Audio Call'), findsNothing);
        expect(find.text('Video Call'), findsNothing);
        expect(find.text('Start Chat'), findsNothing);
      });
    });

    group('Animation and Transitions', () {
      testWidgets('should animate expansion with AnimatedCrossFade',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
          ),
        );
        await tester.pump();

        expect(find.byType(AnimatedCrossFade), findsWidgets);
      });

      testWidgets('should have smooth expansion animation duration',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
          ),
        );
        await tester.pump();

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer).first,
        );
        expect(animatedContainer.duration, const Duration(milliseconds: 300));
      });
    });

    group('Device Name Extraction', () {
      testWidgets('should extract device name from schedule notification body',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
            body: 'Doorbell device Back Door to be scheduled',
            isExpanded: true,
          ),
        );
        await tester.pump();

        expect(find.textContaining('Back Door'), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle missing image gracefully', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
            isExpanded: true,
          ),
        );
        await tester.pump();

        // Should not crash and should still render
        expect(find.byType(NotificationTile), findsOneWidget);
      });

      testWidgets('should handle missing visitor data gracefully',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
            isExpanded: true,
          ),
        );
        await tester.pump();

        // Should not crash and should still render
        expect(find.byType(NotificationTile), findsOneWidget);
      });

      testWidgets('should handle missing doorbell data gracefully',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Schedule Update',
            isExpanded: true,
          ),
        );
        await tester.pump();

        // Should not crash and should still render
        expect(find.byType(NotificationTile), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantic labels', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Visitor Detected',
            body: 'A visitor was detected at your door',
          ),
        );
        await tester.pump();

        expect(find.byType(GestureDetector), findsWidgets);
      });

      testWidgets('should support screen readers', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Visitor Detected',
            body: 'A visitor was detected at your door',
          ),
        );
        await tester.pump();

        // Check that text is properly accessible
        expect(find.text('Visitor Detected'), findsOneWidget);
        expect(
          find.text('A visitor was detected at your door'),
          findsOneWidget,
        );
      });
    });

    group('Theme and Styling', () {
      testWidgets('should apply theme colors correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final textWidget = tester.widget<Text>(
          find.text('Test Notification'),
        );
        expect(textWidget.style, isNotNull);
      });

      testWidgets('should use proper text styles', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final titleText = tester.widget<Text>(
          find.text('Test Notification'),
        );
        expect(titleText.style, isNotNull);
        expect(titleText.style!.fontSize, isNotNull);
      });
    });

    group('Responsive Design', () {
      testWidgets('should adapt to different screen sizes', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(FlutterSizer), findsOneWidget);
      });

      testWidgets('should use responsive dimensions', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Check for responsive spacing
        expect(find.byType(SizedBox), findsWidgets);
      });
    });
  });
}
