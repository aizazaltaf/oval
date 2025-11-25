import 'dart:async';

import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/sub_user_model.dart';
import 'package:admin/pages/main/dashboard/main_dashboard.dart';
import 'package:admin/pages/main/locations/bloc/location_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/components/profile_otp_page.dart';
import 'package:admin/widgets/app_drop_down_button.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/validate_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class OwnershipTransferDialog extends StatelessWidget {
  const OwnershipTransferDialog({
    super.key,
    required this.location,
    required this.parentContext,
  });

  final DoorbellLocations location;
  final BuildContext parentContext;

  String getRoleTitle(int roleId) {
    if (roleId == 1 || roleId == 2) {
      return "Owner";
    } else if (roleId == 3) {
      return "Admin";
    } else {
      return "Viewer";
    }
  }

  String getDropDownDisplay(SubUserModel user) {
    return "${user.name} - ${getRoleTitle(user.role!.id)}";
  }

  Future<void> ownershipSuccessRelease(
    BuildContext context,
    int? anyOtherLocationId,
  ) async {
    final startupBloc = StartupBloc.of(context)..clearPageIndexes();
    final navigationContext = singletonBloc.navigatorKey?.currentState?.context;
    singletonBloc.socket?.emit(
      "leaveRoom",
      // singletonBloc.profileBloc.state!.locationId,
      singletonBloc.profileBloc.state!.selectedDoorBell?.locationId.toString(),
    );
    singletonBloc.joinRoom = false;
    ProfileBloc.of(context).updateSelectedDoorBellToNull();
    StartupBloc.of(context).updateDashboardApiCalling(true);
    await startupBloc.callEverything(id: anyOtherLocationId);
    if (navigationContext != null && navigationContext.mounted) {
      unawaited(CommonFunctions.updateLocationData(navigationContext));
      unawaited(MainDashboard.pushRemove(navigationContext));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LocationBloc.of(parentContext);
    final userProfileBloc = UserProfileBloc.of(parentContext);
    return Dialog(
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
                context.appLocalizations.select_user_role,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: CommonFunctions.getThemeBasedWidgetColor(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            LocationBlocSelector.selectedOwnershipUser(
              builder: (selectedOwner) {
                return AppDropDownButton(
                  items: bloc.state.locationSubUsersList!,
                  selectedValue:
                      selectedOwner ?? bloc.state.locationSubUsersList!.first,
                  onChanged: bloc.updateSelectedOwnershipUser,
                  displayDropDownItems: getDropDownDisplay,
                  buttonHeight: 6.h,
                  dropdownRadius: 10,
                  dropDownWidth: 70.w,
                  dropDownHeight: 22.h,
                );
              },
            ),
            const SizedBox(height: 30),
            Theme(
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
                    onSubmit: () async {
                      Navigator.pop(context);
                      await showDialog(
                        context: parentContext,
                        builder: (validatePasswordContext) {
                          return ValidatePasswordDialog(
                            userProfileBloc: userProfileBloc,
                            successFunction: () {
                              ProfileOtpPage.push(
                                parentContext,
                                otpFor: "transfer_ownership",
                                successReleaseTransferFunction: () {
                                  bloc.callTransferOwnership(
                                    locationId: location.id!,
                                    newOwnerId:
                                        bloc.state.selectedOwnershipUser!.id,
                                    currentOwnerId: location.ownerId!,
                                    successFunction: () {
                                      final startupBloc =
                                          StartupBloc.of(parentContext);
                                      int? anyOtherLocationId;
                                      try {
                                        anyOtherLocationId =
                                            startupBloc.state.userDeviceModel!
                                                .where(
                                                  (element) =>
                                                      element.locationId !=
                                                          location.id &&
                                                      element.entityId == null,
                                                )
                                                .firstOrNull!
                                                .locationId;
                                        ownershipSuccessRelease(
                                          parentContext,
                                          anyOtherLocationId,
                                        );
                                      } catch (e) {
                                        ownershipSuccessRelease(
                                          parentContext,
                                          anyOtherLocationId,
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    label: context.appLocalizations.general_proceed,
                  ),
                  const SizedBox(height: 20),
                  CustomCancelButton(
                    label: context.appLocalizations.general_cancel,
                    customWidth: 100.w,
                    onSubmit: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
