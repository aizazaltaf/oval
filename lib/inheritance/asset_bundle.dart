import 'package:admin/custom_classes/cache.dart';
import 'package:flutter/services.dart';

class ByteDataAssetBundle extends AssetBundle {
  final _cache = Cache<String, ByteData>(100);

  @override
  Future<ByteData> load(final String key) async {
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }
    final data = await rootBundle.load(key);
    _cache[key] = data;
    return data;
  }

  @override
  Future<T> loadStructuredData<T>(
    final String key,
    final Future<T> Function(String value) parser,
  ) async {
    return parser(await loadString(key));
  }
}
