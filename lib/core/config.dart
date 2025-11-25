import 'package:admin/models/enums/environment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class _Config {
  String get appName => dotenv.env['APP_NAME'] ?? "";

  String get apiUrl => dotenv.env['BASE_URL_V2'] ?? "";

  String get ovalChatUrl => dotenv.env['OVAL_CHAT_URL'] ?? "";

  String get envUrl => dotenv.env['ENV_URL'] ?? "";

  String get accountsUrl => dotenv.env['ACCOUNTS_URL'] ?? "";

  String get iotAttributesUrl => dotenv.env['IOT_ATTRIBUTE_URL'] ?? "";

  String get aiServerUrl => dotenv.env['AI_SERVER_URL_NEW'] ?? "";

  String get key => dotenv.env['KEY'] ?? "";

  String get openApiKey => dotenv.env['OPEN_AI_WHISPER_KEY'] ?? "";

  // String get secret => dotenv.env['SECRET']??"";

  // String get imageBaseUrl => dotenv.env['ASSETS_BASE_URL']??"";

  String get socketUrl => dotenv.env['SOCKET_URL'] ?? "";

  String get pushyKey => dotenv.env['PUSHY_KEY'] ?? "";

  String get whepUrl => dotenv.env['WHEP_URL'] ?? "";

  String get streamingGatewayPath => dotenv.env['STREAMING_GATEWAY_PATH'] ?? "";

  String get iceServerUrl => dotenv.env['ICE_SERVER_URL'] ?? "";

  String get bugFenderUrl => dotenv.env['BUGFENDER_KEY'] ?? "";

  String get accessKey => dotenv.env['AWS_ACCESS_KEY_ID'] ?? "";

  String get s3BucketUrl => dotenv.env['S3_BUCKET_URL'] ?? "";

  String get secretKey => dotenv.env['AWS_SECRET_ACCESS_KEY'] ?? "";

  String get region => dotenv.env['AWS_DEFAULT_REGION'] ?? "";

  String get endPoint => dotenv.env['AWS_END_POINT'] ?? "";

  String get bucket => dotenv.env['AWS_BUCKET'] ?? "";

  String get iceServerId => dotenv.env['ICE_SERVER_ID'] ?? "";

  String get iceServerKey => dotenv.env['ICE_SERVER_KEY'] ?? "";

  String get webSocketUrl => dotenv.env['WEB_SOCKET_URL'] ?? "";

  String get themeBucketUrl => dotenv.env['THEME_BUCKET'] ?? "";

  String get s3ThemeBucketUrl => dotenv.env['S3_THEME_BUCKET_URL'] ?? "";

  // String get rapidKey => dotenv.env['RAPID_KEY']??"";

  static Environment? _environment;

  Environment get environment {
    if (_environment == null) {
      _initEnvironment();
    }
    return _environment ?? Environment.develop;
  }

  void _initEnvironment() {
    // First try to get from compile-time environment
    const String compileTimeEnv = String.fromEnvironment('DART_ENV');
    if (compileTimeEnv.isNotEmpty) {
      _environment = Environment.valueOf(compileTimeEnv);
      return;
    }

    // Fallback to default
    _environment = Environment.develop;
  }

  final String defaultLanguageCode = 'en';
}

final config = _Config();
