// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiState<T> extends ApiState<T> {
  @override
  final T? data;
  @override
  final bool isApiInProgress;
  @override
  final ApiMetaData? error;
  @override
  final String? message;
  @override
  final PaginatedDataNew? pagination;
  @override
  final double? uploadProgress;
  @override
  final bool isApiPaginationEnabled;
  @override
  final int totalCount;
  @override
  final int currentPage;

  factory _$ApiState([void Function(ApiStateBuilder<T>)? updates]) =>
      (ApiStateBuilder<T>()..update(updates))._build();

  _$ApiState._(
      {this.data,
      required this.isApiInProgress,
      this.error,
      this.message,
      this.pagination,
      this.uploadProgress,
      required this.isApiPaginationEnabled,
      required this.totalCount,
      required this.currentPage})
      : super._();
  @override
  ApiState<T> rebuild(void Function(ApiStateBuilder<T>) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiStateBuilder<T> toBuilder() => ApiStateBuilder<T>()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiState &&
        data == other.data &&
        isApiInProgress == other.isApiInProgress &&
        error == other.error &&
        message == other.message &&
        pagination == other.pagination &&
        uploadProgress == other.uploadProgress &&
        isApiPaginationEnabled == other.isApiPaginationEnabled &&
        totalCount == other.totalCount &&
        currentPage == other.currentPage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, isApiInProgress.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, pagination.hashCode);
    _$hash = $jc(_$hash, uploadProgress.hashCode);
    _$hash = $jc(_$hash, isApiPaginationEnabled.hashCode);
    _$hash = $jc(_$hash, totalCount.hashCode);
    _$hash = $jc(_$hash, currentPage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiState')
          ..add('data', data)
          ..add('isApiInProgress', isApiInProgress)
          ..add('error', error)
          ..add('message', message)
          ..add('pagination', pagination)
          ..add('uploadProgress', uploadProgress)
          ..add('isApiPaginationEnabled', isApiPaginationEnabled)
          ..add('totalCount', totalCount)
          ..add('currentPage', currentPage))
        .toString();
  }
}

class ApiStateBuilder<T> implements Builder<ApiState<T>, ApiStateBuilder<T>> {
  _$ApiState<T>? _$v;

  T? _data;
  T? get data => _$this._data;
  set data(T? data) => _$this._data = data;

  bool? _isApiInProgress;
  bool? get isApiInProgress => _$this._isApiInProgress;
  set isApiInProgress(bool? isApiInProgress) =>
      _$this._isApiInProgress = isApiInProgress;

  ApiMetaDataBuilder? _error;
  ApiMetaDataBuilder get error => _$this._error ??= ApiMetaDataBuilder();
  set error(ApiMetaDataBuilder? error) => _$this._error = error;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  PaginatedDataNewBuilder? _pagination;
  PaginatedDataNewBuilder get pagination =>
      _$this._pagination ??= PaginatedDataNewBuilder();
  set pagination(PaginatedDataNewBuilder? pagination) =>
      _$this._pagination = pagination;

  double? _uploadProgress;
  double? get uploadProgress => _$this._uploadProgress;
  set uploadProgress(double? uploadProgress) =>
      _$this._uploadProgress = uploadProgress;

  bool? _isApiPaginationEnabled;
  bool? get isApiPaginationEnabled => _$this._isApiPaginationEnabled;
  set isApiPaginationEnabled(bool? isApiPaginationEnabled) =>
      _$this._isApiPaginationEnabled = isApiPaginationEnabled;

  int? _totalCount;
  int? get totalCount => _$this._totalCount;
  set totalCount(int? totalCount) => _$this._totalCount = totalCount;

  int? _currentPage;
  int? get currentPage => _$this._currentPage;
  set currentPage(int? currentPage) => _$this._currentPage = currentPage;

  ApiStateBuilder() {
    ApiState._initialize(this);
  }

  ApiStateBuilder<T> get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data;
      _isApiInProgress = $v.isApiInProgress;
      _error = $v.error?.toBuilder();
      _message = $v.message;
      _pagination = $v.pagination?.toBuilder();
      _uploadProgress = $v.uploadProgress;
      _isApiPaginationEnabled = $v.isApiPaginationEnabled;
      _totalCount = $v.totalCount;
      _currentPage = $v.currentPage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiState<T> other) {
    _$v = other as _$ApiState<T>;
  }

  @override
  void update(void Function(ApiStateBuilder<T>)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiState<T> build() => _build();

  _$ApiState<T> _build() {
    ApiState._finalize(this);
    _$ApiState<T> _$result;
    try {
      _$result = _$v ??
          _$ApiState<T>._(
            data: data,
            isApiInProgress: BuiltValueNullFieldError.checkNotNull(
                isApiInProgress, r'ApiState', 'isApiInProgress'),
            error: _error?.build(),
            message: message,
            pagination: _pagination?.build(),
            uploadProgress: uploadProgress,
            isApiPaginationEnabled: BuiltValueNullFieldError.checkNotNull(
                isApiPaginationEnabled, r'ApiState', 'isApiPaginationEnabled'),
            totalCount: BuiltValueNullFieldError.checkNotNull(
                totalCount, r'ApiState', 'totalCount'),
            currentPage: BuiltValueNullFieldError.checkNotNull(
                currentPage, r'ApiState', 'currentPage'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'error';
        _error?.build();

        _$failedField = 'pagination';
        _pagination?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SocketState<T> extends SocketState<T> {
  @override
  final T? data;
  @override
  final bool isSocketInProgress;
  @override
  final String? message;
  @override
  final ApiMetaData? error;

  factory _$SocketState([void Function(SocketStateBuilder<T>)? updates]) =>
      (SocketStateBuilder<T>()..update(updates))._build();

  _$SocketState._(
      {this.data, required this.isSocketInProgress, this.message, this.error})
      : super._();
  @override
  SocketState<T> rebuild(void Function(SocketStateBuilder<T>) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SocketStateBuilder<T> toBuilder() => SocketStateBuilder<T>()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SocketState &&
        data == other.data &&
        isSocketInProgress == other.isSocketInProgress &&
        message == other.message &&
        error == other.error;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, isSocketInProgress.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SocketState')
          ..add('data', data)
          ..add('isSocketInProgress', isSocketInProgress)
          ..add('message', message)
          ..add('error', error))
        .toString();
  }
}

class SocketStateBuilder<T>
    implements Builder<SocketState<T>, SocketStateBuilder<T>> {
  _$SocketState<T>? _$v;

  T? _data;
  T? get data => _$this._data;
  set data(T? data) => _$this._data = data;

  bool? _isSocketInProgress;
  bool? get isSocketInProgress => _$this._isSocketInProgress;
  set isSocketInProgress(bool? isSocketInProgress) =>
      _$this._isSocketInProgress = isSocketInProgress;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ApiMetaDataBuilder? _error;
  ApiMetaDataBuilder get error => _$this._error ??= ApiMetaDataBuilder();
  set error(ApiMetaDataBuilder? error) => _$this._error = error;

  SocketStateBuilder() {
    SocketState._initialize(this);
  }

  SocketStateBuilder<T> get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data;
      _isSocketInProgress = $v.isSocketInProgress;
      _message = $v.message;
      _error = $v.error?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SocketState<T> other) {
    _$v = other as _$SocketState<T>;
  }

  @override
  void update(void Function(SocketStateBuilder<T>)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SocketState<T> build() => _build();

  _$SocketState<T> _build() {
    _$SocketState<T> _$result;
    try {
      _$result = _$v ??
          _$SocketState<T>._(
            data: data,
            isSocketInProgress: BuiltValueNullFieldError.checkNotNull(
                isSocketInProgress, r'SocketState', 'isSocketInProgress'),
            message: message,
            error: _error?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'error';
        _error?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SocketState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
