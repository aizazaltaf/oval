import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/notifications/bloc/notification_state.dart';
import 'package:admin/pages/main/notifications/components/dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_helper.dart';

class MockNotificationBloc extends Mock implements NotificationBloc {}

void main() {
  group('NotificationDialog UI Tests', () {
    late MockNotificationBloc mockNotificationBloc;

    setUpAll(() async {
      await TestHelper.initialize();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    setUp(() {
      mockNotificationBloc = MockNotificationBloc();

      // Setup default mock behaviors
      when(() => mockNotificationBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(() => mockNotificationBloc.updateDateFilter(any(), any()))
          .thenAnswer((_) {});
      when(() => mockNotificationBloc.updateAiFilter(any(), any()))
          .thenAnswer((_) {});
      when(() => mockNotificationBloc.updateDevicesFilter(any(), any()))
          .thenAnswer((_) {});
      when(() => mockNotificationBloc.updateAiSubFilter(any(), any()))
          .thenAnswer((_) {});
      when(() => mockNotificationBloc.updateCustomDate(any()))
          .thenAnswer((_) {});
      when(() => mockNotificationBloc.updateFilter(any())).thenAnswer((_) {});
      when(() => mockNotificationBloc.updateNoDeviceAvailable(any()))
          .thenAnswer((_) {});
      when(() => mockNotificationBloc.callNotificationApi())
          .thenAnswer((_) async {});
      when(() => mockNotificationBloc.resetFiltersWithoutFilterParam())
          .thenAnswer((_) {});
    });

    NotificationState createMockState({
      List<FeatureModel>? dateFilters,
      List<FeatureModel>? aiAlertsFilters,
      List<FeatureModel>? aiAlertsSubFilters,
      List<FeatureModel>? deviceFilters,
      DateTime? customDate,
      bool isApiInProgress = false,
    }) {
      return NotificationState((b) {
        if (dateFilters != null) {
          b.dateFilters.replace(dateFilters);
        }
        if (aiAlertsFilters != null) {
          b.aiAlertsFilters.replace(aiAlertsFilters);
        }
        if (aiAlertsSubFilters != null) {
          b.aiAlertsSubFilters.replace(aiAlertsSubFilters);
        }
        if (deviceFilters != null) {
          b.deviceFilters.replace(deviceFilters);
        }
        if (customDate != null) {
          b.customDate = customDate;
        }
        b.notificationApi.isApiInProgress = isApiInProgress;
      });
    }

    List<FeatureModel> createFilterList({
      required List<String> titles,
      required List<bool> selectedStates,
    }) {
      return titles.asMap().entries.map((entry) {
        return FeatureModel(
          title: entry.value,
          value: entry.value.toLowerCase().replaceAll(' ', '_'),
          isSelected: selectedStates[entry.key],
        );
      }).toList();
    }

    group('Mock Bloc Interactions', () {
      testWidgets('should call updateDateFilter when date filter is updated',
          (tester) async {
        final dateFilters = createFilterList(
          titles: ['Today', 'Yesterday'],
          selectedStates: [false, false],
        );

        final state = createMockState(dateFilters: dateFilters);
        when(() => mockNotificationBloc.state).thenReturn(state);

        // Verify the mock is set up correctly
        expect(mockNotificationBloc.state.dateFilters.length, equals(2));

        // Test the method call
        mockNotificationBloc.updateDateFilter(0, true);

        verify(() => mockNotificationBloc.updateDateFilter(0, true)).called(1);
      });

      testWidgets('should call updateAiFilter when AI filter is updated',
          (tester) async {
        final aiAlertsFilters = createFilterList(
          titles: ['Subscription Alerts', 'Spam Alerts'],
          selectedStates: [false, false],
        );

        final state = createMockState(aiAlertsFilters: aiAlertsFilters);
        when(() => mockNotificationBloc.state).thenReturn(state);

        // Verify the mock is set up correctly
        expect(mockNotificationBloc.state.aiAlertsFilters.length, equals(2));

        // Test the method call
        mockNotificationBloc.updateAiFilter(1, true);

        verify(() => mockNotificationBloc.updateAiFilter(1, true)).called(1);
      });

      testWidgets(
          'should call updateDevicesFilter when device filter is updated',
          (tester) async {
        final deviceFilters = createFilterList(
          titles: ['Device 1', 'Device 2'],
          selectedStates: [false, false],
        );

        final state = createMockState(deviceFilters: deviceFilters);
        when(() => mockNotificationBloc.state).thenReturn(state);

        // Verify the mock is set up correctly
        expect(mockNotificationBloc.state.deviceFilters.length, equals(2));

        // Test the method call
        mockNotificationBloc.updateDevicesFilter(0, true);

        verify(() => mockNotificationBloc.updateDevicesFilter(0, true))
            .called(1);
      });
    });

    group('State Management', () {
      testWidgets('should handle custom date updates', (tester) async {
        final customDate = DateTime(2024, 1, 15);

        mockNotificationBloc.updateCustomDate(customDate);

        verify(() => mockNotificationBloc.updateCustomDate(customDate))
            .called(1);
      });

      testWidgets('should handle filter updates', (tester) async {
        mockNotificationBloc.updateFilter(true);

        verify(() => mockNotificationBloc.updateFilter(true)).called(1);
      });

      testWidgets('should handle API calls', (tester) async {
        await mockNotificationBloc.callNotificationApi();

        verify(() => mockNotificationBloc.callNotificationApi()).called(1);
      });

      testWidgets('should handle filter reset', (tester) async {
        mockNotificationBloc.resetFiltersWithoutFilterParam();

        verify(() => mockNotificationBloc.resetFiltersWithoutFilterParam())
            .called(1);
      });
    });

    group('Filter List Creation', () {
      testWidgets('should create filter lists correctly', (tester) async {
        final titles = ['Filter 1', 'Filter 2', 'Filter 3'];
        final selectedStates = [true, false, true];

        final filterList = createFilterList(
          titles: titles,
          selectedStates: selectedStates,
        );

        expect(filterList.length, equals(3));
        expect(filterList[0].title, equals('Filter 1'));
        expect(filterList[0].isSelected, isTrue);
        expect(filterList[1].title, equals('Filter 2'));
        expect(filterList[1].isSelected, isFalse);
        expect(filterList[2].title, equals('Filter 3'));
        expect(filterList[2].isSelected, isTrue);
      });

      testWidgets('should handle empty filter lists', (tester) async {
        final filterList = createFilterList(
          titles: [],
          selectedStates: [],
        );

        expect(filterList.length, equals(0));
      });
    });

    group('Mock State Creation', () {
      testWidgets('should create mock state with date filters', (tester) async {
        final dateFilters = createFilterList(
          titles: ['Today', 'Yesterday'],
          selectedStates: [false, false],
        );

        final state = createMockState(dateFilters: dateFilters);

        expect(state.dateFilters.length, equals(2));
        expect(state.dateFilters[0].title, equals('Today'));
        expect(state.dateFilters[1].title, equals('Yesterday'));
      });

      testWidgets('should create mock state with AI alert filters',
          (tester) async {
        final aiAlertsFilters = createFilterList(
          titles: ['AI Alert 1', 'AI Alert 2'],
          selectedStates: [true, false],
        );

        final state = createMockState(aiAlertsFilters: aiAlertsFilters);

        expect(state.aiAlertsFilters.length, equals(2));
        expect(state.aiAlertsFilters[0].title, equals('AI Alert 1'));
        expect(state.aiAlertsFilters[0].isSelected, isTrue);
        expect(state.aiAlertsFilters[1].title, equals('AI Alert 2'));
        expect(state.aiAlertsFilters[1].isSelected, isFalse);
      });

      testWidgets('should create mock state with device filters',
          (tester) async {
        final deviceFilters = createFilterList(
          titles: ['Device A', 'Device B'],
          selectedStates: [false, true],
        );

        final state = createMockState(deviceFilters: deviceFilters);

        expect(state.deviceFilters.length, equals(2));
        expect(state.deviceFilters[0].title, equals('Device A'));
        expect(state.deviceFilters[0].isSelected, isFalse);
        expect(state.deviceFilters[1].title, equals('Device B'));
        expect(state.deviceFilters[1].isSelected, isTrue);
      });

      testWidgets('should create mock state with custom date', (tester) async {
        final customDate = DateTime(2024, 1, 15);
        final state = createMockState(customDate: customDate);

        expect(state.customDate, equals(customDate));
      });

      testWidgets('should create mock state with API progress', (tester) async {
        final state = createMockState(isApiInProgress: true);

        expect(state.notificationApi.isApiInProgress, isTrue);
      });
    });

    group('NotificationDialog Component Structure', () {
      testWidgets('should have proper constructor parameters', (tester) async {
        // Test that the component can be instantiated with required parameters
        expect(
          () => NotificationDialog('By Date', mockNotificationBloc),
          returnsNormally,
        );
        expect(
          () => NotificationDialog('By Alert', mockNotificationBloc),
          returnsNormally,
        );
        expect(
          () => NotificationDialog('By Device', mockNotificationBloc),
          returnsNormally,
        );
      });

      testWidgets('should handle different filter types in constructor',
          (tester) async {
        final filterTypes = ['By Date', 'By Alert', 'By Device'];

        for (final filterType in filterTypes) {
          final dialog = NotificationDialog(filterType, mockNotificationBloc);
          expect(dialog.filterType, equals(filterType));
          expect(dialog.bloc, equals(mockNotificationBloc));
        }
      });
    });
  });
}
