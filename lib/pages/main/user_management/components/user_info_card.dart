import 'package:admin/constants.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
  });
  final String title;
  final String value;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    String code = "+1";
    if (title == Constants.phoneNumberTitle) {
      code = CommonFunctions.getDialCode(value);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: CommonFunctions.getThemeBasedWidgetColor(context),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 3.h,
        ),
        Row(
          children: [
            if (title == Constants.phoneNumberTitle)
              const SizedBox.shrink()
            else
              SizedBox(
                width: 5.w,
              ),
            if (title == Constants.phoneNumberTitle)
              CountryCodePicker(
                initialSelection: code == "+1" ? "US" : code,
                hideMainText: true,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                alignLeft: true,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: CommonFunctions.getThemeBasedWidgetColor(context),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                enabled: false,
              )
            else
              SvgPicture.asset(
                icon!,
                width: title == Constants.roleTitle ? 30 : 20,
                colorFilter: ColorFilter.mode(
                  CommonFunctions.getThemeBasedWidgetColor(context),
                  BlendMode.srcIn,
                ),
              ),
            if (title == Constants.phoneNumberTitle)
              const SizedBox.shrink()
            else
              SizedBox(
                width: 3.w,
              ),
            Expanded(
              child: Text(
                title == Constants.phoneNumberTitle
                    ? CommonFunctions.maskPhoneNumber(value)
                    : value,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: CommonFunctions.getThemeBasedWidgetColor(context),
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
