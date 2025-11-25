import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DualItemsBottomSheet extends StatelessWidget {
  const DualItemsBottomSheet({
    super.key,
    required this.firstButtonPressed,
    required this.secondButtonPressed,
    required this.title,
    required this.firstSvgLogo,
    required this.secondSvgLogo,
    required this.firstTitle,
    required this.secondTitle,
  });
  final VoidCallback firstButtonPressed;
  final VoidCallback secondButtonPressed;
  final String title;
  final String firstSvgLogo;
  final String secondSvgLogo;
  final String firstTitle;
  final String secondTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 40,
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: secondButtonPressed,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          firstSvgLogo,
                          width: 45,
                          colorFilter: ColorFilter.mode(
                            CommonFunctions.getThemeBasedWidgetColor(context),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Flexible(
                          child: Text(
                            firstTitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      CommonFunctions.getThemeBasedWidgetColor(
                                    context,
                                  ),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: firstButtonPressed,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          secondSvgLogo,
                          colorFilter: ColorFilter.mode(
                            CommonFunctions.getThemeBasedWidgetColor(context),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Flexible(
                          child: Text(
                            secondTitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      CommonFunctions.getThemeBasedWidgetColor(
                                    context,
                                  ),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
