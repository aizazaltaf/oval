// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PaginatedDataNew> _$paginatedDataNewSerializer =
    _$PaginatedDataNewSerializer();

class _$PaginatedDataNewSerializer
    implements StructuredSerializer<PaginatedDataNew> {
  @override
  final Iterable<Type> types = const [PaginatedDataNew, _$PaginatedDataNew];
  @override
  final String wireName = 'PaginatedDataNew';

  @override
  Iterable<Object?> serialize(Serializers serializers, PaginatedDataNew object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'current_page',
      serializers.serialize(object.currentPage,
          specifiedType: const FullType(int)),
      'last_page',
      serializers.serialize(object.lastPage,
          specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.nextPageUrl;
    if (value != null) {
      result
        ..add('next_page_url')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  PaginatedDataNew deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PaginatedDataNewBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'current_page':
          result.currentPage = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'last_page':
          result.lastPage = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'next_page_url':
          result.nextPageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$PaginatedData<T> extends PaginatedData<T> {
  @override
  final int currentPage;
  @override
  final int lastPage;
  @override
  final String? nextPageUrl;
  @override
  final BuiltList<T> data;

  factory _$PaginatedData([void Function(PaginatedDataBuilder<T>)? updates]) =>
      (PaginatedDataBuilder<T>()..update(updates))._build();

  _$PaginatedData._(
      {required this.currentPage,
      required this.lastPage,
      this.nextPageUrl,
      required this.data})
      : super._();
  @override
  PaginatedData<T> rebuild(void Function(PaginatedDataBuilder<T>) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaginatedDataBuilder<T> toBuilder() =>
      PaginatedDataBuilder<T>()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginatedData &&
        currentPage == other.currentPage &&
        lastPage == other.lastPage &&
        nextPageUrl == other.nextPageUrl &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPage.hashCode);
    _$hash = $jc(_$hash, lastPage.hashCode);
    _$hash = $jc(_$hash, nextPageUrl.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaginatedData')
          ..add('currentPage', currentPage)
          ..add('lastPage', lastPage)
          ..add('nextPageUrl', nextPageUrl)
          ..add('data', data))
        .toString();
  }
}

class PaginatedDataBuilder<T>
    implements Builder<PaginatedData<T>, PaginatedDataBuilder<T>> {
  _$PaginatedData<T>? _$v;

  int? _currentPage;
  int? get currentPage => _$this._currentPage;
  set currentPage(int? currentPage) => _$this._currentPage = currentPage;

  int? _lastPage;
  int? get lastPage => _$this._lastPage;
  set lastPage(int? lastPage) => _$this._lastPage = lastPage;

  String? _nextPageUrl;
  String? get nextPageUrl => _$this._nextPageUrl;
  set nextPageUrl(String? nextPageUrl) => _$this._nextPageUrl = nextPageUrl;

  ListBuilder<T>? _data;
  ListBuilder<T> get data => _$this._data ??= ListBuilder<T>();
  set data(ListBuilder<T>? data) => _$this._data = data;

  PaginatedDataBuilder();

  PaginatedDataBuilder<T> get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPage = $v.currentPage;
      _lastPage = $v.lastPage;
      _nextPageUrl = $v.nextPageUrl;
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaginatedData<T> other) {
    _$v = other as _$PaginatedData<T>;
  }

  @override
  void update(void Function(PaginatedDataBuilder<T>)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginatedData<T> build() => _build();

  _$PaginatedData<T> _build() {
    _$PaginatedData<T> _$result;
    try {
      _$result = _$v ??
          _$PaginatedData<T>._(
            currentPage: BuiltValueNullFieldError.checkNotNull(
                currentPage, r'PaginatedData', 'currentPage'),
            lastPage: BuiltValueNullFieldError.checkNotNull(
                lastPage, r'PaginatedData', 'lastPage'),
            nextPageUrl: nextPageUrl,
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PaginatedData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PaginatedDataNew extends PaginatedDataNew {
  @override
  final int currentPage;
  @override
  final int lastPage;
  @override
  final String? nextPageUrl;

  factory _$PaginatedDataNew(
          [void Function(PaginatedDataNewBuilder)? updates]) =>
      (PaginatedDataNewBuilder()..update(updates))._build();

  _$PaginatedDataNew._(
      {required this.currentPage, required this.lastPage, this.nextPageUrl})
      : super._();
  @override
  PaginatedDataNew rebuild(void Function(PaginatedDataNewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaginatedDataNewBuilder toBuilder() =>
      PaginatedDataNewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginatedDataNew &&
        currentPage == other.currentPage &&
        lastPage == other.lastPage &&
        nextPageUrl == other.nextPageUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPage.hashCode);
    _$hash = $jc(_$hash, lastPage.hashCode);
    _$hash = $jc(_$hash, nextPageUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaginatedDataNew')
          ..add('currentPage', currentPage)
          ..add('lastPage', lastPage)
          ..add('nextPageUrl', nextPageUrl))
        .toString();
  }
}

class PaginatedDataNewBuilder
    implements Builder<PaginatedDataNew, PaginatedDataNewBuilder> {
  _$PaginatedDataNew? _$v;

  int? _currentPage;
  int? get currentPage => _$this._currentPage;
  set currentPage(int? currentPage) => _$this._currentPage = currentPage;

  int? _lastPage;
  int? get lastPage => _$this._lastPage;
  set lastPage(int? lastPage) => _$this._lastPage = lastPage;

  String? _nextPageUrl;
  String? get nextPageUrl => _$this._nextPageUrl;
  set nextPageUrl(String? nextPageUrl) => _$this._nextPageUrl = nextPageUrl;

  PaginatedDataNewBuilder();

  PaginatedDataNewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPage = $v.currentPage;
      _lastPage = $v.lastPage;
      _nextPageUrl = $v.nextPageUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaginatedDataNew other) {
    _$v = other as _$PaginatedDataNew;
  }

  @override
  void update(void Function(PaginatedDataNewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginatedDataNew build() => _build();

  _$PaginatedDataNew _build() {
    final _$result = _$v ??
        _$PaginatedDataNew._(
          currentPage: BuiltValueNullFieldError.checkNotNull(
              currentPage, r'PaginatedDataNew', 'currentPage'),
          lastPage: BuiltValueNullFieldError.checkNotNull(
              lastPage, r'PaginatedDataNew', 'lastPage'),
          nextPageUrl: nextPageUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
