import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/main/dashboard/components/bottomsheet.dart';
import 'package:admin/widgets/circular_profile_image.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DoorbellAppbar extends StatelessWidget {
  const DoorbellAppbar({super.key, this.isDisabled = false});

  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final themeBasedWidgetColor =
        CommonFunctions.getThemeBasedWidgetColor(context);
    return ProfileBlocSelector.selectedDoorBell(
      builder: (doorbell) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileBlocSelector.image(
              builder: (image) {
                return CircularProfileImage(
                  size: 54,
                  border: false,
                  profileImageUrl: singletonBloc.profileBloc.state?.image,
                );
              },
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileBlocSelector.name(
                  builder: (name) {
                    if (singletonBloc.profileBloc.state == null) {
                      return const SizedBox.shrink();
                    }
                    return SizedBox(
                      width: 60.w,
                      child: Text(
                        "Hi, ${singletonBloc.profileBloc.state!.name}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(fontSize: 22),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 5),
                IgnorePointer(
                  ignoring: isDisabled,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      // CommonFunctions.displayLocationBottomSheet(
                      //     context, ScrollController());

                      await showModalBottomSheet(
                        isScrollControlled: true,
                        showDragHandle: true,
                        context: context.mounted ? context : context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        builder: (c) {
                          StartupBloc.of(c).getUserDoorbells(
                            id: singletonBloc.profileBloc.state
                                        ?.selectedDoorBell?.locationId ==
                                    null
                                ? null
                                : int.tryParse(
                                    // singletonBloc
                                    //     .profileBloc.state!.locationId!,
                                    singletonBloc.profileBloc.state!
                                        .selectedDoorBell!.locationId
                                        .toString(),
                                  ),
                          );
                          return DisplayLocationBottomSheet();
                        },
                      );
                    },
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: null,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: Icon(
                            MdiIcons.mapMarkerOutline,
                            size: 20,
                            color: themeBasedWidgetColor,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.only(top: 2),
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Row(
                            children: [
                              Text(
                                singletonBloc
                                        .profileBloc
                                        .state
                                        ?.selectedDoorBell
                                        ?.doorbellLocations
                                        ?.name ??
                                    "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.keyboard_arrow_right_outlined,
                                size: 20,
                                color: themeBasedWidgetColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
