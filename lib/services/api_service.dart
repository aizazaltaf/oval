import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/core/app_restrictions.dart';
import 'package:admin/core/config.dart';
import 'package:admin/models/data/ai_alert_preferences_model.dart';
import 'package:admin/models/data/brand_model.dart';
import 'package:admin/models/data/curtain_model_without_serializer.dart';
import 'package:admin/models/data/login_session_model.dart';
import 'package:admin/models/data/payment_methods_model.dart';
import 'package:admin/models/data/plan_features_model.dart';
import 'package:admin/models/data/role_model.dart';
import 'package:admin/models/data/room_items_model.dart';
import 'package:admin/models/data/statistics_model.dart';
import 'package:admin/models/data/sub_user_model.dart';
import 'package:admin/models/data/transaction_history_model.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/data/visitor_chat_model.dart';
import 'package:admin/pages/main/chat/components/temporary_chat_model.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/model/streaming_alerts_data.dart';
import 'package:admin/pages/themes/model/ai_theme_model.dart';
import 'package:admin/pages/themes/model/weather_model.dart';
import 'package:admin/utils/dio.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

/// Represents a single segment in an M3U8 file with timing information
class M3U8Segment {
  M3U8Segment({
    required this.url,
    required this.startTime,
    required this.duration,
    required this.videoPosition,
    required this.hasDiscontinuity,
  });

  final String url;
  final DateTime startTime;
  final double duration;
  final double videoPosition; // Position in the video timeline
  final bool hasDiscontinuity;

  @override
  String toString() {
    return 'M3U8Segment(url: $url, startTime: $startTime, duration: $duration, videoPosition: $videoPosition, hasDiscontinuity: $hasDiscontinuity)';
  }
}

class M3U8Second {
  M3U8Second({
    required this.timestamp,
    required this.pixel,
    required this.position,
    required this.second,
  });

  final String timestamp; // formatted yyyy-MM-dd HH:mm:ss
  final double pixel;
  final int position;
  final int second;

  @override
  String toString() =>
      "second $second => $timestamp (pixel: $pixel, pos: $position)";
}

/// Complete time mapping for an M3U8 file that accounts for timeskips
class M3U8TimeMapping {
  M3U8TimeMapping({
    required this.segments,
    required this.totalDuration,
  });

  final List<M3U8Segment> segments;
  final double totalDuration;

  /// Get all discontinuity points in the timeline
  List<double> get discontinuityPoints {
    final points = <double>[];
    for (final segment in segments) {
      if (segment.hasDiscontinuity) {
        points.add(segment.videoPosition);
      }
    }
    return points;
  }
}

/// Complete time mapping for an M3U8 file that accounts for timeskips
class SegmentDateTime {
  SegmentDateTime({
    required this.segment,
    required this.dateTime,
    required this.segmentIndex,
  });

  final M3U8Segment segment;
  final DateTime dateTime;
  final int segmentIndex;
}

final _logger = Logger('api_service.dart');

class _ApiService {
  Future<UserData> login({
    required final String email,
    required final String password,
  }) async {
    final token = await CommonFunctions.getDeviceToken();
    final data = {
      "email": email,
      "password": password,
      "ip": await getPublicIp(),
      "device_name": await CommonFunctions.getDeviceName(),
      "device_model": await CommonFunctions.getDeviceModel(),
      "device_token_login": token,
    };
    _logger.fine("Login data: $data");
    final response = await dio.post(
      'auth/login',
      data: data,
    );
    return UserData.fromDynamic(response.data["data"]);
  }

  Future<BuiltList<LoginSessionModel>> getLoginActivities() async {
    final response = await dio.get("login-activity");
    return LoginSessionModel.fromDynamics(response.data["data"]);
  }

  Future<Response> logoutAllSessions() async {
    final response = await dio.post("user/logout-all-sessions");
    return response;
  }

  Future<Response> setGuide({required String guideKey}) async {
    final params = {
      "guides": {guideKey: 1},
    };
    final response = await dio.put("user/guides", data: params);
    return response;
  }

  Future<void> resendEmail({
    required final String email,
  }) async {
    await dio.post(
      'auth/resend-email-verification',
      data: {
        'email': email,
      },
    );
    ToastUtils.successToast("Verification email has been sent to your email.");
  }

  Future<bool> updateSnapshots() async {
    try {
      if (singletonBloc.profileBloc.state != null) {
        if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
          if (singletonBloc.profileBloc.state?.selectedDoorBell?.locationId !=
              null) {
            final response = await dio.get(
              'doorbell/snapshot/uuid/${singletonBloc.profileBloc.state?.selectedDoorBell?.locationId}',
            );
            return response.statusCode == 200;
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> aiServerVoiceControl(String text) async {
    try {
      final data = {
        "user_id": singletonBloc.profileBloc.state!.id.toString(),
        "user_name": singletonBloc.profileBloc.state!.name,
        "text": text,
        // "location_id": singletonBloc.profileBloc.state!.locationId.toString(),

        if (singletonBloc.profileBloc.state!.selectedDoorBell != null)
          "location_id": singletonBloc
              .profileBloc.state!.selectedDoorBell?.locationId
              .toString(),
        "role": singletonBloc.profileBloc.state!.locations
            ?.singleWhereOrNull(
              (e) =>
                  e.id ==
                  singletonBloc.profileBloc.state!.selectedDoorBell?.locationId,
            )
            ?.roles[0],
      };
      final response = await Dio().post(
        '${config.aiServerUrl}/irvinei_voice_crew',
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        ToastUtils.errorToast(response.data["statusCode"]);
        unawaited(
          loggingApiForAiVoiceControl("Error", jsonEncode(response.data)),
        );
        return false;
      }
    } on DioException catch (e) {
      ToastUtils.errorToast(e.response!.data["statusCode"]);
      _logger.severe(e);
    }
  }

  Future<dynamic> loggingApiForAiVoiceControl(
    String command,
    String data,
  ) async {
    final response = await dio
        .post('voice-command/log', data: {"command": command, "data": data});

    return response.data;
  }

  Future<String?>? getPublicIp() async {
    try {
      final response = await Dio().get("https://api.ipify.org");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      return "0.0.0.0";
    }
  }

  Future<Response> logoutOfSpecificDevice({
    required String deviceToken,
    required bool sendPushNotification,
  }) async {
    final Map<String, dynamic> params = {
      "user_id": singletonBloc.profileBloc.state!.id,
      "device_token": deviceToken,
      "send_push_notification": sendPushNotification,
    };

    final response = await dio.post(
      "user/logout-device",
      data: params,
    );
    return response;
  }

  Future<void> saveChatMessage(
    TemporaryChatModel chat,
    int locationId,
    String participantType,
    String visitorName,
  ) async {
    /// If 0304 not present, Chat history will not saved
    if (!singletonBloc
        .isFeatureCodePresent(AppRestrictions.visitorLogsAndChatHistory.code)) {
      return;
    }
    final Map<String, dynamic> params = {
      "message": chat.message,
      "participant_type": participantType,
      "title": "doorbell chat",
      "location_id": locationId,
      "visitor_name": visitorName,
      "user_name": singletonBloc.profileBloc.state!.name,
      "user_id": singletonBloc.profileBloc.state!.id,
      "visitor_id": chat.visitorId,
      "device_id": chat.deviceId,
    };
    final response = await dio.post(
      "${config.ovalChatUrl}messages/send",
      data: params,
      options: Options(headers: {"Authorization": "Bearer ${config.key}"}),
    );
    return response.data;
  }

  Future<BuiltList<VisitorChatModel>> getChatMessages(int visitorId) async {
    final queryParams = {
      // "user_id": singletonBloc.profileBloc.state?.id,
      "visitor_id": visitorId,
    };
    final response = await dio.get(
      "${config.ovalChatUrl}messages/history",
      queryParameters: queryParams,
      options: Options(headers: {"Authorization": "Bearer ${config.key}"}),
    );
    return VisitorChatModel.fromDynamics(response.data["data"]);
  }

  Future<dynamic> changePassword({
    required String newPassword,
    required String currentPassword,
  }) async {
    final Map<String, String> params = {
      "password": newPassword,
      "current_password": currentPassword,
    };
    final response = await dio.post('user/change-password', data: params);
    return response.data;
  }

  Future<dynamic> validatePassword(String password) async {
    final params = {"password": password};
    final response = await dio.post('user/validate-password', data: params);
    return response.data;
  }

  Future<String> uploadFile(
    File file, {
    String? directory,
    bool fromTheme = false,
    required String fileName,
  }) async {
    final stream = file.readAsBytesSync();
    final s3 = S3(
      region: config.region,
      endpointUrl: config.endPoint,
      credentials: AwsClientCredentials(
        accessKey: config.accessKey,
        secretKey: config.secretKey,
      ),
    );
    try {
      await s3.putObject(
        bucket: fromTheme ? config.themeBucketUrl : config.bucket,
        acl: ObjectCannedACL.bucketOwnerFullControl,
        // bucketKeyEnabled: true,
        key: fileName,
        body: stream,
      );
      return (fromTheme ? config.s3ThemeBucketUrl : config.s3BucketUrl) +
          fileName;
    } catch (e) {
      _logger.severe(e);
    }
    return "";
  }

  Future<dynamic> updateProfile({
    String? newName,
    File? profilePhoto,
    bool pendingEmail = false,
    String? newPhone,
    String? newEmail,
  }) async {
    String url = "";
    if (profilePhoto != null) {
      url = await apiService.uploadFile(
        profilePhoto,
        fileName:
            "images/${DateTime.now().microsecondsSinceEpoch}.${profilePhoto.path.split(".").last}",
      );
    }
    final bloc = singletonBloc.profileBloc;
    final String strName = newName ?? bloc.state!.name!;
    final String strPhone = newPhone ?? bloc.state!.phone!;
    final response = await dio.post(
      'user/update-profile',
      data: {
        "name": strName,
        "phone": strPhone,
        "address": "",
        if (pendingEmail) "pending_email": "",
        if (newEmail != null) "email": newEmail,
        if (url.isNotEmpty) "image": url,
      },
    );
    return response.data;
  }

  Future<UserData> getUserDetail() async {
    final response = await dio.get(
      'user/detail',
    );
    return UserData.fromDynamic(response.data["data"]);
  }

  Future<BuiltList<PlanFeaturesModel>> getPlanFeatures() async {
    if (singletonBloc.profileBloc.state!.selectedDoorBell?.locationId == null) {
      return <PlanFeaturesModel>[].toBuiltList();
    } else {
      final response = await dio.get(
        'payment/plans/features/${singletonBloc.profileBloc.state!.selectedDoorBell?.locationId}',
      );
      return PlanFeaturesModel.fromDynamics(response.data["data"]["code"]);
    }
  }

  Future<BuiltList<UserDeviceModel>> getUserDoorbells({int? id}) async {
    final response = await dio.get(
      'doorbell/get',
      queryParameters: {if (id != null) "location_id": id},
    );

    return UserDeviceModel.fromDynamics(response.data["data"]);
  }

  Future<Map<String, bool>> getNotificationStatus() async {
    try {
      // if (singletonBloc.profileBloc.state?.locationId != null) {
      if (singletonBloc.profileBloc.state?.selectedDoorBell?.locationId !=
          null) {
        // ignore: avoid_print
        // print(
        //   "notification/unread/status/${singletonBloc.profileBloc.state!.selectedDoorBell?.locationId}",
        // );
        final response = await dio.get(
          options: Options(receiveTimeout: const Duration(days: 10)),
          'notification/unread/status/${singletonBloc.profileBloc.state!.selectedDoorBell?.locationId}',
        );

        // Transform the response data into Map<String, bool>
        final Map<String, dynamic> rawData =
            response.data["data"] is List ? {} : response.data["data"];
        final Map<String, bool> transformedData = rawData.map(
          (key, value) => MapEntry(key, value as bool),
        );

        return transformedData;
      }
      return {};
    } catch (e) {
      _logger.severe(e.toString());
      return {};
    }
  }

  Future<Response> editDoorbellName({
    required String deviceId,
    required String name,
  }) async {
    final params = {"name": name};
    final response = await dio.put("doorbell/name/$deviceId", data: params);
    return response;
  }

  Future<Response> releaseDoorbell(int deviceId) async {
    final params = {"session_id": await CommonFunctions.getDeviceToken()};
    final response = await dio.post("doorbell/release/$deviceId", data: params);
    return response;
  }

  Future<Response> scanDoorbell(String deviceId, int value) async {
    final response = await dio.get(
      'doorbell/scan/$deviceId',
      queryParameters: {
        "is_scan": value,
      },
    );
    return response;
  }

  // Future<Response> verifyDoorbell(String deviceId) async {
  //   return await dio.get('doorbell/scan/verify/$deviceId');
  // }

  Future<BuiltList<IotDeviceModel>> getIotDevices() async {
    if (singletonBloc.profileBloc.state!.selectedDoorBell?.locationId == null) {
      return <IotDeviceModel>[].toBuiltList();
    } else {
      final response = await dio.get(
        'smart/device',
        queryParameters: {
          "location_id":
              singletonBloc.profileBloc.state!.selectedDoorBell?.locationId,
        },
      );
      return IotDeviceModel.fromDynamics(response.data["data"]);
    }
  }

  Future<bool> updateIotDeviceUsageCount(int id) async {
    final response = await dio.put('smart/device/usage_count/$id');
    return response.data["success"] ?? false;
  }

  Future<BuiltList<RoomItemsModel>> getAllRooms() async {
    final response = await dio.get(
      'room',
      queryParameters: {
        "location_id":
            singletonBloc.profileBloc.state!.selectedDoorBell?.locationId,
      },
    );
    return RoomItemsModel.fromDynamics(response.data["data"]);
  }

  Future<Response> getThemes(
    String type,
    int page, {
    String? locationId,
    String? search,
    int? categoryId,
    String? isNextPage,
  }) async {
    final response = await dio.get(
      'theme/list',
      queryParameters: {
        "type": type,
        "page": page,
        if (singletonBloc.profileBloc.state != null &&
            // singletonBloc.profileBloc.state!.locationId != null)
            singletonBloc.profileBloc.state!.selectedDoorBell?.locationId !=
                null)
          // "location_id": singletonBloc.profileBloc.state!.locationId,
          "location_id": singletonBloc
              .profileBloc.state!.selectedDoorBell?.locationId
              .toString(),
        if (categoryId != null) "category_id": categoryId,
        if (search != null) "search": search,
        "page_size": type == "My Themes" ? 48 : 18,
      },
    );
    return response;
  }

  Future<WeatherModel> getWeather(lat, long) async {
    final response = await Dio().get(
      "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&current_weather=true",
    );
    if (response.statusCode == 200) {
      final data = response.data;

      return WeatherModel.fromJson(data);
    } else {
      throw Exception();
    }
  }

  Future<Response> deleteThemes(int id) async {
    final response = await dio.delete(
      'theme/$id',
    );
    return response;
  }

  Future<Response> applyThemeOnDoorBell(
    int themeId, {
    required String timeZone,
    required String weather,
    required String location,
    required String text,
    required String bottomText,
    required String deviceId,
  }) async {
    final response = await dio.post(
      'theme/doorbell/apply',
      data: {
        "theme_id": themeId,
        "device_id": deviceId,
        "colors": [
          {
            "time_zone": timeZone,
            "weather": weather,
            "location": location,
            "text": text,
            "bottom_text": bottomText,
          }
        ],
      },
    );
    return response;
  }

  Future<Response> removeThemeFromDoorbell({
    required String deviceId,
  }) async {
    final response = await dio.get('theme/doorbell/unassign/$deviceId');
    return response;
  }

  Future<Response> getThemesCategory({
    int? pageSize,
    int? page,
    String? search,
  }) async {
    final response = await dio.get(
      'theme/category/list',
      queryParameters: {
        "page_size": pageSize,
        "page": 1,
        if (search != null) "search": search,
      },
    );
    return response;
  }

  Future<Response> uploadTheme({
    required String file,
    required String thumbnail,
    required categoryId,
    required String title,
  }) async {
    final response = await dio.post(
      'theme/user/upload',
      data: {
        "cover": file,
        "thumbnail": thumbnail,
        "category_id": categoryId,
        // "location_id": singletonBloc.profileBloc.state!.locationId,
        "location_id": singletonBloc
            .profileBloc.state!.selectedDoorBell?.locationId
            .toString(),
        "title": title,
      },
    );
    return response;
  }

  Future<Response> themeLike({
    String? locationId,
    String? themeId,
    bool? isLike,
  }) async {
    final response = await dio.post(
      'theme/like',
      data: {
        "location_id": locationId,
        "theme_id": themeId,
        "like": isLike,
      },
    );
    return response;
  }

  Future<AiThemeModel> createAiTheme(String description) async {
    final response = await dio.post(
      'theme/user/ai-theme',
      options: Options(receiveTimeout: const Duration(minutes: 1)),
      data: {
        "description": description,
      },
    );
    return AiThemeModel(
      counter: response.data["data"]["ai_theme_counter"],
      url: response.data["data"]["url"],
    );
  }

  int count = 0;

  Future<Response> streamingFunction(String sdp, bool isStreaming) async {
    if (count > 0) {
      await Future.delayed(const Duration(seconds: 2));
    }
    String? userName;
    String? password;
    final keys = await getKeys();
    keys?.forEach((element) {
      if (element["slug"] == "sg_username") {
        userName = element["value"];
      }
      if (element["slug"] == "sg_password") {
        password = element["value"];
      }
    });
    try {
      final basicAuth =
          "Basic ${base64Encode(utf8.encode('$userName:$password'))}";
      final response = await Dio().post(
        '${config.whepUrl}/${singletonBloc.profileBloc.state!.streamingId}/whep',
        data: sdp,
        options: Options(
          headers: {
            'Content-Type': 'application/sdp',
            "Authorization": basicAuth,
          },
        ),
      );
      _logger.fine("whep successful");
      return response;
    } on DioException catch (e) {
      _logger.fine("whep successful not");
      if (count <= 1) {
        count++;
        return streamingFunction(sdp, isStreaming);
      }
      // unawaited(
      //   GetStorage().write(
      //     "imageValue[${singletonBloc.profileBloc.state!.streamingId}]",
      //     "offline",
      //   ),
      // );
      _logger.severe(e);
      return e.response!;
    }
  }

  Future<StreamingAlertsData> getRecodedM3U8(
    DateTime calendarDate,
    String deviceId,
    String uuid,
    VoipBloc bloc, {
    bool isExternalCamera = false,
  }) async {
    final DateTime endTime = DateTime(
      calendarDate.year,
      calendarDate.month,
      calendarDate.day,
      23,
      59,
    );
    // final DateTime startTime = DateTime(
    //   calendarDate.year,
    //   calendarDate.month,
    //   calendarDate.day,
    //   11,
    //   06,
    // );
    final Map<String, dynamic> queryParameters = {
      "device_id": deviceId,
      "start_date":
          DateFormat('yyyy-MM-dd HH:mm:ss').format(calendarDate.toUtc()),
      "end_date": DateFormat('yyyy-MM-dd HH:mm:ss').format(
        endTime.toUtc(),
      ),
      // "start_date": DateFormat('yyyy-MM-dd HH:mm:ss')
      //     .format(DateTime.now().add(const Duration(minutes: -30)).toUtc()),
      // "end_date": DateFormat('yyyy-MM-dd HH:mm:ss').format(
      //   endTime.toUtc(),
      // ),
      "uuid": uuid,
    };
    final response =
        await dio.get("stream/fetch-streams", queryParameters: queryParameters);
    if (response.data["data"]["fileStartTime"] == null) {
      return StreamingAlertsData.fromDynamic(
        response.data["data"],
        calendarDate,
      );
    } else {
      bloc.calendarDate =
          DateTime.parse(response.data["data"]["fileStartTime"]).toLocal();
      return StreamingAlertsData.fromDynamic(
        response.data["data"],
        DateTime.parse(response.data["data"]["fileStartTime"]).toLocal(),
      );
    }
  }

  /// Enhanced M3U8 parsing that creates a time mapping for accurate synchronization
  Future<M3U8TimeMapping> parseM3U8WithTimeMapping(String m3u8Url) async {
    final response = await http.get(Uri.parse(m3u8Url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load .m3u8 file');
    }

    final lines = response.body.split('\n');

    final segments = <M3U8Segment>[];
    double currentDuration = 0;
    bool hasDiscontinuity = false;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Check for discontinuity marker
      if (line == '#EXT-X-DISCONTINUITY') {
        hasDiscontinuity = true;
        continue;
      }

      // Parse segment duration
      if (line.startsWith('#EXTINF:')) {
        final durationMatch = RegExp(r'#EXTINF:([0-9.]+)').firstMatch(line);
        if (durationMatch != null) {
          final duration = double.parse(durationMatch.group(1)!);

          // Look for the next .ts file
          for (int j = i + 1; j < lines.length; j++) {
            final nextLine = lines[j].trim();
            if (nextLine.endsWith('.ts')) {
              final tsUrl = nextLine;
              final tsFileName = Uri.parse(tsUrl).pathSegments.last;
              final timestampPart =
                  tsFileName.split('.ts').first.replaceAll("_", " ");

              try {
                if (j == 2676) {
                  _logger.fine("tsUrl: $tsUrl");
                }
                final dateTime = DateFormat("yyyy-MM-dd HH-mm-ss")
                    .parseUTC(timestampPart)
                    .toLocal();

                segments.add(
                  M3U8Segment(
                    url: tsUrl,
                    startTime: dateTime.add(const Duration(seconds: 1)),
                    duration: duration,
                    videoPosition: currentDuration,
                    hasDiscontinuity: hasDiscontinuity,
                  ),
                );

                currentDuration += duration;
                hasDiscontinuity = false;
                break;
              } catch (e) {
                // Skip invalid entries
                break;
              }
            }
          }
        }
      }
    }

    return M3U8TimeMapping(
      segments: segments,
      totalDuration: currentDuration,
    );
  }

  /// Enhanced M3U8 parsing that extracts duration from URL query parameters
  /// This method prioritizes the duration parameter in the URL over EXTINF values
  Future<M3U8TimeMapping> parseM3U8WithUrlDuration(String m3u8Url) async {
    final response = await http.get(Uri.parse(m3u8Url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load .m3u8 file');
    }

    final lines = response.body.split('\n');

    final segments = <M3U8Segment>[];
    double currentDuration = 0;
    bool hasDiscontinuity = false;

    for (int i = 0; i < lines.length; i++) {
      final l = lines[i].trim();
      final line = l.split('?')[0];

      // Check for discontinuity marker
      if (line == '#EXT-X-DISCONTINUITY') {
        hasDiscontinuity = true;
        continue;
      }

      double? durationParam;
      // Look for .ts files and extract duration from URL query parameters
      if (line.contains("#EXTINF:")) {
        durationParam = double.parse(line.split("#EXTINF:")[1]);
        // _logger.fine("${line.split(":")[0]} tester");
        // _logger.fine("${line.split(":")[1]} tester");
      }
      if (line.endsWith('.ts')) {
        final tsUrl = l;
        final uri = Uri.parse(tsUrl);

        double segmentDuration = 5; // Default duration

        // Check if duration parameter exists in URL
        if (durationParam != null) {
          try {
            segmentDuration = durationParam;
            durationParam.toInt();
            _logger.fine(
              'Extracted duration from URL: $segmentDuration for segment: ${uri.pathSegments.last}',
            );
          } catch (e) {
            _logger.warning(
              'Failed to parse duration parameter: $durationParam, using default: $segmentDuration',
            );
          }
        } else {
          // Fallback to EXTINF duration if available
          // Look backwards for EXTINF line
          for (int j = i - 1; j >= 0; j--) {
            final prevLine = lines[j].trim();
            if (prevLine.startsWith('#EXTINF:')) {
              final durationMatch =
                  RegExp(r'#EXTINF:([0-9.]+)').firstMatch(prevLine);
              if (durationMatch != null) {
                segmentDuration = double.parse(durationMatch.group(1)!);
                _logger.fine(
                  'Using EXTINF duration: $segmentDuration for segment: ${uri.pathSegments.last}',
                );
                break;
              }
            }
          }
        }

        final dateTime = DateFormat("yyyy-MM-dd HH-mm-ss")
            .parseUTC(
              uri.pathSegments.last.split('.ts').first.replaceAll("_", " "),
            )
            .toLocal();

        segments.add(
          M3U8Segment(
            url: tsUrl,
            startTime: dateTime.add(const Duration(seconds: 1)),
            duration: segmentDuration,
            videoPosition: currentDuration,
            hasDiscontinuity: hasDiscontinuity,
          ),
        );

        currentDuration += segmentDuration;
        hasDiscontinuity = false;
      }
    }

    _logger.fine(
      'Parsed ${segments.length} segments with total duration: $currentDuration seconds',
    );
    return M3U8TimeMapping(
      segments: segments,
      totalDuration: currentDuration,
    );
  }

  /// Extract all duration values from M3U8 file URLs
  /// Returns a list of maps containing segment info and extracted durations
  Future<List<Map<String, dynamic>>> extractDurationsFromM3U8(
    String m3u8Url,
  ) async {
    final response = await http.get(Uri.parse(m3u8Url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load .m3u8 file');
    }

    final lines = response.body.split('\n');
    final durations = <Map<String, dynamic>>[];

    for (final line in lines) {
      if (line.trim().endsWith('.ts')) {
        final tsUrl = line.trim();
        final uri = Uri.parse(tsUrl);
        final durationParam = uri.queryParameters['duration'];

        if (durationParam != null) {
          try {
            final duration = double.parse(durationParam);
            final fileName = uri.pathSegments.last;

            durations.add({
              'url': tsUrl,
              'fileName': fileName,
              'duration': duration,
              'extractedDuration': durationParam,
            });
          } catch (e) {
            _logger.warning(
              'Failed to parse duration: $durationParam from URL: $tsUrl',
            );
          }
        }
      }
    }

    _logger
        .fine('Extracted ${durations.length} duration values from M3U8 file');
    return durations;
  }

  /// Get summary statistics of extracted durations
  Future<Map<String, dynamic>> getDurationStatistics(String m3u8Url) async {
    final durations = await extractDurationsFromM3U8(m3u8Url);

    if (durations.isEmpty) {
      return {
        'totalSegments': 0,
        'totalDuration': 0.0,
        'averageDuration': 0.0,
        'minDuration': 0.0,
        'maxDuration': 0.0,
        'durationValues': <double>[],
      };
    }

    final durationValues =
        durations.map((d) => d['duration'] as double).toList();
    final totalDuration = durationValues.reduce((a, b) => a + b);
    final averageDuration = totalDuration / durationValues.length;
    final minDuration = durationValues.reduce((a, b) => a < b ? a : b);
    final maxDuration = durationValues.reduce((a, b) => a > b ? a : b);

    return {
      'totalSegments': durations.length,
      'totalDuration': totalDuration,
      'averageDuration': averageDuration,
      'minDuration': minDuration,
      'maxDuration': maxDuration,
      'durationValues': durationValues,
    };
  }

  Future<M3U8TimeMapping> parseM3U8WithTimeMappingTest(String m3u8Url) async {
    final response = await http.get(Uri.parse(m3u8Url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load .m3u8 file');
    }

    final lines = response.body.split('\n')
      ..removeWhere((line) => line.startsWith('#'));
    final segments = <M3U8Segment>[];
    double currentDuration = 0;
    bool hasDiscontinuity = false;

    for (int i = 0; i < lines.length; i++) {
      final bool isNextSegment = i + 1 < lines.length;
      if (isNextSegment) {
        final line =
            lines[i].split("/").last.split(".ts").first.replaceAll("_", " ");
        final nextLine = lines[i + 1]
            .split("/")
            .last
            .split(".ts")
            .first
            .replaceAll("_", " ");
        final firstLine =
            DateFormat("yyyy-MM-dd HH-mm-ss").parseUTC(line).toLocal();
        final secondLine =
            DateFormat("yyyy-MM-dd HH-mm-ss").parseUTC(nextLine).toLocal();
        final timestampPart =
            secondLine.difference(firstLine).inSeconds.toDouble();
        final tsUrl = lines[i];
        if (timestampPart < 14) {
          try {
            segments.add(
              M3U8Segment(
                url: tsUrl,
                startTime: firstLine,
                duration: timestampPart,
                videoPosition: currentDuration,
                hasDiscontinuity: hasDiscontinuity,
              ),
            );

            currentDuration += timestampPart;
            hasDiscontinuity = false;
          } catch (e) {
            // Skip invalid entries
            break;
          }
        } else {
          try {
            segments.add(
              M3U8Segment(
                url: tsUrl,
                startTime: firstLine,
                duration: 5,
                videoPosition: currentDuration,
                hasDiscontinuity: hasDiscontinuity,
              ),
            );

            if (timestampPart > 2000) {
              _logger.fine("timestampPart $timestampPart");
            }
            _logger.fine("timestampPart $timestampPart");
            currentDuration += 5;
            hasDiscontinuity = false;
          } catch (e) {
            // Skip invalid entries
            break;
          }
        }
      } else {
        final line =
            lines[i].split("/").last.split(".ts").first.replaceAll("_", " ");
        final firstLine =
            DateFormat("yyyy-MM-dd HH-mm-ss").parseUTC(line).toLocal();
        const timestampPart = 10.0;
        final tsUrl = lines[i];
        try {
          segments.add(
            M3U8Segment(
              url: tsUrl,
              startTime: firstLine,
              duration: timestampPart,
              videoPosition: currentDuration,
              hasDiscontinuity: true,
            ),
          );

          currentDuration += timestampPart;
          hasDiscontinuity = true;
        } catch (e) {
          // Skip invalid entries
          break;
        }
      }
    }

    return M3U8TimeMapping(
      segments: segments,
      totalDuration: currentDuration,
    );
  }

  Future<String> fixExtinfDurations(String m3u8Url) async {
    // ---------- 1. Load the playlist ----------
    final res = await http.get(Uri.parse(m3u8Url));
    if (res.statusCode != 200) {
      throw Exception('Failed to load $m3u8Url  (HTTP ${res.statusCode})');
    }
    final lines = res.body.split('\n');

    // ---------- 2. Collect the timestamps of every .ts ----------
    final tsRegex = RegExp(r'https?.+?/(\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2})');
    final fmt = DateFormat('yyyy-MM-dd_HH-mm-ss');
    final List<DateTime> tsTimes = [];
    for (final line in lines) {
      final m = tsRegex.firstMatch(line.trim());
      if (m != null) {
        tsTimes.add(fmt.parseUtc(m.group(1)!).toLocal());
      }
    }
    if (tsTimes.length < 2) {
      return res.body; // nothing to fix
    }

    // ---------- 3. Build a map: lineIndex → computedDuration ----------
    final Map<int, double> extinfDurations = {};
    int tsCursor = 0;
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.startsWith('#EXTINF:')) {
        // Duration between current ts and the next ts
        if (tsCursor + 1 < tsTimes.length) {
          int seconds =
              tsTimes[tsCursor + 1].difference(tsTimes[tsCursor]).inSeconds - 3;
          if (seconds > 9) {
            seconds = 9;
          }
          extinfDurations[i] = seconds.toDouble();
        }
      } else if (line.trim().endsWith('.ts')) {
        tsCursor++;
      }
    }

    // ---------- 4. Re‑assemble playlist ----------
    final buffer = StringBuffer();
    for (var i = 0; i < lines.length; i++) {
      if (extinfDurations.containsKey(i)) {
        buffer.writeln('#EXTINF:${extinfDurations[i]!.toStringAsFixed(1)}');
      } else {
        buffer.writeln(lines[i]);
      }
    }
    return buffer.toString();
  }

  /// Get the real timestamp for a given video position (accounting for timeskips)
  DateTime? getRealTimestampForVideoPosition(
    M3U8TimeMapping timeMapping,
    double videoPositionSeconds,
  ) {
    if (timeMapping.segments.isEmpty) {
      return null;
    }

    // Find the segment that contains this video position
    for (final segment in timeMapping.segments) {
      if (videoPositionSeconds >= segment.videoPosition &&
          videoPositionSeconds < segment.videoPosition + segment.duration) {
        // Calculate the offset within this segment
        final segmentOffset = videoPositionSeconds - segment.videoPosition;
        final time = segment.startTime
            .add(Duration(milliseconds: (segmentOffset * 1000).round()));
        // _logger.fine("time is $time");
        // _logger.fine("videoPositionSeconds is $videoPositionSeconds");
        // _logger.fine("segment.startTime is ${segment.url}");
        return time;
      }
    }
    // If position is beyond all segments, return the last segment's end time
    final lastSegment = timeMapping.segments.last;
    return lastSegment.startTime
        .add(Duration(milliseconds: (lastSegment.duration * 1000).round()));
  }

  SegmentDateTime? getRealTimestampForScrollPosition(
    M3U8TimeMapping timeMapping,
    double videoPositionSeconds,
  ) {
    if (timeMapping.segments.isEmpty) {
      return null;
    }

    // Find the segment that contains this video position
    for (int i = 0; i < timeMapping.segments.length; i++) {
      final segment = timeMapping.segments[i];
      if (videoPositionSeconds >= segment.videoPosition &&
          videoPositionSeconds < segment.videoPosition + segment.duration) {
        // Calculate the offset within this segment
        // final segmentOffset = segment.videoPosition;
        final time = segment.startTime;
        _logger
          ..fine("time is $time")
          ..fine("videoPositionSeconds is $videoPositionSeconds")
          ..fine("segment.startTime is ${segment.url}");
        return SegmentDateTime(
          segment: segment,
          dateTime: time,
          segmentIndex: i,
        );
      }
    }
    // If position is beyond all segments, return the last segment's end time
    final lastSegment = timeMapping.segments.last;
    return SegmentDateTime(
      segment: lastSegment,
      segmentIndex: timeMapping.segments.length - 1,
      dateTime: lastSegment.startTime.add(
        Duration(milliseconds: (lastSegment.duration * 1000).round()),
      ),
    );
  }

  /// Get the video position for a given real timestamp (accounting for timeskips)
  double? getVideoPositionForRealTimestamp(
    M3U8TimeMapping timeMapping,
    DateTime realTimestamp,
  ) {
    if (timeMapping.segments.isEmpty) {
      return null;
    }

    // Find the segment that contains this timestamp
    for (final segment in timeMapping.segments) {
      final segmentEndTime = segment.startTime.add(
        Duration(seconds: segment.duration.round() - 1),
      );

      // _logger
      //   ..fine("segmentStartTime ${segment.startTime}")
      //   ..fine("segmentStartSeconds $d")
      //   ..fine("segmentEndTime $segmentEndTime");
      if (realTimestamp.isAfter(segment.startTime) &&
          realTimestamp.isBefore(segmentEndTime)) {
        // Calculate the offset within this segment
        final segmentOffset =
            realTimestamp.difference(segment.startTime).inMilliseconds / 1000.0;
        return segment.videoPosition + segmentOffset;
      }
    }

    return null;
  }

  Future<List<Map<String, dynamic>>> getAllIceServers() async {
    try {
      final response = await Dio().post(
        config.iceServerUrl, //"https://turn-dev.irvinei.com/turn/credentials",
        options: Options(headers: {"Content-Type": "application/json"}),
        data: {
          // "identity": "test",
          // "key": "APINGATp5C4yp5M"
          "identity": config.iceServerId,
          "key": config.iceServerKey,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> iceServersJson = response.data;
        // final List<dynamic> iceServersJson = iceCandidate['ice_servers'];

        final List<Map<String, dynamic>> iceServers = [];

        for (final iceServer in iceServersJson) {
          final String url = iceServer['url'];
          final String username = iceServer['username'] ?? '';
          final String credential = iceServer['credential'] ?? '';

          // Adding each ICE server as a Map
          iceServers.add({
            'urls': [url],
            'username': username,
            'credential': credential,
          });
        }

        return iceServers;
      } else {
        throw Exception('Failed to load ICE servers');
      }
    } on DioException catch (e) {
      _logger.severe(e);
      return [];
    }
  }

  Future<String> joinMeeting({String? callUserId}) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final String url =
          "${config.streamingGatewayPath}${callUserId ?? singletonBloc.profileBloc.state!.streamingId}";
      final response = await Dio().get(
        url,
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        return response.data["name"];
      } else {
        return "";
      }
    } on DioException {
      return "";
    }
  }

  // Future<void> sendCallNotification(
  //     String command, String deviceId, String constant,
  //     {int? themeId}) async {
  //   // final data_ = {
  //   //   Constants.request: command,
  //   //   "room_id": singletonBloc.profileBloc.state!.locationId,
  //   //   "device_id": deviceId,
  //   //   if (themeId != null) "theme_id": themeId,
  //   //   "sessionId": await CommonFunctions.getDeviceModel(),
  //   //   "message": ""
  //   // };
  //   // _logger.severe(data_);
  //   // final message = {
  //   //   Constants.userId: singletonBloc.profileBloc.state!.id,
  //   //   Constants.roomId: jsonEncode({}),
  //   //   Constants.request: command,
  //   //   Constants.deviceId:
  //   //       singletonBloc.profileBloc.state!.selectedDoorBell!.deviceId,
  //   // };
  //   try {
  //   } on SocketException catch (e) {
  //     _logger.severe(e);
  //   }
  // }

  // Future<Response> sendServerNotification(
  //   Map<String, dynamic> data, {
  //   String command = "audio-audio-flutter",
  //   String? deviceName,
  // }) async {
  //   data[Constants.time] = DateTime.now().toUtc().toString();
  //
  //   final message = {
  //     Constants.userId: singletonBloc.profileBloc.state!.id,
  //     Constants.roomId: jsonEncode(data),
  //     Constants.command: command,
  //     Constants.deviceId: deviceName ??
  //         singletonBloc.profileBloc.state!.selectedDoorBell!.deviceId,
  //   };
  //   sendSocketMessage(command, message);
  //
  //   return await dio.post(
  //     "send/command",
  //     data: message,
  //   );
  // }
  //
  // static sendSocketMessage(String request, Map<String, dynamic> message) async {
  //   String deviceModel = await CommonFunctions.getDeviceModel();
  //
  //   final data_ = {
  //     Constants.roomId:
  //         singletonBloc.profileBloc.state!.selectedDoorBell!.deviceId,
  //     Constants.request: request,
  //     Constants.sessionId: deviceModel,
  //     Constants.message: message
  //   };
  //   try {
  //     singletonBloc.socket!.emit(
  //       Constants.comMessage,
  //       data_,
  //     );
  //   } catch (e) {
  //     _logger.severe(e);
  //   }
  // }

  Future<Response> sendIceCandidate(String location, String fag) async {
    try {
      final response = await Dio().patch(
        '${config.whepUrl}/$location',
        options: Options(
          headers: {
            'Content-Type': 'application/trickle-ice-sdpfrag',
            "If-Match": "*",
          },
        ),
        data: fag,
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        _logger.severe('ICE candidate sent successfully.');
      } else {
        _logger.severe(
          'Failed to send ICE candidate: ${response.statusCode} - ${response.data}',
        );
      }
      return response;
    } on DioException catch (e) {
      _logger.severe(e);
      return e.response!;
    }
  }

  Future<BuiltList<SubUserModel>> getSubUsers({int? locationId}) async {
    final Map<String, dynamic> queryParameters = {
      // "location_id": locationId ?? singletonBloc.profileBloc.state!.locationId,
      "location_id": locationId ??
          singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
              .toString(),
    };

    final response = await dio.get("users", queryParameters: queryParameters);

    return SubUserModel.fromDynamics(response.data["data"]);
  }

  Future<dynamic> getUserInviteDelete({required int inviteId}) async {
    final response = await dio.delete("user/invite/delete/$inviteId");

    return response.data;
  }

  Future<dynamic> getUserDelete({required int subUserId}) async {
    // final params = {"location_id": singletonBloc.profileBloc.state!.locationId};
    final params = {
      "location_id": singletonBloc
          .profileBloc.state!.selectedDoorBell?.locationId
          .toString(),
      "session_id": await CommonFunctions.getDeviceToken(),
    };
    final response = await dio.delete("user/$subUserId", data: params);
    return response.data;
  }

  Future<BuiltList<RoleModel>> getRoles() async {
    final response = await dio.get("roles");
    return RoleModel.fromDynamics(response.data["data"]);
  }

  Future<dynamic> getCreateUserInvite({
    required int userId,
    required String email,
    required int roleId,
    required String relation,
  }) async {
    final params = {
      "user_id": userId,
      // "location_id": singletonBloc.profileBloc.state!.locationId,
      "location_id": singletonBloc
          .profileBloc.state!.selectedDoorBell?.locationId
          .toString(),
      "email": email,
      "name": null,
      "phone": null,
      "role_id": roleId,
      "relation": relation,
    };

    final response = await dio.post("user/invite/create", data: params);

    return response.data;
  }

  Future<BuiltList<PaymentMethodsModel>> getPaymentMethodsList() async {
    final response = await dio.get("payment/payment-methods");
    return PaymentMethodsModel.fromDynamics(response.data['data']);
  }

  Future<bool> makeDefaultPaymentMethod(int paymentId) async {
    final response =
        await dio.put("payment/payment-methods/$paymentId/default");
    return response.data['success'];
  }

  Future<bool> deletePaymentMethod(int paymentId) async {
    final response = await dio.delete("payment/payment-methods/$paymentId");
    return response.data['success'];
  }

  Future<BuiltList<TransactionHistoryModel>> getPaymentTransactions(
    String? transactionFilter,
  ) async {
    final response = await dio.get(
      "payment/transactions",
      data: {if (transactionFilter != null) "interval": transactionFilter},
    );
    return TransactionHistoryModel.fromDynamics(response.data['data']);
  }

  Future<String> getPaymentTransactionInvoiceUrl(String id) async {
    final response = await dio.get("payment/transactions/invoices/$id");
    return response.data['data']['invoice_url'];
  }

  Future<bool> getDeleteVisitor(String visitorId) async {
    final response = await dio.delete("visitors/$visitorId");
    return response.data['success'];
  }

  Future<bool> getDeleteVisits(BuiltList<String> visitIdsList) async {
    final String visitIds = visitIdsList.map((item) => item).join(',');

    final params = {"visit_ids": visitIds};

    final response = await dio.delete("visitors/visit/delete", data: params);

    return response.data['success'];
  }

  Future<bool> getMarkWantedOrUnwantedVisitor(String visitorId) async {
    final response = await dio.post("visitors/$visitorId/mark-wanted");
    return response.data['success'];
  }

  Future<dynamic> editVisitorName(String visitorId, String visitorName) async {
    final params = {
      "name": visitorName,
    };
    final response = await dio.put("visitors/$visitorId", data: params);
    return response.data;
  }

  Future getVisitorHistory({
    required String visitorId,
    String? filterVal,
    int? page,
  }) async {
    final String timeZone = await CommonFunctions.getTz();
    final Map<String, dynamic> queryParameters = {
      "time_zone": timeZone,
      "page": page ?? 1,
    };
    if (filterVal != null) {
      queryParameters['date_filter'] = filterVal;
    }

    final response =
        await dio.get("visitors/$visitorId", queryParameters: queryParameters);

    return response.data;
  }

  Future<Response> getVisitorManagement(int? page, String? filterVal) async {
    final String timeZone = await CommonFunctions.getTz();
    final String locationId =
        // singletonBloc.profileBloc.state!.locationId.toString();
        singletonBloc.profileBloc.state!.selectedDoorBell!.locationId
            .toString();

    final Map<String, dynamic> queryParameters = {
      "location_id": locationId,
      "time_zone": timeZone,
      "page": page ?? 1,
    };
    if (filterVal != null) {
      queryParameters['date_filter'] = filterVal;
    }

    final response =
        await dio.get("visitors", queryParameters: queryParameters);

    return response;
  }

  Future<BuiltList<StatisticsModel>> getIndividualVisitorStats({
    required String visitorId,
    required String? timeInterval,
  }) async {
    final String timeZone = await CommonFunctions.getTz();
    final Map<String, dynamic> queryParameters = {
      "time_zone": timeZone,
    };
    if (timeInterval != null) {
      queryParameters["time_interval"] = timeInterval;
    }
    final response = await dio.get(
      "visitors/$visitorId/statistics",
      queryParameters: queryParameters,
    );
    return StatisticsModel.fromDynamics(response.data["data"]["traffic_data"]);
  }

  Future<BuiltList<StatisticsModel>> getStatistics({
    required String dropDownValue,
    required String timeInterval,
    String? startDate,
    String? endDate,
  }) async {
    final String timeZone = await CommonFunctions.getTz();
    final String locationId = singletonBloc
        .profileBloc.state!.selectedDoorBell!.locationId
        .toString();

    final Map<String, dynamic> queryParameters = {
      "location_id": locationId,
      "drop_value": dropDownValue,
      "time_zone": timeZone,
      "time_interval": timeInterval,
      if (startDate != null) "start_date": startDate,
      if (endDate != null) "end_date": endDate,
    };
    final response =
        await dio.get("visitors/statistics", queryParameters: queryParameters);
    return StatisticsModel.fromDynamics(response.data["data"]);
  }

  // Future<bool> validateUserDetails(
  //     {required String email, required String phoneNumber}) async {
  //   final response = await dio.post('validate-user-detail',
  //       data: FormData.fromMap({
  //         "email": email,
  //         "phone": phoneNumber,
  //       }));
  //   return response.statusCode == 200;
  // }

  Future sendOTPOnPhoneNumber({
    required String phoneNumber,
    required String email,
  }) async {
    final response = await dio.post(
      'otp/send',
      data: {
        "phone_number": phoneNumber,
        "email": email,
      },
    );
    return response.statusCode == 200;
  }

  Future verifyOtp({
    required String otp,
    required String phoneNumber,
    required String email,
  }) async {
    final response = await dio.post(
      'otp/verify',
      data: {
        "otp": otp,
        "phone_number": phoneNumber,
        "email": email,
      },
    );
    return response;
  }

  Future signup({
    required String? name,
    required String email,
    required String password,
    required String phone,
    // required String address,
  }) async {
    final response = await dio.post(
      'auth/register',
      data: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        // "address": address,
      },
    );
    return response.statusCode == 200;
  }

  Future<Response> validateEmail(String email) async {
    final response = await dio.post(
      'auth/vaildate-email',
      data: {
        "email": email,
      },
    );
    return response;
  }

  Future callForgotPassword(String email) async {
    final response = await dio.post(
      "auth/forget-password",
      data: {
        "email": email,
      },
    );
    return response.statusCode == 200;
  }

  Future<BuiltList<AiAlertPreferencesModel>> getAiAlertPreferences(
    String uuid,
    bool isCamera,
  ) async {
    final response = await dio
        .get("alert-preferences/$uuid/${isCamera ? "camera" : "doorbell"}");
    return AiAlertPreferencesModel.fromDynamics(response.data['data']);
  }

  Future<bool> updateAiAlertPreferences({
    required int id,
    required bool isCamera,
    required BuiltList<AiAlertPreferencesModel> aiAlertPreferences,
  }) async {
    final Map<String, dynamic> params = {
      "notification_code_id": aiAlertPreferences
          .where((alert) => alert.isEnabled == 1)
          .map((element) => element.notificationCode.id)
          .toList(),
      "is_enabled": true,
      "device_id": isCamera ? id : null,
      "doorbell_id": !isCamera ? id : null,
      "location_id":
          singletonBloc.profileBloc.state?.selectedDoorBell?.locationId,
    };
    final response = await dio.put("alert-preferences", data: params);
    return response.data['success'];
  }

  Future getNotifications({
    int? isRead,
    int? page,
    String filterParam = '',
    String deviceId = "",
    String cameraId = "",
    DateTime? startDate,
    bool noDeviceAvailable = false,
  }) async {
    final String timeZone = await CommonFunctions.getTz();
    final queryParameters = {
      "page": page ?? 1,
      'location_id':
          singletonBloc.profileBloc.state!.selectedDoorBell?.locationId,
      "time_zone": timeZone,
      "is_read": isRead,
      if (filterParam.isNotEmpty) "filter": filterParam,
      if (deviceId.isNotEmpty) "device_id": deviceId,
      if (cameraId.isNotEmpty) "camera_id": cameraId,
      if (noDeviceAvailable) "type": "noDevice",
      if (startDate != null)
        "startdate": DateFormat('yyyy-MM-dd').format(startDate),
      if (startDate != null)
        "enddate": DateFormat('yyyy-MM-dd').format(startDate),
    };
    final response = await dio.post(
      "notification/get-all",
      queryParameters: queryParameters,
    );
    // //TODO: Bypass
    // List data = [];
    // if (response.data['data']['data'] is Map) {
    //   Map dataLog = response.data['data']['data'];
    //   dataLog.forEach((key, value) {
    //     if (value is List) {
    //       data.addAll(value);
    //     }
    //   });
    //   response.data['data']['data'] = data;
    // }
    return response.data;
  }

  Future<String> refreshToken() async {
    final response = await dio.get(
      "auth/refresh-token/${singletonBloc.profileBloc.state!.refreshToken}",
    );
    return response.data["data"]['session_token'];
  }

  Future<Response> updateDefaultLocation({required int? locationId}) async {
    final params = {
      "location_id": locationId,
    };
    final response = await dio.post("location/default", data: params);
    return response;
  }

  Future<int?> getDefaultLocation() async {
    final response = await dio.get("user/dashboard");
    return response.data["data"]["default_location"] ??
        singletonBloc.profileBloc.state?.selectedDoorBell?.locationId;
  }

  Future<Response> releaseLocation({required int locationId}) async {
    final params = {
      "location_id": locationId,
      "session_id": await CommonFunctions.getDeviceToken(),
    };
    final response = await dio.post("location/release", data: params);
    return response;
  }

  Future<Response> getOwnershipTransfer({
    required int locationId,
    required int newOwnerId,
    required int currentOwnerId,
  }) async {
    final params = {
      "current_owner_id": currentOwnerId,
      "new_owner_id": newOwnerId,
      "location_id": locationId,
    };
    final response = await dio.post("location/transfer", data: params);
    return response;
  }

  Future<Response> getUpdateLocation({
    required int locationId,
    required double latitude,
    required double longitude,
    required String houseNo,
    required String street,
    required String locationName,
    required Placemark address,
  }) {
    String locality = "";
    String subLocality = "";
    if (!(address.subLocality == null || address.subLocality!.isEmpty)) {
      subLocality = "${address.subLocality}";
    }
    if (!(address.locality == null || address.locality!.isEmpty)) {
      locality = "${address.locality}";
    }
    final params = {
      "name": locationName,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "house_no": houseNo,
      "street": street,
      "state": address.administrativeArea,
      "city": "${subLocality.isNotEmpty ? subLocality : ""}"
          "${(subLocality.isNotEmpty && locality.isNotEmpty) ? "," : ""}"
          "${locality.isNotEmpty ? " $locality" : ""}",
      "zipcode": address.postalCode,
      "country": address.country,
    };
    final response = dio.put("location/update/$locationId", data: params);
    return response;
  }

  Future<Response> createLocation({
    required String name,
    required String houseNo,
    required String street,
    Placemark? address,
    LatLng? coordinates,
  }) async {
    String city = "";
    if (!(address?.subLocality == null || address!.subLocality!.isEmpty)) {
      city = "${address.subLocality}";
    }
    if (!(address?.locality == null || address!.locality!.isEmpty)) {
      city = "$city, ${address.locality}";
    }
    final response = await dio.post(
      "location/create",
      data: {
        "name": name,
        "latitude": coordinates!.latitude.toString(),
        "longitude": coordinates.longitude.toString(),
        "house_no": houseNo,
        "street": street,
        "state": address!.administrativeArea,
        "city": city,
        "zipcode": address.postalCode,
        "country": address.country,
      },
    );
    return response;
  }

  Future assignDoorbell({
    String? name,
    String? deviceId,
    int? locationId,
  }) async {
    final response = await dio.post(
      "location/connect-doorbell",
      data: {
        "name": name,
        "device_id": deviceId,
        "location_id": locationId,
      },
    );
    return response;
  }

  Future markAllAsRead() async {
    try {
      // if (singletonBloc.profileBloc.state?.locationId == null) {
      if (singletonBloc.profileBloc.state?.selectedDoorBell?.locationId ==
          null) {
        await Future.delayed(
          const Duration(seconds: 2),
        );
        // return singletonBloc.profileBloc.state?.locationId == null
        return singletonBloc.profileBloc.state?.selectedDoorBell?.locationId ==
                null
            ? null
            : dio.post(
                'notification/mark-all-as-read',
                data: {
                  // "location_id": singletonBloc.profileBloc.state!.locationId,
                  "location_id": singletonBloc
                      .profileBloc.state!.selectedDoorBell?.locationId
                      .toString(),
                },
              );
      }
      return dio.post(
        'notification/mark-all-as-read',
        data: {
          // "location_id": singletonBloc.profileBloc.state!.locationId,
          "location_id": singletonBloc
              .profileBloc.state!.selectedDoorBell?.locationId
              .toString(),
        },
      );
    } catch (e) {
      _logger.severe(e.toString());
      // if (singletonBloc.profileBloc.state?.locationId == null) {
      if (singletonBloc.profileBloc.state?.selectedDoorBell?.locationId ==
          null) {
        await Future.delayed(
          const Duration(seconds: 2),
        );
        // return singletonBloc.profileBloc.state?.locationId == null
        return singletonBloc.profileBloc.state?.selectedDoorBell?.locationId ==
                null
            ? null
            : dio.post(
                'notification/mark-all-as-read',
                data: {
                  // "location_id": singletonBloc.profileBloc.state!.locationId,
                  "location_id": singletonBloc
                      .profileBloc.state!.selectedDoorBell?.locationId
                      .toString(),
                },
              );
      }
    }
  }

  Future createRoom(name, type) async {
    return dio.post(
      "room",
      data: {
        "location_id":
            singletonBloc.profileBloc.state!.selectedDoorBell?.locationId,
        "name": name,
        "type": type,
      },
    );
  }

  Future getAllBrands() async {
    final response = await dio.get(
      "smart/device/brands",
    );
    return Brands.fromDynamics(response.data['data']);
  }

  Future<String?> getKeyForDaVoice() async {
    try {
      final response = await dio.get(
        "general/settings?filter=oval_key",
      );
      return response.data["data"]["value"];
    } catch (e) {
      _logger.severe(e.toString());
      return null;
    }
  }

  Future<List?> getKeys() async {
    try {
      final response = await dio.get(
        "general/settings",
      );
      return response.data["data"];
    } catch (e) {
      _logger.severe(e.toString());
      return null;
    }
  }

  Future<bool> deleteIotDevice(
    String id,
    BuiltList<IotDeviceModel> data,
    String entityId,
  ) async {
    final response = await dio.delete(
      "smart/device/$id",
      data: {
        "entity_ids": data
            .where((x) => x.entityId != entityId)
            .map((x) => x.entityId)
            .toList(),
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> editIotDevice(
    int id,
    String name,
    String entityId,
    int roomId,
  ) async {
    final response = await dio.put(
      "smart/device/$id",
      data: {
        "name": name,
        "entity_id": entityId,
        "room_id": roomId,
      },
    );
    return response.statusCode == 200;
  }

  Future<String> getVersionApi() async {
    final response = await dio.get(
      "general/settings",
      queryParameters: {
        "filter":
            Platform.isAndroid ? "admin_app_version" : "admin_app_version_ios",
      },
    );
    return response.data["data"]['value'];
  }

  String _generateNonce() {
    return Random().nextInt(100000).toString();
  }

  String _generateHmacSha256(String data, String secret) {
    final hmac = Hmac(sha256, utf8.encode(secret));
    final digest = hmac.convert(utf8.encode(data));
    return base64.encode(digest.bytes);
  }

  Future getCurtainDeviceId({
    bool list = false,
    String token =
        "c399c51e1ad0c4acd45933b2d1abfd3fc448057a4a2b4ba4ff66c1c6187fb8de7dfefff3de1c75240ee1285aa4ad644e",
    String secret = '4b3265a0287e6f1fbd7d94a6bfa7da6f',
  }) async {
    try {
      final String nonce = _generateNonce();
      final String time = DateTime.now().millisecondsSinceEpoch.toString();
      final String data = '$token$time$nonce';
      final String signature = _generateHmacSha256(data, secret);
      final dio = Dio();
      final Response response = await dio.get(
        "https://api.switch-bot.com/v1.1/devices",
        options: Options(
          headers: {
            "Authorization": token,
            "sign": signature,
            "nonce": nonce,
            "t": time,
          },
        ),
      );
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        if (list) {
          return (jsonResponse['body']['deviceList'] ?? [])
              .map((e) => Device.fromJson(e))
              .toList();
        } else {
          final List deviceList = jsonResponse['body']['deviceList'] ?? [];

          final devices = deviceList.map((e) => Device.fromJson(e)).toList();
          String selectedDeviceId = "";
          for (int i = 0; i < devices.length; i++) {
            if (devices[i].deviceType.toLowerCase().contains('curtain')) {
              selectedDeviceId = devices[i].deviceId;
              break;
            }
          }
          return selectedDeviceId;
        }
      }
      return "";
    } catch (e) {
      return "Unauthorized, Please enter valid token and key";
    }
  }

  Future<bool> setCurtainAttributes(
    entityId,
    Map<String, dynamic> jsonData,
  ) async {
    final Dio dio = Dio();
    jsonData["s"] = jsonData['body']['slidePosition']?.toDouble() ?? 0.0;
    jsonData["a"] = jsonData['body'];
    jsonData
      ..remove("statusCode")
      ..remove("body")
      ..remove("message");
    final data = {
      "attributes": [
        {
          "entity_id": entityId,
          "attribute": jsonEncode(jsonData),
        }
      ],
    };
    final response = await dio.post(
      "${config.iotAttributesUrl}api/devices/attributes/${singletonBloc.profileBloc.state?.selectedDoorBell?.locationId}",
      data: data,
      options: Options(headers: {"Authorization": "Bearer ${config.key}"}),
    );

    return response.statusCode == 200;
  }

  dynamic findSlidePosition(Map<String, dynamic> data) {
    if (data.containsKey('slidePosition')) {
      return data['slidePosition'];
    }

    for (final value in data.values) {
      if (value is Map<String, dynamic>) {
        final result = findSlidePosition(value);
        if (result != null) {
          return result;
        }
      }
    }
    return null; // Not found
  }

  dynamic findDirection(Map<String, dynamic> data) {
    if (data.containsKey('direction')) {
      return data['direction'];
    }

    for (final value in data.values) {
      if (value is Map<String, dynamic>) {
        final result = findDirection(value);
        if (result != null) {
          return result;
        }
      }
    }
    return null; // Not found
  }

  Future<List<dynamic>> getStatusCurtain(
    String selectedDeviceId,
    String selectedEntityId, {
    String token =
        "c399c51e1ad0c4acd45933b2d1abfd3fc448057a4a2b4ba4ff66c1c6187fb8de7dfefff3de1c75240ee1285aa4ad644e",
    String secret = '4b3265a0287e6f1fbd7d94a6bfa7da6f',
  }) async {
    try {
      final String nonce = _generateNonce();
      final String time = DateTime.now().millisecondsSinceEpoch.toString();
      final String data = '$token$time$nonce';
      final String signature = _generateHmacSha256(data, secret);
      // https://api.switch-bot.com/v1.1/devices
      final dio = Dio();

      final response = await dio.get(
        "https://api.switch-bot.com/v1.1/devices/$selectedDeviceId/status",
        options: Options(
          headers: {
            "Authorization": token,
            "sign": signature,
            "nonce": nonce,
            "t": time,
          },
        ),
      );
      try {
        if (response.statusCode == 200) {
          final jsonResponse = response.data;
          // unawaited(setCurtainAttributes(selectedEntityId, jsonResponse));

          _logger.severe(jsonResponse.toString());

          // Extract direction and raw position
          final direction = findDirection(jsonResponse);
          final rawPosition = (findSlidePosition(jsonResponse) ?? 0).toDouble();

          // If direction exists, use raw position directly; otherwise, round it
          final sliderPosition =
              direction != null ? rawPosition : roundToNearestTen(rawPosition);

          // Return both in a structured format
          return [sliderPosition, direction];
        }
      } on Exception catch (e) {
        _logger.severe(e);
        return [0];
      }
      return [0];
    } catch (e) {
      return [0];
    }
  }

  Future<Map<String, dynamic>> operateCurtain(
    String selectedDeviceId, {
    String token =
        "c399c51e1ad0c4acd45933b2d1abfd3fc448057a4a2b4ba4ff66c1c6187fb8de7dfefff3de1c75240ee1285aa4ad644e",
    String secret = '4b3265a0287e6f1fbd7d94a6bfa7da6f',
    String? command,
    String? parameter,
    required String? entityId,
    required String? val,
  }) async {
    try {
      final String nonce = _generateNonce();
      final String time = DateTime.now().millisecondsSinceEpoch.toString();
      final String data = '$token$time$nonce';
      final String signature = _generateHmacSha256(data, secret);
      // https://api.switch-bot.com/v1.1/devices
      final dio = Dio();

      final response = await dio.post(
        "https://api.switch-bot.com/v1.1/devices/$selectedDeviceId/commands",
        data: {
          "command": command,
          "parameter": parameter,
          "commandType": "command",
        },
        options: Options(
          headers: {
            "Authorization": token,
            "sign": signature,
            "nonce": nonce,
            "t": time,
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        data["slidePosition"] = double.parse(val!);
        final finalData = {
          "body": data,
        };
        // unawaited(
        //   setCurtainAttributes(entityId, {
        //     "body": data,
        //   }),
        // );
        return {"status": true, "request_data": finalData};
      } else {
        _logger.severe("Failed to send command: ${response.statusCode}");
        return {"status": false};
      }
    } on Exception catch (e) {
      _logger.severe(e);
      return {"status": false};
    }
  }

  double roundToNearestTen(double number) {
    return (number / 10).round() * 10;
  }

  Future editRoomName(name, RoomItemsModel room) async {
    final response = await dio.put(
      "room/${room.roomId}",
      data: {
        "name": name,
        // "location_id": singletonBloc.profileBloc.state!.locationId,
        "location_id": singletonBloc
            .profileBloc.state!.selectedDoorBell?.locationId
            .toString(),
        "type": room.roomType,
      },
    );
    return response;
  }

  Future<bool> deleteRoom(RoomItemsModel room) async {
    final response = await dio.delete(
      "room/${room.roomId}",
    );
    return response.statusCode == 200;
  }

  Future<Response> callAddIotDeviceApi(Map<String, dynamic> map) async {
    final response = await dio.post(
      "smart/device/add",
      data: map,
    );
    return response;
  }

  Future<Response> switchBotRsync(Map<String, dynamic> map) async {
    final response = await dio.post(
      "smart/device/switchbot/resync",
      data: map,
    );
    return response;
  }

  Future<bool> updateDoorbellSchedule({
    String? deviceId,
    required DateTime time,
  }) async {
    final response = await dio.put(
      "ota/doorbell/schedule/$deviceId",
      data: {"schedule": time.toString().split(".").first},
    );
    return response.statusCode == 200;
  }

  Future editCameraPlacement(String? selectedFormPosition, int id) async {
    final response = await dio.put(
      "smart/device/camera/placement/$id",
      data: {
        "placement": selectedFormPosition,
      },
    );
    return response.statusCode == 200;
  }
}

final apiService = _ApiService();

class TestApiService extends _ApiService {}
