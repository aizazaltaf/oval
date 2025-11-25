import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/country_codes_translated.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/pages/main/dashboard/components/subscription_dialog.dart';
import 'package:admin/pages/main/device_onboarding/bluetooth_scan_page.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/subscription/components/restrictions_dialog.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/components/blur_overlay_live_stream.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:admin/widgets/smooth_memory_image.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

final _logger = Logger('common_functions.dart');

mixin CommonFunctions {
  static int daysBetween(DateTime from, DateTime to) {
    return (to.difference(from).inHours / 24).round();
  }

  static bool isMoveAble(String input) {
    return input.contains("ptz_down") ||
        input.contains("ptz_right") ||
        input.contains("ptz_left") ||
        input.contains("ptz_up");
  }

  static bool left(String input) {
    return input.contains("ptz_left");
  }

  static bool right(String input) {
    return input.contains("ptz_right");
  }

  static bool up(String input) {
    return input.contains("ptz_up");
  }

  static bool down(String input) {
    return input.contains("ptz_down");
  }

  static bool containsAnyFromList(String input) {
    for (final value in Constants.allowedEntityIds) {
      if (input.contains(value)) {
        return true;
      }
    }
    return false;
  }

  static Map<String, dynamic> colorMap = {
    "Ocean": ["#2865E9", "#20BD2F"],
    "Romance": ["#CC4DA4", "#710EA2"],
    "Sunset": ["#E7F753", "#E9886E"],
    "Party": [
      "#A90F12",
      "#E222E8",
      "#DCE991",
      "#2DF6E8",
      "#F92222",
    ],
    "Fireplace": ["#E91519", "#F3D13E"],
    "Cozy": ["#EF6627", "#D2B618"],
    "Forest": ["#19A427", "#0F990F", "#06480C"],
    "Pastel Colors": [
      "#E4E912",
      "#E4E912BF",
      "#E4E91280",
      "#E4E91240",
      "#E4E91200",
    ],
    "Wake up": [
      "#EBA3E1",
      "#EBA3E1BF",
      "#EBA3E180",
      "#EBA3E140",
      "#EBA3E100",
    ],
    "Bedtime": [
      "#CDE68B",
      "#795526",
      "#F1FD6A",
    ],
    "Warm White": "#FCE61C",
    "Daylight": "#F2F9A3",
    "Cool white": "#FFFFFF",
    "Night light": [
      "#F7EAEA",
      "#E2DEDE",
      "#FFFFFF",
    ],
    "Focus": "#EBE5E5",
    "Relax": "#FFD3D3",
    "True colors": [
      "#D5DB5D",
      "#FCAD0F",
    ],
    "TV time": [
      "#1929D8",
      "#F3AAE0",
    ],
    "Plantgrowth": [
      "#7F077D",
      "#612778",
    ],
    "Spring": ["#50B9EE", "#7DFFFF"],
    "Summer": ["#E7F753", "#C5DA0E"],
    "Fall": ["#B29864", "#FFBF49"],
    "Deepdive": "#4514F8",
    "Jungle": ["#8EF281", "#8EF281CC"],
    "Mojito": [
      "#19A427",
      "#67B46B",
      "#81CF81",
      "#FEEFEF",
    ],
    "Club": [
      "#FEEFEF",
      "#F77A14BF",
      "#F77A1480",
      "#F77A1440",
      "#F77A1440",
    ],
    "Christmas": [
      "#024311",
      "#024311BF",
      "#02431180",
      "#02431140",
      "#02431140",
    ],
    "Halloween": [
      "#F4D210",
      "#F4D210BF",
      "#00000080",
    ],
    "Candlelight": [
      "#EF1C0D",
      "#EF1C0DBF",
      "#EF1C0D80",
      "#EF1C0D40",
      "#EF1C0D00",
    ],
    "Golden white": "#FEC005",
    "Pulse": ["#F7EF05", "#F7EF0580"],
    // "Colorloop": ["#F7EF05", "#F7EF0580"],
  };

  static Color _hexToColor(String hex) {
    final formattedHex = hex.replaceFirst('#', '');
    final fullHex = formattedHex.length == 6 ? 'FF$formattedHex' : formattedHex;

    return Color(int.parse(fullHex, radix: 16));
  }

  static dynamic getColorByKey(String key) {
    if (colorMap.containsKey(key)) {
      if (colorMap[key]! is List) {
        final List<Color> list =
            List.generate(colorMap[key].length, (i) => Colors.transparent);
        for (int i = 0; i < colorMap[key].length; i++) {
          list[i] = _hexToColor(colorMap[key][i]!);
        }
        return list;
      }
      return _hexToColor(colorMap[key]!);
    } else {
      // return _getRandomColor();
      return const Color.fromARGB(0, 0, 0, 0);
    }
  }

  static Widget videoCallTopWidget(BuildContext context, String visitorName) {
    final statusTextStyle = Theme.of(context).textTheme.displayMedium;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 50),
        width: 100.w,
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              visitorName.toLowerCase().contains("someone")
                  ? "Unknown Visitor"
                  : visitorName,
              style: TextStyle(
                color: CommonFunctions.getThemeBasedWidgetColor(context),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            VoipBlocSelector.callValue(
              builder: (callValue) {
                if (callValue != null) {
                  return Text(
                    "Doorbell is busy",
                    style: statusTextStyle,
                    textAlign: TextAlign.start,
                  );
                }
                return VoipBlocSelector.remoteRenderer(
                  builder: (remoteRenderer) {
                    if (remoteRenderer == null) {
                      return Text(
                        "Connecting..",
                        style: statusTextStyle,
                        textAlign: TextAlign.start,
                      );
                    }
                    return VoipBlocSelector.seconds(
                      builder: (seconds) {
                        return VoipBlocSelector.isCallConnected(
                          builder: (isCallConnected) {
                            return VoipBlocSelector.isReconnecting(
                              builder: (isReconnecting) {
                                if (isReconnecting) {
                                  return Text(
                                    "Reconnecting...",
                                    style: statusTextStyle,
                                    textAlign: TextAlign.start,
                                  );
                                } else if (seconds == 0) {
                                  return Text(
                                    isCallConnected
                                        ? "Connected"
                                        : "Connecting..",
                                    style: statusTextStyle,
                                    textAlign: TextAlign.start,
                                  );
                                } else if (!remoteRenderer.value.renderVideo) {
                                  return Text(
                                    "Connecting..",
                                    style: statusTextStyle,
                                    textAlign: TextAlign.start,
                                  );
                                }
                                return Text(
                                  CommonFunctions.formatAudioVisualiserTime(
                                    seconds,
                                  ),
                                  style: statusTextStyle,
                                  textAlign: TextAlign.start,
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static bool isVideoTheme(String path) {
    if (path.isEmpty) {
      return false;
    }
    return path.endsWith('.mp4') ||
        path.endsWith('.avi') ||
        path.endsWith('.mov') ||
        path.contains('.mp4') ||
        path.contains('.avi') ||
        path.contains('.mov');
  }

  static void addOrShopDialog(mainContext) {
    showDialog<void>(
      context: mainContext,
      builder: (context) {
        return AppDialogPopup(
          title: context.appLocalizations.shop_doorbell,
          description: context.appLocalizations.purchase_doorbell,
          confirmButtonLabel: context.appLocalizations.shop_doorbell,
          confirmButtonOnTap: () {
            Navigator.of(context).pop('dialog');
            CommonFunctions.openUrl(Constants.shopDoorbellMoreUrl);
          },
          cancelButtonLabel: context.appLocalizations.add_doorbell,
          cancelButtonOnTap: () {
            Navigator.of(context).pop('dialog');
            // unawaited(ScanDoorbell.push(mainContext));
            unawaited(BluetoothScanPage.push(mainContext));
          },
        );
      },
    );
  }

  static BuiltList<IotDeviceModel> getIotFilteredList(
    BuiltList<IotDeviceModel>? list,
  ) {
    if (list == null || list.isEmpty) {
      return const <IotDeviceModel>[].toBuiltList();
    }
    final List<IotDeviceModel> iotList = list
        .where(
          (x) =>
              !(x.entityId!.isCamera() ||
                  x.entityId!.isThermostat() ||
                  x.entityId!.isHub() ||
                  x.entityId!.isSwitchBot()) &&
              // singletonBloc.profileBloc.state!.locationId.toString() ==
              singletonBloc.profileBloc.state?.selectedDoorBell?.locationId
                      .toString() ==
                  x.locationId.toString(),
        )
        .toList()
      ..sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return iotList.toBuiltList();
  }

  static String formatAudioVisualiserTime(
    int time, {
    bool inSeconds = true,
  }) {
    final int time_ = inSeconds ? time : (time / 1000).floor();
    final int hours = (time_ ~/ 3600) % 24;
    final int minutes = (time_ ~/ 60) % 60;
    final int remainingSeconds = time_ % 60;
    final String hoursStr = hours.toString().padLeft(2, '0');
    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$hoursStr:$minutesStr:$secondsStr';
  }

  static Widget noStreamView(
    context, {
    required String title,
    String? icon,
    String? image,
    String? description,
    String? redirection,
    double? titleSize,
  }) =>
      BlurOverlayLiveStream(
        background: image == null
            ? null
            : CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.fill,
              ),
        overlay: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).cupertinoOverrideTheme!.barBackgroundColor!,
                  BlendMode.srcIn,
                ),
              ),
            if (icon != null) const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context)
                    .cupertinoOverrideTheme!
                    .barBackgroundColor,
                fontSize: titleSize ?? 18.0,
              ),
            ),
            const SizedBox(height: 6),
            if (description != null)
              Text(
                description,
                style: TextStyle(
                  color: AppColors.darkPrimaryColor,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.darkPrimaryColor,
                ),
              ),
          ],
        ),
      );

  static String getDialCode(String number) {
    for (final country in translatedCodes) {
      if (number.startsWith(country["dial_code"]!)) {
        return country["dial_code"]!;
      }
    }
    return "US";
  }

  static Widget noSearchRecord(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30.h),
      alignment: Alignment.center,
      child: Text(
        context.appLocalizations.no_records_available_for_this_search,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: CommonFunctions.getThemeBasedWidgetColor(context),
              fontSize: 16,
            ),
      ),
    );
  }

  static Widget guideTitle(String title) {
    return Text(
      title,
      maxLines: 5,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static Widget guideDescription(String description) {
    return Text(
      description,
      maxLines: 8,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  static Widget loadingStreamVideo(
    context, {
    required String title,
    String? image,
    Uint8List? imageValue,
  }) =>
      AspectRatio(
        aspectRatio: 2 / 1.2,
        child: BlurOverlayLiveStream(
          background: imageValue == null
              ? image == null
                  ? null
                  : CachedNetworkImage(
                      imageUrl: image,
                      useOldImageOnUrlChange: true,
                      fit: BoxFit.fill,
                      errorWidget: (context, exception, stackTrace) {
                        return Image.asset(
                          DefaultImages.FRONT_CAMERA_THUMBNAIL,
                          fit: BoxFit.cover,
                          width: 100.w,
                          height: 205,
                        );
                      },
                    )
              : SmoothMemoryImage(newImageBytes: imageValue),
          overlay: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PrimaryCircularLoading(),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context)
                      .cupertinoOverrideTheme!
                      .barBackgroundColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );

  static void showRestrictionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return RestrictionsDialog(dialogContext: dialogContext);
      },
    );
  }

  static bool isSubscriptionExpiredDialogShown = false;

  static void showSubscriptionExpiredDialog(BuildContext context) {
    final subscription = singletonBloc.profileBloc.state?.locations
        ?.where(
          (e) =>
              e.id ==
              singletonBloc.profileBloc.state?.selectedDoorBell?.locationId,
        )
        .first
        .subscription;
    final planExpired =
        CommonFunctions.isExpired(subscription?.expiresAt ?? "");
    final planCancelled = subscription?.subscriptionStatus == "canceled";
    if (subscription == null || (!planExpired && !planCancelled)) {
      return;
    }
    if (isSubscriptionExpiredDialogShown) {
      return;
    }
    isSubscriptionExpiredDialogShown = true;
    showDialog(
      context: context,
      barrierDismissible: false, // prevents tap outside to dismiss
      builder: (dialogContext) {
        return BlocProvider.value(
          value: VisitorManagementBloc.of(context),
          child: BlocProvider.value(
            value: NotificationBloc.of(context),
            child: PopScope(
              canPop: false,
              child: SubscriptionDialog(
                subscription: subscription,
                dialogContext: dialogContext,
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      isSubscriptionExpiredDialogShown = false;
    });
  }

  static bool isNoInternetConnectionDialogShown = false;

  static void showNoInternetConnectionDialog(BuildContext context) {
    if (isNoInternetConnectionDialogShown) {
      return;
    }
    isNoInternetConnectionDialogShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AppDialogPopup(
            needCross: false,
            headerWidget: SvgPicture.asset(
              DefaultImages.TRI_WARNING_IMAGE,
            ),
            title: context.appLocalizations.no_internet_connection,
            description:
                context.appLocalizations.no_internet_connection_dialog_desc,
            confirmButtonLabel: context.appLocalizations.general_okay,
            confirmButtonOnTap: () => Navigator.pop(dialogContext),
          );
        },
      ).whenComplete(() {
        isNoInternetConnectionDialogShown = false;
      });
    });
  }

  static PreferredSizeWidget noInternetBar(
    BuildContext context, {
    bool needShowNoInternetBar = true,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(0), // adjust height as needed
      child: needShowNoInternetBar
          ? StartupBlocSelector.isInternetConnected(
              builder: (isInternetConnected) {
                if (!isInternetConnected) {
                  return Container(
                    width: 100.w,
                    color: const Color.fromRGBO(77, 119, 135, 1),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cancel_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "No internet connection.",
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            )
          : const SizedBox.shrink(),
    );
  }

  /// Returns true if the given timestamp has already expired
  static bool isExpired(String timestampUtc) {
    final expiry = DateTime.parse(timestampUtc).toLocal();
    return DateTime.now().isAfter(expiry);
  }

  static String timeFormation(DateTime inputDate) {
    // Convert to local timezone
    final DateTime localTime = inputDate.toLocal();

    // Format date to "Month-Day Hour:Minute AM/PM" without seconds
    final String formattedDate = DateFormat('h:mm a').format(localTime);
    return formattedDate.toLowerCase();
  }

  static String formatDateForApi(DateTime date, {String? dateFormat}) {
    // Use DateFormat from intl package to format the date
    final DateFormat formatter = DateFormat(dateFormat ?? 'dd-MM-yyyy');
    return formatter.format(date);
  }

  static String monthDateFormat(DateTime date, {String? dateFormat}) {
    // Use DateFormat from intl package to format the date
    final DateFormat formatter = DateFormat(dateFormat ?? 'MM-dd-yyyy');
    return formatter.format(date);
  }

  static Future<void> openUrl(String url) async {
    try {
      // Validate URL format
      final uri = Uri.parse(url);
      // Use external application mode to avoid Safari View Controller issues
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _logger.severe('Could not launch $url');
      }
    } catch (e) {
      _logger.severe('Error launching URL $url: $e');
    }
  }

  static Color searchTextFieldWidgetColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBlueColor.withValues(alpha: 0.6)
        : const Color(0xff9EA0A4);
  }

  static Color getThemeBasedWidgetColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBlueColor
        : Colors.white;
  }

  static Color getThemeBasedWidgetColorInverted(BuildContext context) {
    return Theme.of(context).brightness != Brightness.light
        ? AppColors.darkBlueColor
        : Colors.white;
  }

  static Color getTabSelectedColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBluePrimaryColor
        : Colors.white;
  }

  static Color getThemeBasedPrimaryWhiteColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBluePrimaryColor
        : Colors.white;
  }

  static Color getDialogDescriptionColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.descriptionGreyColor
        : Colors.white;
  }

  static Color getThemeWidgetColor(BuildContext context) {
    return Theme.of(context).brightness != Brightness.light
        ? AppColors.darkBlueColor
        : Colors.white;
  }

  static Color getTabLineColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.cancelButtonColor
        : Colors.white;
  }

  static Future<File> compressFile(File file) async {
    // Get the original file size
    final originalFileSize = await file.length();
    _logger.fine('Original file size: ${originalFileSize / 1024} KB');

    // Get the directory to save the compressed file
    final dir = await getTemporaryDirectory();
    final targetPath =
        path.join(dir.path, 'compressed_${path.basename(file.path)}');

    // Perform the file compression
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 40, // You can adjust the quality parameter
    );

    // Get the compressed file size
    if (result != null) {
      final compressedFileSize = await result.length();
      _logger.fine('Compressed file size: ${compressedFileSize / 1024} KB');
    } else {
      _logger.fine('Compression failed.');
    }

    return result?.path == null ? file : File(result!.path);
  }

  static List<DateTime> getWeekStartAndEndDatesList(String dateString) {
    // Parse the input date string
    try {
      final DateFormat inputFormat = DateFormat("dd-MM-yyyy");

      final DateTime givenDate = inputFormat.parse(dateString);

      // Calculate the start of the week (Monday)
      final DateTime startOfWeek =
          givenDate.subtract(Duration(days: givenDate.weekday - 1));

      // Calculate the end of the week (Sunday)
      final DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

      return [startOfWeek, endOfWeek];
    } catch (e) {
      return [DateTime.now()];
    }
  }

  static DateTime getDateTime({
    required String dateString,
    String? dateFormat,
  }) {
    final DateFormat format = DateFormat(dateFormat ?? "dd-MM-yyyy");
    final DateTime dateTime = format.parse(dateString);
    return dateTime;
  }

  static String getWeekStartAndEndDates(String dateString) {
    // Parse the input date string
    try {
      final DateFormat inputFormat = DateFormat("dd-MM-yyyy");
      final DateFormat outputFormat = DateFormat("MM-dd-yyyy");

      final DateTime givenDate = inputFormat.parse(dateString);

      // Calculate the start of the week (Monday)
      final DateTime startOfWeek =
          givenDate.subtract(Duration(days: givenDate.weekday - 1));

      // Calculate the end of the week (Sunday)
      final DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

      // Format the output as strings
      final String startOfWeekString = outputFormat.format(startOfWeek);
      final String endOfWeekString = outputFormat.format(endOfWeek);

      return "$startOfWeekString to $endOfWeekString";
    } catch (e) {
      return dateString;
    }
  }

  static Widget defaultErrorWidget({
    required BuildContext context,
    required String message,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 5),
        const Icon(Icons.error_outline, color: Colors.red, size: 18),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  static int getRoleId(String role) {
    if (role == "Admin") {
      return 3;
    } else if (role == "Viewer") {
      return 4;
    } else {
      return 2;
    }
  }

  static Widget noSamples(BuildContext context, {String? text}) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 20,
      ),
      child: Center(
        child: Text(
          text ?? context.appLocalizations.no_samples,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
        ),
      ),
    );
  }

  static Color getThemeBasedPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;
  }

  static Color getThemePrimaryLightWhiteColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Theme.of(context).primaryColorLight;
  }

  static Color getReverseThemeBasedWidgetColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkBlueColor
        : Colors.white;
  }

  static Future<String> getTimeZone() async {
    const url =
        "https://api.getgeoapi.com/v2/ip/check?api_key=d40c24674dde13b3c402cd73e880330d5a8f5102";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['time']['timezone'];
    } else {
      String timeZone = "";
      tz_data.initializeTimeZones(); // This initializes the timezone database
      final currentLocation = tz.timeZoneDatabase.locations;

      final currentLocations = DateTime.now().toLocal().timeZoneName;
      final tzOffset = DateTime.now().toLocal().timeZoneOffset.inMilliseconds;
      for (int i = 0; i < currentLocation.values.length; i++) {
        for (int j = 0;
            j < currentLocation.values.elementAt(i).zones.length;
            j++) {
          if (currentLocation.values
                  .elementAt(i)
                  .zones
                  .elementAt(j)
                  .abbreviation
                  .contains(currentLocations) &&
              currentLocation.values.elementAt(i).zones.elementAt(j).offset ==
                  tzOffset) {
            timeZone = currentLocation.values.elementAt(i).name;
          }
        }
      }
      return timeZone;
    }
  }

  static String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length <= 3) {
      return phoneNumber; // Return as is if too short
    }

    final String maskedPart = '*' * (phoneNumber.length - 3);
    final String visiblePart = phoneNumber.substring(phoneNumber.length - 3);

    return '$maskedPart$visiblePart';
  }

  static String maskEmail(String email) {
    final List<String> parts = email.split('@');
    if (parts.length != 2) {
      return email; // Return original if not a valid email
    }

    final String username = parts[0];
    final String domain = parts[1];

    int visibleChars;
    if (username.length > 6) {
      visibleChars = 4;
    } else if (username.length > 4) {
      visibleChars = 3;
    } else {
      visibleChars = 2;
    }

    final String maskedPart = '*' * (username.length - visibleChars);
    return '${username.substring(0, visibleChars)}$maskedPart@$domain';
  }

  static bool isValidDateFormat(String dateString) {
    final pattern = RegExp(
      r'^[0-9]{4}-[0-1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]$',
    );
    return pattern.hasMatch(dateString);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now().toLocal();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final now = DateTime.now().toLocal();
    final yesterday = now.subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  static String getMonthDate({
    required String lastVisitDateTime,
    String? dateFormat,
  }) {
    DateTime visitDate;
    visitDate = DateTime.parse(lastVisitDateTime).toLocal();

    return DateFormat(dateFormat ?? 'dd MMMM, y').format(
      visitDate,
    );
  }

  static String getTimeAmPm({
    required String lastVisitDateTime,
    String? dateFormat,
  }) {
    DateTime visitDate;
    visitDate = DateTime.parse(lastVisitDateTime).toLocal();

    return DateFormat(dateFormat ?? 'h:mm a').format(
      visitDate,
    );
  }

  static String getDayNameFromDate({
    required String lastVisitDateTime,
    String? dateFormat,
  }) {
    DateTime visitDate;
    visitDate = DateTime.parse(lastVisitDateTime).toLocal();

    final DateTime now = DateTime.now().toLocal();
    final differenceInDays = now.difference(visitDate);

    if (differenceInDays.inDays <= 7) {
      if (isToday(visitDate)) {
        return "Today";
      } else if (isYesterday(visitDate)) {
        return "Yesterday";
      }
    }
    return DateFormat(dateFormat ?? "EEEE").format(
      visitDate,
    );
  }

  static String getPerfectTime({
    required String lastVisitDateTime,
    bool needLastVisit = true,
  }) {
    DateTime visitDate;
    visitDate = DateTime.parse(lastVisitDateTime).toLocal();

    final DateTime now = DateTime.now().toLocal();
    final differenceInDays = now.difference(visitDate);

    final String time = DateFormat('h:mm a').format(visitDate);

    if (differenceInDays.inDays <= 7) {
      // Use weekday format for visits within a week
      if (isToday(visitDate)) {
        return '${needLastVisit ? "Last visit on " : ""}Today | $time';
      } else if (isYesterday(visitDate)) {
        return '${needLastVisit ? "Last visit on " : ""}Yesterday | $time';
      } else {
        // return 'Last visit on ${DateFormat('EEEE').format(visitDate)} @ $time';
        return '${needLastVisit ? "Last visit on " : ""}${DateFormat('MM-dd-yyyy').format(
          visitDate,
        )} | $time';
      }
    } else {
      return '${needLastVisit ? "Last visit on " : ""}${DateFormat('MM-dd-yyyy').format(
        visitDate,
      )} | $time';
    }
  }

  static String formatDateToLocal(String dateTimeString, {String? dateFormat}) {
    final DateTime utcDate = DateTime.parse(dateTimeString).toLocal();
    return DateFormat(dateFormat ?? "d MMM yyyy").format(utcDate);
  }

  static String formatTimeToLocal(String dateTimeString, {String? timeFormat}) {
    final DateTime utcDate = DateTime.parse(dateTimeString).toLocal();
    return DateFormat(timeFormat ?? "HH:mm").format(utcDate);
  }

  static Future<String?>? getDeviceToken() async {
    String? token;
    try {
      token = await Pushy.register();
      _logger.fine("Pushy Token $token");
    } catch (e) {
      _logger.severe(e);
      token = "0";
    }
    return token;
  }

  static Future<void> updateLocationData(BuildContext context) async {
    // all blocs initialized
    final iotBloc = IotBloc.of(context);
    final notificationBloc = NotificationBloc.of(context);
    final startupBloc = StartupBloc.of(context);
    final visitorBloc = VisitorManagementBloc.of(context);

    // iot room call
    unawaited(iotBloc.callIotRoomsApi(needLoaderDismiss: false));

    // wait for iotDevices api call
    await iotBloc.callIotApi(needLoaderDismiss: false);
    await iotBloc.socketListener();

    // dashboard loading false
    unawaited(
      Future.delayed(const Duration(seconds: 3), () {
        startupBloc.updateDashboardApiCalling(false);
      }),
    );

    // rest api calls
    await notificationBloc.callStatusApi();
    await visitorBloc.initialCall(isRefresh: true);
    await notificationBloc.callNotificationApi(refresh: true);
    notificationBloc.updateFilter(false);
    visitorBloc.updateVisitorNewNotification(false);
  }

  static Future<String> getDeviceModel() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String customUserAgent = '';
    // if (Platform.isAndroid) {
    //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //   customUserAgent += androidInfo.device;
    // } else if (Platform.isIOS) {
    //   IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //   customUserAgent += iosInfo.utsname.machine;
    // }
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      customUserAgent =
          "${androidInfo.id}.${await getDeviceToken()}"; // Unique hardware ID
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      customUserAgent = iosInfo.identifierForVendor ??
          "unknown_ios_id"; // Unique per app install
    } else {
      throw Exception("Unsupported Platform");
    }
    return customUserAgent;
  }

  static Future<String> getDeviceName() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String customName = '';
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      customName = "${androidInfo.brand} ${androidInfo.device}";
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      customName = iosInfo.modelName;
    } else {
      _logger.fine("Unsupported Device");
    }
    return customName;
  }

  static DateTime formattedDate(String time) {
    final String dateString = time;
    final DateTime dateTime = DateTime.parse(
      DateFormat("MM-dd-yyyy HH:mm:ss").parse(dateString).toString(),
    );

    return dateTime;
  }

  static Future<String> getUUID() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor.toString();
    }
    return "";
  }

  // static Future<String> getTz() async {
  //   try {
  //     final ipAddress = ip.IpAddress(type: ip.RequestType.json);
  //
  //     /// Get the IpAddress based on requestType.
  //     final dynamic data = await ipAddress.getIpAddress();
  //
  //     final dio = Dio();
  //     final response = await dio.request(
  //       'http://ip-api.com/json/${data["ip"]}',
  //       options: Options(
  //         method: 'GET',
  //       ),
  //     );
  //     String timeZone = "";
  //     if (response.statusCode == 200) {
  //       timeZone = response.data["timezone"];
  //     }
  //     // print(timeZone);
  //     return timeZone;
  //   } on ip.IpAddressException catch (exception) {
  //     throw Exception(exception.message);
  //   } on DioException catch (exception) {
  //     throw Exception(exception.message);
  //   }
  // }

  static Future<String> getTz() async {
    try {
      final response = await http.get(Uri.parse('https://ipwho.is/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['timezone']['id'];
      } else {
        return "Asia/Karachi";
      }
    } catch (e) {
      return "Asia/Karachi";
    }
  }
}
