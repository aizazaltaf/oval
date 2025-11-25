import 'package:admin/models/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'participant_model.g.dart';

abstract class ChatUserModel
    implements Built<ChatUserModel, ChatUserModelBuilder> {
  factory ChatUserModel([void Function(ChatUserModelBuilder) updates]) =
      _$ChatUserModel;
  ChatUserModel._();

  static Serializer<ChatUserModel> get serializer => _$chatUserModelSerializer;

  @BuiltValueField(wireName: '_id')
  int get id;

  String get name;

  static ChatUserModel fromDynamic(dynamic json) {
    return serializers.deserializeWith(ChatUserModel.serializer, json)!;
  }
}

abstract class ChatVisitorModel
    implements Built<ChatVisitorModel, ChatVisitorModelBuilder> {
  factory ChatVisitorModel([void Function(ChatVisitorModelBuilder) updates]) =
      _$ChatVisitorModel;
  ChatVisitorModel._();

  static Serializer<ChatVisitorModel> get serializer =>
      _$chatVisitorModelSerializer;

  @BuiltValueField(wireName: '_id')
  int get id;

  String get name;

  static ChatVisitorModel fromDynamic(dynamic json) {
    return serializers.deserializeWith(ChatVisitorModel.serializer, json)!;
  }
}

abstract class ParticipantModel
    implements Built<ParticipantModel, ParticipantModelBuilder> {
  factory ParticipantModel([void Function(ParticipantModelBuilder) updates]) =
      _$ParticipantModel;

  ParticipantModel._();

  static Serializer<ParticipantModel> get serializer =>
      _$participantModelSerializer;

  @BuiltValueField(wireName: '_id')
  String get id;

  ChatUserModel get user;
  ChatVisitorModel get visitor;

  @BuiltValueField(wireName: 'conversation_id')
  String get conversationId;

  DateTime get createdAt;
  DateTime get updatedAt;

  @BuiltValueField(wireName: '__v')
  int get v;

  /// Deserialize a single ParticipantModel
  static ParticipantModel fromDynamic(dynamic json) {
    return serializers.deserializeWith(ParticipantModel.serializer, json)!;
  }
}
