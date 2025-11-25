import 'package:admin/models/data/participant_model.dart';
import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'visitor_chat_model.g.dart';

abstract class VisitorChatModel
    implements Built<VisitorChatModel, VisitorChatModelBuilder> {
  factory VisitorChatModel([void Function(VisitorChatModelBuilder) updates]) =
      _$VisitorChatModel;

  VisitorChatModel._();

  static Serializer<VisitorChatModel> get serializer =>
      _$visitorChatModelSerializer;

  @BuiltValueField(wireName: '_id')
  String get id;

  String get message;

  @BuiltValueField(wireName: 'participant_id')
  ParticipantModel get participant;

  @BuiltValueField(wireName: 'participant_type')
  String get participantType;

  DateTime get createdAt;
  DateTime get updatedAt;

  @BuiltValueField(wireName: '__v')
  int get v;

  /// Deserialize a single object
  static VisitorChatModel fromDynamic(dynamic json) {
    return serializers.deserializeWith(VisitorChatModel.serializer, json)!;
  }

  /// Deserialize a list of objects
  static BuiltList<VisitorChatModel> fromDynamics(List<dynamic> list) {
    return BuiltList<VisitorChatModel>(list.map(fromDynamic));
  }
}
