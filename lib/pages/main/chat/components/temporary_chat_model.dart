class TemporaryChatModel {
  TemporaryChatModel({
    required this.deviceId,
    required this.message,
    this.doorbellCallUserId,
    required this.adminUserId,
    required this.time,
    this.visitorId,
    this.participantType = "user",
    this.readStatus = false,
  });

  String deviceId;
  String message;
  String? doorbellCallUserId;
  int adminUserId;
  String participantType;
  int? visitorId;
  int? time;
  bool readStatus;

  TemporaryChatModel copyWith({
    String? deviceId,
    String? message,
    String? doorbellCallUserId,
    int? adminUserId,
    String? participantType,
    int? visitorId,
    int? time,
    bool? readStatus,
  }) {
    return TemporaryChatModel(
      deviceId: deviceId ?? this.deviceId,
      message: message ?? this.message,
      doorbellCallUserId: doorbellCallUserId ?? this.doorbellCallUserId,
      adminUserId: adminUserId ?? this.adminUserId,
      participantType: participantType ?? this.participantType,
      visitorId: visitorId ?? this.visitorId,
      time: time ?? this.time,
      readStatus: readStatus ?? this.readStatus,
    );
  }
}
