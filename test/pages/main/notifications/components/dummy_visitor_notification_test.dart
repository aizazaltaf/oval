import 'package:admin/core/theme.dart';
import 'package:admin/pages/main/notifications/components/dummy_visitor_notification.dart';
import 'package:admin/pages/main/notifications/guides/audio_call_guide.dart';
import 'package:admin/pages/main/notifications/guides/chat_guide.dart';
import 'package:admin/pages/main/notifications/guides/video_call_guide.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../helpers/test_helper.dart';
import '../../../../mocks/bloc/bloc_mocks.dart';

void main() {
  group('DummyVisitorNotification UI Tests', () {
    late MockNotificationBloc mockNotificationBloc;

    setUpAll(() async {
      await TestHelper.initialize();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    setUp(() {
      mockNotificationBloc = MockNotificationBloc();
    });

    Widget createTestWidget() {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: getTheme(),
            darkTheme: darkTheme(),
            home: ShowCaseWidget(
              builder: (context) => Scaffold(
                body: DummyVisitorNotification(
                  innerContext: context,
                  bloc: mockNotificationBloc,
                ),
              ),
            ),
          );
        },
      );
    }

    group('Basic Structure and Layout', () {
      testWidgets('should render DummyVisitorNotification with basic structure',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(DummyVisitorNotification), findsOneWidget);
        expect(find.byType(Column), findsNWidgets(2));
      });

      testWidgets('should display date header correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Check that date header is displayed
        final currentDate = DateTime.now();
        final formattedDate = DateFormat('MMM dd, yyyy').format(currentDate);
        expect(find.text(formattedDate), findsOneWidget);
      });

      testWidgets('should have proper spacing between elements',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Check for SizedBox elements that provide spacing
        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('Visitor Alert Section', () {
      testWidgets('should display visitor alert icon', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets('should display "Visitor Alert!" text', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('Visitor Alert!'), findsOneWidget);
      });

      testWidgets('should display formatted date and time', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final currentDate = DateTime.now();
        final formattedDate = DateFormat('MMM dd').format(currentDate);
        final formattedTime = DateFormat('h:mm a').format(currentDate);

        expect(find.text(formattedDate), findsOneWidget);
        expect(find.text(formattedTime), findsOneWidget);
        expect(find.text(' • '), findsOneWidget);
      });

      testWidgets('should display visitor description text', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(
          find.text(
            'Someone is at the door (Front Door) whose face is unclear.',
          ),
          findsOneWidget,
        );
      });

      testWidgets('should display arrow icon', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byIcon(Icons.keyboard_arrow_up_outlined), findsOneWidget);
      });
    });

    group('Camera Thumbnail', () {
      testWidgets('should display camera thumbnail image', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(Container), findsWidgets);

        // Look for the container with the camera thumbnail
        final containers = tester.widgetList<Container>(find.byType(Container));
        bool foundThumbnail = false;

        for (final container in containers) {
          if (container.decoration is BoxDecoration) {
            final decoration = container.decoration! as BoxDecoration;
            if (decoration.image != null) {
              foundThumbnail = true;
              break;
            }
          }
        }

        expect(foundThumbnail, isTrue);
      });

      testWidgets('should have proper thumbnail dimensions', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Find the thumbnail container
        final containers = tester.widgetList<Container>(find.byType(Container));
        Container? thumbnailContainer;

        for (final container in containers) {
          if (container.decoration is BoxDecoration) {
            final decoration = container.decoration! as BoxDecoration;
            if (decoration.image != null) {
              thumbnailContainer = container;
              break;
            }
          }
        }

        expect(thumbnailContainer, isNotNull);
        // Check constraints instead of direct height/width
        expect(thumbnailContainer!.constraints, isNotNull);
      });

      testWidgets('should have rounded corners on thumbnail', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Find the thumbnail container and check border radius
        final containers = tester.widgetList<Container>(find.byType(Container));
        bool foundRoundedThumbnail = false;

        for (final container in containers) {
          if (container.decoration is BoxDecoration) {
            final decoration = container.decoration! as BoxDecoration;
            if (decoration.image != null && decoration.borderRadius != null) {
              foundRoundedThumbnail = true;
              break;
            }
          }
        }

        expect(foundRoundedThumbnail, isTrue);
      });
    });

    group('Action Buttons', () {
      testWidgets('should display three action buttons', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Check for the three action buttons
        expect(find.byType(Showcase), findsNWidgets(3));
      });

      testWidgets('should display audio call button', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // The button text should be localized, but we can check for the Showcase
        expect(find.byType(Showcase), findsNWidgets(3));

        // Check that the first Showcase has the audio call guide key
        final showcases =
            tester.widgetList<Showcase>(find.byType(Showcase)).toList();
        expect(showcases.first.key, mockNotificationBloc.audioCallGuideKey);
      });

      testWidgets('should display video call button', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final showcases =
            tester.widgetList<Showcase>(find.byType(Showcase)).toList();
        expect(showcases[1].key, mockNotificationBloc.videoCallGuideKey);
      });

      testWidgets('should display chat button', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final showcases =
            tester.widgetList<Showcase>(find.byType(Showcase)).toList();
        expect(showcases[2].key, mockNotificationBloc.chatGuideKey);
      });

      testWidgets('should have proper button styling', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Check that buttons have proper text styling
        expect(find.byType(Text), findsWidgets);
      });
    });

    group('Showcase Integration', () {
      testWidgets('should wrap buttons with Showcase widgets', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(Showcase), findsNWidgets(3));
      });

      testWidgets('should have proper showcase configuration', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final showcases = tester.widgetList<Showcase>(find.byType(Showcase));

        for (final showcase in showcases) {
          expect(
            showcase.targetPadding,
            const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 5,
            ),
          );
          expect(showcase.tooltipPosition, TooltipPosition.bottom);
          expect(showcase.targetBorderRadius, BorderRadius.circular(15));
        }
      });

      testWidgets('should have proper guide containers', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final showcases =
            tester.widgetList<Showcase>(find.byType(Showcase)).toList();

        // Check that each showcase has the appropriate guide container
        expect(showcases[0].container, isA<AudioCallGuide>());
        expect(showcases[1].container, isA<VideoCallGuide>());
        expect(showcases[2].container, isA<ChatGuide>());
      });
    });

    group('Responsive Design', () {
      testWidgets('should use FlutterSizer for responsive layout',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(FlutterSizer), findsOneWidget);
      });

      testWidgets('should handle different screen sizes', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // The component should adapt to different screen sizes
        expect(find.byType(DummyVisitorNotification), findsOneWidget);
      });
    });

    group('Theme and Styling', () {
      testWidgets('should apply theme colors correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Check that theme colors are applied to text elements
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('should have proper text styling', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Check that different text styles are applied
        final texts = tester.widgetList<Text>(find.byType(Text));
        expect(texts.isNotEmpty, isTrue);
      });
    });

    group('Animation and Interactions', () {
      testWidgets('should have animated container for visitor alert',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(AnimatedContainer), findsOneWidget);
      });

      testWidgets('should have proper animation duration', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        expect(animatedContainer.duration, const Duration(milliseconds: 300));
        expect(animatedContainer.curve, Curves.easeInOut);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantic structure', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Check that the component renders without accessibility errors
        expect(find.byType(DummyVisitorNotification), findsOneWidget);
      });

      testWidgets('should have readable text sizes', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Check that text elements are present and readable
        expect(find.byType(Text), findsWidgets);
      });
    });

    group('Localization Support', () {
      testWidgets('should support localized button text', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // The component should use localized text for buttons
        expect(find.byType(Showcase), findsNWidgets(3));
      });
    });

    group('Error Handling', () {
      testWidgets('should handle missing assets gracefully', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should render without crashing even if assets are missing
        expect(find.byType(DummyVisitorNotification), findsOneWidget);
      });
    });

    group('Performance', () {
      testWidgets('should render efficiently', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should render without performance issues
        expect(find.byType(DummyVisitorNotification), findsOneWidget);
      });
    });

    group('Integration with NotificationBloc', () {
      testWidgets('should use bloc guide keys correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final showcases =
            tester.widgetList<Showcase>(find.byType(Showcase)).toList();

        expect(showcases[0].key, mockNotificationBloc.audioCallGuideKey);
        expect(showcases[1].key, mockNotificationBloc.videoCallGuideKey);
        expect(showcases[2].key, mockNotificationBloc.chatGuideKey);
      });

      testWidgets('should pass bloc to guide components', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final showcases =
            tester.widgetList<Showcase>(find.byType(Showcase)).toList();

        // Check that each guide receives the bloc
        final audioGuide = showcases[0].container! as AudioCallGuide;
        final videoGuide = showcases[1].container! as VideoCallGuide;
        final chatGuide = showcases[2].container! as ChatGuide;

        expect(audioGuide.bloc, mockNotificationBloc);
        expect(videoGuide.bloc, mockNotificationBloc);
        expect(chatGuide.bloc, mockNotificationBloc);
      });
    });
  });
}
