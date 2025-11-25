import 'package:admin/core/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HorizontalHeaderTitles extends StatelessWidget {
  const HorizontalHeaderTitles({
    super.key,
    required this.title,
    this.viewAll = "View All",
    this.viewAllBool = true,
    required this.pinnedOption,
    this.pinnedTitle = "",
    required this.viewAllClick,
  });

  final String title;
  final String viewAll;
  final VoidCallback viewAllClick;
  final bool viewAllBool;
  final bool pinnedOption;
  final String pinnedTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(width: 5),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontWeight: FontWeight.w600, fontSize: 22),
              textAlign: TextAlign.left,
            ),
            // const SizedBox(
            //   width: 10,
            // ),
            // ProfileBlocBuilder(
            //   builder: (context, state) {
            //     return IotBlocSelector.iotDeviceModel(
            //       builder: (list) {
            //         bool canPinned = false;
            //         if (CommonFunctions.getIotFilteredList(list).isNotEmpty) {
            //           canPinned = true;
            //         }
            //         if (canPinned) {
            //           return GestureDetector(
            //             behavior: HitTestBehavior.opaque,
            //             // behavior: HitTestBehavior.opaque,
            //             onTap: () {
            //               if (singletonBloc.profileBloc.state!.sectionList!
            //                   .contains(pinnedTitle)) {
            //                 singletonBloc.profileBloc.updateSectionList(
            //                   singletonBloc.profileBloc.state!.sectionList!
            //                       .rebuild((a) => a.remove(pinnedTitle)),
            //                 );
            //               } else if (singletonBloc
            //                       .profileBloc.state!.sectionList!.length ==
            //                   2) {
            //                 ToastUtils.warningToast(
            //                   context.appLocalizations.two_section_warning,
            //                 );
            //               } else {
            //                 singletonBloc.profileBloc.updateSectionList(
            //                   singletonBloc.profileBloc.state!.sectionList!
            //                       .rebuild((a) => a.insert(0, pinnedTitle)),
            //                 );
            //               }
            //               final String? quotedSections = singletonBloc
            //                   .profileBloc.state?.sectionList
            //                   ?.map((item) => item)
            //                   .join(',');
            //               singletonBloc.getBox
            //                   .write(Constants.pinnedSections, quotedSections);
            //             },
            //             child: SizedBox(
            //               width: 20,
            //               child: ProfileBlocSelector.sectionList(
            //                 builder: (sectionList) {
            //                   return SvgPicture.asset(
            //                     sectionList != null &&
            //                             sectionList.contains(pinnedTitle)
            //                         ? DefaultVectors.SECTION_PIN
            //                         : DefaultVectors.SECTION_UNPIN,
            //                     height: 20,
            //                     width: 20,
            //                     colorFilter: ColorFilter.mode(
            //                       Theme.of(context).tabBarTheme.indicatorColor!,
            //                       BlendMode.srcIn,
            //                     ),
            //                   );
            //                 },
            //               ),
            //             ),
            //           );
            //         }
            //         return const SizedBox.shrink();
            //       },
            //     );
            //   },
            // ),
          ],
        ),
        if (viewAllBool)
          TextButton(
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: viewAllClick,
            child: Container(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Text(
                    viewAll,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(width: 10),
                  SvgPicture.asset(
                    DefaultIcons.NEXT_GRADIENT,
                    width: 8,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
