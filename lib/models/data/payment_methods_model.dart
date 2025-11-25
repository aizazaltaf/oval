import 'package:admin/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_methods_model.g.dart';

abstract class PaymentMethodsModel
    implements Built<PaymentMethodsModel, PaymentMethodsModelBuilder> {
  factory PaymentMethodsModel([
    void Function(PaymentMethodsModelBuilder) updates,
  ]) = _$PaymentMethodsModel;

  PaymentMethodsModel._();

  static Serializer<PaymentMethodsModel> get serializer =>
      _$paymentMethodsModelSerializer;

  int get id;

  @BuiltValueField(wireName: 'user_id')
  int get userId;

  @BuiltValueField(wireName: 'payment_method_id')
  String get paymentMethodId;

  String? get type;

  String? get brand;

  String? get last4;

  @BuiltValueField(wireName: 'exp_month')
  String? get expMonth;

  @BuiltValueField(wireName: 'exp_year')
  String? get expYear;

  @BuiltValueField(wireName: 'is_default')
  bool? get isDefault;

  @BuiltValueField(wireName: 'is_active')
  bool? get isActive;

  @BuiltValueField(wireName: 'wallet_email_address')
  String? get walletEmailAddress;

  @BuiltValueField(wireName: 'created_at')
  String? get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  String? get updatedAt;

  static PaymentMethodsModel fromDynamic(dynamic json) {
    return serializers.deserializeWith(
      PaymentMethodsModel.serializer,
      json,
    )!;
  }

  static BuiltList<PaymentMethodsModel> fromDynamics(List<dynamic> list) {
    return BuiltList<PaymentMethodsModel>(list.map(fromDynamic));
  }
}
