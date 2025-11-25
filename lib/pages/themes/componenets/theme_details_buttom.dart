import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_color_edit.dart';
import 'package:admin/pages/themes/componenets/theme_selection_button.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class ThemeDetailsButtons extends StatelessWidget {
  const ThemeDetailsButtons({
    super.key,
    required this.themeId,
    this.isAppliedTheme = false,
    required this.data,
  });

  final int themeId;
  final ThemeDataModel data;
  final bool isAppliedTheme;

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    final startupBloc = StartupBloc.of(context);
    final UserDeviceModel? doorbell = startupBloc.state.userDeviceModel!
        .singleWhereOrNull((e) => e.deviceId == data.deviceId);
    final String role = singletonBloc.profileBloc.state!.locations!
        .singleWhere(
          (e) =>
              e.id ==
              singletonBloc.profileBloc.state!.selectedDoorBell!.locationId,
        )
        .roles[0];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isAppliedTheme)
          const SizedBox.shrink()
        else
          ThemeSelectionButton(
            icon: DefaultImages.COLOR_WHEEL,
            image: DefaultVectors.EDIT_NAME,
            title: context.appLocalizations.edit,
            onPressed: () {
              if (role.toLowerCase() == "viewer") {
                ToastUtils.infoToast(
                  null,
                  "Viewer is not allowed to set theme",
                );
              } else {
                ThemeColorEdit.push(
                  context,
                  doorbell: doorbell,
                  themeId: themeId,
                  isEdit: true,
                );
              }
            },
          ),
        ThemeSelectionButton(
          image: isAppliedTheme
              ? DefaultVectors.ROUND_MINUS
              : DefaultVectors.ROUND_ADD,
          title: isAppliedTheme
              ? context.appLocalizations.remove_from_doorbell
              : context.appLocalizations.set_to_doorbell,
          onPressed: () {
            if (!isAppliedTheme) {
              if (singletonBloc.profileBloc.state!.selectedDoorBell != null) {
                if (role.toLowerCase() == "viewer") {
                  ToastUtils.infoToast(
                    null,
                    "Viewer is not allowed to set theme",
                  );
                } else {
                  ThemeColorEdit.push(context, themeId: themeId);
                }
              } else {
                CommonFunctions.addOrShopDialog(context);
              }
            } else {
              if (doorbell != null) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => StatefulBuilder(
                    builder: (dialogContext, snapshot) {
                      return AppDialogPopup(
                        title:
                            "Are you sure you want to remove this theme form ${doorbell.name ?? ''}?",
                        confirmButtonLabel: context.appLocalizations.remove,
                        confirmButtonOnTap: () async {
                          Navigator.pop(dialogContext);
                          await bloc.removeThemeApi(
                            context,
                            doorbell,
                            themeId,
                            deviceId: bloc
                                .getThemeApiType(
                                  bloc.state.activeType,
                                )
                                .data!
                                .data
                                .singleWhereOrNull(
                                  (e) => e.id == themeId,
                                )!
                                .deviceId!,
                          );
                        },
                        cancelButtonLabel:
                            context.appLocalizations.general_cancel,
                        cancelButtonOnTap: () => Navigator.pop(dialogContext),
                      );
                    },
                  ),
                );
              }
            }
          },
        ),
        ThemeBlocSelector.index(
          builder: (index) {
            final BuiltList<ThemeDataModel> dataModel =
                bloc.getThemeApiType(bloc.state.activeType).data!.data;
            return index > dataModel.length - 1 ||
                    dataModel[index].userUploaded != null
                ? const SizedBox.shrink()

                ///Index out of bound aiya hai idar @hamza
                : ThemeBlocSelector(
                    selector: (state) =>
                        bloc.getThemeApiType(state.activeType).data == null
                            ? 0
                            : index >
                                    bloc
                                            .getThemeApiType(state.activeType)
                                            .data!
                                            .data
                                            .length -
                                        1
                                ? null
                                : bloc
                                    .getThemeApiType(state.activeType)
                                    .data!
                                    .data[index]
                                    .userLike,
                    builder: (userLike) {
                      // return LikeButton(
                      //   size: 22,
                      //   onTap: (isLiked) async {
                      //     await bloc.themeLike(
                      //       context,
                      //       locationId: singletonBloc
                      //           // .profileBloc.state!.locationId
                      //           .profileBloc
                      //           .state!
                      //           .selectedDoorBell!
                      //           .locationId
                      //           .toString(),
                      //       isLike: userLike != 1,
                      //       type: bloc.state.activeType,
                      //       totalLikes: bloc
                      //           .getThemeApiType(bloc.state.activeType)
                      //           .data!
                      //           .data[index]
                      //           .totalLikes,
                      //       index: index,
                      //       data: bloc
                      //           .getThemeApiType(bloc.state.activeType)
                      //           .data!
                      //           .data[index],
                      //     );
                      //     return null;
                      //   },
                      //   circleColor: const CircleColor(
                      //       start: Colors.red, end: Color(0xffd51820)),
                      //   bubblesColor: const BubblesColor(
                      //     dotPrimaryColor: Colors.red,
                      //     dotSecondaryColor: Color(0xffd51820),
                      //   ),
                      //   likeBuilder: (isLiked) {
                      //     return Center(
                      //       child: SvgPicture.asset(
                      //         DefaultVectors.HEART_FILLED,
                      //         colorFilter: ColorFilter.mode(
                      //           userLike == 1
                      //               ? Colors.red
                      //               : Theme.of(context).primaryColor,
                      //           BlendMode.srcIn,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   likeCount: dataModel[index].totalLikes,
                      //   countBuilder: (count, isLiked, text) {
                      //     final color = isLiked
                      //         ? Colors.red
                      //         : Theme.of(context).primaryColor;
                      //     Widget result;
                      //     if (count == 0) {
                      //       result = Center(
                      //         child: SvgPicture.asset(
                      //           DefaultVectors.HEART_EMPTY,
                      //           colorFilter: ColorFilter.mode(
                      //             color,
                      //             BlendMode.srcIn,
                      //           ),
                      //         ),
                      //       );
                      //     } else {
                      //       result = Center(
                      //         child: SvgPicture.asset(
                      //           DefaultVectors.HEART_FILLED,
                      //           colorFilter: ColorFilter.mode(
                      //             color,
                      //             BlendMode.srcIn,
                      //           ),
                      //         ),
                      //       );
                      //     }
                      //     return result;
                      //   },
                      // );

                      return ThemeSelectionButton(
                        image: userLike == 1
                            ? DefaultVectors.HEART_FILLED
                            : DefaultVectors.HEART_EMPTY,
                        iconColor: userLike == 1
                            ? Colors.red
                            : Theme.of(context).primaryColor,
                        title: userLike == 1
                            ? context.appLocalizations.remove_favourite
                            : context.appLocalizations.add_to_favourite,
                        onPressed: () {
                          bloc.themeLike(
                            context,
                            locationId: singletonBloc
                                // .profileBloc.state!.locationId
                                .profileBloc
                                .state!
                                .selectedDoorBell!
                                .locationId
                                .toString(),
                            isLike: userLike != 1,
                            type: bloc.state.activeType,
                            totalLikes: bloc
                                .getThemeApiType(bloc.state.activeType)
                                .data!
                                .data[index]
                                .totalLikes,
                            index: index,
                            data: bloc
                                .getThemeApiType(bloc.state.activeType)
                                .data!
                                .data[index],
                          );
                        },
                      );
                    },
                  );
          },
        ),
      ],
    );
  }
}
