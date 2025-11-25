// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_theme_data_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PaginatedThemeDataModel> _$paginatedThemeDataModelSerializer =
    _$PaginatedThemeDataModelSerializer();
Serializer<PaginationModel> _$paginationModelSerializer =
    _$PaginationModelSerializer();

class _$PaginatedThemeDataModelSerializer
    implements StructuredSerializer<PaginatedThemeDataModel> {
  @override
  final Iterable<Type> types = const [
    PaginatedThemeDataModel,
    _$PaginatedThemeDataModel
  ];
  @override
  final String wireName = 'PaginatedThemeDataModel';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, PaginatedThemeDataModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'success',
      serializers.serialize(object.success,
          specifiedType: const FullType(bool)),
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
      'code',
      serializers.serialize(object.code, specifiedType: const FullType(int)),
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(
              BuiltList, const [const FullType(ThemeDataModel)])),
      'pagination',
      serializers.serialize(object.pagination,
          specifiedType: const FullType(PaginationModel)),
    ];

    return result;
  }

  @override
  PaginatedThemeDataModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PaginatedThemeDataModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'success':
          result.success = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'code':
          result.code = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ThemeDataModel)]))!
              as BuiltList<Object?>);
          break;
        case 'pagination':
          result.pagination.replace(serializers.deserialize(value,
                  specifiedType: const FullType(PaginationModel))!
              as PaginationModel);
          break;
      }
    }

    return result.build();
  }
}

class _$PaginationModelSerializer
    implements StructuredSerializer<PaginationModel> {
  @override
  final Iterable<Type> types = const [PaginationModel, _$PaginationModel];
  @override
  final String wireName = 'PaginationModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, PaginationModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'total',
      serializers.serialize(object.total, specifiedType: const FullType(int)),
      'current_page',
      serializers.serialize(object.currentPage,
          specifiedType: const FullType(int)),
      'last_page',
      serializers.serialize(object.lastPage,
          specifiedType: const FullType(int)),
      'per_page',
      serializers.serialize(object.perPage, specifiedType: const FullType(int)),
      'last_page_url',
      serializers.serialize(object.lastPageUrl,
          specifiedType: const FullType(String)),
      'next_page_url',
      serializers.serialize(object.nextPageUrl,
          specifiedType: const FullType(String)),
      'path',
      serializers.serialize(object.path, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.prevPageUrl;
    if (value != null) {
      result
        ..add('prev_page_url')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  PaginationModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PaginationModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'total':
          result.total = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'current_page':
          result.currentPage = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'last_page':
          result.lastPage = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'per_page':
          result.perPage = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'last_page_url':
          result.lastPageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'next_page_url':
          result.nextPageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'path':
          result.path = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'prev_page_url':
          result.prevPageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$PaginatedThemeDataModel extends PaginatedThemeDataModel {
  @override
  final bool success;
  @override
  final String message;
  @override
  final int code;
  @override
  final BuiltList<ThemeDataModel> data;
  @override
  final PaginationModel pagination;

  factory _$PaginatedThemeDataModel(
          [void Function(PaginatedThemeDataModelBuilder)? updates]) =>
      (PaginatedThemeDataModelBuilder()..update(updates))._build();

  _$PaginatedThemeDataModel._(
      {required this.success,
      required this.message,
      required this.code,
      required this.data,
      required this.pagination})
      : super._();
  @override
  PaginatedThemeDataModel rebuild(
          void Function(PaginatedThemeDataModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaginatedThemeDataModelBuilder toBuilder() =>
      PaginatedThemeDataModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginatedThemeDataModel &&
        success == other.success &&
        message == other.message &&
        code == other.code &&
        data == other.data &&
        pagination == other.pagination;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, pagination.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaginatedThemeDataModel')
          ..add('success', success)
          ..add('message', message)
          ..add('code', code)
          ..add('data', data)
          ..add('pagination', pagination))
        .toString();
  }
}

class PaginatedThemeDataModelBuilder
    implements
        Builder<PaginatedThemeDataModel, PaginatedThemeDataModelBuilder> {
  _$PaginatedThemeDataModel? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  int? _code;
  int? get code => _$this._code;
  set code(int? code) => _$this._code = code;

  ListBuilder<ThemeDataModel>? _data;
  ListBuilder<ThemeDataModel> get data =>
      _$this._data ??= ListBuilder<ThemeDataModel>();
  set data(ListBuilder<ThemeDataModel>? data) => _$this._data = data;

  PaginationModelBuilder? _pagination;
  PaginationModelBuilder get pagination =>
      _$this._pagination ??= PaginationModelBuilder();
  set pagination(PaginationModelBuilder? pagination) =>
      _$this._pagination = pagination;

  PaginatedThemeDataModelBuilder();

  PaginatedThemeDataModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _message = $v.message;
      _code = $v.code;
      _data = $v.data.toBuilder();
      _pagination = $v.pagination.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaginatedThemeDataModel other) {
    _$v = other as _$PaginatedThemeDataModel;
  }

  @override
  void update(void Function(PaginatedThemeDataModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginatedThemeDataModel build() => _build();

  _$PaginatedThemeDataModel _build() {
    _$PaginatedThemeDataModel _$result;
    try {
      _$result = _$v ??
          _$PaginatedThemeDataModel._(
            success: BuiltValueNullFieldError.checkNotNull(
                success, r'PaginatedThemeDataModel', 'success'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'PaginatedThemeDataModel', 'message'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'PaginatedThemeDataModel', 'code'),
            data: data.build(),
            pagination: pagination.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'pagination';
        pagination.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PaginatedThemeDataModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PaginationModel extends PaginationModel {
  @override
  final int total;
  @override
  final int currentPage;
  @override
  final int lastPage;
  @override
  final int perPage;
  @override
  final String lastPageUrl;
  @override
  final String nextPageUrl;
  @override
  final String path;
  @override
  final String? prevPageUrl;

  factory _$PaginationModel([void Function(PaginationModelBuilder)? updates]) =>
      (PaginationModelBuilder()..update(updates))._build();

  _$PaginationModel._(
      {required this.total,
      required this.currentPage,
      required this.lastPage,
      required this.perPage,
      required this.lastPageUrl,
      required this.nextPageUrl,
      required this.path,
      this.prevPageUrl})
      : super._();
  @override
  PaginationModel rebuild(void Function(PaginationModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaginationModelBuilder toBuilder() => PaginationModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginationModel &&
        total == other.total &&
        currentPage == other.currentPage &&
        lastPage == other.lastPage &&
        perPage == other.perPage &&
        lastPageUrl == other.lastPageUrl &&
        nextPageUrl == other.nextPageUrl &&
        path == other.path &&
        prevPageUrl == other.prevPageUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, currentPage.hashCode);
    _$hash = $jc(_$hash, lastPage.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, lastPageUrl.hashCode);
    _$hash = $jc(_$hash, nextPageUrl.hashCode);
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jc(_$hash, prevPageUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaginationModel')
          ..add('total', total)
          ..add('currentPage', currentPage)
          ..add('lastPage', lastPage)
          ..add('perPage', perPage)
          ..add('lastPageUrl', lastPageUrl)
          ..add('nextPageUrl', nextPageUrl)
          ..add('path', path)
          ..add('prevPageUrl', prevPageUrl))
        .toString();
  }
}

class PaginationModelBuilder
    implements Builder<PaginationModel, PaginationModelBuilder> {
  _$PaginationModel? _$v;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _currentPage;
  int? get currentPage => _$this._currentPage;
  set currentPage(int? currentPage) => _$this._currentPage = currentPage;

  int? _lastPage;
  int? get lastPage => _$this._lastPage;
  set lastPage(int? lastPage) => _$this._lastPage = lastPage;

  int? _perPage;
  int? get perPage => _$this._perPage;
  set perPage(int? perPage) => _$this._perPage = perPage;

  String? _lastPageUrl;
  String? get lastPageUrl => _$this._lastPageUrl;
  set lastPageUrl(String? lastPageUrl) => _$this._lastPageUrl = lastPageUrl;

  String? _nextPageUrl;
  String? get nextPageUrl => _$this._nextPageUrl;
  set nextPageUrl(String? nextPageUrl) => _$this._nextPageUrl = nextPageUrl;

  String? _path;
  String? get path => _$this._path;
  set path(String? path) => _$this._path = path;

  String? _prevPageUrl;
  String? get prevPageUrl => _$this._prevPageUrl;
  set prevPageUrl(String? prevPageUrl) => _$this._prevPageUrl = prevPageUrl;

  PaginationModelBuilder();

  PaginationModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _currentPage = $v.currentPage;
      _lastPage = $v.lastPage;
      _perPage = $v.perPage;
      _lastPageUrl = $v.lastPageUrl;
      _nextPageUrl = $v.nextPageUrl;
      _path = $v.path;
      _prevPageUrl = $v.prevPageUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaginationModel other) {
    _$v = other as _$PaginationModel;
  }

  @override
  void update(void Function(PaginationModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginationModel build() => _build();

  _$PaginationModel _build() {
    final _$result = _$v ??
        _$PaginationModel._(
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'PaginationModel', 'total'),
          currentPage: BuiltValueNullFieldError.checkNotNull(
              currentPage, r'PaginationModel', 'currentPage'),
          lastPage: BuiltValueNullFieldError.checkNotNull(
              lastPage, r'PaginationModel', 'lastPage'),
          perPage: BuiltValueNullFieldError.checkNotNull(
              perPage, r'PaginationModel', 'perPage'),
          lastPageUrl: BuiltValueNullFieldError.checkNotNull(
              lastPageUrl, r'PaginationModel', 'lastPageUrl'),
          nextPageUrl: BuiltValueNullFieldError.checkNotNull(
              nextPageUrl, r'PaginationModel', 'nextPageUrl'),
          path: BuiltValueNullFieldError.checkNotNull(
              path, r'PaginationModel', 'path'),
          prevPageUrl: prevPageUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
