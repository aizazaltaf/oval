enum AppRestrictions {
  notificationSnap,
  recordings,
  snapshotCapture,
  audioVideoCallButtons,
  visitorLogsAndChatHistory,
  addLight,
  doorbellRecording,
  addCameraAndAllIot,
  addSmartLock,
  aiThemeButton,
}

extension AppRestrictionsExtension on AppRestrictions {
  String get name => switch (this) {
        AppRestrictions.notificationSnap => "Notification Snap",
        AppRestrictions.recordings => "Recordings",
        AppRestrictions.snapshotCapture => "Snapshot Capture",
        AppRestrictions.audioVideoCallButtons => "Audio / Video Call Buttons",
        AppRestrictions.visitorLogsAndChatHistory => "Visitor Logs",
        AppRestrictions.addLight => "Light Add",
        AppRestrictions.doorbellRecording => "Doorbell Recordings",
        AppRestrictions.addCameraAndAllIot => "Add Camera and other All Iot",
        AppRestrictions.addSmartLock => "Add Smart Lock",
        AppRestrictions.aiThemeButton => "AI Button",
      };

  String get code => switch (this) {
        AppRestrictions.notificationSnap => "010102",
        AppRestrictions.recordings => "0202",
        AppRestrictions.snapshotCapture => "0206",
        AppRestrictions.audioVideoCallButtons => "0301",
        AppRestrictions.visitorLogsAndChatHistory => "0304",
        AppRestrictions.addLight => "060101",
        AppRestrictions.doorbellRecording => "060102",
        AppRestrictions.addCameraAndAllIot => "060103",
        AppRestrictions.addSmartLock => "0602",
        AppRestrictions.aiThemeButton => "0901",
      };
}
