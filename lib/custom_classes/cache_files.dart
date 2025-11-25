import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

mixin CacheFiles {
  static late File fileStream;

  static Future<FileInfo?> downloadAndGetFile(String url) async {
    try {
      FileInfo? file = await DefaultCacheManager().getFileFromMemory(url);
      return file ??= await DefaultCacheManager().downloadFile(url);
    } catch (e) {
      return null;
    }
  }

  static Future<File?> getFile(String url) async {
    try {
      final File file =
          await DefaultCacheManager().getSingleFile(url, key: url);
      return file;
    } catch (e) {
      return null;
    }
  }
}
