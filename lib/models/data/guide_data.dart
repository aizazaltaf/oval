import 'package:admin/models/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'guide_data.g.dart';

abstract class GuideModel implements Built<GuideModel, GuideModelBuilder> {
  factory GuideModel([void Function(GuideModelBuilder) updates]) = _$GuideModel;

  GuideModel._();
  @BuiltValueField(wireName: 'maps_guide')
  int? get mapsGuide;

  @BuiltValueField(wireName: 'visitor_guide')
  int? get visitorGuide;

  @BuiltValueField(wireName: 'statistics_guide')
  int? get statisticsGuide;

  @BuiltValueField(wireName: 'notification_guide')
  int? get notificationGuide;

  @BuiltValueField(wireName: 'manage_devices_guide')
  int? get manageDevicesGuide;

  @BuiltValueField(wireName: 'visitor_history_guide')
  int? get visitorHistoryGuide;

  @BuiltValueField(wireName: 'three_dot_menu_guide')
  int? get threeDotMenuGuide;

  static Serializer<GuideModel> get serializer => _$guideModelSerializer;

  static GuideModel fromDynamic(final json) {
    return serializers.deserializeWith(
      GuideModel.serializer,
      json,
    )!;
  }
}
