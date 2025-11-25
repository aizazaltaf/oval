// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streaming_alerts_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<StreamingAlertsData> _$streamingAlertsDataSerializer =
    _$StreamingAlertsDataSerializer();
Serializer<AiAlert> _$aiAlertSerializer = _$AiAlertSerializer();

class _$StreamingAlertsDataSerializer
    implements StructuredSerializer<StreamingAlertsData> {
  @override
  final Iterable<Type> types = const [
    StreamingAlertsData,
    _$StreamingAlertsData
  ];
  @override
  final String wireName = 'StreamingAlertsData';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, StreamingAlertsData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'fileStartTime',
      serializers.serialize(object.fileStartTime,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.fileUrl;
    if (value != null) {
      result
        ..add('fileUrl')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.duration;
    if (value != null) {
      result
        ..add('duration')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.aiAlert;
    if (value != null) {
      result
        ..add('aiAlert')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(AiAlert)])));
    }
    return result;
  }

  @override
  StreamingAlertsData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = StreamingAlertsDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'fileUrl':
          result.fileUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'fileStartTime':
          result.fileStartTime = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'duration':
          result.duration = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'aiAlert':
          result.aiAlert.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(AiAlert)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$AiAlertSerializer implements StructuredSerializer<AiAlert> {
  @override
  final Iterable<Type> types = const [AiAlert, _$AiAlert];
  @override
  final String wireName = 'AiAlert';

  @override
  Iterable<Object?> serialize(Serializers serializers, AiAlert object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.deviceId;
    if (value != null) {
      result
        ..add('device_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.entityId;
    if (value != null) {
      result
        ..add('entity_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.title;
    if (value != null) {
      result
        ..add('title')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.image;
    if (value != null) {
      result
        ..add('image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.text;
    if (value != null) {
      result
        ..add('text')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.createdAt;
    if (value != null) {
      result
        ..add('created_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  AiAlert deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = AiAlertBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'device_id':
          result.deviceId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'entity_id':
          result.entityId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'text':
          result.text = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$StreamingAlertsData extends StreamingAlertsData {
  @override
  final String? fileUrl;
  @override
  final String fileStartTime;
  @override
  final int? duration;
  @override
  final BuiltList<AiAlert>? aiAlert;

  factory _$StreamingAlertsData(
          [void Function(StreamingAlertsDataBuilder)? updates]) =>
      (StreamingAlertsDataBuilder()..update(updates))._build();

  _$StreamingAlertsData._(
      {this.fileUrl, required this.fileStartTime, this.duration, this.aiAlert})
      : super._();
  @override
  StreamingAlertsData rebuild(
          void Function(StreamingAlertsDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StreamingAlertsDataBuilder toBuilder() =>
      StreamingAlertsDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StreamingAlertsData &&
        fileUrl == other.fileUrl &&
        fileStartTime == other.fileStartTime &&
        duration == other.duration &&
        aiAlert == other.aiAlert;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fileUrl.hashCode);
    _$hash = $jc(_$hash, fileStartTime.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, aiAlert.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StreamingAlertsData')
          ..add('fileUrl', fileUrl)
          ..add('fileStartTime', fileStartTime)
          ..add('duration', duration)
          ..add('aiAlert', aiAlert))
        .toString();
  }
}

class StreamingAlertsDataBuilder
    implements Builder<StreamingAlertsData, StreamingAlertsDataBuilder> {
  _$StreamingAlertsData? _$v;

  String? _fileUrl;
  String? get fileUrl => _$this._fileUrl;
  set fileUrl(String? fileUrl) => _$this._fileUrl = fileUrl;

  String? _fileStartTime;
  String? get fileStartTime => _$this._fileStartTime;
  set fileStartTime(String? fileStartTime) =>
      _$this._fileStartTime = fileStartTime;

  int? _duration;
  int? get duration => _$this._duration;
  set duration(int? duration) => _$this._duration = duration;

  ListBuilder<AiAlert>? _aiAlert;
  ListBuilder<AiAlert> get aiAlert =>
      _$this._aiAlert ??= ListBuilder<AiAlert>();
  set aiAlert(ListBuilder<AiAlert>? aiAlert) => _$this._aiAlert = aiAlert;

  StreamingAlertsDataBuilder();

  StreamingAlertsDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fileUrl = $v.fileUrl;
      _fileStartTime = $v.fileStartTime;
      _duration = $v.duration;
      _aiAlert = $v.aiAlert?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StreamingAlertsData other) {
    _$v = other as _$StreamingAlertsData;
  }

  @override
  void update(void Function(StreamingAlertsDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StreamingAlertsData build() => _build();

  _$StreamingAlertsData _build() {
    _$StreamingAlertsData _$result;
    try {
      _$result = _$v ??
          _$StreamingAlertsData._(
            fileUrl: fileUrl,
            fileStartTime: BuiltValueNullFieldError.checkNotNull(
                fileStartTime, r'StreamingAlertsData', 'fileStartTime'),
            duration: duration,
            aiAlert: _aiAlert?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'aiAlert';
        _aiAlert?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StreamingAlertsData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$AiAlert extends AiAlert {
  @override
  final int? id;
  @override
  final String? deviceId;
  @override
  final String? entityId;
  @override
  final String? title;
  @override
  final String? image;
  @override
  final String? text;
  @override
  final String? createdAt;

  factory _$AiAlert([void Function(AiAlertBuilder)? updates]) =>
      (AiAlertBuilder()..update(updates))._build();

  _$AiAlert._(
      {this.id,
      this.deviceId,
      this.entityId,
      this.title,
      this.image,
      this.text,
      this.createdAt})
      : super._();
  @override
  AiAlert rebuild(void Function(AiAlertBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AiAlertBuilder toBuilder() => AiAlertBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AiAlert &&
        id == other.id &&
        deviceId == other.deviceId &&
        entityId == other.entityId &&
        title == other.title &&
        image == other.image &&
        text == other.text &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, entityId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AiAlert')
          ..add('id', id)
          ..add('deviceId', deviceId)
          ..add('entityId', entityId)
          ..add('title', title)
          ..add('image', image)
          ..add('text', text)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AiAlertBuilder implements Builder<AiAlert, AiAlertBuilder> {
  _$AiAlert? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _entityId;
  String? get entityId => _$this._entityId;
  set entityId(String? entityId) => _$this._entityId = entityId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  AiAlertBuilder();

  AiAlertBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _deviceId = $v.deviceId;
      _entityId = $v.entityId;
      _title = $v.title;
      _image = $v.image;
      _text = $v.text;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AiAlert other) {
    _$v = other as _$AiAlert;
  }

  @override
  void update(void Function(AiAlertBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AiAlert build() => _build();

  _$AiAlert _build() {
    final _$result = _$v ??
        _$AiAlert._(
          id: id,
          deviceId: deviceId,
          entityId: entityId,
          title: title,
          image: image,
          text: text,
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
