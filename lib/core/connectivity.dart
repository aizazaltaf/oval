import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> initConnectivity() async {
  final List<ConnectivityResult> connectivityResult =
      await Connectivity().checkConnectivity();

// This condition is for demo purposes only to explain every connection type.
// Use conditions which work for your requirements.
  if (connectivityResult.contains(ConnectivityResult.mobile)) {
    singletonBloc.socket?.emit("joinRoom", {
      "room": singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
          .toString(),
      "device_id": await CommonFunctions.getDeviceModel(),
    });
  } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
    singletonBloc.socket?.emit("joinRoom", {
      "room": singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
          .toString(),
      "device_id": await CommonFunctions.getDeviceModel(),
    });
  } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
    singletonBloc.socket?.emit("joinRoom", {
      "room": singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
          .toString(),
      "device_id": await CommonFunctions.getDeviceModel(),
    });
  } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
    singletonBloc.socket?.emit("joinRoom", {
      "room": singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
          .toString(),
      "device_id": await CommonFunctions.getDeviceModel(),
    });
  } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
// Bluetooth connection available.
  } else if (connectivityResult.contains(ConnectivityResult.other)) {
    singletonBloc.socket?.emit("joinRoom", {
      "room": singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
          .toString(),
      "device_id": await CommonFunctions.getDeviceModel(),
    });
  } else if (connectivityResult.contains(ConnectivityResult.none)) {
    singletonBloc.socket?.close();
// No available network types
  }
}
