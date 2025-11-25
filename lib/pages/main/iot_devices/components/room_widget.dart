import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/loading_widget.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoomWidget extends StatelessWidget {
  const RoomWidget({
    super.key,
    this.roomName,
    this.color,
    this.images,
    this.isLoading = false,
    this.svgColor,
    this.isNetwork = false,
    this.roomSelected = false,
    this.isDisabled = false,
    this.newWidget = false,
  });

  final String? roomName;
  final BuiltList<Color>? color;
  final Color? svgColor;
  final String? images;
  final bool isNetwork;
  final bool isLoading;
  final bool isDisabled;
  final bool roomSelected;
  final bool newWidget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: newWidget
          ? Column(
              spacing: 5,
              children: [
                Card(
                  elevation: 1,
                  shadowColor: Colors.grey,
                  surfaceTintColor:
                      CommonFunctions.getThemeBasedWidgetColorInverted(context),
                  color: roomSelected
                      ? Theme.of(context).primaryColor
                      : CommonFunctions.getThemeBasedWidgetColorInverted(
                          context,
                        ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(100), // large enough for circle
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: SvgPicture.asset(
                        images!,
                        colorFilter: ColorFilter.mode(
                          roomSelected
                              ? Colors.white
                              : isDisabled
                                  ? Colors.white
                                  : CommonFunctions.getThemeBasedWidgetColor(
                                      context,
                                    ),
                          BlendMode.srcIn,
                        ),
                        height: 32,
                      ),
                    ),
                  ),
                ),
                Text(
                  roomName ?? "",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: CommonFunctions.getThemeBasedWidgetColor(
                          context,
                        ),
                        fontSize: 12,
                      ),
                ),
              ],
            )
          : Card(
              elevation: 1,
              shadowColor: Colors.grey,
              surfaceTintColor:
                  Theme.of(context).appBarTheme.titleTextStyle!.color,
              color: roomSelected
                  ? Theme.of(context).primaryColor
                  : CommonFunctions.getThemeBasedWidgetColorInverted(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isNetwork)
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: LoadingWidget(
                        isLoading: isLoading,
                        label: CachedNetworkImage(
                          imageUrl: images!,
                          useOldImageOnUrlChange: true,
                          errorWidget: (context, exception, stackTrace) {
                            return const CircularProgressIndicator();
                          },
                        ),
                      ),
                    )
                  else
                    SvgPicture.asset(
                      images!,
                      colorFilter: ColorFilter.mode(
                        roomSelected
                            ? Colors.white
                            : isDisabled
                                ? Colors.white
                                : CommonFunctions.getThemeBasedWidgetColor(
                                    context,
                                  ),
                        BlendMode.srcIn,
                      ),
                      height: 40,
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      (roomName ?? "").replaceAll("_", " "),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: roomSelected
                                ? Colors.white
                                : isDisabled
                                    ? Colors.white
                                    : CommonFunctions.getThemeBasedWidgetColor(
                                        context,
                                      ),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
