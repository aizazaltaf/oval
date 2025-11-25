import 'dart:async';

import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/logout/bloc/logout_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/components/email_verification_popup.dart';
import 'package:admin/pages/main/user_profile/components/profile_otp_page.dart';
import 'package:admin/pages/main/user_profile/components/profile_shimmer_widget.dart';
import 'package:admin/pages/main/user_profile/edit_profile_page.dart';
import 'package:admin/pages/main/user_profile/user_profile_page.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/circular_profile_image.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/dual_items_bottom_sheet.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/validate_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ProfileMainPage extends StatefulWidget {
  const ProfileMainPage({
    super.key,
    this.nameFocus = false,
    this.emailFocus = false,
    this.phoneFocus = false,
  });
  final bool nameFocus;
  final bool emailFocus;
  final bool phoneFocus;

  static const routeName = "UserProfile";

  static Future<void> push(
    final BuildContext context, {
    bool nameFocus = false,
    bool emailFocus = false,
    bool phoneFocus = false,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => ProfileMainPage(
        nameFocus: nameFocus,
        emailFocus: emailFocus,
        phoneFocus: phoneFocus,
      ),
    );
  }

  static void showBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
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
      backgroundColor: CommonFunctions.getReverseThemeBasedWidgetColor(
        ctx,
      ),
      elevation: 8,
      builder: (context) {
        final userProfileBloc = UserProfileBloc.of(context);
        return DualItemsBottomSheet(
          title: "Upload Image",
          firstSvgLogo: DefaultIcons.CAMERA_ATTACHMENT,
          firstTitle: "Camera",
          secondSvgLogo: DefaultIcons.UNWANTED_GALLERY,
          secondTitle: "Gallery",
          firstButtonPressed: () async {
            Navigator.pop(
              context,
            );
            userProfileBloc.updateFromGallery(
              true,
            );
            await userProfileBloc.getImage();
          },
          secondButtonPressed: () async {
            Navigator.pop(
              context,
            );
            userProfileBloc.updateFromGallery(
              false,
            );
            await userProfileBloc.getImage();
          },
        );
      },
    );
  }

  @override
  State<ProfileMainPage> createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage> {
  @override
  void initState() {
    //  implement initState
    super.initState();
    UserProfileBloc.of(context).updateEditImageStr(null);
  }

  @override
  Widget build(BuildContext context) {
    final profileBloc = singletonBloc.profileBloc;
    final userProfileBloc = UserProfileBloc.of(context);
    return UserProfileBlocSelector.isProfileEditing(
      builder: (profileEditingBool) {
        return AppScaffold(
          onBackPressed: () {
            if (profileEditingBool) {
              userProfileBloc
                ..updateEditImageStr(null)
                ..updateIsProfileEditing(false);
            } else {
              Navigator.pop(context);
            }
          },
          bottomNavigationBar: profileEditingBool
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: UserProfileBlocSelector.updateProfileButtonEnabled(
                    builder: (isUpdateProfileEnabled) {
                      return CustomGradientButton(
                        isButtonEnabled: isUpdateProfileEnabled,
                        onSubmit: () async {
                          if (isUpdateProfileEnabled) {
                            final bool phoneChanged =
                                "${userProfileBloc.state.countryCode}${userProfileBloc.state.editPhoneNumber.trim()}" !=
                                    profileBloc.state!.phone!;
                            await showDialog(
                              context: context,
                              builder: (innerContext) => ValidatePasswordDialog(
                                successFunction: () async {
                                  if (phoneChanged) {
                                    unawaited(
                                      ProfileOtpPage.push(
                                        context,
                                        updatedPhoneNumber:
                                            "${userProfileBloc.state.countryCode}${userProfileBloc.state.editPhoneNumber.trim()}",
                                      ),
                                    );
                                  } else {
                                    userProfileBloc
                                        .updateConfirmButtonEnabled(false);
                                    await userProfileBloc.callUpdateProfile(
                                      phoneChanged: false,
                                      phoneChangedFunction: () {
                                        Navigator.pop(context);
                                      },
                                      emailChangedFunction: () {
                                        final LogoutBloc logoutBloc =
                                            LogoutBloc.of(context);
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (emailVerificationContext) {
                                            return EmailVerificationPopup(
                                              logoutBloc: logoutBloc,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                                userProfileBloc: userProfileBloc,
                              ),
                            );
                          }
                        },
                        label: context.appLocalizations.update_profile,
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),
          appBarAction: [
            if (profileEditingBool)
              const SizedBox.shrink()
            else
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    final String countryCode = CommonFunctions.getDialCode(
                      profileBloc.state!.phone!,
                    );
                    final String phoneNumberWithoutDialCode =
                        profileBloc.state!.phone!.replaceFirst(countryCode, '');
                    userProfileBloc
                      ..updateEditName(profileBloc.state!.name!)
                      ..updateEditEmail(profileBloc.state!.email!)
                      ..updateCountryCode(countryCode)
                      ..updateEditPhoneNumber(phoneNumberWithoutDialCode)
                      ..updateIsProfileEditing(true)
                      ..updateUpdateProfileButtonEnabled(false);
                  },
                  child: Icon(
                    Icons.edit,
                    color: CommonFunctions.getThemeBasedWidgetColor(context),
                  ),
                ),
              ),
          ],
          appTitle: profileEditingBool
              ? context.appLocalizations.edit_profile
              : context.appLocalizations.profile,
          body: NoGlowListViewWrapper(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: UserProfileBlocSelector(
                selector: (state) => state.updateProfileApi.isApiInProgress,
                builder: (inProgress) {
                  return inProgress
                      ? const ProfileShimmerWidget()
                      : ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 4.h,
                                ),
                                ProfileBlocSelector.image(
                                  builder: (image) {
                                    return Stack(
                                      children: [
                                        Center(
                                          child: UserProfileBlocSelector
                                              .editImageStr(
                                            builder: (editImageStr) {
                                              return CircularProfileImage(
                                                size: 18.h,
                                                galleryImageUrl: editImageStr,
                                                profileImageUrl:
                                                    profileBloc.state?.image,
                                              );
                                            },
                                          ),
                                        ),
                                        if (profileEditingBool)
                                          Positioned(
                                            bottom: 10,
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.26,
                                            child: IconButton(
                                              // behavior: HitTestBehavior.opaque,
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              icon: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: CommonFunctions
                                                      .getReverseThemeBasedWidgetColor(
                                                    context,
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: CommonFunctions
                                                      .getThemeBasedWidgetColor(
                                                    context,
                                                  ),
                                                  size: 20,
                                                ),
                                              ),
                                              onPressed: () {
                                                ProfileMainPage.showBottomSheet(
                                                  context,
                                                );
                                              },
                                            ),
                                          )
                                        else
                                          const SizedBox.shrink(),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 6.h),
                                if (profileEditingBool)
                                  EditProfilePage(
                                    nameFocus: widget.nameFocus,
                                    emailFocus: widget.emailFocus,
                                    phoneFocus: widget.phoneFocus,
                                  )
                                else
                                  const UserProfilePage(),
                              ],
                            ),
                          ],
                        );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
