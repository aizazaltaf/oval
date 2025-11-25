import 'package:admin/extensions/context.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:flutter/material.dart';

const double iconOff = -3;
const double iconOn = 0;
const double textOff = 1;
const double textOn = 1;
const double alphaOff = 0;
const double alphaOn = 1;
const int animDuration = 300;

class MotionTabItem extends StatefulWidget {
  const MotionTabItem({
    super.key,
    required this.title,
    required this.selected,
    required this.iconData,
    required this.textStyle,
    required this.disabled,
    this.disabledIndex = 1,
    required this.tabIconColor,
    required this.callbackFunction,
    this.tabIconSize = 24,
    this.badge,
  });
  final String? title;
  final bool selected;
  final IconData? iconData;
  final TextStyle textStyle;
  final Function callbackFunction;
  final Color tabIconColor;
  final double? tabIconSize;
  final Widget? badge;
  final int disabledIndex;
  final bool disabled;

  @override
  MotionTabItemState createState() => MotionTabItemState();
}

class MotionTabItemState extends State<MotionTabItem> {
  double iconYAlign = iconOn;
  double textYAlign = textOff;
  double iconAlpha = alphaOn;

  @override
  void initState() {
    super.initState();
    _setIconTextAlpha();
  }

  @override
  void didUpdateWidget(MotionTabItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setIconTextAlpha();
  }

  Future<void> _setIconTextAlpha() async {
    setState(() {
      iconYAlign = (widget.selected) ? iconOff : iconOn;
      textYAlign = (widget.selected) ? textOn : textOff;
      iconAlpha = (widget.selected) ? alphaOff : alphaOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.callbackFunction(),
      child: SizedBox(
        // height: widget.title == "Home" || widget.title == "More" ? 70 : 82,
        height: 74,
        width: MediaQuery.of(context).size.width / 4.1,
        // decoration: widget.selected
        //     ? BoxDecoration(
        //         shape: BoxShape.circle,
        //         border: Border.all(
        //           color: Theme.of(contzext).primaryColor,
        //         ),
        //       )
        //     : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.selected)
              Container(
                height: 4,
                width: 55,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
              ),
            const SizedBox(height: 10),
            AnimatedAlign(
              duration: const Duration(milliseconds: animDuration),
              curve: Curves.easeIn,
              alignment: Alignment(0, iconYAlign),
              child: Icon(
                widget.iconData,
                color: (widget.disabled &&
                            widget.title ==
                                context
                                    .appLocalizations.visitor_log_dashboard) ||
                        (widget.title ==
                            context.appLocalizations.neighbourhood_dashboard)
                    ? AppColors.darkGreyBg
                    : widget.selected
                        ? Theme.of(context).primaryColor
                        : widget.tabIconColor,
                size: widget.tabIconSize,
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: animDuration),
              alignment: Alignment(0, textYAlign),
              curve: Curves.easeIn,
              child: Text(
                widget.title!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: (widget.disabled &&
                                  widget.title ==
                                      context.appLocalizations
                                          .visitor_log_dashboard) ||
                              (widget.title ==
                                  context
                                      .appLocalizations.neighbourhood_dashboard)
                          ? AppColors.darkGreyBg
                          : widget.selected
                              ? Theme.of(context).primaryColor
                              : widget.tabIconColor,
                    ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),

      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     AnimatedAlign(
      //       duration: const Duration(milliseconds: animDuration),
      //       curve: Curves.easeIn,
      //       alignment: Alignment(0, iconYAlign),
      //       child: AnimatedOpacity(
      //         duration: const Duration(milliseconds: animDuration),
      //         opacity: iconAlpha,
      //         child: iconAlpha == 0
      //             ? const SizedBox.shrink()
      //             : Icon(
      //                 widget.iconData,
      //                 color: (widget.disabled &&
      //                             widget.title ==
      //                                 context.appLocalizations
      //                                     .visitor_log_dashboard) ||
      //                         (widget.title ==
      //                             context
      //                                 .appLocalizations.neighbourhood_dashboard)
      //                     ? const Color.fromRGBO(161, 161, 161, 1)
      //                     : widget.tabIconColor,
      //                 size: widget.tabIconSize,
      //               ),
      //       ),
      //     ),
      //     SizedBox(
      //       width: MediaQuery.of(context).size.width / 4.1,
      //       // height: 26,
      //       child: AnimatedAlign(
      //         duration: const Duration(milliseconds: animDuration),
      //         alignment: Alignment(0, textYAlign),
      //         curve: Curves.easeIn,
      //         child: iconAlpha == 0
      //             ? const SizedBox.shrink()
      //             : Text(
      //                 widget.title!,
      //                 textAlign: TextAlign.center,
      //                 style:
      //                     Theme.of(context).textTheme.headlineLarge!.copyWith(
      //                           fontSize: 11,
      //                           fontWeight: FontWeight.w700,
      //                           color: (widget.disabled &&
      //                                       widget.title ==
      //                                           context.appLocalizations
      //                                               .visitor_log_dashboard) ||
      //                                   (widget.title ==
      //                                       context.appLocalizations
      //                                           .neighbourhood_dashboard)
      //                               ? AppColors.darkGreyBg
      //                               : widget.tabIconColor,
      //                         ),
      //               ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
