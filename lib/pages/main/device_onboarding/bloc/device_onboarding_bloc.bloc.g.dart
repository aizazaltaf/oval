// ignore_for_file: type=lint, unused_element

part of 'device_onboarding_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class DeviceOnboardingBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<DeviceOnboardingState>? buildWhen;
  final BlocWidgetBuilder<DeviceOnboardingState> builder;

  const DeviceOnboardingBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<DeviceOnboardingBloc, DeviceOnboardingState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class DeviceOnboardingBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<DeviceOnboardingState, T> selector;
  final Widget Function(T state) builder;
  final DeviceOnboardingBloc? bloc;

  const DeviceOnboardingBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static DeviceOnboardingBlocSelector<bool> isBluetoothConnected({
    final Key? key,
    required Widget Function(bool isBluetoothConnected) builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.isBluetoothConnected,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DeviceOnboardingBlocSelector<bool> isDoorbellWifiConnected({
    final Key? key,
    required Widget Function(bool isDoorbellWifiConnected) builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.isDoorbellWifiConnected,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DeviceOnboardingBlocSelector<bool> checkDoorbellWifiConnection({
    final Key? key,
    required Widget Function(bool checkDoorbellWifiConnection) builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.checkDoorbellWifiConnection,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DeviceOnboardingBlocSelector<bool> isWifiConnecting({
    final Key? key,
    required Widget Function(bool isWifiConnecting) builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.isWifiConnecting,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DeviceOnboardingBlocSelector<bool> isBluetoothEnabled({
    final Key? key,
    required Widget Function(bool isBluetoothEnabled) builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.isBluetoothEnabled,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DeviceOnboardingBlocSelector<bool> isScanning({
    final Key? key,
    required Widget Function(bool isScanning) builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.isScanning,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DeviceOnboardingBlocSelector<bool> isConnecting({
    final Key? key,
    required Widget Function(bool isConnecting) builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.isConnecting,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DeviceOnboardingBlocSelector<String?> connectedDeviceId({
    final Key? key,
    required Widget Function(String? connectedDeviceId) builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.connectedDeviceId,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DeviceOnboardingBlocSelector<String?> connectedSSID({
    final Key? key,
    required Widget Function(String? connectedSSID) builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.connectedSSID,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DeviceOnboardingBlocSelector<BuiltList<BluetoothDevice>>
      scannedDevices({
    final Key? key,
    required Widget Function(BuiltList<BluetoothDevice> scannedDevices) builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.scannedDevices,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DeviceOnboardingBlocSelector<BuiltList<String>> wifiNetworks({
    final Key? key,
    required Widget Function(BuiltList<String> wifiNetworks) builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.wifiNetworks,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DeviceOnboardingBlocSelector<String> permissionStatus({
    final Key? key,
    required Widget Function(String permissionStatus) builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.permissionStatus,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DeviceOnboardingBlocSelector<bool> obscurePassword({
    final Key? key,
    required Widget Function(bool obscurePassword) builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.obscurePassword,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DeviceOnboardingBlocSelector<String> wifiPassword({
    final Key? key,
    required Widget Function(String wifiPassword) builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.wifiPassword,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DeviceOnboardingBlocSelector<SocketState<Map<String, dynamic>>>
      getWifiResponse({
    final Key? key,
    required Widget Function(SocketState<Map<String, dynamic>> getWifiResponse)
        builder,
    final DeviceOnboardingBloc? bloc,
  }) {
    return DeviceOnboardingBlocSelector(
      key: key,
      selector: (state) => state.getWifiResponse,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<DeviceOnboardingBloc, DeviceOnboardingState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _DeviceOnboardingBlocMixin on Cubit<DeviceOnboardingState> {
  @mustCallSuper
  void updateIsBluetoothConnected(final bool isBluetoothConnected) {
    if (this.state.isBluetoothConnected == isBluetoothConnected) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isBluetoothConnected = isBluetoothConnected));

    $onUpdateIsBluetoothConnected();
  }

  @protected
  void $onUpdateIsBluetoothConnected() {}

  @mustCallSuper
  void updateIsDoorbellWifiConnected(final bool isDoorbellWifiConnected) {
    if (this.state.isDoorbellWifiConnected == isDoorbellWifiConnected) {
      return;
    }

    emit(this.state.rebuild(
        (final b) => b.isDoorbellWifiConnected = isDoorbellWifiConnected));

    $onUpdateIsDoorbellWifiConnected();
  }

  @protected
  void $onUpdateIsDoorbellWifiConnected() {}

  @mustCallSuper
  void updateCheckDoorbellWifiConnection(
      final bool checkDoorbellWifiConnection) {
    if (this.state.checkDoorbellWifiConnection == checkDoorbellWifiConnection) {
      return;
    }

    emit(this.state.rebuild((final b) =>
        b.checkDoorbellWifiConnection = checkDoorbellWifiConnection));

    $onUpdateCheckDoorbellWifiConnection();
  }

  @protected
  void $onUpdateCheckDoorbellWifiConnection() {}

  @mustCallSuper
  void updateIsWifiConnecting(final bool isWifiConnecting) {
    if (this.state.isWifiConnecting == isWifiConnecting) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.isWifiConnecting = isWifiConnecting));

    $onUpdateIsWifiConnecting();
  }

  @protected
  void $onUpdateIsWifiConnecting() {}

  @mustCallSuper
  void updateIsBluetoothEnabled(final bool isBluetoothEnabled) {
    if (this.state.isBluetoothEnabled == isBluetoothEnabled) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isBluetoothEnabled = isBluetoothEnabled));

    $onUpdateIsBluetoothEnabled();
  }

  @protected
  void $onUpdateIsBluetoothEnabled() {}

  @mustCallSuper
  void updateIsScanning(final bool isScanning) {
    if (this.state.isScanning == isScanning) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isScanning = isScanning));

    $onUpdateIsScanning();
  }

  @protected
  void $onUpdateIsScanning() {}

  @mustCallSuper
  void updateIsConnecting(final bool isConnecting) {
    if (this.state.isConnecting == isConnecting) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isConnecting = isConnecting));

    $onUpdateIsConnecting();
  }

  @protected
  void $onUpdateIsConnecting() {}

  @mustCallSuper
  void updateConnectedDeviceId(final String? connectedDeviceId) {
    if (this.state.connectedDeviceId == connectedDeviceId) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.connectedDeviceId = connectedDeviceId));

    $onUpdateConnectedDeviceId();
  }

  @protected
  void $onUpdateConnectedDeviceId() {}

  @mustCallSuper
  void updateConnectedSsid(final String? connectedSSID) {
    if (this.state.connectedSSID == connectedSSID) {
      return;
    }

    emit(this.state.rebuild((final b) => b.connectedSSID = connectedSSID));

    $onUpdateConnectedSsid();
  }

  @protected
  void $onUpdateConnectedSsid() {}

  @mustCallSuper
  void updateScannedDevices(final BuiltList<BluetoothDevice> scannedDevices) {
    if (this.state.scannedDevices == scannedDevices) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.scannedDevices.replace(scannedDevices);
    }));

    $onUpdateScannedDevices();
  }

  @protected
  void $onUpdateScannedDevices() {}

  @mustCallSuper
  void updateWifiNetworks(final BuiltList<String> wifiNetworks) {
    if (this.state.wifiNetworks == wifiNetworks) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.wifiNetworks.replace(wifiNetworks);
    }));

    $onUpdateWifiNetworks();
  }

  @protected
  void $onUpdateWifiNetworks() {}

  @mustCallSuper
  void updatePermissionStatus(final String permissionStatus) {
    if (this.state.permissionStatus == permissionStatus) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.permissionStatus = permissionStatus));

    $onUpdatePermissionStatus();
  }

  @protected
  void $onUpdatePermissionStatus() {}

  @mustCallSuper
  void updateObscurePassword(final bool obscurePassword) {
    if (this.state.obscurePassword == obscurePassword) {
      return;
    }

    emit(this.state.rebuild((final b) => b.obscurePassword = obscurePassword));

    $onUpdateObscurePassword();
  }

  @protected
  void $onUpdateObscurePassword() {}

  @mustCallSuper
  void updateWifiPassword(final String wifiPassword) {
    if (this.state.wifiPassword == wifiPassword) {
      return;
    }

    emit(this.state.rebuild((final b) => b.wifiPassword = wifiPassword));

    $onUpdateWifiPassword();
  }

  @protected
  void $onUpdateWifiPassword() {}
}
