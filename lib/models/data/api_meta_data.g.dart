// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_meta_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ApiMetaData> _$apiMetaDataSerializer = _$ApiMetaDataSerializer();

class _$ApiMetaDataSerializer implements StructuredSerializer<ApiMetaData> {
  @override
  final Iterable<Type> types = const [ApiMetaData, _$ApiMetaData];
  @override
  final String wireName = 'ApiMetaData';

  @override
  Iterable<Object?> serialize(Serializers serializers, ApiMetaData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.statusCode;
    if (value != null) {
      result
        ..add('statusCode')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.code;
    if (value != null) {
      result
        ..add('code')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.message;
    if (value != null) {
      result
        ..add('message')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.success;
    if (value != null) {
      result
        ..add('success')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.pagination;
    if (value != null) {
      result
        ..add('pagination')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(PaginatedDataNew)));
    }
    return result;
  }

  @override
  ApiMetaData deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ApiMetaDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'statusCode':
          result.statusCode = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'code':
          result.code = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'success':
          result.success = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'pagination':
          result.pagination.replace(serializers.deserialize(value,
                  specifiedType: const FullType(PaginatedDataNew))!
              as PaginatedDataNew);
          break;
      }
    }

    return result.build();
  }
}

class _$ApiMetaData extends ApiMetaData {
  @override
  final int? statusCode;
  @override
  final int? code;
  @override
  final String? message;
  @override
  final bool? success;
  @override
  final PaginatedDataNew? pagination;

  factory _$ApiMetaData([void Function(ApiMetaDataBuilder)? updates]) =>
      (ApiMetaDataBuilder()..update(updates))._build();

  _$ApiMetaData._(
      {this.statusCode, this.code, this.message, this.success, this.pagination})
      : super._();
  @override
  ApiMetaData rebuild(void Function(ApiMetaDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiMetaDataBuilder toBuilder() => ApiMetaDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiMetaData &&
        statusCode == other.statusCode &&
        code == other.code &&
        message == other.message &&
        success == other.success &&
        pagination == other.pagination;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, statusCode.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, pagination.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiMetaData')
          ..add('statusCode', statusCode)
          ..add('code', code)
          ..add('message', message)
          ..add('success', success)
          ..add('pagination', pagination))
        .toString();
  }
}

class ApiMetaDataBuilder implements Builder<ApiMetaData, ApiMetaDataBuilder> {
  _$ApiMetaData? _$v;

  int? _statusCode;
  int? get statusCode => _$this._statusCode;
  set statusCode(int? statusCode) => _$this._statusCode = statusCode;

  int? _code;
  int? get code => _$this._code;
  set code(int? code) => _$this._code = code;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  PaginatedDataNewBuilder? _pagination;
  PaginatedDataNewBuilder get pagination =>
      _$this._pagination ??= PaginatedDataNewBuilder();
  set pagination(PaginatedDataNewBuilder? pagination) =>
      _$this._pagination = pagination;

  ApiMetaDataBuilder();

  ApiMetaDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _statusCode = $v.statusCode;
      _code = $v.code;
      _message = $v.message;
      _success = $v.success;
      _pagination = $v.pagination?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiMetaData other) {
    _$v = other as _$ApiMetaData;
  }

  @override
  void update(void Function(ApiMetaDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiMetaData build() => _build();

  _$ApiMetaData _build() {
    _$ApiMetaData _$result;
    try {
      _$result = _$v ??
          _$ApiMetaData._(
            statusCode: statusCode,
            code: code,
            message: message,
            success: success,
            pagination: _pagination?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pagination';
        _pagination?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiMetaData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
