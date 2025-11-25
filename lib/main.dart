import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/config.dart';
import 'package:admin/core/theme.dart';
import 'package:admin/flavors.dart';
import 'package:admin/models/enums/environment.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/main/dashboard/main_dashboard.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/notifications/notification_service.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/router/app_router_delegate.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:audio_session/audio_session.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nested/nested.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toastification/toastification.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

final Logger _logger = Logger('main.dart');
final GlobalKey<NavigatorState> navigatorKeyMain = GlobalKey<NavigatorState>();
// /// Recursively searches [data] for the first occurrence of key "device_id".
// /// Returns its value, or null if not found.
// dynamic _findDeviceId(Map<String, dynamic> data) {
//   // 1) Check current level
//   if (data.containsKey('device_id')) {
//     return data['device_id'];
//   }
//
//   // 2) Recurse into values
//   for (final value in data.values) {
//     dynamic found;
//
//     if (value is Map<String, dynamic>) {
//       found = _findDeviceId(value);
//     } else if (value is List) {
//       found = _findInList(value);
//     }
//
//     if (found != null) {
//       return found; // break once found
//     }
//   }
//
//   // 3) Not found at any branch
//   return null;
// }
//
// /// Helper: search through a [list] for "device_id" in any nested map or list.
// dynamic _findInList(List<dynamic> list) {
//   for (final element in list) {
//     dynamic found;
//
//     if (element is Map<String, dynamic>) {
//       found = _findDeviceId(element);
//     } else if (element is List) {
//       found = _findInList(element);
//     }
//
//     if (found != null) {
//       return found;
//     }
//   }
//   return null;
// }

mixin AppLifecycleTracker {
  static bool isAppRunning = false;
}

@pragma('vm:entry-point')
Future<void> backgroundNotificationListener(Map<String, dynamic> data) async {
  try {
    HttpOverrides.global = MyHttpOverrides();

    // Validate input data
    if (data.isEmpty) {
      _logger.warning("Empty notification data received");
      return;
    }

    final String receiveType = data['recieveType'] ?? "";
    _logger.severe("Notification received");

    // Handle auth logout
    if (receiveType == "auth_logout" && AppLifecycleTracker.isAppRunning) {
      try {
        singletonBloc.socket?.emit(
          "leaveRoom",
          singletonBloc.profileBloc.state?.selectedDoorBell?.locationId
                  ?.toString() ??
              "",
        );
        unawaited(singletonBloc.getBox.erase());
        singletonBloc.profileBloc.updateProfile(null);
      } catch (e) {
        _logger.severe("Error during auth logout: $e");
      }
      return;
    }

    // Initialize HydratedBloc storage if not already initialized
    if (!AppLifecycleTracker.isAppRunning) {
      try {
        WidgetsFlutterBinding.ensureInitialized();
        HydratedBloc.storage = await HydratedStorage.build(
          storageDirectory:
              HydratedStorageDirectory((await getTemporaryDirectory()).path),
        );
      } catch (e) {
        _logger.severe("Error initializing HydratedBloc storage: $e");
      }
    }

    // Show notification for Android
    if (singletonBloc.profileBloc.state != null && Platform.isAndroid) {
      try {
        unawaited(NotificationService.showNotification(data));
      } catch (e) {
        _logger.severe("Error showing notification: $e");
      }
    }

    try {
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
      if (AppLifecycleTracker.isAppRunning &&
          title.isNotEmpty &&
          singletonBloc.profileBloc.state != null) {
        unawaited(singletonBloc.textToSpeech.speak(title));
      }
    } catch (e) {
      _logger.severe("Error with text-to-speech: $e");
    }
    final deviceSessionId = await CommonFunctions.getDeviceToken();

    // Process notification if app is running and context is available
    if (singletonBloc.navigatorKey?.currentState?.context != null &&
        singletonBloc.profileBloc.state != null &&
        AppLifecycleTracker.isAppRunning) {
      final context = singletonBloc.navigatorKey!.currentState!.context;

      // Check if context is still mounted
      if (!context.mounted) {
        _logger.warning(
          "Context is not mounted, skipping notification processing",
        );
        return;
      }

      try {
        final NotificationBloc bloc = NotificationBloc.of(context);
        final StartupBloc startupBloc = StartupBloc.of(context);
        final VisitorManagementBloc visitorManagementBloc =
            VisitorManagementBloc.of(context);

        await bloc.callStatusApi();

        // Safe JSON parsing with error handling
        Map<String, dynamic> notificationData = {};
        try {
          final notificationJson = data["notification"] ?? "{}";
          if (notificationJson is String && notificationJson.isNotEmpty) {
            notificationData = jsonDecode(notificationJson);
          }
        } catch (e) {
          _logger.severe("Error parsing notification JSON: $e");
          notificationData = {};
        }

        final String title =
            notificationData['title'] ?? notificationData['command'] ?? "";
        final String body =
            notificationData['text'] ?? notificationData['body'] ?? "";

        if (title.contains('Visitor') &&
            !body.toLowerCase().contains("face is unclear") &&
            bloc.state.newNotification) {
          visitorManagementBloc.updateVisitorNewNotification(true);
        }

        // Update Streaming Online/Offline Status of Doorbell/Camera
        if (data.containsKey('device_id') && data.containsKey('is_streaming')) {
          try {
            startupBloc.updateStreamingStatus(
              targetDeviceId: data['device_id'],
              isStreaming: data['is_streaming'],
            );
          } catch (e) {
            _logger.severe("Error updating streaming status: $e");
          }
        }

        // Handle subscription deletion
        if (receiveType == "subscription_deleted") {
          try {
            await startupBloc.callUserDetails();

            Map<String, dynamic> subscriptionData = {};
            try {
              final subscriptionJson = notificationData["subscription"] ?? "{}";
              if (subscriptionJson is String && subscriptionJson.isNotEmpty) {
                subscriptionData = jsonDecode(subscriptionJson);
              }
            } catch (e) {
              _logger.severe("Error parsing subscription JSON: $e");
              subscriptionData = {};
            }

            final String? selectedLocationId = singletonBloc
                .profileBloc.state?.selectedDoorBell?.locationId
                ?.toString();
            final String notificationLocationId =
                subscriptionData["location_id"]?.toString() ?? "";

            if (selectedLocationId == notificationLocationId) {
              startupBloc.clearPageIndexes();
              await startupBloc.callPlanFeaturesManagement();

              if (context.mounted) {
                unawaited(MainDashboard.pushRemove(context));
              }
            }
          } catch (e) {
            _logger.severe("Error handling subscription deletion: $e");
          }
        }

        // Handle location/user/doorbell release
        if (receiveType == "release_location" ||
            receiveType == "release_user" ||
            receiveType == "release_doorbell") {
          try {
            final String? selectedLocationId = singletonBloc
                .profileBloc.state?.selectedDoorBell?.locationId
                ?.toString();
            final String notificationLocationId =
                data["location_id"]?.toString() ?? "";

            if (selectedLocationId == notificationLocationId) {
              if (data["session_id"] != deviceSessionId) {
                if (context.mounted) {
                  startupBloc
                    ..clearPageIndexes()
                    ..updateDashboardApiCalling(true);
                  await startupBloc.callEverything();

                  if (context.mounted) {
                    unawaited(CommonFunctions.updateLocationData(context));
                    unawaited(MainDashboard.pushRemove(context));
                  }
                }
              }
            }
          } catch (e) {
            _logger.severe("Error handling release notification: $e");
          }
        }
      } catch (e) {
        _logger.severe("Error processing notification in context: $e");
      }
    } else if (!AppLifecycleTracker.isAppRunning &&
        (receiveType == "release_location" ||
            receiveType == "release_user" ||
            receiveType == "release_doorbell")) {
      final releasedLocationId = data["location_id"]?.toString();
      if (releasedLocationId != null &&
          releasedLocationId.isNotEmpty &&
          deviceSessionId != data["session_id"]) {
        try {
          final box = await HydratedStorage.build(
            storageDirectory: HydratedStorageDirectory(
              (await getTemporaryDirectory()).path,
            ),
          );

          // Read existing list
          final List<String> releasedLocations =
              List<String>.from(box.read('released_locations') ?? []);

          if (!releasedLocations.contains(releasedLocationId)) {
            releasedLocations.add(releasedLocationId);
            await box.write('released_locations', releasedLocations);
            _logger.fine(
              "Location added to background release list: $releasedLocationId",
            );
          }
        } catch (e) {
          _logger.severe(e.toString());
        }
      }
    }
  } catch (e) {
    _logger.severe("Critical error in background notification listener: $e");
    try {
      unawaited(FlutterBugfender.sendIssue("Notification Crash", e.toString()));
    } catch (bugfenderError) {
      _logger.severe("Error sending to Bugfender: $bugfenderError");
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context)

      // Configure SSL/TLS settings for better security and compatibility
      ..badCertificateCallback = (cert, host, port) {
        // Log certificate issues for debugging
        _logger.warning('Bad certificate for host: $host, port: $port');
        // Only bypass certificate validation in development/test environments
        return config.environment == Environment.develop ||
            config.environment == Environment.test;
      }

      // Set connection timeout
      ..connectionTimeout = const Duration(seconds: 30)

      // Configure user agent
      ..userAgent = 'OVAL-AdminApp/2.0';

    return client;
  }
}

Future<void> main() async {
  AppLifecycleTracker.isAppRunning = true;
  HttpOverrides.global = MyHttpOverrides();

  // Wrap everything
  FlutterBugfender.handleUncaughtErrors(() async {
    // 🔑 init binding INSIDE this zone
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    await GetStorage.init();
    await dotenv.load(fileName: 'config/${config.environment}.config');

    F.appFlavor = Flavor.values.firstWhereOrNull(
          (element) => element.name == appFlavor,
        ) ??
        Flavor.test;

    await FlutterBugfender.init(
      config.bugFenderUrl,
      enableAndroidLogcatLogging: true,
    );

    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    LoggingUtils.initialize();

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(
        (await getTemporaryDirectory()).path,
      ),
    );

    await NotificationService.initialize();
    // CubitUtils.initConnectivityCheck();

    FlutterError.onError = (details) {
      if (_shouldIgnoreError(details.exception)) {
        _logger.severe("🚨 Ignored error: ${details.exception}");
      } else {
        // Enhanced error logging with more context
        final errorInfo = {
          'exception': details.exception.toString(),
          'stack': details.stack.toString(),
          'library': details.library,
          'context': details.context?.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        };

        _logger.severe("Flutter Error: $errorInfo");

        FlutterBugfender.sendIssue(
          "Flutter Error: ${details.exception}",
          details.stack.toString(),
        );
        if (details.stack != null) {
          Zone.current.handleUncaughtError(details.exception, details.stack!);
        }
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      final errorInfo = {
        'error': error.toString(),
        'stack': stack.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      _logger.severe("Platform Error: $errorInfo");

      // Handle specific platform errors
      if (error.toString().contains('HandshakeException') ||
          error.toString().contains('SSL') ||
          error.toString().contains('TLS')) {
        _logger.severe("SSL/TLS Platform Error: $error");
      }

      return true;
    };

    await singletonBloc.textToSpeech.setVolume(1);
    await singletonBloc.textToSpeech.awaitSpeakCompletion(true);
    await singletonBloc.textToSpeech.awaitSynthCompletion(true);

    if (Platform.isIOS) {
      await singletonBloc.textToSpeech.setSharedInstance(true);
      await singletonBloc.textToSpeech.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );
    }

    FlutterForegroundTask.initCommunicationPort();

    // 🔑 same zone as ensureInitialized
    runApp(const MyApp());
  });
}

bool _shouldIgnoreError(Object e) {
  final ignored = [
    "Deserialization",
    "BuiltValueNullFieldError",
    "Dio Exception",
    "Socket",
    "HttpException",
    "ClientException",
    "HandshakeException",
    "PathNotFoundException",
    "PlatformException",
    "SocketException",
    "DioException",
    "TlsException",
    "CertificateException",
    "SSLException",
    "ConnectionException",
    "TimeoutException",
    "NetworkException",
  ];
  return ignored.any((msg) => e.toString().contains(msg));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouterDelegate _appRouterDelegate = AppRouterDelegate();

  void _initService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        onlyAlertOnce: true,
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnMyPackageReplaced: true,
        allowWifiLock: true,
      ),
    );
  }

  @override
  void initState() {
    configureAudioSession();
    EasyLoading.instance
      // ..indicatorType = EasyLoadingIndicatorType.circle
      ..backgroundColor = Theme.of(context).tabBarTheme.indicatorColor ??
          Colors.white // Transparent background
      ..maskColor = Theme.of(context).tabBarTheme.indicatorColor
      ..indicatorWidget = const ButtonProgressIndicator(
        fgColor: Color(0xFF44CEFF),
      ) // Circular ProgressIndicator
      ..indicatorColor = const Color(0xFF44CEFF)
      ..maskType = EasyLoadingMaskType
          .black // Mask the background with a transparent overlay
      ..loadingStyle = EasyLoadingStyle.custom // Custom loading style
      ..textColor = Colors.white;
    super.initState();
    _initService();
    Permission.locationWhenInUse.request();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: isDarkMode
            ? Colors.transparent
            : Platform.isIOS
                ? Colors.black
                : Colors.transparent,
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }

  Future<void> configureAudioSession() async {
    final session = await AudioSession.instance;

    await session.configure(
      AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth |
                AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.measurement,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransient,
        androidWillPauseWhenDucked: false,
      ),
    );
  }

  // pushyKey
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider(
            create: (_) => StartupBloc(),
            lazy: false,
          ),
          BlocProvider(
            create: (_) => IotBloc(),
            lazy: false,
          ),
          BlocProvider(
            create: (_) => VoiceControlBloc(),
            lazy: false,
          ),
          BlocProvider(
            lazy: false,
            create: (final _) => singletonBloc.profileBloc,
          ),
          BlocProvider(
            lazy: false,
            create: (final _) =>
                LoginBloc(profileBloc: singletonBloc.profileBloc),
          ),
        ],
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: FlutterSizer(
            builder: (
              context,
              orientation,
              screenType,
            ) =>
                GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: ToastificationWrapper(
                child: MaterialApp(
                  title: 'OVAL 2.0',

                  theme: getTheme(),
                  darkTheme: darkTheme(),
                  debugShowCheckedModeBanner: false,
                  builder: EasyLoading.init(builder: BotToastInit()),
                  navigatorKey: navigatorKeyMain,
                  // Assign the global navigator key
                  home: Router(
                    routerDelegate: _appRouterDelegate,
                    backButtonDispatcher: RootBackButtonDispatcher(),
                  ),
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                ),
              ),
            ),
          ),
        ),
      );
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  static const String incrementCountCommand = 'incrementCount';

  int _count = 0;

  void _incrementCount() {
    _count++;

    // Update notification content.
    FlutterForegroundTask.updateService(
      notificationTitle: 'Calling is in progress',
      notificationText: 'Tap to return to the app',
    );

    // Send data to main isolate.
    FlutterForegroundTask.sendDataToMain(_count);
  }

  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _incrementCount();
  }

  // Called based on the eventAction set in ForegroundTaskOptions.
  @override
  void onRepeatEvent(DateTime timestamp) {
    _incrementCount();
  }

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}

  // Called when data is sent using `FlutterForegroundTask.sendDataToTask`.
  @override
  void onReceiveData(Object data) {
    if (data == incrementCountCommand) {
      _incrementCount();
    }
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {}

  // Called when the notification itself is pressed.
  @override
  void onNotificationPressed() {}

  // Called when the notification itself is dismissed.
  @override
  void onNotificationDismissed() {}
}
