import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class EditNameDialog extends StatelessWidget {
  EditNameDialog({super.key, required this.bloc, this.isNotRoom = true});

  final IotBloc bloc;
  final bool isNotRoom;
  final TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final device = isNotRoom
        ? bloc.state.inRoomIotDeviceModel![bloc.state.selectedIotIndex]
        : null;
    controller.text =
        isNotRoom ? device!.deviceName! : bloc.state.selectedRoom!.roomName!;
    final String alreadyName =
        isNotRoom ? device!.deviceName! : bloc.state.selectedRoom!.roomName!;

    return Dialog(
      child: BlocProvider.value(
        value: bloc,
        child: Form(
          key: formKey,
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
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    isNotRoom
                        ? context.appLocalizations.device_name
                        : context.appLocalizations.room_name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: CommonFunctions.getThemeBasedWidgetColor(
                            context,
                          ),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                NameTextFormField(
                  controller: controller,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z\s]'),
                    ),
                    // Allow alphabets & spaces
                    LengthLimitingTextInputFormatter(
                      15,
                    ),
                  ],
                  validator: Validators.compose([
                    Validators.required(
                      context.appLocalizations.name_required_error,
                    ),
                    if (!bloc.state.editIotDevice.isApiInProgress)
                      (val) {
                        final exists = bloc.state.iotDeviceModel!.any(
                          (e) =>
                              e.deviceName!.toLowerCase() ==
                              controller.text.toLowerCase(),
                        );

                        return exists
                            ? context.appLocalizations.device_name_exist
                            : null;
                      },
                  ]),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textTheme: const TextTheme(
                        titleSmall: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    child: IotBlocSelector(
                      selector: (state) => state.editIotDevice.isApiInProgress,
                      builder: (isLoading) {
                        return Column(
                          children: [
                            CustomGradientButton(
                              isLoadingEnabled: isLoading,
                              onSubmit: () {
                                if (controller.text.isNotEmpty &&
                                    !bloc.state.iotDeviceModel!.any(
                                      (e) =>
                                          e.deviceName!.toLowerCase() ==
                                          controller.text.toLowerCase(),
                                    )) {
                                  if (alreadyName.toLowerCase() !=
                                      controller.text.toLowerCase()) {
                                    if (isNotRoom) {
                                      bloc.editIotDevice(
                                          device!.id,
                                          controller.text,
                                          device.entityId,
                                          device.roomId, () {
                                        ToastUtils.successToast(
                                          context.appLocalizations
                                              .successfully_updated,
                                        );
                                        Navigator.pop(context);
                                      });
                                    } else {
                                      bloc.editRoom(bloc.state.selectedRoom!,
                                          controller.text, () {
                                        ToastUtils.successToast(
                                          context.appLocalizations
                                              .successfully_updated,
                                        );
                                        Navigator.pop(context);
                                      });
                                    }
                                  } else {
                                    ToastUtils.warningToast(
                                      "Please change the name",
                                    );
                                  }
                                } else {
                                  formKey.currentState!.validate();
                                }
                              },
                              label: context.appLocalizations.general_save,
                            ),
                            const SizedBox(height: 20),
                            CustomCancelButton(
                              onSubmit: () {
                                if (!isLoading) {
                                  Navigator.pop(context);
                                }
                              },
                              customWidth: 100.w,
                              label: context.appLocalizations.general_cancel,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
