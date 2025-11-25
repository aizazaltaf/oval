import 'package:admin/models/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscription_location_model.g.dart';

abstract class SubscriptionLocationModel
    implements
        Built<SubscriptionLocationModel, SubscriptionLocationModelBuilder> {
  factory SubscriptionLocationModel([
    void Function(SubscriptionLocationModelBuilder) updates,
  ]) = _$SubscriptionLocationModel;

  SubscriptionLocationModel._();

  static Serializer<SubscriptionLocationModel> get serializer =>
      _$subscriptionLocationModelSerializer;

  String? get name;

  @BuiltValueField(wireName: 'payment_status')
  String? get paymentStatus;

  @BuiltValueField(wireName: 'subscription_status')
  String? get subscriptionStatus;

  @BuiltValueField(wireName: 'expires_at')
  String? get expiresAt;

  @BuiltValueField(wireName: 'trial_ends_at')
  String? get trialEnds;

  String? get amount;

  static SubscriptionLocationModel fromDynamic(json) {
    return serializers.deserializeWith(
      SubscriptionLocationModel.serializer,
      json,
    )!;
  }
}
