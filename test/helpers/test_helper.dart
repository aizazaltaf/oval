import 'dart:io';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/core/config.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

/// A helper class for test setup and utilities
class TestHelper {
  // Private constructor to prevent instantiation
  TestHelper._();

  static Directory? _tempDir;
  static TestSingletonBloc? _singletonBloc;

  /// Initialize test environment
  static Future<void> initialize() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Set up fake path provider
    PathProviderPlatform.instance = FakePathProviderPlatform();

    // Create temporary directory
    _tempDir = await Directory.systemTemp.createTemp('test_');

    // Initialize HydratedBloc storage
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(_tempDir!.path),
    );

    await dotenv.load(fileName: 'config/${config.environment}.config');
  }

  /// Set the singleton bloc for testing
  static Future<void> setSingletonBloc(TestSingletonBloc bloc) async {
    _singletonBloc = bloc;
  }

  /// Get the singleton bloc for testing
  static TestSingletonBloc? getSingletonBloc() {
    return _singletonBloc;
  }

  /// Clean up test environment
  static Future<void> cleanup() async {
    if (_tempDir != null) {
      // Try to delete the directory with retries
      for (var i = 0; i < 3; i++) {
        try {
          if (await _tempDir!.exists()) {
            await _tempDir!.delete(recursive: true);
            break;
          }
        } catch (e) {
          if (i < 2) {
            // Wait before retrying
            await Future.delayed(const Duration(milliseconds: 100));
          }
        }
      }
    }
  }
}

class FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String> getTemporaryPath() async {
    final tempDir = await Directory.systemTemp.createTemp('test_');
    return tempDir.path;
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return Directory.systemTemp.path;
  }
}

class VisitorsModelFake extends Fake implements VisitorsModel {}
