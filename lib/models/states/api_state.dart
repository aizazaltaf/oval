import 'package:admin/models/data/api_meta_data.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:built_value/built_value.dart';

part 'api_state.g.dart';

abstract class ApiState<T> implements Built<ApiState<T>, ApiStateBuilder<T>> {
  factory ApiState([void Function(ApiStateBuilder<T>) updates]) = _$ApiState<T>;

  ApiState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize<T>(final ApiStateBuilder<T> b) => b
    ..isApiInProgress = false
    ..isApiPaginationEnabled = false
    ..currentPage = 0;

  @BuiltValueHook(finalizeBuilder: true)
  static void _finalize<T>(final ApiStateBuilder<T> b) {
    if (b.totalCount == null || b.totalCount == 0) {
      final data = b.data;
      if (data is Iterable) {
        b.totalCount = data.length;
      } else if (data is Map) {
        b.totalCount = data['last_page'];
      } else {
        b.totalCount = 0;
      }
    }
  }

  T? get data;

  bool get isApiInProgress;

  ApiMetaData? get error;

  String? get message;

  PaginatedDataNew? get pagination;

  double? get uploadProgress;

  bool get isApiPaginationEnabled;

  int get totalCount;

  int get currentPage;
}

abstract class SocketState<T>
    implements Built<SocketState<T>, SocketStateBuilder<T>> {
  factory SocketState([final void Function(SocketStateBuilder<T>) updates]) =
      _$SocketState<T>;

  SocketState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize<T>(final SocketStateBuilder<T> b) =>
      b..isSocketInProgress = false;

  T? get data;

  bool get isSocketInProgress;

  String? get message;

  ApiMetaData? get error;
}
