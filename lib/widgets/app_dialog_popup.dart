import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class AppDialogPopup extends StatelessWidget {
  const AppDialogPopup({
    super.key,
    required this.title,
    this.description,
    this.headerWidget,
    this.isConfirmButtonEnabled = true,
    this.isLoadingEnabled = false,
    this.needCross = true,
    this.buttonGradientLabelStyle,
    this.buttonCancelLabelStyle,
    this.cancelButtonLabel,
    required this.confirmButtonLabel,
    this.cancelButtonOnTap,
    required this.confirmButtonOnTap,
  });
  final String title;
  final Widget? headerWidget;
  final String? description;
  final String? cancelButtonLabel;
  final TextStyle? buttonGradientLabelStyle;
  final TextStyle? buttonCancelLabelStyle;
  final bool isConfirmButtonEnabled;
  final bool isLoadingEnabled;
  final bool needCross;
  final String confirmButtonLabel;
  final VoidCallback? cancelButtonOnTap;
  final VoidCallback confirmButtonOnTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 100.w,
              child: Row(
                mainAxisAlignment: needCross
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (needCross)
                    SizedBox(width: 10.w)
                  else
                    const SizedBox.shrink(),
                  if (headerWidget == null)
                    const SizedBox.shrink()
                  else
                    headerWidget!,
                  if (needCross)
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: AppColors.darkBluePrimaryColor,
                          size: 26,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: headerWidget != null
                  ? 30
                  : needCross
                      ? 15
                      : 0,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: CommonFunctions.getThemeBasedWidgetColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            if (description == null)
              const SizedBox.shrink()
            else
              const SizedBox(height: 20),
            if (description == null)
              const SizedBox.shrink()
            else
              Text(
                description!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: CommonFunctions.getDialogDescriptionColor(context),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
              ),
            const SizedBox(height: 30),
            Theme(
              data: Theme.of(context).copyWith(
                textTheme: const TextTheme(
                  titleSmall: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              child: Column(
                children: [
                  CustomGradientButton(
                    onSubmit: confirmButtonOnTap,
                    isButtonEnabled: isConfirmButtonEnabled,
                    isLoadingEnabled: isLoadingEnabled,
                    label: confirmButtonLabel,
                    style: buttonGradientLabelStyle,
                  ),
                  if (cancelButtonLabel != null) const SizedBox(height: 20),
                  if (cancelButtonLabel == null)
                    const SizedBox.shrink()
                  else
                    CustomCancelButton(
                      label: cancelButtonLabel!,
                      customWidth: 100.w,
                      style: buttonCancelLabelStyle,
                      onSubmit: () => cancelButtonOnTap!(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
