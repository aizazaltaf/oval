import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/core/app_restrictions.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/bottom_navigation_bar/motion_tab_bar_controller.dart';
import 'package:admin/widgets/bottom_navigation_bar/motion_tab_item.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';

typedef MotionTabBuilder = Widget Function();

class MotionTabBar extends StatefulWidget {
  MotionTabBar({
    super.key,
    this.textStyle,
    this.tabIconColor = Colors.black,
    this.tabIconSize = 24,
    this.tabIconSelectedColor = Colors.white,
    this.tabIconSelectedSize = 24,
    this.tabSelectedColor = Colors.black,
    this.tabBarColor = Colors.white,
    this.tabBarHeight = kBottomNavigationBarHeight,
    // this.tabSize = 60,
    this.onTabItemSelected,
    required this.initialSelectedTab,
    required this.labels,
    this.disabledIndex = 1,
    this.disabled = false,
    required this.icons,
    this.useSafeArea = true,
    this.badges,
    this.controller,
  })  : assert(labels.contains(initialSelectedTab)),
        // assert(homeController != null),
        assert(icons.length == labels.length),
        assert(
          badges == null || badges.isEmpty || badges.length == labels.length,
        );
  final Color? tabIconColor;
  final Color? tabIconSelectedColor;
  final Color? tabSelectedColor;
  final Color? tabBarColor;
  final double? tabIconSize;
  final double? tabIconSelectedSize;
  final double? tabBarHeight;
  // final double? tabSize;
  final TextStyle? textStyle;
  final Function? onTabItemSelected;
  final String initialSelectedTab;
  final int disabledIndex;
  final bool disabled;
  final List<String?> labels;
  final List<IconData> icons;
  final bool useSafeArea;
  final MotionTabBarController? controller;

  // badge
  final List<Widget?>? badges;

  @override
  MotionTabBarState createState() => MotionTabBarState();
}

class MotionTabBarState extends State<MotionTabBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Tween<double> _positionTween;
  late Animation<double> _positionAnimation;

  late AnimationController _fadeOutController;
  late Animation<double> _fadeFabOutAnimation;
  late Animation<double> _fadeFabInAnimation;

  late List<String?> labels;
  late Map<String?, IconData> icons;

  int get tabAmount => icons.keys.length;

  int get index => labels.indexOf(selectedTab);

  double fabIconAlpha = 1;
  IconData? activeIcon;
  String? selectedTab;

  bool isRtl = false;
  List<Widget>? badges;
  Widget? activeBadge;

  @override
  void dispose() {
    _animationController.dispose();

    _fadeOutController.dispose();

    super.dispose();
  } // late HomeController homeController;

  double getPosition(bool isRTL) {
    final double pace = 2 / (labels.length - 1);
    double position = (pace * index) - 1;

    if (isRTL) {
      // If RTL, reverse the position calculation
      position = 1 - (pace * index);
    }

    return position;
  }

  @override
  void initState() {
    // homeController = Provider.of<HomeController>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isRtl = Directionality.of(context).index == 0;
    });

    if (widget.controller != null) {
      widget.controller!.onTabChange = (index) {
        setState(() {
          activeIcon = widget.icons[index];
          selectedTab = widget.labels[index];
        });
        _initAnimationAndStart(_positionAnimation.value, getPosition(isRtl));
      };
    }
    labels = widget.labels;
    icons = {
      for (final label in labels) label: widget.icons[labels.indexOf(label)],
    };

    selectedTab = widget.initialSelectedTab;
    activeIcon = icons[selectedTab];

    // init badge text
    final int selectedIndex =
        labels.indexWhere((element) => element == widget.initialSelectedTab);
    activeBadge = (widget.badges != null && widget.badges!.isNotEmpty)
        ? widget.badges![selectedIndex]
        : null;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: animDuration),
      vsync: this,
    );

    _fadeOutController = AnimationController(
      duration: const Duration(milliseconds: animDuration ~/ 5),
      vsync: this,
    );

    _positionTween = Tween<double>(begin: getPosition(isRtl), end: 1);

    _positionAnimation = _positionTween.animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {});
      });

    _fadeFabOutAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeOut),
    )
      ..addListener(() {
        setState(() {
          fabIconAlpha = _fadeFabOutAnimation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            activeIcon = icons[selectedTab];
            final int selectedIndex =
                labels.indexWhere((element) => element == selectedTab);
            activeBadge = (widget.badges != null && widget.badges!.isNotEmpty)
                ? widget.badges![selectedIndex]
                : null;
          });
        }
      });

    _fadeFabInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.8, 1, curve: Curves.easeOut),
      ),
    )..addListener(() {
        setState(() {
          fabIconAlpha = _fadeFabInAnimation.value;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.tabBarColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 5,
          ),
        ],
      ),
      child: SafeArea(
        bottom: widget.useSafeArea,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: widget.tabBarColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: generateTabItems(),
              ),
            ),
            // IgnorePointer(
            //   child: DecoratedBox(
            //     decoration: const BoxDecoration(color: Colors.transparent),
            //     child: Align(
            //       heightFactor: 0,
            //       alignment: Alignment(_positionAnimation.value, 0),
            //       child: FractionallySizedBox(
            //         widthFactor: 1 / tabAmount,
            //         child: Stack(
            //           alignment: Alignment.center,
            //           children: <Widget>[
            //             ClipRect(
            //               clipper: HalfClipper(),
            //               child: Center(
            //                 child: Container(
            //                   width: MediaQuery.of(context).size.width > 500
            //                       ? 44
            //                       : 40,
            //                   decoration: BoxDecoration(
            //                     color: widget.tabBarColor,
            //                     shape: BoxShape.circle,
            //                     boxShadow: const [
            //                       BoxShadow(
            //                         color: Colors.black12,
            //                         blurRadius: 8,
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             SizedBox(
            //               height: 55,
            //               width:
            //                   MediaQuery.of(context).size.width > 500 ? 75 : 55,
            //               child: CustomPaint(
            //                 painter: HalfPainter(color: widget.tabBarColor),
            //               ),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.only(top: 30),
            //               child: SizedBox(
            //                 height: 74,
            //                 width: 74,
            //                 child: DecoratedBox(
            //                   decoration: BoxDecoration(
            //                     shape: BoxShape.circle,
            //                     color: widget.tabSelectedColor,
            //                   ),
            //                   child: DecoratedBox(
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(40),
            //                       border: Border.all(
            //                         color: Theme.of(context).primaryColor,
            //                       ),
            //                     ),
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         Icon(
            //                           activeIcon,
            //                           color: Theme.of(context).primaryColor,
            //                           size: widget.tabIconSelectedSize,
            //                         ),
            //                         if (activeBadge != null)
            //                           Positioned(
            //                             top: 0,
            //                             right: 0,
            //                             child: activeBadge!,
            //                           )
            //                         else
            //                           const SizedBox(),
            //                         Text(
            //                           selectedTab ?? '',
            //                           textAlign: TextAlign.center,
            //                           style: Theme.of(context)
            //                               .textTheme
            //                               .headlineLarge!
            //                               .copyWith(
            //                                 fontSize: 11,
            //                                 fontWeight: FontWeight.w700,
            //                                 color:
            //                                     Theme.of(context).primaryColor,
            //                               ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  List<Widget> generateTabItems() {
    final bool isRtl = Directionality.of(context).index == 0;
    return labels.map((tabLabel) {
      final IconData? icon = icons[tabLabel];

      final int selectedIndex =
          labels.indexWhere((element) => element == tabLabel);
      final Widget? badge = (widget.badges != null && widget.badges!.isNotEmpty)
          ? widget.badges![selectedIndex]
          : null;

      return MotionTabItem(
        selected: selectedTab == tabLabel,
        iconData: icon,
        title: tabLabel,
        textStyle: widget.textStyle ?? const TextStyle(color: Colors.black),
        tabIconColor: widget.tabIconColor ?? Colors.black,
        tabIconSize: widget.tabIconSize,
        badge: badge,
        callbackFunction: () {
          setState(() {
            if (selectedIndex == 1) {
              if (widget.disabled) {
                ToastUtils.infoToast(
                  null,
                  'Purchase an Irvinei Doorbell to manage your doorbell visitors.',
                );
              }

              /// If 0304 not present, Visitor Log will not be accessed
              else if (!singletonBloc.isFeatureCodePresent(
                AppRestrictions.visitorLogsAndChatHistory.code,
              )) {
                CommonFunctions.showRestrictionDialog(context);
              } else {
                activeIcon = icon;
                selectedTab = tabLabel;
                widget.onTabItemSelected?.call(index);
              }
            } else if (selectedIndex == 2) {
              ToastUtils.infoToast(
                'Coming Soon',
                'Neighbourhoods will be available soon.',
              );
            } else {
              activeIcon = icon;
              selectedTab = tabLabel;
              widget.onTabItemSelected?.call(index);
            }
          });
          if (selectedIndex == 1) {
            if (!widget.disabled) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _initAnimationAndStart(
                  _positionAnimation.value,
                  getPosition(isRtl),
                );
              });
            }
          } else if (selectedIndex == 2) {
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _initAnimationAndStart(
                _positionAnimation.value,
                getPosition(isRtl),
              );
            });
          }
        },
        disabled: widget.disabled ||
            !singletonBloc.isFeatureCodePresent(
              AppRestrictions.visitorLogsAndChatHistory.code,
            ),
        disabledIndex: selectedIndex,
      );
    }).toList();
  }

  Future<void> _initAnimationAndStart(double from, double to) async {
    _positionTween
      ..begin = from
      ..end = to;

    _animationController.reset();
    _fadeOutController.reset();
    unawaited(_animationController.forward());
    unawaited(_fadeOutController.forward());
  }
}
