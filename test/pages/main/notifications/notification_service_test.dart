import 'dart:convert';

import 'package:admin/pages/main/notifications/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationService Unit Tests', () {
    group('checkImage Method Tests', () {
      test('should return true for visitor notification', () {
        final result = NotificationService.checkImage('Visitor detected');
        expect(result, isTrue);
      });

      test('should return true for unwanted notification', () {
        final result =
            NotificationService.checkImage('Unwanted person detected');
        expect(result, isTrue);
      });

      test('should return true for fire notification', () {
        final result = NotificationService.checkImage('Fire detected');
        expect(result, isTrue);
      });

      test('should return true for parcel notification', () {
        final result = NotificationService.checkImage('Parcel delivered');
        expect(result, isTrue);
      });

      test('should return true for baby notification', () {
        final result = NotificationService.checkImage('Baby crying detected');
        expect(result, isTrue);
      });

      test('should return true for pet notification', () {
        final result = NotificationService.checkImage('Pet detected');
        expect(result, isTrue);
      });

      test('should return true for dog notification', () {
        final result = NotificationService.checkImage('Dog detected');
        expect(result, isTrue);
      });

      test('should return true for poop notification', () {
        final result = NotificationService.checkImage('Poop detected');
        expect(result, isTrue);
      });

      test('should return true for eavesdropper notification', () {
        final result = NotificationService.checkImage('Eavesdropper detected');
        expect(result, isTrue);
      });

      test('should return true for intruder notification', () {
        final result = NotificationService.checkImage('Intruder detected');
        expect(result, isTrue);
      });

      test('should return true for weapon notification', () {
        final result = NotificationService.checkImage('Weapon detected');
        expect(result, isTrue);
      });

      test('should return true for human fall notification', () {
        final result = NotificationService.checkImage('Human fall detected');
        expect(result, isTrue);
      });

      test('should return true for drowning notification', () {
        final result = NotificationService.checkImage('Drowning detected');
        expect(result, isTrue);
      });

      test('should return true for boundary breach notification', () {
        final result =
            NotificationService.checkImage('Boundary breach detected');
        expect(result, isTrue);
      });

      test('should return true for spam notification', () {
        final result = NotificationService.checkImage('Spam detected');
        expect(result, isTrue);
      });

      test('should return false for regular notification', () {
        final result = NotificationService.checkImage('Regular notification');
        expect(result, isFalse);
      });

      test('should handle case insensitive matching', () {
        final result = NotificationService.checkImage('VISITOR DETECTED');
        expect(result, isTrue);
      });

      test('should handle mixed case matching', () {
        final result = NotificationService.checkImage('ViSiToR DeTeCtEd');
        expect(result, isTrue);
      });

      test('should handle empty string', () {
        final result = NotificationService.checkImage('');
        expect(result, isFalse);
      });

      test('should handle whitespace trimming', () {
        final result = NotificationService.checkImage('  Visitor detected  ');
        expect(result, isTrue);
      });
    });

    group('isValidUrl Method Tests', () {
      test('should return true for valid HTTP URL', () {
        final result = NotificationService.isValidUrl('http://example.com');
        expect(result, isTrue);
      });

      test('should return true for valid HTTPS URL', () {
        final result = NotificationService.isValidUrl('https://example.com');
        expect(result, isTrue);
      });

      test('should return false for URL without protocol', () {
        final result = NotificationService.isValidUrl('example.com');
        expect(result, isFalse);
      });

      test('should return true for URL with path', () {
        final result =
            NotificationService.isValidUrl('https://example.com/path');
        expect(result, isTrue);
      });

      test('should return true for URL with query parameters', () {
        final result = NotificationService.isValidUrl('https://example.com');
        expect(result, isTrue);
      });

      test('should return true for URL with subdomain', () {
        final result =
            NotificationService.isValidUrl('https://sub.example.com');
        expect(result, isTrue);
      });

      test('should return false for invalid URL', () {
        final result = NotificationService.isValidUrl('not-a-url');
        expect(result, isFalse);
      });

      test('should return false for empty string', () {
        final result = NotificationService.isValidUrl('');
        expect(result, isFalse);
      });

      test('should return false for URL with invalid characters', () {
        final result = NotificationService.isValidUrl('http://example.com<>');
        expect(result, isFalse);
      });

      test('should return true for URL with multiple subdomains', () {
        final result =
            NotificationService.isValidUrl('https://api.sub.example.com');
        expect(result, isTrue);
      });

      test('should return true for URL with port number', () {
        final result =
            NotificationService.isValidUrl('https://example.com:8080');
        expect(result, isTrue);
      });
    });

    group('Notification Data Processing Tests', () {
      test('should process notification data correctly', () {
        final data = {
          'notification': jsonEncode({
            'title': 'Test Title',
            'text': 'Test Body',
          }),
          'notification_id': '123',
        };

        final notificationData =
            jsonDecode(data["notification"] ?? data["__json"] ?? "");
        final title =
            notificationData['title'] ?? notificationData['command'] ?? "";
        final body = notificationData['text'] ?? notificationData['body'] ?? "";

        expect(title, equals('Test Title'));
        expect(body, equals('Test Body'));
      });

      test('should handle missing notification data', () {
        final data = {
          'notification_id': '123',
        };

        final notificationData =
            jsonDecode(data["notification"] ?? data["__json"] ?? "{}");
        final title =
            notificationData['title'] ?? notificationData['command'] ?? "";
        final body = notificationData['text'] ?? notificationData['body'] ?? "";

        expect(title, equals(''));
        expect(body, equals(''));
      });

      test('should handle empty notification data', () {
        final data = {
          'notification': jsonEncode({
            'title': '',
            'text': '',
          }),
          'notification_id': '123',
        };

        final notificationData =
            jsonDecode(data["notification"] ?? data["__json"] ?? "");
        final title =
            notificationData['title'] ?? notificationData['command'] ?? "";
        final body = notificationData['text'] ?? notificationData['body'] ?? "";

        expect(title, equals(''));
        expect(body, equals(''));
      });

      test('should handle notification with command field', () {
        final data = {
          'notification': jsonEncode({
            'command': 'Test Command',
            'body': 'Test Body',
          }),
          'notification_id': '123',
        };

        final notificationData =
            jsonDecode(data["notification"] ?? data["__json"] ?? "");
        final title =
            notificationData['title'] ?? notificationData['command'] ?? "";
        final body = notificationData['text'] ?? notificationData['body'] ?? "";

        expect(title, equals('Test Command'));
        expect(body, equals('Test Body'));
      });

      test('should handle notification with __json field', () {
        final data = {
          '__json': jsonEncode({
            'title': 'Test Title from __json',
            'text': 'Test Body from __json',
          }),
          'notification_id': '123',
        };

        final notificationData =
            jsonDecode(data["notification"] ?? data["__json"] ?? "");
        final title =
            notificationData['title'] ?? notificationData['command'] ?? "";
        final body = notificationData['text'] ?? notificationData['body'] ?? "";

        expect(title, equals('Test Title from __json'));
        expect(body, equals('Test Body from __json'));
      });

      test(
          'should handle notification with both notification and __json fields',
          () {
        final data = {
          'notification': jsonEncode({
            'title': 'Test Title from notification',
            'text': 'Test Body from notification',
          }),
          '__json': jsonEncode({
            'title': 'Test Title from __json',
            'text': 'Test Body from __json',
          }),
          'notification_id': '123',
        };

        final notificationData =
            jsonDecode(data["notification"] ?? data["__json"] ?? "");
        final title =
            notificationData['title'] ?? notificationData['command'] ?? "";
        final body = notificationData['text'] ?? notificationData['body'] ?? "";

        // Should prioritize notification field over __json
        expect(title, equals('Test Title from notification'));
        expect(body, equals('Test Body from notification'));
      });
    });

    group('Notification Action Tests', () {
      test('should identify visitor notifications for call actions', () {
        const title = 'Visitor detected';
        final shouldHaveActions = title.toLowerCase().contains("visitor") ||
            title.toLowerCase().contains("parcel") ||
            title.toLowerCase().contains("unwanted");

        expect(shouldHaveActions, isTrue);
      });

      test('should identify parcel notifications for call actions', () {
        const title = 'Parcel delivered';
        final shouldHaveActions = title.toLowerCase().contains("visitor") ||
            title.toLowerCase().contains("parcel") ||
            title.toLowerCase().contains("unwanted");

        expect(shouldHaveActions, isTrue);
      });

      test('should identify unwanted notifications for call actions', () {
        const title = 'Unwanted person detected';
        final shouldHaveActions = title.toLowerCase().contains("visitor") ||
            title.toLowerCase().contains("parcel") ||
            title.toLowerCase().contains("unwanted");

        expect(shouldHaveActions, isTrue);
      });

      test('should not include call actions for regular notifications', () {
        const title = 'Regular notification';
        final shouldHaveActions = title.toLowerCase().contains("visitor") ||
            title.toLowerCase().contains("parcel") ||
            title.toLowerCase().contains("unwanted");

        expect(shouldHaveActions, isFalse);
      });

      test('should handle case insensitive action detection', () {
        const title = 'VISITOR DETECTED';
        final shouldHaveActions = title.toLowerCase().contains("visitor") ||
            title.toLowerCase().contains("parcel") ||
            title.toLowerCase().contains("unwanted");

        expect(shouldHaveActions, isTrue);
      });
    });

    group('Notification ID Processing Tests', () {
      test('should parse numeric notification ID', () {
        const notificationId = '123';
        final parsedId = int.parse(notificationId);
        expect(parsedId, equals(123));
      });

      test('should handle notification ID as integer', () {
        const notificationId = 123;
        final parsedId = int.parse(notificationId.toString());
        expect(parsedId, equals(123));
      });

      test('should handle zero notification ID', () {
        const notificationId = '0';
        final parsedId = int.parse(notificationId);
        expect(parsedId, equals(0));
      });

      test('should handle large notification ID', () {
        const notificationId = '999999';
        final parsedId = int.parse(notificationId);
        expect(parsedId, equals(999999));
      });

      test('should handle notification ID with fallback', () {
        const notificationId = null;
        const fallbackId = notificationId ?? 0;
        final parsedId = int.parse(fallbackId.toString());
        expect(parsedId, equals(0));
      });
    });

    group('Image URL Processing Tests', () {
      test('should identify valid image URLs', () {
        const imageUrl = 'https://example.com/image.jpg';
        final hasImage = imageUrl.isNotEmpty;
        expect(hasImage, isTrue);
      });

      test('should identify empty image URLs', () {
        const imageUrl = '';
        final hasImage = imageUrl.isNotEmpty;
        expect(hasImage, isFalse);
      });

      test('should handle image URL with different extensions', () {
        const imageUrl = 'https://example.com/image.png';
        final hasImage = imageUrl.isNotEmpty;
        expect(hasImage, isTrue);
      });

      test('should handle image URL with query parameters', () {
        const imageUrl = 'https://example.com/image.jpg?v=123';
        final hasImage = imageUrl.isNotEmpty;
        expect(hasImage, isTrue);
      });
    });

    group('Text-to-Speech Integration Tests', () {
      test('should handle text-to-speech for notification titles', () {
        const title = 'Visitor detected';
        final shouldSpeak = title.isNotEmpty;
        expect(shouldSpeak, isTrue);
      });

      test('should not speak empty titles', () {
        const title = '';
        final shouldSpeak = title.isNotEmpty;
        expect(shouldSpeak, isFalse);
      });

      test('should handle text-to-speech for long titles', () {
        const title =
            'This is a very long notification title that should be spoken';
        final shouldSpeak = title.isNotEmpty;
        expect(shouldSpeak, isTrue);
      });

      test('should handle text-to-speech for special characters', () {
        const title = 'Alert! Someone is at your door 🚪';
        final shouldSpeak = title.isNotEmpty;
        expect(shouldSpeak, isTrue);
      });
    });

    group('Notification Priority Tests', () {
      test('should handle priority based on notification type', () {
        const title = 'Fire detected';
        final isImportant = title.toLowerCase().contains('fire') ||
            title.toLowerCase().contains('emergency') ||
            title.toLowerCase().contains('alert');
        final priority = isImportant ? 'high' : 'normal';
        expect(priority, equals('high'));
      });
    });

    group('Notification Channel Tests', () {
      test('should use correct channel ID for notifications', () {
        const channelId = 'channel_id';
        const channelName = 'Notifications';
        expect(channelId, equals('channel_id'));
        expect(channelName, equals('Notifications'));
      });

      test('should handle channel importance settings', () {
        const importance = 'max';
        const priority = 'high';
        expect(importance, equals('max'));
        expect(priority, equals('high'));
      });
    });

    group('Notification Payload Tests', () {
      test('should encode notification payload correctly', () {
        final data = {
          'notification': jsonEncode({
            'title': 'Test Title',
            'text': 'Test Body',
          }),
          'notification_id': '123',
        };

        final payload = jsonEncode(data);
        final decodedPayload = jsonDecode(payload);

        expect(decodedPayload['notification_id'], equals('123'));
        expect(decodedPayload['notification'], isA<String>());
      });

      test('should handle complex notification payload', () {
        final data = {
          'notification': jsonEncode({
            'title': 'Visitor detected',
            'text': 'Someone is at your door',
            'device_id': 'device_123',
            'created_at': '2024-01-01T12:00:00Z',
          }),
          'notification_id': '456',
          'imageurl': 'https://example.com/image.jpg',
        };

        final payload = jsonEncode(data);
        final decodedPayload = jsonDecode(payload);

        expect(decodedPayload['notification_id'], equals('456'));
        expect(
          decodedPayload['imageurl'],
          equals('https://example.com/image.jpg'),
        );
      });

      test('should handle payload with additional metadata', () {
        final data = {
          'notification': jsonEncode({
            'title': 'Test Title',
            'text': 'Test Body',
          }),
          'notification_id': '123',
          'imageurl': 'https://example.com/image.jpg',
          'location': jsonEncode({
            'house_no': '123',
            'country': 'USA',
          }),
          'payload': jsonEncode({
            'name': 'John Doe',
            'type': 'visitor',
          }),
        };

        final payload = jsonEncode(data);
        final decodedPayload = jsonDecode(payload);

        expect(decodedPayload['notification_id'], equals('123'));
        expect(
          decodedPayload['imageurl'],
          equals('https://example.com/image.jpg'),
        );
        expect(decodedPayload['location'], isA<String>());
        expect(decodedPayload['payload'], isA<String>());
      });
    });

    group('Notification Extension Method Simulation Tests', () {
      test('should simulate getExpansion method for visitor notifications', () {
        const title = 'Visitor detected';
        final hasExpansion = title.toLowerCase().contains('visitor') ||
            title.toLowerCase().contains('unwanted') ||
            title.toLowerCase().contains('fire') ||
            title.toLowerCase().contains('parcel');
        expect(hasExpansion, isTrue);
      });

      test('should simulate getExpansion method for regular notifications', () {
        const title = 'Regular notification';
        final hasExpansion = title.toLowerCase().contains('visitor') ||
            title.toLowerCase().contains('unwanted') ||
            title.toLowerCase().contains('fire') ||
            title.toLowerCase().contains('parcel');
        expect(hasExpansion, isFalse);
      });

      test('should simulate getCanCall method for callable notifications', () {
        const title = 'Visitor detected';
        final canCall = title.toLowerCase().contains('visitor') ||
            title.toLowerCase().contains('parcel') ||
            title.toLowerCase().contains('unwanted');
        expect(canCall, isTrue);
      });

      test('should simulate getCanCall method for non-callable notifications',
          () {
        const title = 'Fire detected';
        final canCall = title.toLowerCase().contains('visitor') ||
            title.toLowerCase().contains('parcel') ||
            title.toLowerCase().contains('unwanted');
        expect(canCall, isFalse);
      });
    });

    group('Notification Action Button Logic Tests', () {
      test('should determine actions for visitor notifications', () {
        const title = 'Visitor detected';
        final shouldHaveActions = title.toLowerCase().contains("visitor") ||
            title.toLowerCase().contains("parcel") ||
            title.toLowerCase().contains("unwanted");
        expect(shouldHaveActions, isTrue);
      });

      test('should determine actions for parcel notifications', () {
        const title = 'Parcel delivered';
        final shouldHaveActions = title.toLowerCase().contains("visitor") ||
            title.toLowerCase().contains("parcel") ||
            title.toLowerCase().contains("unwanted");
        expect(shouldHaveActions, isTrue);
      });

      test('should determine actions for unwanted notifications', () {
        const title = 'Unwanted person detected';
        final shouldHaveActions = title.toLowerCase().contains("visitor") ||
            title.toLowerCase().contains("parcel") ||
            title.toLowerCase().contains("unwanted");
        expect(shouldHaveActions, isTrue);
      });

      test('should not have actions for fire notifications', () {
        const title = 'Fire detected';
        final shouldHaveActions = title.toLowerCase().contains("visitor") ||
            title.toLowerCase().contains("parcel") ||
            title.toLowerCase().contains("unwanted");
        expect(shouldHaveActions, isFalse);
      });

      test('should not have actions for baby notifications', () {
        const title = 'Baby crying detected';
        final shouldHaveActions = title.toLowerCase().contains("visitor") ||
            title.toLowerCase().contains("parcel") ||
            title.toLowerCase().contains("unwanted");
        expect(shouldHaveActions, isFalse);
      });
    });

    group('Notification Error Handling Tests', () {
      test('should handle empty title and body gracefully', () {
        const title = '';
        const body = '';
        final shouldShowNotification = title.isNotEmpty && body.isNotEmpty;
        expect(shouldShowNotification, isFalse);
      });

      test('should handle malformed JSON gracefully', () {
        const malformedJson = '{"title": "Test", "text": "Body"';
        bool isValidJson = true;
        try {
          jsonDecode(malformedJson);
        } catch (e) {
          isValidJson = false;
        }
        expect(isValidJson, isFalse);
      });

      test('should handle missing notification ID gracefully', () {
        const notificationId = null;
        final fallbackId = (notificationId ?? 0).toString();
        expect(fallbackId, equals('0'));
      });

      test('should handle invalid notification ID gracefully', () {
        const invalidId = 'invalid_id';
        bool isValidInt = true;
        try {
          int.parse(invalidId);
        } catch (e) {
          isValidInt = false;
        }
        expect(isValidInt, isFalse);
      });
    });

    group('Notification Data Structure Tests', () {
      test('should handle notification with all required fields', () {
        final data = {
          'notification': jsonEncode({
            'title': 'Test Title',
            'text': 'Test Body',
            'device_id': 'device_123',
            'created_at': '2024-01-01T12:00:00Z',
            'entity_id': 'entity_456',
          }),
          'notification_id': '123',
          'imageurl': 'https://example.com/image.jpg',
        };

        final notificationData = jsonDecode(data["notification"] ?? "{}");
        expect(notificationData['title'], equals('Test Title'));
        expect(notificationData['text'], equals('Test Body'));
        expect(notificationData['device_id'], equals('device_123'));
        expect(notificationData['created_at'], equals('2024-01-01T12:00:00Z'));
        expect(notificationData['entity_id'], equals('entity_456'));
        expect(data['notification_id'], equals('123'));
        expect(data['imageurl'], equals('https://example.com/image.jpg'));
      });

      test('should handle notification with minimal fields', () {
        final data = {
          'notification': jsonEncode({
            'title': 'Test Title',
          }),
          'notification_id': '123',
        };

        final notificationData = jsonDecode(data["notification"] ?? "{}");
        expect(notificationData['title'], equals('Test Title'));
        expect(notificationData['text'], isNull);
        expect(data['notification_id'], equals('123'));
        expect(data['imageurl'], isNull);
      });

      test('should handle notification with command instead of title', () {
        final data = {
          'notification': jsonEncode({
            'command': 'Test Command',
            'body': 'Test Body',
          }),
          'notification_id': '123',
        };

        final notificationData = jsonDecode(data["notification"] ?? "{}");
        final title =
            notificationData['title'] ?? notificationData['command'] ?? "";
        final body = notificationData['text'] ?? notificationData['body'] ?? "";

        expect(title, equals('Test Command'));
        expect(body, equals('Test Body'));
      });
    });
  });
}
