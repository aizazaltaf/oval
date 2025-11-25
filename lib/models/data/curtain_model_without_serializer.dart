class Device {
  Device({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.enableCloudService,
    required this.hubDeviceId,
    this.calibrate,
    this.master,
    this.openDirection,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      deviceType: json['deviceType'] as String,
      enableCloudService: json['enableCloudService'] as bool,
      hubDeviceId: json['hubDeviceId'] as String,
      calibrate: json['calibrate'] as bool?,
      master: json['master'] as bool?,
      openDirection: json['openDirection'] as String?,
    );
  }
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final bool enableCloudService;
  final String hubDeviceId;
  final bool? calibrate;
  final bool? master;
  final String? openDirection;
}
