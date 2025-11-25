import 'dart:convert';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/models/data/api_meta_data.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/components/step_indicator.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/app_drop_down_button.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class AddDeviceForm extends StatefulWidget {
  const AddDeviceForm._();

  static const routeName = 'addDeviceForm';
  static bool? fromAddManuallyScreen;
  static bool? fromCameraScreen;
  static Function? onSuccessScreen;

  static void _defaultOnSuccess() {
    debugPrint("onSuccess called with default implementation.");
  }

  static Future<void> push(
    final BuildContext context, {
    bool fromCamera = false,
    fromAddManually = false,
    Function()? onSuccess = _defaultOnSuccess,
  }) {
    fromAddManuallyScreen = fromAddManually;
    fromCameraScreen = fromCamera;
    onSuccessScreen = onSuccess;
    IotBloc.of(context)
      ..resetCreateState()
      ..updateCurrentFormStep(1);
    return showModalBottomSheet(
      showDragHandle: true,
      isDismissible: false,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            30,
          ),
          topRight: Radius.circular(
            30,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,

      // backgroundColor: CommonFunctions.getReverseThemeBasedWidgetColor(
      //   context,
      // ),
      elevation: 8,
      context: context,
      builder: (_) => const AddDeviceForm._(),
    ).whenComplete(() {
      if (context.mounted) {
        final bloc = IotBloc.of(context);

        if (Constants.brandMap[bloc.state.formDevice?.brand] == 3 &&
            bloc.state.currentFormStep! > 1) {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return AppDialogPopup(
                headerWidget: Image.asset(
                  DefaultImages.WARNING_IMAGE,
                  height: 60,
                  width: 60,
                ),
                title: context.appLocalizations.warning,
                needCross: false,
                description: context.appLocalizations.quit_process,
                confirmButtonLabel: context.appLocalizations.quit,
                cancelButtonLabel: context.appLocalizations.general_cancel,
                cancelButtonOnTap: () {
                  Navigator.pop(dialogContext);
                  final step = bloc.state.currentFormStep;
                  push(
                    context,
                    fromCamera: fromCamera,
                    fromAddManually: fromAddManually,
                    onSuccess: onSuccess,
                  );
                  bloc.updateCurrentFormStep(step);
                },
                confirmButtonOnTap: () {
                  Navigator.pop(dialogContext);
                  // unawaited(ScanDoorbell.push(context));
                  // BluetoothScanPage.push(context);
                  IotBloc.of(context).resetCreateState();
                  // Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 500), () {
                    bloc.updateCurrentFormStep(null);
                  });
                },
              );
            },
          );
        } else {
          IotBloc.of(context).resetCreateState();
        }
      }
    });
    // return pushMaterialPageRoute(
    //   context,
    //   name: routeName,
    //   builder: (final _) => const AddDeviceForm._(),
    // );
  }

  static void pushReplacement(
    final BuildContext context, {
    fromAddManually = false,
  }) {
    fromAddManuallyScreen = fromAddManually;
    fromCameraScreen = false;
    IotBloc.of(context).updateCurrentFormStep(2);
    Constants.dismissLoader();

    // return pushReplacementMaterialPageRoute(
    //   context,
    //   name: routeName,
    //   builder: (final _) => const AddDeviceForm._(),
    // );
  }

  @override
  State<AddDeviceForm> createState() => _AddDeviceFormState();
}

class _AddDeviceFormState extends State<AddDeviceForm> {
  final TextEditingController deviceName = TextEditingController();
  Map<String, TextEditingController> _controllers = {};
  Map<String, dynamic> _formData = {};
  final _formKey = GlobalKey<FormState>();
  List<dynamic>? _schema;
  Map<String, dynamic>? _mainData;
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = IotBloc.of(context);
      if (bloc.state.formDevice?.brand?.isWyze() ?? false) {
        videoController = VideoPlayerController.networkUrl(
          Uri.parse(
            "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
          ),
          // viewType: VideoViewType.textureView,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
        videoController!.initialize().then((_) => setState(() {}));
        // videoController!.play();
      }
      _controllers = {};
      _formData = {};
      _mainData = null;
      _mainData = jsonDecode(
        bloc.state.newFormData ??
            bloc.state.getDeviceConfigResponse.data!["data"],
      );
      _schema = null;
      _schema = _mainData!["data_schema"] is String
          ? jsonDecode(_mainData!["data_schema"])
          : _mainData!["data_schema"];

      deviceName.text = bloc.state.newFormDataDeviceName ?? "";
      bloc.updateSelectedFormPosition("Indoor");
      for (final field in _schema!) {
        final String fieldName = field["name"];
        String? defaultValue = field["default"] is String
            ? (field["default"] ?? "")
            : (field["default"]?.toString() ?? "");

        if (fieldName == "host" && bloc.state.formDevice != null) {
          defaultValue = bloc.state.formDevice!.title;
        }
        if (!_controllers.containsKey(fieldName)) {
          _controllers[fieldName] =
              TextEditingController(text: defaultValue ?? "");
          _formData[fieldName] = defaultValue ?? "";

          // Default password visibility
          if (fieldName.toLowerCase().contains("password")) {
            _formData['${fieldName}_isObscure'] = true;
          }
        }
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    deviceName.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // ScrollController controller = ScrollController();

  List<String> position = ["Indoor", "Outdoor"];
  final Map<String, bool> _obscureStates = {};

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);

    return
        //   AppScaffold(
        //   appTitle:
        //       "Add ${(bloc.state.formDevice?.brand ?? "Not Selected").capitalizeFirstOfEach().replaceAll("_", " ")}",
        //   body: ,
        // );
        Padding(
      padding: EdgeInsets.only(
        // horizontal: 20,
        right: 20,
        left: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: NoGlowListViewWrapper(
          child: IotBlocSelector.currentFormStep(
            builder: (currentForm) => IotBlocSelector(
              selector: (state) =>
                  state.createDeviceResponse.isSocketInProgress ||
                  state.curtainAddAPI.isApiInProgress,
              builder: (isLoading) {
                return IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: 10,
                      children: [
                        if (AddDeviceForm.fromCameraScreen! ||
                            Constants.brandMap[bloc.state.formDevice?.brand] ==
                                1)
                          const SizedBox.shrink()
                        else
                          StepIndicator(
                            currentStep: currentForm ?? 0,
                            totalSteps: Constants
                                    .brandMap[bloc.state.formDevice?.brand] ??
                                2,
                          ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Add ${(bloc.state.formDevice?.brand ?? "Not Selected").capitalizeFirstOfEach().replaceAll("_", " ")}",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (currentForm ==
                                  Constants.brandMap[
                                      bloc.state.formDevice?.brand]) ...[
                                Text(context.appLocalizations.device_name),
                                NameTextFormField(
                                  controller: deviceName,
                                  enabled: AddDeviceForm.fromCameraScreen!
                                      ? true
                                      : !isLoading,
                                  hintText:
                                      "Enter Device Name (eg. ${(bloc.state.formDevice?.brand ?? "Not Selected").capitalizeFirstOfEach()})",
                                  prefix: bloc.state.formDevice!.image
                                          .contains(".png")
                                      ? Image.asset(
                                          bloc.state.formDevice!.image,
                                          color: AppColors.textLightColor,
                                          height: 15,
                                          width: 15,
                                        )
                                      : SvgPicture.asset(
                                          bloc.state.formDevice!.image,
                                          colorFilter: ColorFilter.mode(
                                            AppColors.textLightColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15),
                                  ],
                                  validator: Validators.required(
                                    context.appLocalizations
                                        .device_name_required_error,
                                  ),
                                ),
                                if (bloc.state.getIotBrandsApi.data!.any((e) {
                                  if (e.brand == bloc.state.formDevice?.brand &&
                                      e.type == "camera") {
                                    return true;
                                  }
                                  return false;
                                })) ...[
                                  Text(
                                    context.appLocalizations.select_position,
                                  ),
                                  IotBlocSelector.selectedFormPosition(
                                    builder: (selectedPosition) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          left: 4,
                                          bottom: 5,
                                        ),
                                        child: IgnorePointer(
                                          ignoring:
                                              AddDeviceForm.fromCameraScreen!
                                                  ? true
                                                  : isLoading,
                                          child: AppDropDownButton(
                                            dropDownTextStyle: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                            items: position.toBuiltList(),
                                            selectedValue: selectedPosition ??
                                                position.first,
                                            onChanged:
                                                bloc.updateSelectedFormPosition,
                                            displayDropDownItems: (item) =>
                                                item,
                                            buttonHeight: 6.h,
                                            dropdownRadius: 10,
                                            dropDownWidth: 89.w,
                                            dropDownHeight: 22.h,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                                Text(context.appLocalizations.select_room),
                                IotBlocSelector.selectedFormRoom(
                                  builder: (selectedRoom) {
                                    if (selectedRoom == null) {
                                      if (bloc.state.getIotRoomsApi.data !=
                                          null) {
                                        bloc.updateSelectedFormRoom(
                                          bloc.state.getIotRoomsApi.data!.first,
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        left: 4,
                                        bottom: 5,
                                      ),
                                      child: IgnorePointer(
                                        ignoring:
                                            AddDeviceForm.fromCameraScreen!
                                                ? false
                                                : isLoading,
                                        child: AppDropDownButton(
                                          dropDownTextStyle: Theme.of(context)
                                              .textTheme
                                              .displayMedium,
                                          items:
                                              bloc.state.getIotRoomsApi.data!,
                                          selectedValue: selectedRoom ??
                                              bloc.state.getIotRoomsApi.data
                                                  ?.first,
                                          onChanged:
                                              bloc.updateSelectedFormRoom,
                                          displayDropDownItems: (item) =>
                                              item.roomName!,
                                          buttonHeight: 6.h,
                                          dropdownRadius: 10,
                                          dropDownWidth: 89.w,
                                          dropDownHeight: 22.h,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                              if (_schema != null &&
                                  currentForm !=
                                      Constants.brandMap[
                                          bloc.state.formDevice?.brand]!)
                                for (int index = 0;
                                    index < _schema!.length;
                                    index++) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _schema![index]["name"]
                                            .toString()
                                            .replaceAll("_", " ")
                                            .capitalizeFirstOfEach(),
                                      ),
                                      if (Constants.toolTipText[bloc
                                              .state.formDevice?.brand
                                              ?.toLowerCase()]?[_schema![index]
                                                  ["name"]
                                              .toString()
                                              .toLowerCase()] !=
                                          null)
                                        SuperTooltip(
                                          arrowTipDistance: 24,
                                          arrowLength: 8,
                                          controller: SuperTooltipController(),
                                          arrowTipRadius: 6,
                                          shadowColor: const Color.fromRGBO(
                                            0,
                                            0,
                                            0,
                                            0.1,
                                          ),
                                          backgroundColor: CommonFunctions
                                              .getThemePrimaryLightWhiteColor(
                                            context,
                                          ),
                                          borderColor: CommonFunctions
                                              .getThemeBasedWidgetColor(
                                            context,
                                          ),
                                          popupDirection: TooltipDirection.up,
                                          barrierColor: Colors.transparent,
                                          shadowBlurRadius: 7,
                                          shadowSpreadRadius: 0,
                                          showBarrier: true,
                                          content: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              maxWidth:
                                                  250, // 👈 Adjust to fit your screen or theme
                                            ),
                                            child: IntrinsicWidth(
                                              child: IntrinsicHeight(
                                                child: Text(
                                                  Constants.toolTipText[bloc
                                                              .state
                                                              .formDevice
                                                              ?.brand
                                                              ?.toLowerCase()]?[
                                                          _schema![index]
                                                                  ["name"]
                                                              .toString()
                                                              .toLowerCase()] ??
                                                      "",
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.info_outline,
                                            size: 16,
                                            color: CommonFunctions
                                                .getThemeBasedWidgetColor(
                                              context,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  NameTextFormField(
                                    controller:
                                        _controllers[_schema![index]["name"]],
                                    enabled: (AddDeviceForm
                                                    .fromAddManuallyScreen ==
                                                true ||
                                            (_schema![index]["name"] !=
                                                    "host" ||
                                                _mainData!["host"] == null ||
                                                _controllers[_schema![index]
                                                        ["name"]]!
                                                    .text
                                                    .isEmpty)) &&
                                        !isLoading,
                                    obscure: _schema![index]["name"]
                                            .toString()
                                            .toLowerCase()
                                            .contains("password")
                                        ? (_obscureStates[_schema![index]
                                                ["name"]] ??
                                            true)
                                        : false,
                                    maxLines: 1,
                                    hintText:
                                        "Enter ${_schema![index]["name"].toString().replaceAll("_", " ").capitalizeFirstOfEach()}",
                                    keyboardType:
                                        _schema![index]["type"] == "number"
                                            ? TextInputType.number
                                            : TextInputType.text,
                                    validator: (value) {
                                      final fieldName = _schema![index]["name"];
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "${fieldName.toString().replaceAll("_", " ").capitalizeFirstOfEach()} is required";
                                      } else if (fieldName
                                              .toLowerCase()
                                              .contains("email") &&
                                          !RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                                              .hasMatch(value)) {
                                        return context.appLocalizations
                                            .login_errEmailInvalid;
                                      }
                                      return null;
                                    },
                                    suffix: _schema![index]["name"]
                                            .toString()
                                            .toLowerCase()
                                            .contains("password")
                                        ? IconButton(
                                            icon: Icon(
                                              _obscureStates[_schema![index]
                                                          ["name"]] ??
                                                      true
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureStates[_schema![index]
                                                        ["name"]] =
                                                    !(_obscureStates[
                                                            _schema![index]
                                                                ["name"]] ??
                                                        true);
                                              });
                                            },
                                          )
                                        : null,
                                  ),
                                ],

                              // if (_schema != null)
                              //   for (int index = 0;
                              //       index < _schema!.length;
                              //       index++) ...[
                              //     Text(
                              //       _schema![index]["name"]
                              //           .toString()
                              //           .replaceAll("_", " ")
                              //           .capitalizeFirstOfEach(),
                              //     ),
                              //     StatefulBuilder(
                              //       builder: (context, setState) {
                              //         final fieldName = _schema![index]["name"];
                              //         final isPassword = fieldName
                              //             .toString()
                              //             .toLowerCase()
                              //             .contains("password");
                              //         final obscureKey = '${fieldName}_isObscure';
                              //
                              //         return NameTextFormField(
                              //           controller: _controllers[fieldName],
                              //           enabled: (AddDeviceForm
                              //                           .fromAddManuallyScreen ==
                              //                       true ||
                              //                   (fieldName != "host" ||
                              //                       _mainData!["host"] == null ||
                              //                       _controllers[fieldName]!
                              //                           .text
                              //                           .isEmpty)) &&
                              //               !isLoading,
                              //           obscure: isPassword
                              //               ? (_formData[obscureKey] ?? true)
                              //               : false,
                              //           maxLines: 1,
                              //           hintText:
                              //               "Enter ${fieldName.toString().replaceAll("_", " ").capitalizeFirstOfEach()}",
                              //           keyboardType:
                              //               _schema![index]["type"] == "number"
                              //                   ? TextInputType.number
                              //                   : TextInputType.text,
                              //           validator: (value) {
                              //             if (value == null ||
                              //                 value.trim().isEmpty) {
                              //               return "${fieldName.toString().replaceAll("_", " ").capitalizeFirstOfEach()} is required";
                              //             } else if (fieldName
                              //                     .toLowerCase()
                              //                     .contains("email") &&
                              //                 !RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                              //                     .hasMatch(value)) {
                              //               return context.appLocalizations
                              //                   .login_errEmailInvalid;
                              //             }
                              //             return null;
                              //           },
                              //           suffix: isPassword
                              //               ? IconButton(
                              //                   icon: Icon(
                              //                     _formData[obscureKey] ?? true
                              //                         ? Icons.visibility_off
                              //                         : Icons.visibility,
                              //                   ),
                              //                   onPressed: () {
                              //                     setState(() {
                              //                       _formData[obscureKey] =
                              //                           !(_formData[obscureKey] ??
                              //                               true);
                              //                     });
                              //                   },
                              //                 )
                              //               : null,
                              //         );
                              //       },
                              //     ),
                              //   ],
                              if ((bloc.state.formDevice?.brand?.isWyze() ??
                                      false) &&
                                  currentForm == 1) ...[
                                Text(
                                  "Here is the video to help you out"
                                      .replaceAll("_", " ")
                                      .capitalizeFirstOfEach(),
                                ),
                                if (videoController?.value.isInitialized ??
                                    false)
                                  AspectRatio(
                                    aspectRatio:
                                        videoController!.value.aspectRatio,
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: <Widget>[
                                        VideoPlayer(videoController!),
                                        if (!videoController!.value.isPlaying)
                                          Image.asset(
                                            DefaultImages.WYSE_THUMBNIL,
                                            fit: BoxFit.fill,
                                            scale: 0.1,
                                          ),
                                        _ControlsOverlay(
                                          controller: videoController!,
                                          callBack: () {
                                            setState(() {});
                                          },
                                        ),
                                        VideoProgressIndicator(
                                          videoController!,
                                          allowScrubbing: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                              IotBlocSelector(
                                selector: (state) =>
                                    state.createDeviceResponse.error,
                                builder: (error) {
                                  if (error == null) {
                                    return const SizedBox.shrink();
                                  } else if (error.message == null) {
                                    return const SizedBox.shrink();
                                  }
                                  return Row(
                                    spacing: 10,
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        color: AppColors.red,
                                      ),
                                      Flexible(
                                        child: Text(
                                          error.message ?? "",
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        if ((bloc.state.formDevice?.brand?.isWyze() ?? false) &&
                            currentForm == 1) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomGradientButton(
                              onSubmit: () async {
                                final Uri uri = Uri.parse(
                                  "https://developer-api-console.wyze.com/#/apikey/view",
                                );
                                if (!await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  throw Exception(
                                    "Could not launch https://developer-api-console.wyze.com/#/apikey/view",
                                  );
                                }
                              },
                              label: context.appLocalizations.get_api_key_id,
                            ),
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.only(bottom: 55),
                          child: CustomGradientButton(
                            isLoadingEnabled: isLoading,
                            showCircularLoader: false,
                            onSubmit: () {
                              if (bloc.state.isDeviceAdded) {
                                navigation();
                                if (bloc.state.isDeviceAddedResponse != null) {
                                  ToastUtils.successToast(
                                    bloc.state.isDeviceAddedResponse!,
                                  );
                                }
                              } else if (_formKey.currentState!.validate()) {
                                if ((currentForm! + 1 ==
                                        Constants.brandMap[
                                            bloc.state.formDevice?.brand]) &&
                                    !AddDeviceForm.fromCameraScreen!) {
                                  bloc
                                    ..emit(
                                      bloc.state.rebuild(
                                        (b) => b.createDeviceResponse.error
                                            .replace(ApiMetaData()),
                                      ),
                                    )
                                    ..updateCurrentFormStep(
                                      bloc.state.currentFormStep! + 1,
                                    );
                                  // controller.jumpTo(0);
                                } else if ((_controllers["host"]
                                            ?.text
                                            .isNotEmpty ??
                                        true) &&
                                    _controllers.entries.firstWhereOrNull(
                                          (e) => e.value.text.isEmpty,
                                        ) ==
                                        null) {
                                  if (bloc.state.formDevice?.brand
                                          ?.isSwitchBot() ??
                                      false) {
                                    final token =
                                        _controllers["api_token"]!.text;
                                    final key = _controllers["api_key"]!.text;
                                    bloc.getAndAddDeviceSwitchBot(
                                      token: token,
                                      key: key,
                                      host: _controllers["host"]
                                                  ?.text
                                                  .isNotEmpty ==
                                              true
                                          ? _controllers["host"]?.text
                                          : (_mainData!["host"] ?? ""),
                                      roomId:
                                          bloc.state.selectedFormRoom!.roomId,
                                      onSuccess: () {
                                        bloc
                                          ..callIotApi()
                                          ..updateNewFormDataDeviceName(null);
                                        // Future.delayed(
                                        //   Duration(
                                        //     seconds:
                                        //         Constants.durationRefreshSeconds,
                                        //   ),
                                        //   bloc.withDebounceUpdateWhenDeviceUnreachable,
                                        // );
                                        // ToastUtils.successToast(
                                        //   context.appLocalizations.device_success,
                                        // );
                                        StartupBloc.of(context)
                                            .callEverything();

                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                        AddDeviceForm.onSuccessScreen?.call();

                                        if (AddDeviceForm
                                                .fromAddManuallyScreen ??
                                            false) {
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                      name: deviceName.text,
                                    );
                                  } else {
                                    final Map<String, dynamic> formValues = {
                                      "device_name": deviceName.text,
                                      "user_id":
                                          singletonBloc.profileBloc.state!.id,
                                      "room_id":
                                          bloc.state.selectedFormRoom?.roomId ??
                                              0,
                                      "flow_id": _mainData!["flowid"] ??
                                          _mainData!["flow_id"],
                                      "host": _controllers["host"]
                                                  ?.text
                                                  .isNotEmpty ==
                                              true
                                          ? _controllers["host"]?.text
                                          : (_mainData!["host"] ?? ""),
                                      "brand": bloc.state.formDevice?.brand,
                                      "camera_position":
                                          bloc.state.selectedFormPosition,
                                      "from_camera_form":
                                          AddDeviceForm.fromCameraScreen,
                                    };

                                    for (final entry in _controllers.entries) {
                                      if (entry.key
                                              .toLowerCase()
                                              .contains("email") ||
                                          entry.key
                                              .toLowerCase()
                                              .contains("username")) {
                                        formValues[entry.key] =
                                            entry.value.text.toLowerCase();
                                      } else {
                                        formValues[entry.key] =
                                            entry.value.text;
                                      }
                                    }

                                    bloc.createAddDevice(
                                      map: formValues,
                                      forRing: _initializeForm,
                                      successForm: () {
                                        bloc.updateNewFormDataDeviceName(
                                          deviceName.text,
                                        );
                                        _initializeForm();
                                        AddDeviceForm.pushReplacement(
                                          context,
                                          fromAddManually: AddDeviceForm
                                              .fromAddManuallyScreen,
                                        );
                                      },
                                      success: (data) {
                                        Constants.dismissLoader();
                                        bloc
                                          ..callIotApi()
                                          ..updateNewFormDataDeviceName(null);

                                        ToastUtils.successToast(
                                          data ??
                                              context.appLocalizations
                                                  .device_success,
                                        );
                                        StartupBloc.of(context)
                                            .callEverything();

                                        navigation();
                                        // Future.delayed(
                                        //   Duration(
                                        //     seconds:
                                        //         Constants.durationRefreshSeconds,
                                        //   ),
                                        //   bloc.withDebounceUpdateWhenDeviceUnreachable,
                                        // );
                                      },
                                      onError: () {
                                        if (AddDeviceForm.fromCameraScreen!) {
                                          AddDeviceForm.onSuccessScreen?.call();
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                        } else {
                                          ToastUtils.errorToast(
                                            "Unable to receive the confirmation from the doorbell. Please try again later",
                                          );
                                        }
                                      },
                                    );
                                  }
                                }
                                // else {
                                // controller.jumpTo(0);
                                // }
                              }
                              // else {
                              // controller.jumpTo(0);
                              // }
                            },
                            showPercentage: bloc.state.currentFormStep == 1
                                // &&
                                //     ((bloc.state.formDevice?.brand ?? "")
                                //             .isRing() ||
                                //         (bloc.state.formDevice?.brand ?? "")
                                //             .isAugust())
                                ? false
                                : (bloc.state.formDevice?.brand ?? "").isRing()
                                    ? true
                                    : false,
                            label: context.appLocalizations.add,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void navigation() {
    if (context.mounted) {
      Navigator.pop(context);
    }
    if (!AddDeviceForm.fromCameraScreen!) {
      if (context.mounted) {
        Navigator.pop(context);
      }
    } else {
      AddDeviceForm.onSuccessScreen?.call();
    }
    if (AddDeviceForm.fromAddManuallyScreen ?? false) {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({required this.controller, required this.callBack});

  final VideoPlayerController controller;
  final Function callBack;

  @override
  State<_ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<_ControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: widget.controller.value.isPlaying
              ? const SizedBox.shrink()
              : const ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            widget.controller.value.isPlaying
                ? widget.controller.pause()
                : widget.controller.play();
            setState(() {});
            widget.callBack.call();
          },
        ),
      ],
    );
  }
}
