import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' show GlobalKey, NavigatorState;

part 'pilot_state.g.dart';

abstract class PilotState implements Built<PilotState, PilotStateBuilder> {
  factory PilotState([
    final void Function(PilotStateBuilder) updates,
  ]) = _$PilotState;

  PilotState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final PilotStateBuilder b) =>
      b.navigatorKey = GlobalKey();

  GlobalKey<NavigatorState> get navigatorKey;
}
