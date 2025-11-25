import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/app_restrictions.dart';
import 'package:admin/core/config.dart';
import 'package:admin/extensions/date_time.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/main.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/chat/bloc/chat_bloc.dart';
import 'package:admin/pages/main/chat/chat_screen.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/notifications/notification_page.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/call_screen.dart';
import 'package:admin/pages/main/voip/streaming_page.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_overlay_loader.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

final _logger = Logger("notification_service.dart");

mixin NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    try {
      // Initialize Pushy
      Pushy.listen();
      Pushy.setAppId(config.pushyKey);
      Pushy.setNotificationIcon('notification_icon');
      Pushy.setNotificationListener(backgroundNotificationListener);
      Pushy.toggleInAppBanner(true);

      // Initialize flutter_local_notifications
      const AndroidInitializationSettings androidInitSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSetting =
          DarwinInitializationSettings();

      const InitializationSettings settings = InitializationSettings(
        android: androidInitSettings, iOS: iosSetting,

        // Add iOS settings if needed
      );

      Pushy.setNotificationClickListener((data) {
        if (Platform.isIOS) {
          if (data["payload"] != null) {
            final payload = data["payload"].toString();
            if (payload.contains("pdf")) {
              OpenFile.open(payload);
            } else {
              notificationTap();
            }
          } else {
            notificationTap();
          }
        }
      });

      await notificationsPlugin.initialize(
        settings,
        onDidReceiveNotificationResponse: handleNotificationTap,
        onDidReceiveBackgroundNotificationResponse: handleNotificationTap,
      );

      await notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      // notificationsPlugin.show(
      //     1, 'Attention', 'Two messages', const NotificationDetails());

      _logger.fine(
        'Pushy and flutter_local_notifications initialized successfully.',
      );
    } catch (e) {
      _logger.fine('Error initializing notifications: $e');
    }
  }

  static void notificationTap() {
    try {
      // Validate navigator key and context
      if (singletonBloc.navigatorKey?.currentState?.context == null ||
          singletonBloc.profileBloc.state == null) {
        _logger.warning(
          "Navigator key or profile state is null, delaying notification tap",
        );
        Future.delayed(const Duration(seconds: 6), _retryNotificationTap);
        return;
      }

      final context = singletonBloc.navigatorKey!.currentState!.context;

      // Check if context is still mounted
      if (!context.mounted) {
        _logger.warning("Context is not mounted, delaying notification tap");
        Future.delayed(const Duration(seconds: 6), _retryNotificationTap);
        return;
      }

      // Handle VoIP call state
      if (singletonBloc.voipBloc != null) {
        _logger.fine(
          "VoIP call connected: ${singletonBloc.voipBloc!.state.isCallConnected}",
        );
        if (singletonBloc.voipBloc!.state.isCallConnected) {
          _logger.fine("Call is connected, skipping notification tap");
          return;
        }
      }

      _processNotificationTap(context);
    } catch (e) {
      _logger.severe("Error in notificationTap: $e");
      // Retry after delay
      Future.delayed(const Duration(seconds: 6), _retryNotificationTap);
    }
  }

  static void _retryNotificationTap() {
    try {
      if (singletonBloc.navigatorKey?.currentState?.context == null ||
          singletonBloc.profileBloc.state == null) {
        _logger.warning("Retry failed: Navigator key or profile state is null");
        return;
      }

      final context = singletonBloc.navigatorKey!.currentState!.context;
      if (!context.mounted) {
        _logger.warning("Retry failed: Context is not mounted");
        return;
      }

      _processNotificationTap(context);
    } catch (e) {
      _logger.severe("Error in retry notification tap: $e");
    }
  }

  static void _processNotificationTap(BuildContext context) {
    try {
      final blocIot = IotBloc.of(context);

      if (blocIot.state.currentFormStep == null &&
          !CustomOverlayLoader.isShowing) {
        final bloc = NotificationBloc.of(context);

        // Update doorbell data if available
        if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
          try {
            bloc
              ..callNotificationApi(refresh: true)
              ..callDevicesApi();

            if (singletonBloc.profileBloc.state?.selectedDoorBell?.locationId !=
                null) {
              bloc.callStatusApi(shouldNew: false);
            }
          } catch (e) {
            _logger.severe("Error calling notification APIs: $e");
          }
        }

        // Navigate to notification page if not already there
        if (!bloc.isOnNotificationPage) {
          try {
            bloc.updateNewNotification(false);

            if (!AppLifecycleTracker.isAppRunning) {
              Future.delayed(const Duration(seconds: 10), () {
                if (context.mounted) {
                  NotificationPage.push(context, shouldNew: false);
                }
              });
            } else {
              if (context.mounted) {
                NotificationPage.push(context, shouldNew: false);
              }
            }
          } catch (e) {
            _logger.severe("Error navigating to notification page: $e");
          }
        }
      }
    } catch (e) {
      _logger.severe("Error processing notification tap: $e");
    }
  }

  static bool checkImage(String text) {
    final String title = text.trim().toLowerCase();
    if (title.contains(Constants.visitor) ||
        title.contains(Constants.unwanted) ||
        title.contains(Constants.fire) ||
        title.contains(Constants.parcel) ||
        title.contains(Constants.baby) ||
        title.contains(Constants.pet) ||
        title.contains(Constants.dog) ||
        title.contains(Constants.poop) ||
        title.contains(Constants.eavesdropper) ||
        title.contains(Constants.intruder) ||
        title.contains(Constants.weapon) ||
        title.contains(Constants.humanFall) ||
        title.contains(Constants.wildAnimal) ||
        title.contains(Constants.drowning) ||
        title.contains(Constants.boundaryBreach) ||
        title.contains(Constants.spam)) {
      return true;
    } else {
      return false;
    }
  }

  static void handleNotificationTap(NotificationResponse? notificationData) {
    if (notificationData == null) {
      _logger.warning("Notification data is null");
      return;
    }

    try {
      Pushy.clearBadge();

      // Safe JSON parsing for payload
      Map<String, dynamic> data = {};
      try {
        final payload = notificationData.payload ?? "{}";
        if (payload.isNotEmpty) {
          data = jsonDecode(payload);
        }
      } catch (e) {
        _logger.severe("Error parsing notification payload: $e");
        data = {};
      }

      WidgetsBinding.instance.addPostFrameCallback((c) async {
        try {
          if (singletonBloc.navigatorKey?.currentState?.context == null) {
            _logger.warning("Navigator key context is null");
            return;
          }

          final context = singletonBloc.navigatorKey!.currentState!.context;

          if (!context.mounted) {
            _logger.warning("Context is not mounted");
            return;
          }

          NotificationBloc.of(context).updateNewNotification(true);

          if (notificationData.actionId != null) {
            await _handleButtonAction(notificationData.actionId!, data);
            return;
          }

          // Handle navigation based on notification data
          await _handleNotificationNavigation(context, notificationData, data);
        } catch (e) {
          _logger.severe("Error in notification tap callback: $e");
        }
      });
    } catch (e) {
      _logger.severe("Error in handleNotificationTap: $e");
    }
  }

  static Future<void> _handleNotificationNavigation(
    BuildContext context,
    NotificationResponse notificationData,
    Map<String, dynamic> data,
  ) async {
    try {
      final voipBloc = VoipBloc.of(context);
      _logger.fine('Try Navigation');

      if (voipBloc.state.isCallConnected) {
        _logger.fine("Call is connected, skipping navigation");
        return;
      }

      if (notificationData.payload == null) {
        if (!voipBloc.state.isCallConnected) {
          unawaited(NotificationPage.push(context));
        }
        return;
      }

      // Safe nested JSON parsing
      Map<String, dynamic> notificationPayload = {};
      try {
        final outerPayload = jsonDecode(notificationData.payload!);
        final innerNotification = outerPayload['notification'];
        if (innerNotification != null) {
          if (innerNotification is String && innerNotification.isNotEmpty) {
            notificationPayload = jsonDecode(innerNotification);
          } else if (innerNotification is Map<String, dynamic>) {
            notificationPayload = innerNotification;
          }
        }
      } catch (e) {
        _logger.severe("Error parsing nested notification JSON: $e");
        notificationPayload = {};
      }

      final title = notificationPayload['title']?.toString();
      if (title == null || title.isEmpty) {
        if (!voipBloc.state.isCallConnected) {
          unawaited(NotificationPage.push(context));
        }
        return;
      }

      if (title.getExpansion()) {
        await _handleExpansionNotification(context, notificationPayload);
      } else {
        if (!voipBloc.state.isCallConnected) {
          unawaited(NotificationPage.push(context));
        }
      }
    } catch (e) {
      _logger.severe("Error handling notification navigation: $e");
    }
  }

  static Future<void> _handleExpansionNotification(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      final startupBloc = StartupBloc.of(context);
      final iotBloc = IotBloc.of(context);
      final visitorBloc = VisitorManagementBloc.of(context);
      final notificationBloc = NotificationBloc.of(context);
      final voipBloc = VoipBloc.of(context);

      if (voipBloc.state.isCallConnected) {
        return;
      }

      // Get doorbell data safely
      BuiltList<UserDeviceModel> doorbellData =
          <UserDeviceModel>[].toBuiltList();
      try {
        doorbellData = startupBloc.state.userDeviceModel ??
            await startupBloc.getDoorbells();
      } catch (e) {
        _logger.severe("Error getting doorbell data: $e");
        return;
      }

      // Find doorbell for location
      final doorbellForLocation = doorbellData.firstWhereOrNull(
        (e) => e.deviceId == data["device_id"] && e.isDefault == 1,
      );

      if (doorbellForLocation != null) {
        try {
          // Update profile with selected doorbell
          singletonBloc.profileBloc.emit(
            singletonBloc.profileBloc.state!.rebuild(
              (e) => e.selectedDoorBell.replace(doorbellForLocation),
            ),
          );

          // Handle socket room changes
          final currentLocationId = singletonBloc
              .profileBloc.state!.selectedDoorBell?.locationId
              ?.toString();
          final newLocationId = doorbellForLocation.locationId.toString();

          if (currentLocationId != newLocationId) {
            singletonBloc.socket?.emit("leaveRoom", currentLocationId ?? "");
            singletonBloc.socket?.emit("joinRoom", {
              "room": newLocationId,
              "device_id": await CommonFunctions.getDeviceModel(),
            });
          }

          // Call various APIs
          unawaited(
            startupBloc.callEverything(id: doorbellForLocation.locationId),
          );
          unawaited(iotBloc.callIotApi());
          unawaited(visitorBloc.initialCall(isRefresh: true));
          notificationBloc.updateFilter(false);
          unawaited(notificationBloc.callStatusApi());
          unawaited(notificationBloc.callNotificationApi(refresh: true));
          visitorBloc.updateVisitorNewNotification(false);
        } catch (e) {
          _logger.severe("Error updating doorbell location: $e");
        }
      }

      // Find doorbell for device
      UserDeviceModel? doorbell = doorbellData.firstWhereOrNull(
        (e) => e.deviceId == data["device_id"],
      );

      if (data["entity_id"] != null) {
        doorbell = doorbellData.firstWhereOrNull(
          (e) => e.entityId == data["entity_id"],
        );
      }

      _logger.fine("data $data");

      if (context.mounted && doorbell != null) {
        await _handleDoorbellNavigation(context, data, doorbell);
      }
    } catch (e) {
      _logger.severe("Error handling expansion notification: $e");
    }
  }

  static Future<void> _handleDoorbellNavigation(
    BuildContext context,
    Map<String, dynamic> data,
    UserDeviceModel doorbell,
  ) async {
    try {
      final voipBloc = VoipBloc.of(context);

      // Safe date parsing
      DateTime? localDate;
      try {
        final createdAt = data['created_at']?.toString();
        if (createdAt != null && createdAt.isNotEmpty) {
          localDate = DateTime.parse(createdAt).toLocal();
        }
      } catch (e) {
        _logger.severe("Error parsing created_at date: $e");
        localDate = DateTime.now();
      }

      if (localDate == null) {
        _logger.warning("Could not parse date, using current time");
        localDate = DateTime.now();
      }

      if (localDate.isAudioVideoChatDisabled()) {
        voipBloc.activateLiveMode(true);
        unawaited(
          StreamingPage.push(
            context,
            doorbell.callUserId,
            doorbell.id,
          ).then((_) {
            Future.delayed(const Duration(seconds: 3), () {
              try {
                voipBloc.streamingPeerConnection?.dispose();
                voipBloc.streamingPeerConnection = null;
                final navigatorState = singletonBloc.navigatorKey?.currentState;
                if (navigatorState == null) {
                  return;
                }
                final context = navigatorState.context;
                if (!context.mounted) {
                  return;
                }
                VoiceControlBloc.of(context).reinitializeWakeWord(context);
              } catch (e) {
                _logger.severe("Error disposing streaming connection: $e");
              }
            });
          }),
        );
      } else {
        voipBloc
          ..calendarDate = localDate
          ..activateLiveMode(false);

        unawaited(voipBloc.getRecording(callUserId: doorbell.callUserId));

        unawaited(
          StreamingPage.push(
            context,
            doorbell.callUserId,
            doorbell.id,
            date: localDate,
          ).then((_) {
            Future.delayed(const Duration(seconds: 3), () {
              try {
                voipBloc.streamingPeerConnection?.dispose();
                voipBloc.streamingPeerConnection = null;
                final navigatorState = singletonBloc.navigatorKey?.currentState;
                if (navigatorState == null) {
                  return;
                }
                final context = navigatorState.context;
                if (!context.mounted) {
                  return;
                }
                VoiceControlBloc.of(context).reinitializeWakeWord(context);
              } catch (e) {
                _logger.severe("Error disposing streaming connection: $e");
              }
            });
          }),
        );
      }
    } catch (e) {
      _logger.severe("Error handling doorbell navigation: $e");
    }
  }

  static Future<void> _handleButtonAction(
    String action,
    Map<String, dynamic> data,
  ) async {
    try {
      // Safe JSON parsing for notification data
      Map<String, dynamic> notificationData = {};
      try {
        final notificationJson = data['notification'];
        if (notificationJson != null) {
          if (notificationJson is String && notificationJson.isNotEmpty) {
            notificationData = jsonDecode(notificationJson);
          } else if (notificationJson is Map<String, dynamic>) {
            notificationData = notificationJson;
          }
        }
      } catch (e) {
        _logger.severe("Error parsing notification data in button action: $e");
        return;
      }

      final context = singletonBloc.navigatorKey?.currentState?.context;
      if (context == null || !context.mounted) {
        _logger.warning("Context is null or not mounted for button action");
        return;
      }

      switch (action) {
        case 'audio_call':
          await _handleAudioCallAction(context, notificationData);
        case 'video_call':
          await _handleVideoCallAction(context, notificationData);
        case 'chat':
          await _handleChatAction(context, notificationData);
        default:
          _logger.warning("Unknown button action: $action");
      }
    } catch (e) {
      _logger.severe("Error in _handleButtonAction: $e");
    }
  }

  static Future<void> _handleAudioCallAction(
    BuildContext context,
    Map<String, dynamic> notificationData,
  ) async {
    try {
      final voipBloc = VoipBloc.of(context);
      final startupBloc = StartupBloc.of(context);

      if (voipBloc.state.isCallConnected) {
        _logger.fine("Call is already connected, skipping audio call");
        return;
      }

      BuiltList<UserDeviceModel> doorbellData =
          <UserDeviceModel>[].toBuiltList();
      try {
        doorbellData = await startupBloc.getDoorbells();
      } catch (e) {
        _logger.severe("Error getting doorbells for audio call: $e");
        return;
      }

      final doorbell = doorbellData.firstWhereOrNull(
        (e) => e.deviceId == notificationData["device_id"] && e.isDefault == 1,
      );

      if (doorbell == null) {
        _logger.warning("Doorbell not found for audio call");
        return;
      }

      try {
        singletonBloc.profileBloc.emit(
          singletonBloc.profileBloc.state!
              .rebuild((e) => e.selectedDoorBell.replace(doorbell)),
        );
      } catch (e) {
        _logger.severe("Error updating profile with doorbell: $e");
      }

      voipBloc
        ..resetTimer()
        ..updateEnabledSpeakerInCall(false)
        ..isAudioEmit();

      if (context.mounted) {
        try {
          unawaited(
            CallingScreen.push(
              context,
              doorbell.callUserId,
              false,
              callType: Constants.doorbellAudioCall,
              notificationImage: notificationData["imageurl"]?.toString(),
              visitor: notificationData["visitors"] == null
                  ? null
                  : VisitorsModel.fromDynamic(notificationData["visitors"]),
            ),
          );
        } catch (e) {
          _logger.severe("Error pushing calling screen: $e");
        }
      }
    } catch (e) {
      _logger.severe("Error in _handleAudioCallAction: $e");
    }
  }

  static Future<void> _handleVideoCallAction(
    BuildContext context,
    Map<String, dynamic> notificationData,
  ) async {
    try {
      final voipBloc = VoipBloc.of(context);

      if (voipBloc.state.isCallConnected) {
        _logger.fine("Call is already connected, skipping video call");
        return;
      }

      final startupBloc = StartupBloc.of(context);
      BuiltList<UserDeviceModel> doorbellData =
          <UserDeviceModel>[].toBuiltList();

      try {
        doorbellData = await startupBloc.getDoorbells();
      } catch (e) {
        _logger.severe("Error getting doorbells for video call: $e");
        return;
      }

      final doorbell = doorbellData.firstWhereOrNull(
        (e) => e.deviceId == notificationData["device_id"] && e.isDefault == 1,
      );

      if (doorbell == null) {
        _logger.warning("Doorbell not found for video call");
        return;
      }

      try {
        singletonBloc.profileBloc.emit(
          singletonBloc.profileBloc.state!
              .rebuild((e) => e.selectedDoorBell.replace(doorbell)),
        );
      } catch (e) {
        _logger.severe("Error updating profile with doorbell: $e");
      }

      voipBloc.updateEnabledSpeakerInCall(false);

      if (context.mounted) {
        try {
          voipBloc.shiftToVideoCallOverlay(
            context: context,
            callUserId: doorbell.callUserId,
            callType: 'video',
            notificationImage: notificationData["imageurl"]?.toString(),
            visitor: notificationData["visitors"] == null
                ? null
                : VisitorsModel.fromDynamic(notificationData["visitors"]),
          );
        } catch (e) {
          _logger.severe("Error shifting to video call overlay: $e");
        }
      }
    } catch (e) {
      _logger.severe("Error in _handleVideoCallAction: $e");
    }
  }

  static Future<void> _handleChatAction(
    BuildContext context,
    Map<String, dynamic> notificationData,
  ) async {
    try {
      final startupBloc = StartupBloc.of(context);
      final chatBloc = ChatBloc.of(context);

      BuiltList<UserDeviceModel> doorbellData =
          <UserDeviceModel>[].toBuiltList();
      try {
        doorbellData = await startupBloc.getDoorbells();
      } catch (e) {
        _logger.severe("Error getting doorbells for chat: $e");
        return;
      }

      final doorbell = doorbellData.firstWhereOrNull(
        (e) => e.deviceId == notificationData["device_id"] && e.isDefault == 1,
      );

      if (doorbell == null) {
        _logger.warning("Doorbell not found for chat");
        return;
      }

      if (context.mounted) {
        try {
          chatBloc
              .updateNotificationLocationId(notificationData["location_id"]);
          unawaited(
            ChatScreen.push(
              context: context,
              doorbellUserId: doorbell.callUserId,
              notificationCreatedAt: notificationData["created_at"].toString(),
              notificationId: notificationData["id"],
              deviceId: notificationData["device_id"].toString(),
              visitors: notificationData["visitors"] == null
                  ? null
                  : VisitorsModel.fromDynamic(notificationData["visitors"]),
            ),
          );
        } catch (e) {
          _logger.severe("Error pushing chat screen: $e");
        }
      }
    } catch (e) {
      _logger.severe("Error in _handleChatAction: $e");
    }
  }

  static bool isValidUrl(String url) {
    const urlPattern = r'^(https?:\/\/)' // must start with http:// or https://
        r'([a-zA-Z0-9\-_]+\.)+[a-zA-Z]{2,}' // domain
        r'(:[0-9]+)?' // optional port
        r'(\/[^\s]*)?$'; // path + query + params allowed
    final result = RegExp(urlPattern, caseSensitive: false).hasMatch(url);
    return result;
  }

  static Future<String> _downloadAndSaveImage(
    String url,
    String fileName,
  ) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName.png';

      final http.Response response = await http.get(
        Uri.parse(
          isValidUrl(url)
              ? url
              : "https://media-assets-dev.irvinei.com/themes/media/image_1741061222_5458.jpeg",
        ),
      );

      final File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } catch (e) {
      _logger.severe(e);
      return "";
    }
  }

  static Future<void> showNotification(Map<String, dynamic> data) async {
    try {
      // Validate input data
      if (data.isEmpty) {
        _logger.warning("Empty notification data received");
        return;
      }

      // Safe JSON parsing for notification data
      Map<String, dynamic> notificationData = {};
      try {
        final notificationJson = data["notification"] ?? data["__json"] ?? "{}";
        if (notificationJson is String && notificationJson.isNotEmpty) {
          notificationData = jsonDecode(notificationJson);
        } else if (notificationJson is Map<String, dynamic>) {
          notificationData = notificationJson;
        }
      } catch (e) {
        _logger.severe("Error parsing notification JSON: $e");
        notificationData = {};
      }

      final String title = notificationData['title']?.toString() ??
          notificationData['command']?.toString() ??
          "";
      final String receiveType = data['recieveType']?.toString() ?? "";
      final String body = notificationData['text']?.toString() ??
          notificationData['body']?.toString() ??
          "";
      final String? imageUrl = data['imageurl']?.toString();

      // Validate notification content
      if (title.isEmpty && body.isEmpty) {
        _logger.warning("Empty notification title and body");
        try {
          unawaited(FlutterBugfender.error(jsonEncode(data)));
        } catch (e) {
          _logger.severe("Error sending to Bugfender: $e");
        }
        return;
      }

      // Text-to-speech
      // try {
      //   if (AppLifecycleTracker.isAppRunning && title.isNotEmpty) {
      //     unawaited(singletonBloc.textToSpeech.speak(title));
      //   }
      // } catch (e) {
      //   _logger.severe("Error with text-to-speech: $e");
      // }

      // Generate notification ID safely
      int notificationId;
      try {
        final idValue = data["notification_id"] ?? 0;
        notificationId = int.parse(idValue.toString());
      } catch (e) {
        _logger.severe("Error parsing notification ID: $e");
        notificationId = DateTime.now().millisecondsSinceEpoch % 100000;
      }

      // Create notification details
      final androidDetails = AndroidNotificationDetails(
        'app_channel_id',
        'App Notifications',
        // importance: Importance.defaultImportance,
        // priority: Priority.defaultPriority,
        styleInformation: BigTextStyleInformation(body),
        actions: title.getCanCall() && receiveType != "external_cam"
            ? singletonBloc.isFeatureCodePresent(
                AppRestrictions.audioVideoCallButtons.code,
              )
                ? <AndroidNotificationAction>[
                    AndroidNotificationAction(
                      'audio_call',
                      'Audio Call',
                      showsUserInterface: true,
                      titleColor: AppColors.pushNotificationsIconColor,
                    ),
                    AndroidNotificationAction(
                      'video_call',
                      'Video Call',
                      showsUserInterface: true,
                      titleColor: AppColors.pushNotificationsIconColor,
                    ),
                    AndroidNotificationAction(
                      'chat',
                      'Chat',
                      showsUserInterface: true,
                      titleColor: AppColors.pushNotificationsIconColor,
                    ),
                  ]
                : [
                    AndroidNotificationAction(
                      'chat',
                      'Chat',
                      showsUserInterface: true,
                      titleColor: AppColors.pushNotificationsIconColor,
                    ),
                  ]
            : null,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Show initial notification
      try {
        await notificationsPlugin.show(
          notificationId,
          title,
          body,
          notificationDetails,
          payload: jsonEncode(data),
        );
      } catch (e) {
        _logger.severe("Error showing notification: $e");
        return;
      }

      // Handle image if available
      if (imageUrl != null && imageUrl.isNotEmpty) {
        await _updateNotificationWithImage(
          notificationId,
          title,
          body,
          imageUrl,
          receiveType,
          data,
        );
      }
    } catch (e) {
      _logger.severe("Error in showNotification: $e");
    }
  }

  static Future<void> _updateNotificationWithImage(
    int notificationId,
    String title,
    String body,
    String imageUrl,
    String receiveType,
    Map<String, dynamic> data,
  ) async {
    try {
      // Download image and update notification
      final String largeIconPath =
          await _downloadAndSaveImage(imageUrl, 'largeIcon');

      if (largeIconPath.isNotEmpty) {
        final androidDetails = AndroidNotificationDetails(
          'app_channel_id',
          'App Notifications',
          // importance: Importance.max,
          // priority: Priority.high,
          largeIcon: FilePathAndroidBitmap(largeIconPath),
          styleInformation: BigPictureStyleInformation(
            FilePathAndroidBitmap(largeIconPath),
            contentTitle: title,
            hideExpandedLargeIcon: true,
          ),
          actions: title.getCanCall() && receiveType != "external_cam"
              ? singletonBloc.isFeatureCodePresent(
                  AppRestrictions.audioVideoCallButtons.code,
                )
                  ? <AndroidNotificationAction>[
                      AndroidNotificationAction(
                        'audio_call',
                        'Audio Call',
                        showsUserInterface: true,
                        titleColor: AppColors.pushNotificationsIconColor,
                      ),
                      AndroidNotificationAction(
                        'video_call',
                        'Video Call',
                        showsUserInterface: true,
                        titleColor: AppColors.pushNotificationsIconColor,
                      ),
                      AndroidNotificationAction(
                        'chat',
                        'Chat',
                        showsUserInterface: true,
                        titleColor: AppColors.pushNotificationsIconColor,
                      ),
                    ]
                  : [
                      AndroidNotificationAction(
                        'chat',
                        'Chat',
                        showsUserInterface: true,
                        titleColor: AppColors.pushNotificationsIconColor,
                      ),
                    ]
              : null,
        );

        final notificationDetails =
            NotificationDetails(android: androidDetails);

        // Update the existing notification using the same ID
        try {
          await notificationsPlugin.show(
            notificationId,
            title,
            body,
            notificationDetails,
            payload: jsonEncode(data),
          );
        } catch (e) {
          _logger.severe("Error updating notification with image: $e");
        }
      }
    } catch (e) {
      _logger.severe("Error updating notification with image: $e");
    }
  }
}
