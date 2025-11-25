import 'package:admin/constants.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.loadingProgress,
    this.showCircularLoader = true,
  });

  final Widget? label;
  final LoadingWidgetIcon? prefixIcon;
  final LoadingWidgetIcon? suffixIcon;
  final bool isLoading;
  final bool showCircularLoader;
  final double? loadingProgress;

  @override
  Widget build(final BuildContext context) {
    final buttonStyle = ElevatedButtonTheme.of(context).style;
    if (isLoading) {
      return ButtonProgressIndicator(
        value: loadingProgress,
        showCircularLoader: showCircularLoader,
      );
    }
    buttonStyle?.foregroundColor?.resolve({});
    Constants.dismissLoader();
    return label!;
  }
}

class LoadingWidgetIcon {
  LoadingWidgetIcon({
    required this.icon,
    this.width,
    this.height,
    this.size,
    this.color,
    this.isColorDynamic = false,
  }) {
    if (isColorDynamic) {
      assert(color == null);
    }
  }

  final String icon;
  final double? width;
  final double? height;
  final double? size;
  final Color? color;
  final bool isColorDynamic;
}
