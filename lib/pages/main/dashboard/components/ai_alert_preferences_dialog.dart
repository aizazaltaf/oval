import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/custom_checkbox_list_tile.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class AiAlertPreferencesDialog extends StatelessWidget {
  const AiAlertPreferencesDialog({
    super.key,
    required this.device,
    required this.isCamera,
    required this.dialogContext,
    required this.startupBloc,
  });

  final UserDeviceModel device;
  final bool isCamera;
  final BuildContext dialogContext;
  final StartupBloc startupBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: startupBloc,
      child: Dialog(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100.w,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.cancel,
                      color: AppColors.darkBluePrimaryColor,
                      size: 26,
                    ),
                  ),
                ),
              ),
              Text(
                context.appLocalizations.notifications,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: CommonFunctions.getThemeBasedWidgetColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              StartupBlocSelector.aiAlertPreferencesApi(
                builder: (getAiAlertsApi) {
                  if (getAiAlertsApi.isApiInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StartupBlocSelector.aiAlertPreferencesList(
                    builder: (aiAlertList) {
                      if (aiAlertList.isEmpty) {
                        return const Center(
                          child: Text("No Data Found"),
                        );
                      }

                      return Column(
                        children: [
                          SizedBox(
                            height: 50.h,
                            width: 100.w,
                            child: GridView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: aiAlertList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio:
                                    MediaQuery.of(context).size.shortestSide <
                                            600
                                        ? 7
                                        : 10,
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return IgnorePointer(
                                  ignoring: getAiAlertsApi.isApiInProgress,
                                  child: CustomCheckboxListTile(
                                    value: aiAlertList[index].isEnabled == 1,
                                    onChanged: (val) {
                                      // Correctly rebuild the temporary list
                                      aiAlertList = aiAlertList.rebuild((b) {
                                        b[index] = b[index].rebuild(
                                          (d) =>
                                              d.isEnabled = val == true ? 1 : 0,
                                        );
                                      });
                                      startupBloc.updateAiAlertPreferencesList(
                                        aiAlertList,
                                      );
                                    },
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                    title: aiAlertList[index]
                                        .notificationCode
                                        .title,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          StartupBlocSelector.updateApiAlertPreferencesApi(
                            builder: (updateApi) {
                              return CustomGradientButton(
                                onSubmit: () =>
                                    startupBloc.enableAiAlertPreferences(
                                  dialogContext,
                                  device,
                                  isCamera,
                                ),
                                isButtonEnabled: aiAlertList !=
                                    startupBloc.temporaryAiAlertPreferencesList,
                                isLoadingEnabled: updateApi.isApiInProgress,
                                label: context.appLocalizations.apply,
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          StartupBlocSelector.updateApiAlertPreferencesApi(
                            builder: (updateApi) {
                              return IgnorePointer(
                                ignoring: updateApi.isApiInProgress,
                                child: CustomCancelButton(
                                  label: context.appLocalizations.clear,
                                  customWidth: 100.w,
                                  onSubmit:
                                      startupBloc.setTempAiAlertPreferencesList,
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
