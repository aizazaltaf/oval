import 'package:admin/extensions/context.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

Future<dynamic> showCustomDatePicker({
  required BuildContext context,
  List<DateTime?>? value,
  DateTime? lastDate,
  CalendarDatePicker2Type? calenderType,
  String? btnText,
}) {
  lastDate ??= DateTime.now();
  return showCalendarDatePicker2Dialog(
    context: context,
    dialogBackgroundColor:
        CommonFunctions.getThemePrimaryLightWhiteColor(context),
    config: CalendarDatePicker2WithActionButtonsConfig(
      calendarType: calenderType ?? CalendarDatePicker2Type.single,
      calendarViewMode: CalendarDatePicker2Mode.day,
      daySplashColor: Colors.transparent,
      // controlsHeight: 50,
      allowSameValueSelection: false,
      selectedRangeHighlightColor: AppColors.appBlue.withValues(alpha: 0.2),
      centerAlignModePicker: true,
      hideYearPickerDividers: true,
      disableModePicker: true,
      lastMonthIcon:
          calendarArrowIcon(context, icon: Icons.keyboard_arrow_left),
      nextMonthIcon:
          calendarArrowIcon(context, icon: Icons.keyboard_arrow_right),
      dynamicCalendarRows: true,
      selectedDayHighlightColor: AppColors.darkPrimaryColor,
      lastDate: lastDate,
      buttonPadding: const EdgeInsets.only(right: 50),
      cancelButton: const SizedBox.shrink(),
      okButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 6),
        // margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).primaryColor,
        ),
        child: Text(
          context.appLocalizations.set_date,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontSize: 18,
              ),
        ),
      ),
    ),
    dialogSize: const Size(325, 350),
    value: value ?? [],
    borderRadius: BorderRadius.circular(15),
  );
}

Future<DateTime?> showCustomDateTimePicker({
  required BuildContext context,
  TimeOfDay? initialTime,
}) async {
  final now = DateTime.now();
  initialTime ??= TimeOfDay.now();

  // Round up to next 30-minute slot
  DateTime initialDateTime = DateTime(
    now.year,
    now.month,
    now.day,
    initialTime.hour,
    (initialTime.minute + 29) ~/ 30 * 30 % 60,
  );
  if (initialTime.minute > 30) {
    initialDateTime = initialDateTime.add(const Duration(hours: 1));
  }

  final maxDateTime = initialDateTime.add(const Duration(hours: 24));

  // Step 1: Pick Date
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDateTime,
    firstDate: initialDateTime,
    lastDate: maxDateTime,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor,
          ),
        ),
        child: child!,
      );
    },
  );

  if (pickedDate == null) {
    return null;
  }

  if (!context.mounted) {
    return null;
  }
  // Step 2: Pick Time
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime:
        TimeOfDay(hour: initialDateTime.hour, minute: initialDateTime.minute),
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              dialHandColor: Theme.of(context).primaryColor,
              backgroundColor:
                  CommonFunctions.getThemePrimaryLightWhiteColor(context),
              hourMinuteShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hourMinuteTextColor: Colors.black,
              dayPeriodTextColor: Colors.black,
            ),
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        ),
      );
    },
  );

  if (pickedTime == null) {
    return null;
  }

  // Step 3: Combine and round time
  final DateTime selectedDateTime = DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );

  // if (pickedTime.minute > 30) {
  //   selectedDateTime = selectedDateTime.add(const Duration(hours: 1));
  // }

  // Step 4: Validate
  if (selectedDateTime.isBefore(DateTime.now())) {
    ToastUtils.errorToast(
      "Selected time is in the past. Please choose a valid future time.",
    );
    return null;
  }

  if (selectedDateTime.isAfter(maxDateTime)) {
    ToastUtils.errorToast("Selected time exceeds the 24-hour limit.");
    return null;
  }

  return selectedDateTime;
}

Widget calendarArrowIcon(BuildContext context, {required IconData icon}) {
  return Container(
    height: 36,
    width: 36,
    padding: icon == Icons.arrow_back_ios
        ? const EdgeInsets.only(left: 5)
        : EdgeInsets.zero,
    alignment: Alignment.center,
    decoration: ShapeDecoration(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      // color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
      shadows: const [
        BoxShadow(
          color: Color.fromRGBO(17, 12, 34, 0.5),
          blurRadius: 4.5,
          offset: Offset(0, 1),
          spreadRadius: -0.9,
          blurStyle: BlurStyle.outer,
        ),
      ],
    ),
    child: Icon(
      icon,
      color: CommonFunctions.getThemeBasedWidgetColor(context),
      size: 24,
    ),
  );
}
