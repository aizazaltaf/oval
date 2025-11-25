import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/pages/main/locations/bloc/location_bloc.dart';
import 'package:admin/pages/main/locations/components/location_card.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/components/profile_otp_page.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:admin/widgets/validate_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class LocationSettingsPage extends StatefulWidget {
  const LocationSettingsPage({super.key, this.location, this.isDelete = false});
  final DoorbellLocations? location;
  final bool isDelete;
  static const routeName = "locationSettings";

  static Future<void> push(
    final BuildContext context, {
    DoorbellLocations? location,
    bool isDelete = false,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => LocationSettingsPage(
        isDelete: isDelete,
        location: location,
      ),
    );
  }

  @override
  State<LocationSettingsPage> createState() => _LocationSettingsPageState();
}

class _LocationSettingsPageState extends State<LocationSettingsPage> {
  @override
  void initState() {
    //  implement initState
    super.initState();
    final userProfileBloc = UserProfileBloc.of(context);
    final bloc = LocationBloc.of(context);
    if (widget.isDelete) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        showDialog(
          context: context.mounted ? context : context,
          builder: (innerContext) {
            return AppDialogPopup(
              title: context.appLocalizations.release_without_users_title,
              description: context.appLocalizations.release_without_users_desc,
              confirmButtonLabel: context.appLocalizations.release_location,
              confirmButtonOnTap: () {
                Navigator.pop(innerContext);
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
                              locationId: widget.location!.id!,
                              successFunction: () {
                                bloc.successRelease(
                                  context,
                                  widget.location!,
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
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LocationBloc.of(context);
    return AppScaffold(
      appTitle: context.appLocalizations.location,
      body: NoGlowListViewWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 2.h,
              ),
              NameTextFormField(
                hintText: context.appLocalizations.search_location,
                onChanged: bloc.updateSearch,
                prefix: const Icon(Icons.search),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                context.appLocalizations.locations,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      color: CommonFunctions.getThemeBasedWidgetColor(context),
                      fontWeight: FontWeight.w700,
                    ),
              ),
              SizedBox(
                height: 1.h,
              ),
              ProfileBlocSelector.locations(
                builder: (locations) {
                  return LocationBlocSelector.search(
                    builder: (search) {
                      if (search != null) {
                        if (!locations!.any(
                          (e) => e.name
                              .toString()
                              .toLowerCase()
                              .contains(search.toLowerCase()),
                        )) {
                          return CommonFunctions.noSearchRecord(context);
                        }
                      }
                      return ListViewSeparatedWidget(
                        list: locations,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 1.h),
                        itemBuilder: (context, index) {
                          final String userName =
                              locations![index].name.toString().toLowerCase();
                          if (search != null) {
                            if (userName.contains(search.toLowerCase())) {
                              return LocationCard(location: locations[index]);
                            } else {
                              return const SizedBox.shrink();
                            }
                          }
                          return LocationCard(location: locations[index]);
                        },
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
