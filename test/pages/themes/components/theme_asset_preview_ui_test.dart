import 'package:admin/pages/themes/componenets/theme_asset_preview.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helper.dart';

void main() {
  setUpAll(() async {
    await TestHelper.initialize();
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
  });

  group('ThemeAssetPreview Widget Tests', () {
    group('Widget Properties and Structure', () {
      test('should have correct constructor parameters', () {
        const testPath = 'test_video.mp4';
        const testWidth = 200.0;
        const isNetwork = true;
        const uploadPreview = false;

        const themeAssetPreview = ThemeAssetPreview(
          path: testPath,
          width: testWidth,
          isNetwork: isNetwork,
        );

        expect(themeAssetPreview.path, equals(testPath));
        expect(themeAssetPreview.width, equals(testWidth));
        expect(themeAssetPreview.isNetwork, equals(isNetwork));
        expect(themeAssetPreview.uploadPreview, equals(uploadPreview));
      });

      test('should handle null width parameter', () {
        const testPath = 'test_image.jpg';
        const isNetwork = false;
        const uploadPreview = true;

        const themeAssetPreview = ThemeAssetPreview(
          path: testPath,
          isNetwork: isNetwork,
          uploadPreview: uploadPreview,
        );

        expect(themeAssetPreview.path, equals(testPath));
        expect(themeAssetPreview.width, isNull);
        expect(themeAssetPreview.isNetwork, equals(isNetwork));
        expect(themeAssetPreview.uploadPreview, equals(uploadPreview));
      });

      test('should handle zero width parameter', () {
        const testPath = 'test_image.png';
        const testWidth = 0.0;
        const isNetwork = true;
        const uploadPreview = false;

        const themeAssetPreview = ThemeAssetPreview(
          path: testPath,
          width: testWidth,
          isNetwork: isNetwork,
        );

        expect(themeAssetPreview.path, equals(testPath));
        expect(themeAssetPreview.width, equals(testWidth));
        expect(themeAssetPreview.isNetwork, equals(isNetwork));
        expect(themeAssetPreview.uploadPreview, equals(uploadPreview));
      });

      test('should handle empty path', () {
        const testPath = '';
        const isNetwork = false;
        const uploadPreview = false;

        const themeAssetPreview = ThemeAssetPreview(
          path: testPath,
          isNetwork: isNetwork,
        );

        expect(themeAssetPreview.path, equals(testPath));
        expect(themeAssetPreview.isNetwork, equals(isNetwork));
        expect(themeAssetPreview.uploadPreview, equals(uploadPreview));
      });
    });

    group('Parameter Combinations', () {
      test('should handle different uploadPreview values', () {
        const testPath = 'test_image.jpg';
        const isNetwork = false;
        final uploadPreviewValues = [true, false];

        for (final uploadPreview in uploadPreviewValues) {
          final themeAssetPreview = ThemeAssetPreview(
            path: testPath,
            isNetwork: isNetwork,
            uploadPreview: uploadPreview,
          );

          expect(themeAssetPreview.uploadPreview, equals(uploadPreview));
        }
      });

      test('should handle different isNetwork values', () {
        const testPath = 'test_image.jpg';
        final isNetworkValues = [true, false];

        for (final isNetwork in isNetworkValues) {
          final themeAssetPreview = ThemeAssetPreview(
            path: testPath,
            isNetwork: isNetwork,
          );

          expect(themeAssetPreview.isNetwork, equals(isNetwork));
        }
      });

      test('should handle different width values', () {
        const testPath = 'test_image.jpg';
        final widthValues = [null, 0.0, 100.0, 200.0, 500.0];
        const isNetwork = true;

        for (final width in widthValues) {
          final themeAssetPreview = ThemeAssetPreview(
            path: testPath,
            width: width,
            isNetwork: isNetwork,
          );

          expect(themeAssetPreview.width, equals(width));
        }
      });

      test('should handle different file types with various parameters', () {
        final testCases = [
          {
            'path': 'https://example.com/image.jpg',
            'width': 250.0,
            'isNetwork': true,
            'uploadPreview': false,
          },
          {
            'path': '/local/path/image.png',
            'width': 180.0,
            'isNetwork': false,
            'uploadPreview': true,
          },
          {
            'path': 'https://example.com/video.mp4',
            'width': null,
            'isNetwork': true,
            'uploadPreview': false,
          },
          {
            'path': '/local/path/video.avi',
            'width': 300.0,
            'isNetwork': false,
            'uploadPreview': true,
          },
        ];

        for (final testCase in testCases) {
          final themeAssetPreview = ThemeAssetPreview(
            path: testCase['path']! as String,
            width: testCase['width'] as double?,
            isNetwork: testCase['isNetwork']! as bool,
            uploadPreview: testCase['uploadPreview']! as bool,
          );

          expect(themeAssetPreview.path, equals(testCase['path']));
          expect(themeAssetPreview.width, equals(testCase['width']));
          expect(themeAssetPreview.isNetwork, equals(testCase['isNetwork']));
          expect(
            themeAssetPreview.uploadPreview,
            equals(testCase['uploadPreview']),
          );
        }
      });
    });

    group('File Extension Handling', () {
      test('should handle various file extensions correctly', () {
        final testCases = [
          'image.jpg',
          'image.png',
          'image.gif',
          'video.mp4',
          'video.avi',
          'video.mov',
          'document.pdf',
          'text.txt',
          'archive.zip',
        ];

        for (final testPath in testCases) {
          final themeAssetPreview = ThemeAssetPreview(
            path: testPath,
            isNetwork: false,
          );

          expect(themeAssetPreview.path, equals(testPath));
        }
      });

      test('should handle files with complex paths', () {
        final testCases = [
          'path/to/image.jpg',
          'C:\\Users\\username\\Documents\\image.png',
          '/home/user/pictures/vacation/photo.jpg',
          'https://example.com/images/gallery/photo.gif',
          'assets/images/icons/icon.svg',
        ];

        for (final testPath in testCases) {
          final themeAssetPreview = ThemeAssetPreview(
            path: testPath,
            isNetwork: false,
          );

          expect(themeAssetPreview.path, equals(testPath));
        }
      });
    });

    group('CommonFunctions Integration Tests', () {
      test('CommonFunctions.isVideoTheme should detect MP4 files', () {
        expect(CommonFunctions.isVideoTheme('test.mp4'), isTrue);
        expect(CommonFunctions.isVideoTheme('video.mp4'), isTrue);
        expect(CommonFunctions.isVideoTheme('path/to/video.mp4'), isTrue);
      });

      test('CommonFunctions.isVideoTheme should detect AVI files', () {
        expect(CommonFunctions.isVideoTheme('test.avi'), isTrue);
        expect(CommonFunctions.isVideoTheme('video.avi'), isTrue);
        expect(CommonFunctions.isVideoTheme('path/to/video.avi'), isTrue);
      });

      test('CommonFunctions.isVideoTheme should detect MOV files', () {
        expect(CommonFunctions.isVideoTheme('test.mov'), isTrue);
        expect(CommonFunctions.isVideoTheme('video.mov'), isTrue);
        expect(CommonFunctions.isVideoTheme('path/to/video.mov'), isTrue);
      });

      test(
          'CommonFunctions.isVideoTheme should detect files containing video extensions',
          () {
        expect(CommonFunctions.isVideoTheme('test_video.mp4'), isTrue);
        expect(CommonFunctions.isVideoTheme('video.avi.backup'), isTrue);
        expect(CommonFunctions.isVideoTheme('path/to/video.mov.old'), isTrue);
      });

      test('CommonFunctions.isVideoTheme should not detect non-video files',
          () {
        expect(CommonFunctions.isVideoTheme('test.jpg'), isFalse);
        expect(CommonFunctions.isVideoTheme('image.png'), isFalse);
        expect(CommonFunctions.isVideoTheme('document.pdf'), isFalse);
        expect(CommonFunctions.isVideoTheme(''), isFalse);
      });

      test(
          'CommonFunctions.isVideoTheme should handle case sensitivity correctly',
          () {
        // The function is case-sensitive, so these should return false
        expect(CommonFunctions.isVideoTheme('test.MP4'), isFalse);
        expect(CommonFunctions.isVideoTheme('video.AVI'), isFalse);
        expect(CommonFunctions.isVideoTheme('path/to/video.MOV'), isFalse);
      });
    });

    group('Widget Behavior Tests', () {
      test('should create widget instances with different configurations', () {
        final configurations = [
          {
            'path': 'image1.jpg',
            'width': 100.0,
            'isNetwork': true,
            'uploadPreview': false,
          },
          {
            'path': 'image2.png',
            'width': 200.0,
            'isNetwork': false,
            'uploadPreview': true,
          },
          {
            'path': 'video1.mp4',
            'width': null,
            'isNetwork': true,
            'uploadPreview': false,
          },
          {
            'path': 'video2.avi',
            'width': 300.0,
            'isNetwork': false,
            'uploadPreview': true,
          },
        ];

        for (final config in configurations) {
          final themeAssetPreview = ThemeAssetPreview(
            path: config['path']! as String,
            width: config['width'] as double?,
            isNetwork: config['isNetwork']! as bool,
            uploadPreview: config['uploadPreview']! as bool,
          );

          expect(themeAssetPreview.path, equals(config['path']));
          expect(themeAssetPreview.width, equals(config['width']));
          expect(themeAssetPreview.isNetwork, equals(config['isNetwork']));
          expect(
            themeAssetPreview.uploadPreview,
            equals(config['uploadPreview']),
          );
        }
      });

      test('should handle edge cases gracefully', () {
        // Test with very long paths
        final longPath = 'a' * 1000 + '.jpg';
        final themeAssetPreview1 = ThemeAssetPreview(
          path: longPath,
          isNetwork: false,
        );
        expect(themeAssetPreview1.path, equals(longPath));

        // Test with special characters in paths
        const specialPath =
            'path/with/special/chars/!@#\$%^&*()_+-={}[]|\\:";\'<>?,./file.jpg';
        const themeAssetPreview2 = ThemeAssetPreview(
          path: specialPath,
          isNetwork: false,
        );
        expect(themeAssetPreview2.path, equals(specialPath));

        // Test with numeric paths
        const numericPath = '123/456/789/000.jpg';
        const themeAssetPreview3 = ThemeAssetPreview(
          path: numericPath,
          isNetwork: false,
        );
        expect(themeAssetPreview3.path, equals(numericPath));
      });

      test('should maintain immutability of properties', () {
        const testPath = 'test_image.jpg';
        const testWidth = 150.0;
        const isNetwork = true;
        const uploadPreview = false;

        const themeAssetPreview = ThemeAssetPreview(
          path: testPath,
          width: testWidth,
          isNetwork: isNetwork,
        );

        // Verify that properties are final and cannot be changed
        expect(themeAssetPreview.path, equals(testPath));
        expect(themeAssetPreview.width, equals(testWidth));
        expect(themeAssetPreview.isNetwork, equals(isNetwork));
        expect(themeAssetPreview.uploadPreview, equals(uploadPreview));

        // Create a new instance with different values
        const themeAssetPreview2 = ThemeAssetPreview(
          path: 'different_image.png',
          width: 200,
          isNetwork: false,
          uploadPreview: true,
        );

        // Verify that the original instance is unchanged
        expect(themeAssetPreview.path, equals(testPath));
        expect(themeAssetPreview.width, equals(testWidth));
        expect(themeAssetPreview.isNetwork, equals(isNetwork));
        expect(themeAssetPreview.uploadPreview, equals(uploadPreview));

        // Verify that the new instance has different values
        expect(themeAssetPreview2.path, equals('different_image.png'));
        expect(themeAssetPreview2.width, equals(200.0));
        expect(themeAssetPreview2.isNetwork, equals(false));
        expect(themeAssetPreview2.uploadPreview, equals(true));
      });
    });

    group('Integration Scenarios', () {
      test('should handle typical image upload scenarios', () {
        final imageScenarios = [
          {
            'description': 'Local image upload',
            'path': '/local/path/uploaded_image.jpg',
            'width': 800.0,
            'isNetwork': false,
            'uploadPreview': true,
          },
          {
            'description': 'Network image display',
            'path': 'https://cdn.example.com/images/display_image.png',
            'width': 600.0,
            'isNetwork': true,
            'uploadPreview': false,
          },
          {
            'description': 'Thumbnail generation',
            'path': '/cache/thumbnails/small_image.jpg',
            'width': 150.0,
            'isNetwork': false,
            'uploadPreview': false,
          },
        ];

        for (final scenario in imageScenarios) {
          final themeAssetPreview = ThemeAssetPreview(
            path: scenario['path']! as String,
            width: scenario['width']! as double,
            isNetwork: scenario['isNetwork']! as bool,
            uploadPreview: scenario['uploadPreview']! as bool,
          );

          expect(themeAssetPreview.path, equals(scenario['path']));
          expect(themeAssetPreview.width, equals(scenario['width']));
          expect(themeAssetPreview.isNetwork, equals(scenario['isNetwork']));
          expect(
            themeAssetPreview.uploadPreview,
            equals(scenario['uploadPreview']),
          );
        }
      });

      test('should handle typical video scenarios', () {
        final videoScenarios = [
          {
            'description': 'Local video upload',
            'path': '/local/path/uploaded_video.mp4',
            'width': 1920.0,
            'isNetwork': false,
            'uploadPreview': true,
          },
          {
            'description': 'Network video streaming',
            'path': 'https://stream.example.com/videos/stream_video.avi',
            'width': null,
            'isNetwork': true,
            'uploadPreview': false,
          },
          {
            'description': 'Video thumbnail',
            'path': '/cache/thumbnails/video_thumb.jpg',
            'width': 320.0,
            'isNetwork': false,
            'uploadPreview': false,
          },
        ];

        for (final scenario in videoScenarios) {
          final themeAssetPreview = ThemeAssetPreview(
            path: scenario['path']! as String,
            width: scenario['width'] as double?,
            isNetwork: scenario['isNetwork']! as bool,
            uploadPreview: scenario['uploadPreview']! as bool,
          );

          expect(themeAssetPreview.path, equals(scenario['path']));
          expect(themeAssetPreview.width, equals(scenario['width']));
          expect(themeAssetPreview.isNetwork, equals(scenario['isNetwork']));
          expect(
            themeAssetPreview.uploadPreview,
            equals(scenario['uploadPreview']),
          );
        }
      });
    });
  });
}
