import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/core/config.dart';
import 'package:admin/core/images.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/custom_overlay_loader.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';

mixin Constants {
  static void dismissLoader() {
    if (CustomOverlayLoader.isShowing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomOverlayLoader.dismiss();
      });
    }
  }

  static void showLoader({
    bool showPercentage = false,
    bool showCircularLoader = true,
  }) {
    // if call connected do not show loader
    if (singletonBloc.voipBloc != null) {
      if (singletonBloc.voipBloc!.state.isCallConnected ||
          singletonBloc.voipBloc!.state.isReconnecting) {
        return;
      }
    }
    // if (!CustomOverlayLoader.isShowing) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CustomOverlayLoader.show(
        showPercentage: showPercentage,
        showCircularLoader: showCircularLoader,
      );
    });
    // }
  }

  static const String viewer = "viewer";
  static const String admin = "admin";
  static const String superAdmin = "super_admin";
  static String otaSchedule = "ota_schedule";

  static const String roboto = "Roboto";
  static const String setValue = "set_value";

  static String visitor = "visitor";
  static String unwanted = "unwanted";
  static const String addRoomButtonDisableMsg =
      "Please select a room before adding.";
  static String baby = "baby";
  static String pet = "pet";
  static String run = "run";
  static String fire = "fire";
  static String parcel = "parcel";
  static const String addFavorites = "Add To\nFavorites";
  static const String removeFavorites = "Remove \nFavorite";
  static const String sendToDoorbell = "Set to\nDoorbell";

  static final BuiltList<String> initialVoiceControlCommands =
      BuiltList<String>([
    "Show me the visitor history",
    "Add a new room",
    "Turn on the Living Room Light",
    "Increase the thermostat temperature",
  ]);

  static String dog = "dog";
  static const String videoLengthMsg =
      'Please select a video less than 60 seconds';
  static const String reconnecting = 'Reconnecting...';
  static const String connecting = 'Connecting...';
  static String poop = "poop";
  static String eavesdropper = "eavesdropper";
  static String intruder = "intruder";
  static String weapon = "weapon";
  static String humanFall = "human fall";
  static String wildAnimal = "wild animal";
  static String drowning = "drowning";
  static String boundaryBreach = "boundary breach";
  static String movement = "movement";
  static String motion = "motion";
  static String monitoring = "monitoring";
  static String onlyAlert = "alert!";
  static String doorbellTheft = "doorbell theft";
  static String wifi = "wifi";
  static const String camera = "camera";
  static const String smartLock = "lock";
  static const String curtain = "switchbot";
  static const String light = "light";
  static const String thermostat = "thermostat";
  static const String thermostate = "thermostate";
  static const String bulb = "bulb";
  static const String hub = "hub";
  static const String climate = "climate";
  static const String unavailable = "unavailable";
  static String interruptions = "interruptions";
  static String powerDisconnect = "power disconnect";
  static String powerOff = "power off";
  static String emergency = "emergency";
  static String doorbellAccessRelease = "doorbell access release";
  static String subscription = "subscription";
  static String creditCard = "credit card";
  static String paymentDeclined = "payment declined";
  static String lowBattery = "low battery";
  static String requestNotif = "request";
  static String spam = "spam";
  static String roomId = "room_id";
  static String command = "command";
  static String uuid = "uuid";
  static String callType = "call_type";
  static String callerId = "caller_id";
  static String time = "time";
  static String deviceName = "device_name";
  static String deviceId = "device_id";
  static String adminDeviceId = "admin_device_id";
  static String userId = "user_id";
  static String request = "request";
  static String sessionId = "session_id";
  static String data = "data";
  static String brand = "brand";
  static String host = "host";
  static String state = "state";
  static const String message = "message";
  static const String busy = "busy";
  static const String acknowledgement = "acknowledgement";
  static const String typing = "typing";
  static String comMessage = "com-message";
  static String voip = "voip";
  static String signaling = "signaling";
  static String chat = "chat";
  static String openChat = "open_chat";
  static String endChat = "end_chat";
  static String wifiChange = "wifi_change";
  static String wifiList = "wifi_list";
  static String answer = "answer";
  static String candidate = "candidate";
  static String offer = "offer";
  static String iot = "iot";
  static String doorbell = "doorbell";
  static String theme = "theme";
  static String congratulations = "congratulations";
  static String reminder = "Reminder";
  static String paymentSuccessful = "payment successful";
  static String paymentSchedule = "payment schedule";
  static String voicemail = "voicemail";
  static String location = "location";
  static String stream = "stream";
  static String irvineiTitle = "irvinei";
  static String smartDevice = "smart device";
  static String subscriptionExpiringSoon = "subscription expiring soon";
  static String subscriptionExpired = "subscription expired";
  static String requestRejected = "request rejected";
  static String subscriptionDowngraded = "subscription downgraded";
  static String unwantedVisitor = "unwanted visitor";
  static String flashlightEnabled = "flashlight enabled";
  static String flashlightDisabled = "flashlight Disabled";
  static String today = "Today";
  static String customName = "Custom Name";
  static String customDate = "Custom Date";
  static String iotAlerts = "Iot Alerts";
  static String aiAlerts = "Ai Alerts";
  static String threeMonths = "Three Months";
  static String yesterday = "Yesterday";
  static String thisWeek = "This Week";
  static String thisMonth = "This Month";
  static String lastWeek = "Last Week";
  static String lastMonth = "Last Month";
  static String custom = "Custom";
  static RegExp noNumberSpecialCharacterRegex = RegExp(r'^[a-zA-Z ]+$');
  static RegExp emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  static RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]+$',
  );
  static const String peakVisitorsHourKey = "peak_visitors_hour";
  static const String daysOfWeekKey = "days_of_week";
  static const String frequencyOfVisitsKey = "visitor_frequency";
  static const String unknownVisitorsKey = "unknown_visitors";

  static const String subscriptionAlerts = "Subscription Alerts";
  static const String spamAlerts = "Spam Alerts";
  static const String neighbourhoodAlerts = "Neighbourhood Alerts";
  static const String doorbellAlerts = "Doorbell Theft Alerts";
  static const String ioTAlerts = "IoT Alerts";
  static const String aIAlerts = "AI Alerts";
  static const String visitorAlert = "Visitor Alert";
  static const String babyRunningAway = "Baby Running Away";
  static const String petRunningAway = "Pet Running Away";
  static const String fireAlert = "Fire Alert";
  static const String intruderAlert = "Intruder Alert";
  static const String parcelAlert = "Parcel Alert";
  static const String dogPoop = "Dog Poop";
  static const String drowningAlert = "Drowning Alert";

  static const String doorbellAudioCall = "voice_call";
  static const String convertToAudioCall = "convert_audio";
  static const String convertToVideoCall = "convert_video";
  static const String silentDoorbellAudioCall = "silent_voice_call";
  static const String silentDoorbellVideoCall = "silent_video_call";
  static const String doorbellStreamAudio = "audio_streaming";
  static const String networkSwitch = "network_switch";
  static const String doorbellVideoCall = "video_call";
  static const String doorbellOneWayVideo = "one_way_video";
  static const String callActive = "call_active";
  static const String doorbellSilentVideoCall = "silent_video_call";
  static const String callVisualiserRecording = "call_visualiser_recording";
  static const String liveStream = "live_stream";
  static const String notificationEndCall = "end_call";
  // static const String endAudioStreaming = "end_audio_streaming";
  static const String notificationSilentEndCall = "end_video";
  static const String streamingAudioEnd = "stop_audio_streaming";
  static const String silentNotificationEndCall = "silent_end_call";

  ///REMARKS:Doorbell Topic requests
  static const String doorbellScanned = "scanned";
  static const String doorbellLocation = "location";
  static const String doorbellName = "doorbell_name";
  static const String doorbellSetupComplete = "setup_complete";
  static const String doorbellRelease = "release";
  static const String doorbellProcessTermination = "termination";

  ///REMARKS:Doorbell Topic requests
  static const String doorbellEdgeLight = "edge_light";
  static const String doorbellLuminousLight = "luminus_light";

  ///REMARKS: Simple Switch commands
  static String turnOnSimple = "turn_on";
  static String turnOffSimple = "turn_off";

  ///REMARKS:Iot Topic requests
  static const String scanDevices = "scan_devices";
  static const String deviceConfig = "device_config";
  static const String deviceConfigFlowId = "device_config_flow_id";
  static const String getFlowIds = "get_flow_ids";
  static const String addDevice = "add_device";
  static const String deleteDevice = "delete_device";
  static const String operateIotDevice = "operate_iot_devices";
  static const String getDeviceDetailById = "get_device_detail_by_id";
  static const String allIotDevicesState = "all_iot_devices_state";
  static const String allIotDevicesStateReconnected =
      "all_iot_devices_state_reconnected";
  static const String getAllHomeassistantGroupedDevices =
      "get_all_homeassistant_grouped_devices";

  static String turnOn = "light/turn_on";
  static String rgbwColor = "rgbw_color";
  static String colorTemp = "color_temp";
  static String turnOff = "light/turn_off";
  static int durationRefreshSeconds = 2;

  static String lock = "lock/lock";
  static String unlock = "lock/unlock";
  static String locked = "locked";

  static final hasUpperCase = RegExp(r'[A-Z]');
  static final hasLowerCase = RegExp(r'[a-z]');
  static final hasNumber = RegExp(r'[0-9]');
  static final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  static const isAtLeast8Chars = 8;
  static const String sessionExpired = "session expired";
  static String homeAssistantBrandUrl =
      "https://brands.home-assistant.io/brands/_/";

  static List<FeatureModel> alertsMeta = [
    FeatureModel(
      title: "Fire",
      image: DefaultVectors.FIRE_STREAM_ALERT,
      color: AppColors.motionAlertColor,
    ),
    FeatureModel(
      title: "Weapon",
      image: DefaultVectors.WEAPON_ALERT,
      color: AppColors.motionAlertColor,
    ),
    FeatureModel(
      title: "Visitor",
      image: DefaultVectors.VISITOR_AI,
      color: AppColors.motionAlertColor,
    ),
    FeatureModel(
      title: "Parcel",
      image: DefaultVectors.PARCEL_AI,
      color: AppColors.motionAlertColor,
    ),
    FeatureModel(
      title: "Baby",
      image: DefaultVectors.BABY_AI,
      color: AppColors.motionAlertColor,
    ),
    FeatureModel(
      title: "Pet",
      image: DefaultVectors.PET_AI,
      color: AppColors.motionAlertColor,
    ),
    FeatureModel(
      title: "motion_started",
      image: DefaultVectors.MOTION_STREAM_ALERT,
      color: AppColors.motionAlertColor,
    ),
  ];

  static FeatureModel noAlert = FeatureModel(
    title: "",
    image: DefaultVectors.MOTION_STREAM_ALERT,
    color: AppColors.darkPrimaryColor,
  );
  static double alertWidth = 40 * 5;
  static String phoneNumberTitle = "Phone Number";
  static String roleTitle = "Role";
  static String pending = "pending";

  /// Subscription Web Urls
  static String upgradeDowngradeUrl = "${config.accountsUrl}subscription/update"
      "/${singletonBloc.profileBloc.state?.callUserId}"
      "/${singletonBloc.profileBloc.state?.selectedDoorBell?.locationId}";

  static String subscribeOnboardingUrl =
      "${config.accountsUrl}subscription/onboarding"
      "/${singletonBloc.profileBloc.state?.callUserId}"
      "/${singletonBloc.profileBloc.state?.selectedDoorBell?.locationId}";

  static String addPaymentMethodUrl =
      "${config.accountsUrl}payment/pma/${singletonBloc.profileBloc.state?.callUserId}";

  /// Get Box keys
  static String wrongPasswordCounts = "wrong_password_counts";
  static String wrongPasswordTime = "wrong_password_time";
  static String pinnedSections = "pinned_sections";
  static String pinnedCameras = "pinned_cameras";

  /// Guides Keys
  static String mapsGuideKey = "maps_guide";
  static String visitorGuideKey = "visitor_guide";
  static String statisticsGuideKey = "statistics_guide";
  static String notificationGuideKey = "notification_guide";
  static String manageDevicesGuideKey = "manage_devices_guide";
  static String visitorHistoryGuideKey = "visitor_history_guide";
  static String threeDotMenuGuideKey = "three_dot_menu_guide";

  static String setTemperature = "climate/set_temperature";

  /// App Urls
  static const String visitIrvineiUrl = "https://irvinei.com/";
  static const String shopDoorbellMoreUrl =
      "https://sale.irvinei.com/products/irvinei-ai-powered-touchscreen-doorbell?_gl=1*1srqyzn*_ga*MTEyMjQzNjc4My4xNzIxNDkxNjg5*_ga_J2RRNQXP0Q*MTcyMTc0NzgyOC4xLjAuMTcyMTc0Nzg5MC4wLjAuMA..*_gcl_au*MzA3NDQ1MTM1LjE3MjE0OTE2ODk.*_ga_C79Y2J9E57*MTcyMTc0Nzg0NS4zLjAuMTcyMTc0Nzg5MC4wLjAuMA..";
  static const String guardPlansUrl = "https://irvinei.com/pages/guard-plans";
  static const Set<String> allowedEntityIds = {
    'all_day_video_recording',
    'audio',
    'follow_movement',
    'infrared_light',
    'ptz_down',
    'ptz_right',
    'ptz_left',
    'sleep',
    'ptz_up',
    'light',
    'siren',
    'infra_red_lights_in_night_mode',
    'motion_sensitivity',
    'record',
    'record_audio',
    'autofocus',
    'ir_lamp',
    'wiper',
    'set_system_date_and_time',
    'reboot',
  };

  static final Map<String, int> brandMap = {
    "august": 3,
    "ezviz": 2,
    "govee_light_local": 1,
    "honeywell": 2,
    "lifx": 2,
    "onvif": 2,
    "reolink": 2,
    "ring": 3,
    "sensi": 2,
    "switchbot_cloud": 2,
    "tplink": 2,
    "wiz": 2,
    "wyzeapi": 2,
  };

  static final Map<String, Map<String, String>> toolTipText = {
    "wiz": {
      "host":
          "Obtain the Host address from the Wiz mobile app under Device Settings > Network Info.",
    },
    "tplink": {
      "host":
          "Find the Host/IP address in the TP-Link Kasa app under Device Info.",
    },
    "lifx": {
      "host": "Get the Host/IP from the Lifx mobile app in Network Settings.",
    },
    "wyzeapi": {
      "username": "Enter the email used to sign in to your Wyze account.",
      "password": "Enter the password used to sign in to your Wyze account.",
      "key_id": "Get your KeyID from the Wyze developer portal.",
      "api_key":
          "Get your API Key from the Wyze developer portal: https://developer.wyze.com.",
    },
    "govee_light_local": {
      "host":
          "Obtain the Host address from the Govee mobile app under Device Settings > Network Info.",
    },
    "reolink": {
      "host":
          "Find the camera Host/IP in Reolink app > Device Settings > Network.",
      "email": "Use the email registered with your Reolink account.",
      "password": "Use the password registered with your Reolink account.",
    },
    "ezviz": {
      "host":
          "Enter the camera Host/IP from your Ezviz camera network settings.",
      "username": "Use the email registered with your Ezviz account.",
      "password": "Use the password registered with your Ezviz account.",
    },
    "onvif": {
      "host": "Camera Host/IP can be found in your camera’s network settings.",
      "email": "Use the email registered with your ONVIF camera account.",
      "password": "Use the password registered with your ONVIF camera account.",
    },
    "ring": {
      "email": "Use the email registered with your Ring account.",
      "password": "Use the password registered with your Ring account.",
      "2fa": "Enter the 2FA code from your Ring app if 2FA is enabled.",
    },
    "sensi": {
      "email": "Use the email registered with your Sensi account.",
      "password": "Use the password registered with your Sensi account.",
    },
    "honeywell": {
      "email": "Use the email registered with your Honeywell account.",
      "password": "Use the password registered with your Honeywell account.",
    },
    "switchbot_cloud": {
      "api_key":
          "Get your API Key from the SwitchBot app under Profile > Preferences > About > Tap AppVersion 7 times > Developer Options.",
      "api_token":
          "Get your API Token from the SwitchBot app under Profile > Preferences > About > Tap AppVersion 7 times > Developer Options.",
    },
    "august": {
      "username": "Use the email registered with your August account.",
      "password": "Use the password registered with your August account.",
      "verification_code":
          "Enter the verification code from your August app if 2FA is enabled.",
    },
  };
}

mixin VCConstants {
  static const String connectThermostat = "ADD_SMART_DEVICE";
  static const String recentlyUsedIotDevices = "MANAGE_SMART_DEVICE";
  static const String roomScreen = "ROOM_SCREEN";
  static const String showConnectedDevices = "SHOW_CONNECTED_DEVICES";
  static const String viewRoom = "VIEW_ROOM";
  static const String addLight = "ADD_SMART_DEVICE";
  static const String addCurtain = "ADD_SMART_DEVICE";
  static const String showDoorBellLocationAgainstAccount =
      "SHOW_DOORBELL_LOCATION_AGAINST_ACCOUNT";

  static const String listDevicesByStatus = "LIST_DEVICES_BY_STATUS";
  static const String listDeviceLightStatus = "LIST_DEVICE_LIGHT_STATUS";
  static const String showDevicesByStatus = "SHOW_DEVICES_BY_STATUS";
  static const String showLoggedInDevices = "SHOW_LOGGEDIN_DEVICES";
  static const String logoutAllSessions = "LOGOUT";
  static const String showFeaturesIrvinei = "MORE";
  static const String showFeatures = "MORE";
  static const String openHomeScreen = "OPEN_HOME_SCREEN";
  static const String openHomeScreenDashboard = "HOME_SCREEN";
  static const String openUserManagement = "MANAGE_USER";
  static const String addNewUser = "ADD_USER";
  static const String logoutUserSession = "LOGOUT";
  static const String showMyProfile = "SHOW_MY_PROFILE";
  static const String editMyProfile = "UPDATE_PROFILE";
  static const String openThemeWindow = "THEME_WINDOW";
  static const String openMyThemeWindow = "THEME_WINDOW";
  static const String openFavouritesThemeWindow = "THEME_WINDOW";
  static const String openPopularThemes = "THEME_WINDOW";
  static const String openVideoThemes = "THEME_WINDOW";
  static const String openGifsThemes = "THEME_WINDOW";
  static const String uploadThemeFromGallery = "UPLOAD_THEME";
  static const String addDoorbell = "ADD_DOORBELL";
  static const String addNewDoorbell = "ADD_NEW_DOORBELL";
  static const String addNewDoorbellCamera = "ADD_NEW_DOORBELL_CAMERA";
  static const String purchaseDoorbell = "PURCHASE_DOORBELL";
  static const String openManageDoorbellsWindow =
      "OPEN_MANAGE_DOORBELLS_WINDOW";
  static const String openCameraMonitoring = "MONITOR_CAMERA";
  static const String openLocationSettings = "LOCATION_WINDOW";
  static const String list = "LIST";
  static const String addNewCamera = "ADD_SMART_DEVICE";
  static const String appSetting = "MORE";
  static const String status = "STATUS";
  static const String countCameraMonitoring = "COUNT_CAMERA_MONITORING";
  static const String listDoorbellNameGroupedByLocation =
      "LIST_DOORBELL_NAME_GROUPED_BY_LOCATION";
  static const String connectSmartLock = "ADD_SMART_DEVICE";
  static const String addNewSmartLock = "ADD_NEW_SMARTLOCK";
  static const String editLocationByName = "EDIT_LOCATION_BY_NAME";
  static const String openDeviceManagement = "OPEN_DEVICE_MANAGEMENT";
  static const String addNewDevice = "ADD_NEW_DEVICE";
  static const String delete = "DELETE";
  static const String disconnectThermostat = "DISCONNECT_THERMOSTAT";
  static const String connect = "CONNECT";
  static const String disconnect = "DISCONNECT";
  static const String edit = "EDIT";
  static const String showDeviceLightStatus = "SHOW_DEVICE_LIGHT_STATUS";
  static const String setThermostatTemperature = "SET_THERMOSTAT_TEMPERATURE";
  static const String changeThermostatTemperature =
      "CHANGE_THERMOSTAT_TEMPERATURE";
  static const String setCurtainPosition = "SET_CURTAIN_POSITION";
  static const String transferOwnership = "TRANSFER_OWNERSHIP";
  static const String createAiTheme = "CREATE_AI_THEME";
  static const String releaseDoorbell = "RELEASE_DOORBELL";
  static const String increaseThermostatTemperature =
      "INCREASE_THERMOSTAT_TEMPERATURE";
  static const String decreaseThermostatTemperature =
      "DECREASE_THERMOSTAT_TEMPERATURE";
  static const String switchThermostatModesHeat =
      "SWITCH_THERMOSTAT_MODES_HEAT";
  static const String switchThermostatModesCool =
      "SWITCH_THERMOSTAT_MODES_COOL";
  static const String switchThermostatModesOff = "SWITCH_THERMOSTAT_MODES_OFF";

  static const String checkCameraStatusByName =
      "CHECK_CAMERA_STATUS_BY_CAMERA_NAME";
  static const String switchThermostatFanOn = "SWITCH_THERMOSTAT_FAN_ON";
  static const String switchThermostatFanAuto = "SWITCH_THERMOSTAT_FAN_AUTO";
  static const String switchThermostatFanDiffuse =
      "SWITCH_THERMOSTAT_FAN_DIFFUSE";
  static const String locationReleaseByName = "LOCATION_RELEASE_BY_NAME";

  static const String editBlindsName = "EDIT_BLIND_NAME";

  static const String showBlindsPosition = "SHOW_BLIND_POSITION";
  static const String changeLightColor = "CHANGE_LIGHT_COLOR";
  static const String changeColor = "CHANGE_COLOR";
  static const String changeBrightness = "CHANGE_BRIGHTNESS";
  static const String changeLightMode = "CHANGE_LIGHT_MODE";
  static const String showCurrentThemeApplied = "SHOW_CURRENT_THEME_APPLIED";
  static const String makeACallWithVisitor = "MAKE_A_CALL_WITH_VISITOR";

  static const String addNameToUnwantedVisitor = "ADD_NAME_TO_UNWANTED_VISITOR";
  // static const String showVisitorChatHistoryByName =
  //     "SHOW_VISITOR_CHAT_HISTORY_BY_NAME";
  static const String devicesByRoom = "DEVICES_BY_ROOM";
  static const String showThermostatTemperature = "SHOW_THERMOSTAT_TEMPERATURE";

  static const String showCurtainPosition = "SHOW_CURTAIN_POSITION";
  static const String showTemperatureInside = "SHOW_TEMPERATURE_INSIDE";
  static const String increaseCooling = "INCREASE_COOLING";
  static const String decreaseCooling = "DECREASE_COOLING";
  static const String decreaseHeating = "DECREASE_HEATING";
  static const String increaseHeating = "INCREASE_HEATING";
  static const String showDevicesByRoom = "SHOW_DEVICES_BY_ROOM";
  static const String moveDeviceToRoom = "MOVE";
  static const String doorbellStream = "DOORBELL_STREAM";
  static const String showTemperatureOutside = "SHOW_TEMPERATURE_OUTSIDE";

  static const String openStatistic = "OPEN_STATISTICS";

  static const String openVisitorManagement = "OPEN_VISITOR_MANAGEMENT";
  // static const String showVisitorHistoryByName = "SHOW_VISITOR_HISTORY_BY_NAME";

  static const String openThemeCategory = "THEME_WINDOW";

  static const String startChat = "START_CHAT";
  static const String addRoom = "ADD_ROOM";
  static const String makeVideoCall = "MAKE_VIDEO_CALL";
  static const String makeAudioCall = "MAKE_AUDIO_CALL";

  static const String openNotification = "OPEN_NOTIFICATION";
}
