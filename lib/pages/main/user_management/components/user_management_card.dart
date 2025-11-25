import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/models/data/sub_user_model.dart';
import 'package:admin/pages/main/user_management/user_info_page.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';

class UserManagementCard extends StatelessWidget {
  const UserManagementCard({super.key, required this.subUser});
  final SubUserModel subUser;

  @override
  Widget build(BuildContext context) {
    final themeWidgetColor = CommonFunctions.getThemeBasedWidgetColor(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => UserInfoPage.push(context: context, subUser: subUser),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: subUser.inviteId == null
              ? const BorderRadius.all(Radius.circular(14))
              : const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: CommonFunctions.getThemePrimaryLightWhiteColor(
                  context,
                ),
                borderRadius: subUser.inviteId == null
                    ? const BorderRadius.all(Radius.circular(14))
                    : const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
              ),
              padding: const EdgeInsets.all(14),
              child: Padding(
                padding:
                    EdgeInsets.only(top: subUser.inviteId != null ? 16 : 0),
                child: Row(
                  children: [
                    ClipOval(
                      child: subUser.profileImage == null ||
                              subUser.profileImage!.isEmpty
                          ? Image.asset(
                              height: 70,
                              width: 70,
                              DefaultImages.USER_IMG_PLACEHOLDER,
                            )
                          : CachedNetworkImage(
                              height: 70,
                              width: 70,
                              imageUrl: "${subUser.profileImage}",
                              useOldImageOnUrlChange: true,
                              errorWidget: (context, exception, trace) {
                                return Image.asset(
                                  fit: BoxFit.cover,
                                  height: 70,
                                  width: 70,
                                  DefaultImages.USER_IMG_PLACEHOLDER,
                                );
                              },
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: null,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              subUser.name ?? subUser.email.split("@").first,
                              maxLines: subUser.name == null ? 1 : null,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: themeWidgetColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 20,
                                color: themeWidgetColor,
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: null,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: SizedBox(
                                  width: 52.w,
                                  child: Text(
                                    CommonFunctions.maskEmail(subUser.email),
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color:
                                              Theme.of(context).disabledColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 20,
                                color: themeWidgetColor,
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: null,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  subUser.role!.name,
                                  softWrap: true,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context).disabledColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -5,
              right: -8,
              child: subUser.inviteId != null
                  ? SvgPicture.asset(
                      subUser.isAccepted.toString().toLowerCase() ==
                              Constants.pending
                          ? DefaultImages.PENDING_TAG
                          : DefaultImages.ACCEPTED_TAG,
                      height: 40,
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
