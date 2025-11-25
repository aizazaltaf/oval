import 'dart:async';
import 'dart:io';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_preview.dart';
import 'package:admin/pages/themes/componenets/theme_thumbnail_preview.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';

class ThemeListCard extends StatelessWidget {
  const ThemeListCard({
    super.key,
    required this.themes,
    this.isMyTheme = false,
    required this.index,
    required this.data,
  });
  final BuiltList<ThemeDataModel> themes;
  final ThemeDataModel data;
  final int index;
  final bool isMyTheme;

  bool get isVideo =>
      data.mediaType == 3 && CommonFunctions.isVideoTheme(data.cover);

  bool get isGif => data.cover.split(".").last == "gif";

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ThemeThumbnailPreview(
                data: data,
                themesList: themes,
                isMyTheme: isMyTheme,
                index: index,
              ),
            ),
            if (isVideo)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  bloc
                    ..updateIndex(index)
                    ..updateIsDetailThemePage(true)
                    ..updateThemeId(data.id);
                  if (isMyTheme) {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      bloc.updateActiveType("My Themes");
                    });
                  }

                  ThemePreview.push(
                    context,
                    BoxFit.fill,
                    themes,
                  ).then((_) {
                    bloc.updateIsDetailThemePage(false);
                    if (isMyTheme) {
                      bloc.updateActiveType("Feed");
                    }
                  });
                },
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorDark,
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (isGif)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  bloc
                    ..updateIndex(index)
                    ..updateIsDetailThemePage(true)
                    ..updateThemeId(data.id);
                  if (isMyTheme) {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      bloc.updateActiveType("My Themes");
                    });
                  }

                  ThemePreview.push(
                    context,
                    BoxFit.fill,
                    themes,
                  ).then((_) {
                    bloc.updateIsDetailThemePage(false);
                    if (isMyTheme) {
                      bloc.updateActiveType("Feed");
                    }
                  });
                },
                child: const Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white30,
                    child: Center(
                      child: Text(
                        "GIF",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ),
            // if (singletonBloc.profileBloc.state!.locationId != null &&
            if (singletonBloc.profileBloc.state!.selectedDoorBell?.locationId !=
                    null &&
                data.userUploaded == null &&
                !isMyTheme)
              Positioned(
                bottom: 10,
                left: 10,
                child: ThemeBlocSelector(
                  selector: (state) => state.themeLikeApi.isApiInProgress,
                  builder: (isApiInProgress) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (!isApiInProgress) {
                          bloc.themeLike(
                            context,
                            locationId: singletonBloc
                                // .profileBloc.state!.locationId
                                .profileBloc
                                .state!
                                .selectedDoorBell!
                                .locationId
                                .toString(),
                            isLike: data.userLike == 0,
                            totalLikes: data.totalLikes,
                            type: bloc.state.activeType,
                            index: index,
                            data: data,
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: /*bloc.state.activeType == "Favourite" &&
                                isApiInProgress
                            ? const CircularProgressIndicator()
                            :*/
                            LikeButton(
                          size: 22,
                          animationDuration:
                              Duration(seconds: Platform.isIOS ? 2 : 3),
                          onTap: (isLiked) async {
                            unawaited(
                              bloc.themeLike(
                                context,
                                locationId: singletonBloc
                                    // .profileBloc.state!.locationId
                                    .profileBloc
                                    .state!
                                    .selectedDoorBell!
                                    .locationId
                                    .toString(),
                                isLike: data.userLike != 1,
                                type: bloc.state.activeType,
                                totalLikes: bloc
                                    .getThemeApiType(
                                      bloc.state.activeType,
                                    )
                                    .data!
                                    .data[index]
                                    .totalLikes,
                                index: index,
                                data: bloc
                                    .getThemeApiType(
                                      bloc.state.activeType,
                                    )
                                    .data!
                                    .data[index],
                              ),
                            );
                            return true;
                          },
                          circleColor: const CircleColor(
                            start: Colors.red,
                            end: Color(0xffd51820),
                          ),
                          bubblesColor: const BubblesColor(
                            dotPrimaryColor: Colors.red,
                            dotSecondaryColor: Color(0xffd51820),
                          ),
                          likeCountAnimationType: LikeCountAnimationType.none,
                          isLiked: data.userLike == 1,
                          likeBuilder: (isLiked) {
                            return Center(
                              child: SvgPicture.asset(
                                data.userLike == 1
                                    ? DefaultVectors.HEART_FILLED
                                    : DefaultVectors.HEART_EMPTY,
                                colorFilter: ColorFilter.mode(
                                  data.userLike == 1
                                      ? Colors.red
                                      : Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            );
                          },
                          likeCount: data.totalLikes,
                          countBuilder: (count, isLiked, text) {
                            if (bloc.state.activeType == "Favourite") {
                              return const SizedBox.shrink();
                            }
                            Widget result;
                            if (count == 0) {
                              result = const SizedBox.shrink();
                            } else {
                              result = Text(
                                "$count",
                                // Show total liked count if user has liked the theme.
                                style: const TextStyle(
                                  color: Colors.white,
                                  // Set text color to white.
                                  fontSize: 15, // Set text font size to 15.0.
                                ),
                              );
                            }
                            return result;
                          },
                        ),

                        // Row(
                        //         mainAxisSize: MainAxisSize.min,
                        //         // Align children to the start (left) of the row.
                        //         children: [
                        //           // Icon widget to show the favorite icon or the favorite_border icon based on user/theme like status.
                        //           Icon(
                        //             data.userLike == 0
                        //                 ? Icons
                        //                     .favorite_border // Show favorite_border icon when user hasn't liked.
                        //                 : Icons.favorite,
                        //             // Show favorite_border icon when user liked.
                        //             color: data.userLike ==
                        //                     1 // Set icon color to red if user has liked.
                        //                 ? Colors.red
                        //                 : Colors.white,
                        //             // Set icon color to white if neither theme nor user liked.
                        //             size: 24, // Set the size of the icon.
                        //           ),
                        //           const SizedBox(width: 5),
                        //           // Add a fixed width space of 5.0 between the Icon and Text.
                        //           Text(
                        //             "${data.totalLikes}",
                        //             // Show total liked count if user has liked the theme.
                        //             style: const TextStyle(
                        //               color: Colors.white,
                        //               // Set text color to white.
                        //               fontSize:
                        //                   15, // Set text font size to 15.0.
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
