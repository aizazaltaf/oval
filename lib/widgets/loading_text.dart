import 'package:admin/constants.dart';
import 'package:admin/widgets/image.dart';
import 'package:flutter/material.dart';

class LoadingText extends StatelessWidget {
  const LoadingText({
    super.key,
    this.label,
    this.style,
    this.customButtonFontSize,
    this.customButtonFontWeight,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.showPercentage = false,
    this.showCircularLoader = true,
    this.loadingProgress,
  });

  final String? label;
  final LoadingTextIcon? prefixIcon;
  final LoadingTextIcon? suffixIcon;
  final double? customButtonFontSize;
  final FontWeight? customButtonFontWeight;
  final bool isLoading;
  final bool showPercentage;
  final bool showCircularLoader;
  final TextStyle? style;
  final double? loadingProgress;

  @override
  Widget build(final BuildContext context) {
    final buttonStyle = ElevatedButtonTheme.of(context).style;
    final foregroundColor = buttonStyle?.foregroundColor?.resolve({});
    if (isLoading) {
      Constants.showLoader(
        showPercentage: showPercentage,
        showCircularLoader: showCircularLoader,
      );

      // return ElegantButtonLoader(
      //   value: loadingProgress, // e.g. 0.0 to 1.0
      //   progressColor: Theme.of(context).primaryColor,
      //   backgroundColor: Theme.of(context).primaryColor,
      //   showPercentage: showPercentage,
      // );
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixIcon != null) ...[
            WCImage(
              prefixIcon!.icon,
              color: prefixIcon!.isColorDynamic
                  ? foregroundColor
                  : prefixIcon!.color,
              width: prefixIcon!.size ?? prefixIcon!.width,
              height: prefixIcon!.size ?? prefixIcon!.height,
              fit: BoxFit.contain,
            ),
            if (label != null) ...[
              const SizedBox(width: 12),
            ],
          ],
          if (label != null) ...[
            Text(
              label!,
              textAlign: TextAlign.center,
              style: style ??
                  Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: customButtonFontSize ?? 18,
                        color: Colors.white,
                        fontWeight: customButtonFontWeight ?? FontWeight.w400,
                      ),
            ),
          ],
          if (suffixIcon != null) ...[
            if (label != null) ...[
              const SizedBox(width: 12),
            ],
            WCImage(
              suffixIcon!.icon,
              color: suffixIcon!.isColorDynamic
                  ? foregroundColor
                  : suffixIcon!.color,
              width: suffixIcon!.size ?? suffixIcon!.width,
              height: suffixIcon!.size ?? suffixIcon!.height,
              fit: BoxFit.contain,
            ),
          ],
        ],
      );
    }
    Constants.dismissLoader();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixIcon != null) ...[
          WCImage(
            prefixIcon!.icon,
            color: prefixIcon!.isColorDynamic
                ? foregroundColor
                : prefixIcon!.color,
            width: prefixIcon!.size ?? prefixIcon!.width,
            height: prefixIcon!.size ?? prefixIcon!.height,
            fit: BoxFit.contain,
          ),
          if (label != null) ...[
            const SizedBox(width: 12),
          ],
        ],
        if (label != null) ...[
          Text(
            label!,
            textAlign: TextAlign.center,
            style: style ??
                Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: customButtonFontSize ?? 18,
                      color: Colors.white,
                      fontWeight: customButtonFontWeight ?? FontWeight.w400,
                    ),
          ),
        ],
        if (suffixIcon != null) ...[
          if (label != null) ...[
            const SizedBox(width: 12),
          ],
          WCImage(
            suffixIcon!.icon,
            color: suffixIcon!.isColorDynamic
                ? foregroundColor
                : suffixIcon!.color,
            width: suffixIcon!.size ?? suffixIcon!.width,
            height: suffixIcon!.size ?? suffixIcon!.height,
            fit: BoxFit.contain,
          ),
        ],
      ],
    );
  }
}

class LoadingTextIcon {
  LoadingTextIcon({
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
