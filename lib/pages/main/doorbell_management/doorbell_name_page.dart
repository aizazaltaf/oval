import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/dashboard/main_dashboard.dart';
import 'package:admin/pages/main/doorbell_management/bloc/doorbell_management_bloc.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class DoorbellNamePage extends StatelessWidget {
  const DoorbellNamePage._();

  static const routeName = "doorbellNamePage";

  static Future<void> push(
    final BuildContext context,
  ) {
    // a = 41;

    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const DoorbellNamePage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = DoorbellManagementBloc.of(context)
      ..onUpdateDoorbellName("Front Door")
      ..updateCustomDoorbellName("");

    return AppScaffold(
      appTitle: context.appLocalizations.doorbell_name,
      // appBarAction: [
      //   GestureDetector(behavior: HitTestBehavior.opaque,
      //     onTap: () {
      //       ProfileMainPage.push(context);
      //     },
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: CircularProfileImage(
      //         size: 5.5.h,
      //         profileImageUrl: singletonBloc.profileBloc.state?.image,
      //       ),
      //     ),
      //   ),
      // ],
      body: NoGlowListViewWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: DoorbellManagementBlocSelector(
            selector: (state) => state.doorbellNameSaveLoading,
            builder: (isLoading) {
              return Column(
                spacing: 10,
                children: [
                  Expanded(
                    child: Image.asset(
                      DefaultVectors.DOORBELL_NEW_IMAGE_CENTER_VIEW,
                      // height: 3.h,
                    ),
                  ),
                  DoorbellManagementBlocSelector.doorbellName(
                    builder: (name) {
                      return Text(
                        name! +
                            (bloc.state.customDoorbellName.isNotEmpty
                                ? " (${bloc.state.customDoorbellName})"
                                : ""),
                        style: Theme.of(context).textTheme.headlineLarge,
                      );
                    },
                  ),
                  Text(
                    context.appLocalizations.name_doorbell,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  rowName(
                    context,
                    needDisabled: isLoading,
                    tileLeadingText: "A",
                  ),
                  rowName(
                    context,
                    name: "Back Door",
                    needDisabled: isLoading,
                    tileLeadingText: "B",
                  ),
                  rowName(
                    context,
                    name: "Office Door",
                    needDisabled: isLoading,
                    tileLeadingText: "C",
                  ),
                  rowName(
                    context,
                    name: "Custom",
                    needDisabled: isLoading,
                    tileLeadingText: "D",
                  ),
                  // DoorbellManagementBlocSelector(
                  //   selector: (state) => state.doorbellNameSaveLoading,
                  //   builder: (isLoading) {
                  CustomGradientButton(
                    isLoadingEnabled: isLoading,
                    // isButtonEnabled: !isLoading,
                    onSubmit: () {
                      singletonBloc.socketEmitter(
                        roomName: Constants.doorbell,
                        roomId: bloc.state.deviceId,
                        deviceId: bloc.state.deviceId,
                        request: Constants.doorbellName,
                        message: bloc.state.customDoorbellName.isEmpty
                            ? bloc.state.doorbellName
                            : bloc.state.customDoorbellName,
                      );
                      bloc.updateDoorbellNameSaveLoading(true);

                      if (bloc.state.locationName.isNotEmpty &&
                              bloc.state.companyAddress.isNotEmpty

                          ///  Same Location Name check has been removed -> 467
                          // && !singletonBloc.profileBloc.state!.locations!.any(
                          //   (location) =>
                          //       location.name == bloc.state.locationName,
                          // )
                          ) {
                        DoorbellManagementBloc.of(context).callLocation(() {
                          bloc.assignDoorbell(
                            navigationFunction: () async {
                              if (context.mounted) {
                                unawaited(
                                  singletonBloc.socketEmitter(
                                    roomName: Constants.doorbell,
                                    roomId: bloc.state.deviceId,
                                    deviceId: bloc.state.deviceId,
                                    request: Constants.doorbellSetupComplete,
                                    message: {
                                      "location_id":
                                          bloc.state.selectedLocation!.id,
                                      Constants.deviceId: bloc.state.deviceId,
                                    },
                                  ),
                                );
                                StartupBloc.of(context)
                                    .updateIndexedStackValue(0);
                                singletonBloc.socket?.emit(
                                  "leaveRoom",
                                  // singletonBloc.profileBloc.state!.locationId,
                                  singletonBloc.profileBloc.state!
                                      .selectedDoorBell?.locationId
                                      .toString(),
                                );
                                singletonBloc.joinRoom = false;
                                StartupBloc.of(context)
                                    .updateDashboardApiCalling(true);
                                await StartupBloc.of(context).callEverything(
                                  id: bloc.state.selectedLocation!.id,
                                );

                                if (context.mounted) {
                                  unawaited(
                                    CommonFunctions.updateLocationData(
                                      context,
                                    ),
                                  );
                                  bloc.updateDoorbellNameSaveLoading(false);
                                  unawaited(
                                    MainDashboard.pushRemove(
                                      context.mounted ? context : context,
                                      forOthersPush: "",
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        });
                      } else {
                        final startupBloc = StartupBloc.of(context);
                        final nameAllowed =
                            startupBloc.state.userDeviceModel!.firstWhereOrNull(
                          (e) =>
                              e.locationId.toString() ==
                                  bloc.state.selectedLocation!.id.toString() &&
                              (e.name!.toLowerCase().trim() ==
                                      bloc.state.customDoorbellName
                                          .toLowerCase()
                                          .trim() ||
                                  bloc.state.doorbellName!
                                          .toLowerCase()
                                          .trim() ==
                                      e.name!.toLowerCase().trim()),
                        );
                        if (nameAllowed == null) {
                          bloc.assignDoorbell(
                            navigationFunction: () async {
                              if (context.mounted) {
                                unawaited(
                                  singletonBloc.socketEmitter(
                                    roomName: Constants.doorbell,
                                    roomId: bloc.state.deviceId,
                                    deviceId: bloc.state.deviceId,
                                    request: Constants.doorbellSetupComplete,
                                    message: {
                                      "location_id":
                                          bloc.state.selectedLocation!.id,
                                      Constants.deviceId: bloc.state.deviceId,
                                    },
                                  ),
                                );
                                // StartupBloc.of(context)
                                //     .updateIndexedStackValue(0);
                                StartupBloc.of(context).clearPageIndexes();
                                singletonBloc.socket?.emit(
                                  "leaveRoom",
                                  // singletonBloc.profileBloc.state!.locationId,
                                  singletonBloc.profileBloc.state!
                                      .selectedDoorBell?.locationId
                                      .toString(),
                                );
                                singletonBloc.joinRoom = false;
                                StartupBloc.of(context)
                                    .updateDashboardApiCalling(true);
                                await StartupBloc.of(context).callEverything(
                                  id: bloc.state.selectedLocation!.id,
                                );
                                if (context.mounted) {
                                  bloc.updateDoorbellNameSaveLoading(false);
                                  unawaited(
                                    CommonFunctions.updateLocationData(
                                      context,
                                    ),
                                  );
                                  unawaited(
                                    MainDashboard.pushRemove(
                                      context.mounted ? context : context,
                                      forOthersPush: "",
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        } else {
                          bloc.updateDoorbellNameSaveLoading(false);
                          ToastUtils.warningToast(
                            context.appLocalizations.unique_doorbellName,
                          );
                        }
                      }
                    },
                    label: context.appLocalizations.general_save,
                  ),
                  //   },
                  // ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // static int a = 41;

  Widget rowName(
    context, {
    String name = "Front Door",
    bool needDisabled = false,
    required String tileLeadingText,
  }) {
    final bloc = DoorbellManagementBloc.of(context);
    return IgnorePointer(
      ignoring: needDisabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (name.toLowerCase().contains("custom")) {
            final formKey = GlobalKey<FormState>();
            final TextEditingController doorbellNameController =
                TextEditingController()..text = bloc.state.customDoorbellName;

            showDialog(
              context: context,
              builder: (dialogContext) {
                return Builder(
                  builder: (context) {
                    return Dialog(
                      child: Form(
                        key: formKey,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 30,
                          ),
                          decoration: BoxDecoration(
                            color:
                                CommonFunctions.getThemePrimaryLightWhiteColor(
                              context,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  context.appLocalizations.enter_doorbell_name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: CommonFunctions
                                            .getThemeBasedWidgetColor(
                                          context,
                                        ),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              NameTextFormField(
                                // onChanged: bloc.updateCustomDoorbellName,
                                // initialValue: bloc.state.customDoorbellName,
                                controller: doorbellNameController,
                                hintText: dialogContext
                                    .appLocalizations.doorbell_name,
                                validator: Validators.required(
                                  dialogContext
                                      .appLocalizations.doorbell_name_required,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]'),
                                  ),
                                  // Allow alphabets & spaces
                                  LengthLimitingTextInputFormatter(15),
                                  // Limit to 15 characters
                                ],
                              ),
                              const SizedBox(height: 30),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    textTheme: const TextTheme(
                                      titleSmall: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      CustomGradientButton(
                                        onSubmit: () {
                                          if (doorbellNameController
                                              .text.isNotEmpty) {
                                            bloc
                                              ..onUpdateDoorbellName(name)
                                              ..updateCustomDoorbellName(
                                                doorbellNameController.text
                                                    .trim(),
                                              );
                                            Navigator.pop(dialogContext);
                                          } else {
                                            formKey.currentState!.validate();
                                          }
                                        },
                                        label: dialogContext
                                            .appLocalizations.general_save,
                                      ),
                                      const SizedBox(height: 20),
                                      CustomCancelButton(
                                        onSubmit: () {
                                          Navigator.pop(dialogContext);
                                        },
                                        customWidth: 100.w,
                                        label: dialogContext
                                            .appLocalizations.general_cancel,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            bloc
              ..updateCustomDoorbellName("")
              ..onUpdateDoorbellName(name);
          }
        },
        child: Row(
          spacing: 10,
          children: [
            CircleAvatar(
              backgroundColor: needDisabled
                  ? AppColors.cancelButtonColor
                  : AppColors.blueLinearGradientColor,
              child: Text(tileLeadingText),
            ),
            DoorbellManagementBlocSelector.doorbellName(
              builder: (nameState) {
                return Text(
                  name == "Custom"
                      ? bloc.state.customDoorbellName.isNotEmpty
                          ? bloc.state.customDoorbellName
                          : name
                      : name,
                  style: needDisabled
                      ? Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.cancelButtonColor,
                          )
                      : nameState
                              .toString()
                              .toLowerCase()
                              .contains(name.toLowerCase())
                          ? Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: AppColors.blueLinearGradientColor,
                              )
                          : Theme.of(context).textTheme.titleSmall,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
