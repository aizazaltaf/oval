import 'dart:async';

import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/pages/main/doorbell_management/bloc/doorbell_management_bloc.dart';
import 'package:admin/pages/main/doorbell_management/doorbell_map.dart';
import 'package:admin/pages/main/locations/bloc/location_bloc.dart';
import 'package:admin/pages/main/locations/components/ownership_transfer_dialog.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/components/profile_otp_page.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:admin/widgets/validate_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:latlong2/latlong.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key, required this.location});
  final DoorbellLocations location;

  String getAddress() {
    return "${location.houseNo ?? ''}, "
        "${location.street ?? ''}, "
        "${location.city},"
        " ${location.state ?? ''}, "
        "${location.country ?? ''}";
  }

  int getRoleId() {
    if (location.roles[0] == "Admin") {
      return 3;
    } else if (location.roles[0] == "Viewer") {
      return 4;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LocationBloc.of(context);
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 150,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: CommonFunctions.getThemeBasedWidgetColor(
                              context,
                            ),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(
                      width: 50.w,
                      child: Text(
                        getAddress(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: CommonFunctions.getThemeBasedWidgetColor(
                                context,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    final int roleId = getRoleId();
                    if (roleId == 4) {
                      ToastUtils.errorToast(
                        context.appLocalizations.viewer_cannot_edit_location,
                      );
                    } else {
                      DoorbellManagementBloc.of(context)
                        ..updateCenter(
                          LatLng(location.latitude!, location.longitude!),
                        )
                        ..updateMarkerPosition(
                          LatLng(location.latitude!, location.longitude!),
                        )
                        ..updateCompanyAddress(location.houseNo!)
                        ..updateLocationName(location.name!);
                      unawaited(
                        DoorbellMapPage.pushFromLocationScreen(
                          context,
                          location: location,
                          fromLocationSettings: true,
                        ),
                      );
                    }
                  },
                  child: Image.asset(
                    DefaultImages.LOCATION_CIRCLE,
                    height: 55,
                    width: 55,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Role: ${location.roles[0]}",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color:
                            CommonFunctions.getThemeBasedWidgetColor(context),
                      ),
                ),
                getReleaseButton(bloc, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getReleaseButton(LocationBloc bloc, BuildContext context) {
    final userProfileBloc = UserProfileBloc.of(context);
    final int roleId = getRoleId();
    return LocationBlocSelector(
      selector: (state) => state.locationSubUsersApi.isApiInProgress,
      builder: (isInProgress) {
        return CustomGradientButton(
          label: roleId == 2
              ? context.appLocalizations.release_location
              : context.appLocalizations.release_access,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
          forDialog: true,
          isLoadingEnabled: roleId == 2 &&
              location.id.toString() == bloc.state.selectedReleaseLocationId &&
              isInProgress,
          customHeight: 4.h,
          customWidth: 40.w,
          onSubmit: () {
            ///  roleId = 2 -> Owner, 3 -> Admin, 4 -> Viewer
            if (roleId == 3 || roleId == 4) {
              showDialog(
                context: context,
                builder: (innerContext) {
                  return AppDialogPopup(
                    title: innerContext
                        .appLocalizations.admin_viewer_release_title,
                    cancelButtonLabel:
                        innerContext.appLocalizations.general_cancel,
                    confirmButtonLabel:
                        innerContext.appLocalizations.release_access,
                    cancelButtonOnTap: () {
                      Navigator.pop(innerContext);
                    },
                    confirmButtonOnTap: () {
                      Navigator.pop(innerContext);
                      showDialog(
                        context: context,
                        builder: (releaseLocationContext) {
                          return ValidatePasswordDialog(
                            userProfileBloc: userProfileBloc,
                            successFunction: () {
                              bloc.callReleaseLocation(
                                locationId: location.id!,
                                successFunction: () {
                                  bloc.successRelease(context, location);
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            } else {
              bloc
                ..callSubUsers(locationId: location.id!)
                ..updateSelectedReleaseLocationId(location.id!.toString());
              if (!isInProgress) {
                showDialog(
                  context: context,
                  builder: (releaseLocationPopupContext) {
                    return BlocProvider.value(
                      value: bloc,
                      child: LocationBlocSelector(
                        selector: (state) =>
                            state.locationSubUsersApi.isApiInProgress,
                        builder: (isInProgress) {
                          bool hasSubUsers = false;
                          if (isInProgress ||
                              bloc.state.locationSubUsersList == null ||
                              bloc.state.locationSubUsersList!.isEmpty) {
                            hasSubUsers = false;
                          } else {
                            hasSubUsers = true;
                          }
                          if (!isInProgress) {
                            if (hasSubUsers) {
                              return AppDialogPopup(
                                title:
                                    "As the owner of ${location.name}, ${releaseLocationPopupContext.appLocalizations.owner_release_title}",
                                description: releaseLocationPopupContext
                                    .appLocalizations.owner_release_desc,
                                cancelButtonLabel: releaseLocationPopupContext
                                    .appLocalizations.release_location,
                                confirmButtonLabel: releaseLocationPopupContext
                                    .appLocalizations.ownership_transfer,
                                cancelButtonOnTap: () {
                                  Navigator.pop(
                                    releaseLocationPopupContext,
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (validatePasswordContext) {
                                      return ValidatePasswordDialog(
                                        userProfileBloc: userProfileBloc,
                                        successFunction: () {
                                          ProfileOtpPage.push(
                                            context,
                                            otpFor: "release_location",
                                            successReleaseTransferFunction: () {
                                              bloc.callReleaseLocation(
                                                locationId: location.id!,
                                                successFunction: () {
                                                  bloc.successRelease(
                                                    context,
                                                    location,
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
                                confirmButtonOnTap: () {
                                  Navigator.pop(
                                    releaseLocationPopupContext,
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (ownershipContext) {
                                      return BlocProvider.value(
                                        value: bloc,
                                        child: OwnershipTransferDialog(
                                          location: location,
                                          parentContext: context,
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            } else {
                              return ownerWithoutUsersDialog(
                                parentPageContext: context,
                                releaseLocationPopupContext:
                                    releaseLocationPopupContext,
                                bloc: bloc,
                                userProfileBloc: userProfileBloc,
                              );
                            }
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    );
                  },
                );
              }
            }
          },
        );
      },
    );
  }

  Widget ownerWithoutUsersDialog({
    required BuildContext parentPageContext,
    required BuildContext releaseLocationPopupContext,
    required LocationBloc bloc,
    required UserProfileBloc userProfileBloc,
  }) {
    return AppDialogPopup(
      title: parentPageContext.appLocalizations.release_without_users_title,
      description:
          parentPageContext.appLocalizations.release_without_users_desc,
      confirmButtonLabel: parentPageContext.appLocalizations.release_location,
      confirmButtonOnTap: () {
        Navigator.pop(releaseLocationPopupContext);
        showDialog(
          context: parentPageContext,
          builder: (validatePasswordContext) {
            return ValidatePasswordDialog(
              userProfileBloc: userProfileBloc,
              successFunction: () {
                ProfileOtpPage.push(
                  parentPageContext,
                  otpFor: "release_location",
                  successReleaseTransferFunction: () {
                    bloc.callReleaseLocation(
                      locationId: location.id!,
                      successFunction: () {
                        bloc.successRelease(
                          parentPageContext,
                          location,
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
    );
  }
}
