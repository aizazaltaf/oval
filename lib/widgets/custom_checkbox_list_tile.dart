import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// class CustomCheckboxListTile extends StatelessWidget {
//   const CustomCheckboxListTile({
//     super.key,
//     required this.value,
//     required this.onChanged,
//     required this.title,
//     this.terms,
//     this.radio = false,
//     this.style,
//   });
//   final bool value;
//   final bool radio;
//   final ValueChanged<bool?> onChanged;
//   final String title;
//   final TextStyle? style;
//   final String? terms;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       horizontalTitleGap: 5,
//       leading: SizedBox(
//         width: 24,
//         height: 24,
//         child: Center(
//           child: radio
//               ? Radio<bool>(
//                   value: true,
//                   groupValue: value,
//                   onChanged: (newValue) {
//                     if (newValue != null) {
//                       onChanged(newValue);
//                     }
//                   },
//                   activeColor: Theme.of(context).primaryColor,
//                   fillColor: value
//                       ? null
//                       : WidgetStatePropertyAll(AppColors.cancelButtonColor),
//                 )
//               // Custom Check Box
//               : GestureDetector(
//                   behavior: HitTestBehavior.opaque,
//                   onTap: () => onChanged(!value),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: value ? Theme.of(context).primaryColor : null,
//                       borderRadius: BorderRadius.circular(6),
//                       border: value
//                           ? null
//                           : Border.all(color: AppColors.cancelButtonColor),
//                     ),
//                     width: 20,
//                     height: 20,
//                     child: value
//                         ? const Icon(
//                             Icons.check_rounded,
//                             size: 14,
//                             color: Colors.white,
//                           )
//                         : null,
//                   ),
//                 ),
//           // : Checkbox(
//           //     value: value,
//           //     onChanged: onChanged,
//           //     activeColor: Theme.of(context).primaryColor,
//           //     shape: RoundedRectangleBorder(
//           //       borderRadius: BorderRadius.circular(4),
//           //     ),
//           //     side: BorderSide(
//           //       color: AppColors.cancelButtonColor,
//           //       width: 1.5,
//           //     ),
//           //   ),
//         ),
//       ),
//       title: RichText(
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: "$title ",
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () {
//                   if (radio) {
//                     // ✅ Only update if the radio is NOT already selected
//                     if (!value) {
//                       onChanged(true);
//                     }
//                   } else {
//                     // ✅ Toggle for Checkbox
//                     onChanged(!value);
//                   }
//                 },
//               style: style ??
//                   Theme.of(context).textTheme.headlineSmall!.copyWith(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//             ),
//             // the terms is for sign up page -> Terms and Conditions
//             if (terms != null)
//               TextSpan(
//                 text: terms,
//                 recognizer: TapGestureRecognizer()
//                   ..onTap =
//                       () => CommonFunctions.openUrl("https://www.google.com"),
//                 style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                       decoration: TextDecoration.underline,
//                       decorationColor: Theme.of(context).primaryColor,
//                       fontSize: 12,
//                       color: Theme.of(context).primaryColor,
//                       fontWeight: FontWeight.w500,
//                     ),
//               ),
//           ],
//         ),
//       ),
//       // onTap: () {
//       //   onChanged(!value);
//       // },
//     );
//   }
// }
class CustomCheckboxListTile extends StatelessWidget {
  const CustomCheckboxListTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.terms,
    this.radio = false,
    this.style,
  });

  final bool value;
  final bool radio;
  final ValueChanged<bool?> onChanged;
  final String title;
  final TextStyle? style;
  final String? terms;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // ✅ Ensures even empty areas catch taps
      onTap: () {
        if (radio) {
          if (!value) {
            onChanged(true);
          }
        } else {
          onChanged(!value);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6), // ✅ More tap area
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 5,
          minVerticalPadding: 0,
          dense: true,
          leading: SizedBox(
            width: 28, // ✅ Slightly bigger for easier touch
            height: 28,
            child: Center(
              child: radio
                  ? Radio<bool>(
                      value: true,
                      groupValue: value,
                      onChanged: (newValue) {
                        if (newValue != null) {
                          onChanged(newValue);
                        }
                      },
                      activeColor: Theme.of(context).primaryColor,
                      fillColor: value
                          ? null
                          : WidgetStatePropertyAll(AppColors.cancelButtonColor),
                    )
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(!value),
                      child: Container(
                        decoration: BoxDecoration(
                          color: value ? Theme.of(context).primaryColor : null,
                          borderRadius: BorderRadius.circular(6),
                          border: value
                              ? null
                              : Border.all(color: AppColors.cancelButtonColor),
                        ),
                        width: 22,
                        height: 22,
                        child: value
                            ? const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
            ),
          ),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$title ",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (radio) {
                        if (!value) {
                          onChanged(true);
                        }
                      } else {
                        onChanged(!value);
                      }
                    },
                  style: style ??
                      Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                ),
                if (terms != null)
                  TextSpan(
                    text: terms,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () =>
                          CommonFunctions.openUrl("https://www.google.com"),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).primaryColor,
                          fontSize: 13,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
