import 'package:admin/widgets/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onSubmit,
    required this.isButtonEnabled,
    this.customButtonFontSize,
    this.customButtonFontWeight,
    required this.label,
  });

  final VoidCallback onSubmit;
  final bool isButtonEnabled;
  final String label;
  final double? customButtonFontSize;
  final FontWeight? customButtonFontWeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isButtonEnabled ? null : onSubmit,
      child: Container(
        height: 5.h,
        width: 20.h,
        decoration: BoxDecoration(
          color: isButtonEnabled ? Theme.of(context).primaryColor : Colors.grey,
        ),
        child: Center(
          child: LoadingText(
            isLoading: isButtonEnabled,
            label: label,
            customButtonFontWeight: customButtonFontWeight,
            customButtonFontSize: customButtonFontSize,
          ),
        ),
      ),
    );
  }
}

class CustomWidgetButton extends StatelessWidget {
  const CustomWidgetButton({
    super.key,
    required this.onSubmit,
    required this.isButtonEnabled,
    required this.child,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.height,
    this.shape,
    this.width,
  });

  final VoidCallback onSubmit;
  final bool isButtonEnabled;
  final Color? color;
  final Color? borderColor;
  final Widget child;
  final double? height;
  final double? width;
  final BoxShape? shape;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: !isButtonEnabled ? null : onSubmit,
      child: Container(
        height: height ?? 5.h,
        width: width ?? 20.h,
        decoration: boxDecoration(context, shape),
        child: child,
      ),
    );
  }

  BoxDecoration boxDecoration(context, BoxShape? shape) {
    if (shape == null) {
      return BoxDecoration(
        borderRadius: borderRadius,
        border:
            Border.all(color: borderColor ?? Theme.of(context).primaryColor),
        color: color ??
            (isButtonEnabled ? Theme.of(context).primaryColor : Colors.grey),
      );
    }
    return BoxDecoration(
      shape: shape,
      border: Border.all(color: borderColor ?? Theme.of(context).primaryColor),
      color: color ??
          (isButtonEnabled ? Theme.of(context).primaryColor : Colors.grey),
    );
  }
}

class CustomWidgetCardButton extends StatelessWidget {
  const CustomWidgetCardButton({
    super.key,
    required this.onSubmit,
    required this.isButtonEnabled,
    required this.child,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.height,
    this.shape,
    this.width,
  });

  final VoidCallback onSubmit;
  final bool isButtonEnabled;
  final Color? color;
  final Color? borderColor;
  final Widget child;
  final double? height;
  final double? width;
  final BoxShape? shape;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: !isButtonEnabled ? null : onSubmit,
      child: Card(
        elevation: 3,
        color: color ??
            (isButtonEnabled ? Theme.of(context).primaryColor : Colors.grey),
        child: Container(
          height: height ?? 5.h,
          width: width ?? 20.h,
          decoration: boxDecoration(context, shape),
          child: child,
        ),
      ),
    );
  }

  BoxDecoration boxDecoration(context, BoxShape? shape) {
    if (shape == null) {
      return BoxDecoration(
        borderRadius: borderRadius,
        // boxShadow: [
        //   BoxShadow(
        //     color: color ??
        //         (isButtonEnabled
        //             ? Theme.of(context).primaryColor
        //             : Colors.grey),
        //     spreadRadius: 2.0,
        //     blurRadius: 3.0,
        //   )
        // ],
        border:
            Border.all(color: borderColor ?? Theme.of(context).primaryColor),
        color: color ??
            (isButtonEnabled ? Theme.of(context).primaryColor : Colors.grey),
      );
    }
    return BoxDecoration(
      shape: shape,
      border: Border.all(color: borderColor ?? Theme.of(context).primaryColor),
      color: color ??
          (isButtonEnabled ? Theme.of(context).primaryColor : Colors.grey),
    );
  }
}

class CustomGradientButton extends StatelessWidget {
  const CustomGradientButton({
    super.key,
    required this.onSubmit,
    this.isButtonEnabled = true,
    this.isLoadingEnabled = false,
    this.showPercentage = false,
    this.showCircularLoader = true,
    this.customHeight,
    this.prefix,
    this.suffix,
    this.customWidthBetweenLabelAndSuffix,
    this.customWidthBetweenPrefixAndLabel,
    this.customCircularRadius,
    this.customWidth,
    this.customButtonFontSize,
    this.customButtonFontWeight,
    this.forDialog,
    this.style,
    required this.label,
    this.topColor = const Color.fromRGBO(4, 130, 176, 1),
    // this.bottomColor = const Color.fromRGBO(0, 130, 176, 1),
  });

  final VoidCallback onSubmit;
  final bool isButtonEnabled;
  final bool isLoadingEnabled;
  final bool showPercentage;
  final bool showCircularLoader;
  final String label;
  final TextStyle? style;
  final Color topColor;

  // final Color bottomColor;
  final double? customButtonFontSize;
  final FontWeight? customButtonFontWeight;
  final bool? forDialog;
  final double? customHeight;
  final double? customCircularRadius;
  final double? customWidth;
  final Widget? prefix;
  final Widget? suffix;
  final double? customWidthBetweenPrefixAndLabel;
  final double? customWidthBetweenLabelAndSuffix;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isButtonEnabled
          ? !isLoadingEnabled
              ? () {
                  // Close keyboard first
                  FocusScope.of(context).unfocus();

                  // Delay slightly to allow keyboard to close animation
                  Future.delayed(
                    const Duration(milliseconds: 100),
                    onSubmit,
                  );
                }
              : null
          : null,
      child: Container(
        height: customHeight ?? 6.h,
        width: forDialog == true ? 32.w : customWidth ?? 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(customCircularRadius ?? 10),
          color: isButtonEnabled ? topColor : Colors.grey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefix != null) prefix ?? const SizedBox.shrink(),
            if (prefix != null)
              SizedBox(width: customWidthBetweenPrefixAndLabel ?? 10),
            LoadingText(
              isLoading: isLoadingEnabled,
              label: label,
              style: style,
              showCircularLoader: showCircularLoader,
              showPercentage: showPercentage,
              customButtonFontSize: customButtonFontSize,
              customButtonFontWeight: customButtonFontWeight,
            ),
            if (suffix != null)
              SizedBox(width: customWidthBetweenLabelAndSuffix ?? 10),
            if (suffix != null) suffix ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class CustomCancelButton extends StatelessWidget {
  const CustomCancelButton({
    super.key,
    required this.label,
    required this.onSubmit,
    this.customWidth,
    this.style,
  });

  final String label;
  final double? customWidth;
  final VoidCallback onSubmit;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSubmit,
      child: Container(
        width: customWidth ?? 32.w,
        height: 6.h,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: style ??
                Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400,
                    ),
          ),
        ),
      ),
    );
  }
}
