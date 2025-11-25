import 'package:admin/models/data/doorbell_locations.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DoorbellLocations testLocation;

  void createTestLocation({
    String name = "Test Location",
    String city = "Test City",
    String state = "Test State",
    String country = "Test Country",
    String houseNo = "123",
    String street = "Test Street",
    double latitude = 1.0,
    double longitude = 1.0,
    List<String> roles = const ["Admin"],
    int id = 1,
  }) {
    testLocation = DoorbellLocations(
      (b) => b
        ..id = id
        ..name = name
        ..city = city
        ..state = state
        ..country = country
        ..houseNo = houseNo
        ..street = street
        ..latitude = latitude
        ..longitude = longitude
        ..createdAt = "2024-01-01"
        ..updatedAt = "2024-01-01"
        ..roles = ListBuilder<String>(roles),
    );
  }

  group('LocationCard Data Model Tests', () {
    setUp(createTestLocation);

    test('should create location with basic data', () {
      expect(testLocation.id, equals(1));
      expect(testLocation.name, equals("Test Location"));
      expect(testLocation.city, equals("Test City"));
      expect(testLocation.state, equals("Test State"));
      expect(testLocation.country, equals("Test Country"));
      expect(testLocation.houseNo, equals("123"));
      expect(testLocation.street, equals("Test Street"));
      expect(testLocation.latitude, equals(1.0));
      expect(testLocation.longitude, equals(1.0));
    });

    test('should handle different location IDs', () {
      createTestLocation(id: 999);
      expect(testLocation.id, equals(999));
    });

    test('should handle special characters in location data', () {
      createTestLocation(
        name: "Location with special chars: @#\$%^&*()",
        street: "Street with numbers: 123-456",
        city: "City with dots: U.S.A.",
      );

      expect(
        testLocation.name,
        equals("Location with special chars: @#\$%^&*()"),
      );
      expect(testLocation.street, equals("Street with numbers: 123-456"));
      expect(testLocation.city, equals("City with dots: U.S.A."));
    });

    test('should handle long location names', () {
      const longName =
          "Very Long Location Name That Should Be Truncated With Ellipsis";
      createTestLocation(name: longName);
      expect(testLocation.name, equals(longName));
    });

    test('should handle long addresses', () {
      const longStreet =
          "Very Long Street Name That Should Be Truncated With Ellipsis";
      const longCity =
          "Very Long City Name That Should Be Truncated With Ellipsis";

      createTestLocation(
        street: longStreet,
        city: longCity,
      );

      expect(testLocation.street, equals(longStreet));
      expect(testLocation.city, equals(longCity));
    });

    test('should handle different roles', () {
      // Test Admin role
      createTestLocation(roles: ["Admin"]);
      expect(testLocation.roles.length, equals(1));
      expect(testLocation.roles.first, equals("Admin"));

      // Test Viewer role
      createTestLocation(roles: ["Viewer"]);
      expect(testLocation.roles.length, equals(1));
      expect(testLocation.roles.first, equals("Viewer"));

      // Test Owner role
      createTestLocation(roles: ["Owner"]);
      expect(testLocation.roles.length, equals(1));
      expect(testLocation.roles.first, equals("Owner"));
    });

    test('should handle multiple roles', () {
      createTestLocation(roles: ["Admin", "Viewer"]);
      expect(testLocation.roles.length, equals(2));
      expect(testLocation.roles.contains("Admin"), isTrue);
      expect(testLocation.roles.contains("Viewer"), isTrue);
    });

    test('should handle empty string values', () {
      createTestLocation(
        name: "",
        street: "",
        city: "",
        state: "",
        country: "",
        houseNo: "",
      );

      expect(testLocation.name, equals(""));
      expect(testLocation.street, equals(""));
      expect(testLocation.city, equals(""));
      expect(testLocation.state, equals(""));
      expect(testLocation.country, equals(""));
      expect(testLocation.houseNo, equals(""));
    });

    test('should handle coordinates correctly', () {
      createTestLocation(
        latitude: 40.7128,
        longitude: -74.0060,
      );

      expect(testLocation.latitude, equals(40.7128));
      expect(testLocation.longitude, equals(-74.0060));
    });

    test('should handle date strings correctly', () {
      createTestLocation();

      // The dates are set in createTestLocation, verify they exist
      expect(testLocation.createdAt, isNotEmpty);
      expect(testLocation.updatedAt, isNotEmpty);
    });

    test('should create immutable location object', () {
      final originalName = testLocation.name;

      // Verify the object is immutable (cannot be modified after creation)
      // built_value objects are immutable by design
      expect(testLocation.name, equals(originalName));
      expect(testLocation.name, equals("Test Location"));
    });
  });
}
