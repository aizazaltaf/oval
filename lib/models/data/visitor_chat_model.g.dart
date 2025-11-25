// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor_chat_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<VisitorChatModel> _$visitorChatModelSerializer =
    _$VisitorChatModelSerializer();

class _$VisitorChatModelSerializer
    implements StructuredSerializer<VisitorChatModel> {
  @override
  final Iterable<Type> types = const [VisitorChatModel, _$VisitorChatModel];
  @override
  final String wireName = 'VisitorChatModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, VisitorChatModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
      'participant_id',
      serializers.serialize(object.participant,
          specifiedType: const FullType(ParticipantModel)),
      'participant_type',
      serializers.serialize(object.participantType,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(DateTime)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(DateTime)),
      '__v',
      serializers.serialize(object.v, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  VisitorChatModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = VisitorChatModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '_id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'participant_id':
          result.participant.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ParticipantModel))!
              as ParticipantModel);
          break;
        case 'participant_type':
          result.participantType = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime))! as DateTime;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime))! as DateTime;
          break;
        case '__v':
          result.v = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$VisitorChatModel extends VisitorChatModel {
  @override
  final String id;
  @override
  final String message;
  @override
  final ParticipantModel participant;
  @override
  final String participantType;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int v;

  factory _$VisitorChatModel(
          [void Function(VisitorChatModelBuilder)? updates]) =>
      (VisitorChatModelBuilder()..update(updates))._build();

  _$VisitorChatModel._(
      {required this.id,
      required this.message,
      required this.participant,
      required this.participantType,
      required this.createdAt,
      required this.updatedAt,
      required this.v})
      : super._();
  @override
  VisitorChatModel rebuild(void Function(VisitorChatModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VisitorChatModelBuilder toBuilder() =>
      VisitorChatModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VisitorChatModel &&
        id == other.id &&
        message == other.message &&
        participant == other.participant &&
        participantType == other.participantType &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        v == other.v;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, participant.hashCode);
    _$hash = $jc(_$hash, participantType.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, v.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VisitorChatModel')
          ..add('id', id)
          ..add('message', message)
          ..add('participant', participant)
          ..add('participantType', participantType)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('v', v))
        .toString();
  }
}

class VisitorChatModelBuilder
    implements Builder<VisitorChatModel, VisitorChatModelBuilder> {
  _$VisitorChatModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ParticipantModelBuilder? _participant;
  ParticipantModelBuilder get participant =>
      _$this._participant ??= ParticipantModelBuilder();
  set participant(ParticipantModelBuilder? participant) =>
      _$this._participant = participant;

  String? _participantType;
  String? get participantType => _$this._participantType;
  set participantType(String? participantType) =>
      _$this._participantType = participantType;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  int? _v;
  int? get v => _$this._v;
  set v(int? v) => _$this._v = v;

  VisitorChatModelBuilder();

  VisitorChatModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _message = $v.message;
      _participant = $v.participant.toBuilder();
      _participantType = $v.participantType;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _v = $v.v;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VisitorChatModel other) {
    _$v = other as _$VisitorChatModel;
  }

  @override
  void update(void Function(VisitorChatModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VisitorChatModel build() => _build();

  _$VisitorChatModel _build() {
    _$VisitorChatModel _$result;
    try {
      _$result = _$v ??
          _$VisitorChatModel._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'VisitorChatModel', 'id'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'VisitorChatModel', 'message'),
            participant: participant.build(),
            participantType: BuiltValueNullFieldError.checkNotNull(
                participantType, r'VisitorChatModel', 'participantType'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'VisitorChatModel', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'VisitorChatModel', 'updatedAt'),
            v: BuiltValueNullFieldError.checkNotNull(
                v, r'VisitorChatModel', 'v'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'participant';
        participant.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VisitorChatModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
