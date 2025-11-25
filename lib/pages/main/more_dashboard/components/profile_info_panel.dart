import 'dart:async';

import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/main_profile.dart';
import 'package:admin/widgets/circular_profile_image.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProfileInfoPanel extends StatefulWidget {
  const ProfileInfoPanel({super.key, required this.isNavigated});
  final bool isNavigated;

  @override
  State<ProfileInfoPanel> createState() => _ProfileInfoPanelState();
}

class _ProfileInfoPanelState extends State<ProfileInfoPanel> {
  double columnHeight = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  if (!widget.isNavigated) {
                    StartupBloc.of(context).pageIndexChanged(0);
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: Icon(
                  size: 30,
                  color: CommonFunctions.getThemeBasedWidgetColor(context),
                  Icons.keyboard_arrow_left,
                ),
              ),
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    UserProfileBloc.of(context).updateIsProfileEditing(false);
                    unawaited(ProfileMainPage.push(context));
                  },
                  child: ProfileBlocSelector.image(
                    builder: (image) {
                      return CircularProfileImage(
                        size: columnHeight,
                        profileImageUrl: singletonBloc.profileBloc.state?.image,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: MeasureSize(
                  onChange: (size) {
                    setState(() {
                      columnHeight = size.height;
                    });
                  },
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      UserProfileBloc.of(context).updateIsProfileEditing(false);
                      unawaited(ProfileMainPage.push(context));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileBlocSelector.name(
                            builder: (name) {
                              if (singletonBloc.profileBloc.state == null) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                singletonBloc.profileBloc.state!.name
                                    .toString(),
                                maxLines: 3,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                              );
                            },
                          ),
                          ProfileBlocSelector.email(
                            builder: (name) {
                              if (singletonBloc.profileBloc.state == null) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                singletonBloc.profileBloc.state!.email
                                    .toString(),
                                maxLines: 3,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                              );
                            },
                          ),
                          const SizedBox(height: 5),
                          Text(
                            context.appLocalizations.visit_your_profile,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: const Color.fromRGBO(0, 71, 255, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            thickness: 1.4,
            color: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).disabledColor
                : Colors.white,
          ),
        ),
      ],
    );
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  const MeasureSize({
    required this.onChange,
    required Widget super.child,
    super.key,
  });
  final Function(Size size) onChange;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMeasureSize(onChange);
  }
}

class _RenderMeasureSize extends RenderProxyBox {
  _RenderMeasureSize(this.onChange);
  final Function(Size size) onChange;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    final Size newSize = child!.size;
    if (_oldSize != newSize) {
      _oldSize = newSize;
      // Callback after layout is done
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onChange(newSize);
      });
    }
  }
}
