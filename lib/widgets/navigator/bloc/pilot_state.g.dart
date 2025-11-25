// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pilot_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PilotState extends PilotState {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  factory _$PilotState([void Function(PilotStateBuilder)? updates]) =>
      (PilotStateBuilder()..update(updates))._build();

  _$PilotState._({required this.navigatorKey}) : super._();
  @override
  PilotState rebuild(void Function(PilotStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PilotStateBuilder toBuilder() => PilotStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PilotState && navigatorKey == other.navigatorKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, navigatorKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PilotState')
          ..add('navigatorKey', navigatorKey))
        .toString();
  }
}

class PilotStateBuilder implements Builder<PilotState, PilotStateBuilder> {
  _$PilotState? _$v;

  GlobalKey<NavigatorState>? _navigatorKey;
  GlobalKey<NavigatorState>? get navigatorKey => _$this._navigatorKey;
  set navigatorKey(GlobalKey<NavigatorState>? navigatorKey) =>
      _$this._navigatorKey = navigatorKey;

  PilotStateBuilder() {
    PilotState._initialize(this);
  }

  PilotStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _navigatorKey = $v.navigatorKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PilotState other) {
    _$v = other as _$PilotState;
  }

  @override
  void update(void Function(PilotStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PilotState build() => _build();

  _$PilotState _build() {
    final _$result = _$v ??
        _$PilotState._(
          navigatorKey: BuiltValueNullFieldError.checkNotNull(
              navigatorKey, r'PilotState', 'navigatorKey'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
