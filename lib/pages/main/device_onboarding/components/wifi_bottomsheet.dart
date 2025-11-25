import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/device_onboarding/bloc/device_onboarding_bloc.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/text_fields/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class WifiBottomSheet extends StatelessWidget {
  const WifiBottomSheet({
    super.key,
    required this.ssid,
    required this.deviceOnboardingBloc,
    required this.bottomSheetContext,
    required this.pageContext,
    required this.fromDoorbellControlPage,
    required this.isDoorbellWifiConnected,
  });

  final String ssid;
  final DeviceOnboardingBloc deviceOnboardingBloc;
  final BuildContext bottomSheetContext;
  final bool fromDoorbellControlPage;
  final BuildContext pageContext;
  final bool isDoorbellWifiConnected;

  @override
  Widget build(BuildContext context) {
    return DeviceOnboardingBlocSelector.isWifiConnecting(
      builder: (wifiConnecting) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom, // shift up with keyboard
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Text(
                  ssid,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 22),
                ),
                const SizedBox(height: 24),
                Text(
                  context.appLocalizations.login_password,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 14),
                DeviceOnboardingBlocSelector.obscurePassword(
                  builder: (obscureText) {
                    return PasswordTextFormField(
                      hintText: context.appLocalizations.hint_password,
                      obscureText: obscureText,
                      validator: (value) {
                        final password = value ?? '';

                        // Check if the password is empty
                        if (password.isEmpty) {
                          return context.appLocalizations.login_errPasswordReq;
                        }

                        return null; // Valid password,
                      },
                      onChanged: (val) {
                        deviceOnboardingBloc.updateWifiPassword(val.trim());
                      },
                      onPressed: () {
                        deviceOnboardingBloc
                            .updateObscurePassword(!obscureText);
                      },
                    );
                  },
                ),
                const SizedBox(height: 26),
                DeviceOnboardingBlocSelector.wifiPassword(
                  builder: (wifiPwd) {
                    return CustomGradientButton(
                      isLoadingEnabled: wifiConnecting,
                      onSubmit: () {
                        if (wifiPwd.isNotEmpty) {
                          if (isDoorbellWifiConnected) {
                            DeviceOnboardingBloc.of(context).updateWifiState(
                              ssid: ssid,
                              pwd: wifiPwd,
                              bottomSheetContext: bottomSheetContext,
                              pageContext: pageContext,
                            );
                          } else {
                            deviceOnboardingBloc
                              ..listenToStatusUpdates(
                                pageContext: pageContext,
                                connectingSSID: ssid,
                                bottomSheetContext: bottomSheetContext,
                                fromDoorbellControlPage:
                                    fromDoorbellControlPage,
                              )
                              ..sendWifiCredentials(
                                ssid: ssid,
                                pwd: deviceOnboardingBloc.state.wifiPassword,
                              );
                          }
                        }
                      },
                      label: context.appLocalizations.connect,
                    );
                  },
                ),
                SizedBox(height: 5.5.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
