// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ChatUserModel> _$chatUserModelSerializer =
    _$ChatUserModelSerializer();
Serializer<ChatVisitorModel> _$chatVisitorModelSerializer =
    _$ChatVisitorModelSerializer();
Serializer<ParticipantModel> _$participantModelSerializer =
    _$ParticipantModelSerializer();

class _$ChatUserModelSerializer implements StructuredSerializer<ChatUserModel> {
  @override
  final Iterable<Type> types = const [ChatUserModel, _$ChatUserModel];
  @override
  final String wireName = 'ChatUserModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, ChatUserModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ChatUserModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ChatUserModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '_id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ChatVisitorModelSerializer
    implements StructuredSerializer<ChatVisitorModel> {
  @override
  final Iterable<Type> types = const [ChatVisitorModel, _$ChatVisitorModel];
  @override
  final String wireName = 'ChatVisitorModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, ChatVisitorModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ChatVisitorModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ChatVisitorModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '_id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ParticipantModelSerializer
    implements StructuredSerializer<ParticipantModel> {
  @override
  final Iterable<Type> types = const [ParticipantModel, _$ParticipantModel];
  @override
  final String wireName = 'ParticipantModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, ParticipantModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'user',
      serializers.serialize(object.user,
          specifiedType: const FullType(ChatUserModel)),
      'visitor',
      serializers.serialize(object.visitor,
          specifiedType: const FullType(ChatVisitorModel)),
      'conversation_id',
      serializers.serialize(object.conversationId,
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
  ParticipantModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ParticipantModelBuilder();

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
        case 'user':
          result.user.replace(serializers.deserialize(value,
              specifiedType: const FullType(ChatUserModel))! as ChatUserModel);
          break;
        case 'visitor':
          result.visitor.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ChatVisitorModel))!
              as ChatVisitorModel);
          break;
        case 'conversation_id':
          result.conversationId = serializers.deserialize(value,
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

class _$ChatUserModel extends ChatUserModel {
  @override
  final int id;
  @override
  final String name;

  factory _$ChatUserModel([void Function(ChatUserModelBuilder)? updates]) =>
      (ChatUserModelBuilder()..update(updates))._build();

  _$ChatUserModel._({required this.id, required this.name}) : super._();
  @override
  ChatUserModel rebuild(void Function(ChatUserModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatUserModelBuilder toBuilder() => ChatUserModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatUserModel && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatUserModel')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class ChatUserModelBuilder
    implements Builder<ChatUserModel, ChatUserModelBuilder> {
  _$ChatUserModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ChatUserModelBuilder();

  ChatUserModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatUserModel other) {
    _$v = other as _$ChatUserModel;
  }

  @override
  void update(void Function(ChatUserModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatUserModel build() => _build();

  _$ChatUserModel _build() {
    final _$result = _$v ??
        _$ChatUserModel._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ChatUserModel', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ChatUserModel', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

class _$ChatVisitorModel extends ChatVisitorModel {
  @override
  final int id;
  @override
  final String name;

  factory _$ChatVisitorModel(
          [void Function(ChatVisitorModelBuilder)? updates]) =>
      (ChatVisitorModelBuilder()..update(updates))._build();

  _$ChatVisitorModel._({required this.id, required this.name}) : super._();
  @override
  ChatVisitorModel rebuild(void Function(ChatVisitorModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatVisitorModelBuilder toBuilder() =>
      ChatVisitorModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatVisitorModel && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatVisitorModel')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class ChatVisitorModelBuilder
    implements Builder<ChatVisitorModel, ChatVisitorModelBuilder> {
  _$ChatVisitorModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ChatVisitorModelBuilder();

  ChatVisitorModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatVisitorModel other) {
    _$v = other as _$ChatVisitorModel;
  }

  @override
  void update(void Function(ChatVisitorModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatVisitorModel build() => _build();

  _$ChatVisitorModel _build() {
    final _$result = _$v ??
        _$ChatVisitorModel._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ChatVisitorModel', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ChatVisitorModel', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

class _$ParticipantModel extends ParticipantModel {
  @override
  final String id;
  @override
  final ChatUserModel user;
  @override
  final ChatVisitorModel visitor;
  @override
  final String conversationId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int v;

  factory _$ParticipantModel(
          [void Function(ParticipantModelBuilder)? updates]) =>
      (ParticipantModelBuilder()..update(updates))._build();

  _$ParticipantModel._(
      {required this.id,
      required this.user,
      required this.visitor,
      required this.conversationId,
      required this.createdAt,
      required this.updatedAt,
      required this.v})
      : super._();
  @override
  ParticipantModel rebuild(void Function(ParticipantModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ParticipantModelBuilder toBuilder() =>
      ParticipantModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParticipantModel &&
        id == other.id &&
        user == other.user &&
        visitor == other.visitor &&
        conversationId == other.conversationId &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        v == other.v;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, visitor.hashCode);
    _$hash = $jc(_$hash, conversationId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, v.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ParticipantModel')
          ..add('id', id)
          ..add('user', user)
          ..add('visitor', visitor)
          ..add('conversationId', conversationId)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('v', v))
        .toString();
  }
}

class ParticipantModelBuilder
    implements Builder<ParticipantModel, ParticipantModelBuilder> {
  _$ParticipantModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ChatUserModelBuilder? _user;
  ChatUserModelBuilder get user => _$this._user ??= ChatUserModelBuilder();
  set user(ChatUserModelBuilder? user) => _$this._user = user;

  ChatVisitorModelBuilder? _visitor;
  ChatVisitorModelBuilder get visitor =>
      _$this._visitor ??= ChatVisitorModelBuilder();
  set visitor(ChatVisitorModelBuilder? visitor) => _$this._visitor = visitor;

  String? _conversationId;
  String? get conversationId => _$this._conversationId;
  set conversationId(String? conversationId) =>
      _$this._conversationId = conversationId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  int? _v;
  int? get v => _$this._v;
  set v(int? v) => _$this._v = v;

  ParticipantModelBuilder();

  ParticipantModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _user = $v.user.toBuilder();
      _visitor = $v.visitor.toBuilder();
      _conversationId = $v.conversationId;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _v = $v.v;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ParticipantModel other) {
    _$v = other as _$ParticipantModel;
  }

  @override
  void update(void Function(ParticipantModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ParticipantModel build() => _build();

  _$ParticipantModel _build() {
    _$ParticipantModel _$result;
    try {
      _$result = _$v ??
          _$ParticipantModel._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ParticipantModel', 'id'),
            user: user.build(),
            visitor: visitor.build(),
            conversationId: BuiltValueNullFieldError.checkNotNull(
                conversationId, r'ParticipantModel', 'conversationId'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ParticipantModel', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'ParticipantModel', 'updatedAt'),
            v: BuiltValueNullFieldError.checkNotNull(
                v, r'ParticipantModel', 'v'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
        _$failedField = 'visitor';
        visitor.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ParticipantModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
