import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transaction_history_model.g.dart';

abstract class TransactionHistoryModel
    implements Built<TransactionHistoryModel, TransactionHistoryModelBuilder> {
  factory TransactionHistoryModel([
    void Function(TransactionHistoryModelBuilder) updates,
  ]) = _$TransactionHistoryModel;

  TransactionHistoryModel._();

  static Serializer<TransactionHistoryModel> get serializer =>
      _$transactionHistoryModelSerializer;

  int get id;

  @BuiltValueField(wireName: 'subscription_id')
  int get subscriptionId;

  @BuiltValueField(wireName: 'plan_name')
  String get planName;

  String get status;

  String get amount;

  String get type;

  @BuiltValueField(wireName: 'expiry_date')
  String get expiryDate;

  @BuiltValueField(wireName: 'amount_deducted')
  String get amountDeducted;

  @BuiltValueField(wireName: 'date_time')
  String get dateTime;

  @BuiltValueField(wireName: 'tax_deducted')
  String get taxDeducted;

  @BuiltValueField(wireName: 'location')
  DoorbellLocations? get doorbellLocations;

  /// Deserialize single object
  static TransactionHistoryModel fromDynamic(dynamic json) {
    return serializers.deserializeWith(
      TransactionHistoryModel.serializer,
      json,
    )!;
  }

  /// Deserialize list of objects
  static BuiltList<TransactionHistoryModel> fromDynamics(List<dynamic> list) {
    return BuiltList<TransactionHistoryModel>(
      list.map(fromDynamic),
    );
  }
}
