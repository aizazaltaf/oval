import 'package:admin/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

// Test callback for intercepting toast calls
typedef ToastCallback = void Function(
  String type,
  String? title,
  String description,
);

mixin ToastUtils {
  // Test-only callback - will be null in production
  static ToastCallback? _testCallback;

  // Test-only method to set callback
  static Future<void> setTestCallback(ToastCallback? callback) async {
    _testCallback = callback;
  }

  // Test-only method to reset callback
  static void resetTestCallback() {
    _testCallback = null;
  }

  static void successToast(String description, {String? title}) {
    // Call test callback if set
    _testCallback?.call('success', title ?? 'Success', description);

    //  this function shows toast message on success
    Toastification().dismissAll();
    Toastification().show(
      type: ToastificationType.success,
      alignment: Alignment.bottomCenter,
      style: ToastificationStyle.minimal,
      foregroundColor: Colors.black,
      margin: const EdgeInsets.only(bottom: 50),
      backgroundColor: AppColors.successToastBg,
      closeOnClick: true,
      showProgressBar: false,
      primaryColor: AppColors.successToastPrimaryColors,
      dragToClose: true,
      autoCloseDuration: const Duration(seconds: 4),
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: AppColors.successToastPrimaryColors,
              ),
            ),
            const TextSpan(
              text: '  ',
              style: TextStyle(fontSize: 10),
            ),
            TextSpan(
              text: title ?? 'Success',
              style: TextStyle(
                color: AppColors.successToastPrimaryColors,
                fontSize: 16,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      description: Text(
        description,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: 'SF Pro Text',
          color: AppColors.darkBlueColor,
          fontSize: 12,
        ),
      ),
      showIcon: false,
      borderRadius: BorderRadius.circular(0),
      pauseOnHover: false,
      applyBlurEffect: false,
      closeButtonShowType: CloseButtonShowType.always,
    );
  }

  static void errorToast(
    String description, {
    String? title,
    Duration? duration,
    bool close = true,
  }) {
    // Call test callback if set
    _testCallback?.call('error', title ?? 'Error', description);

    //  this function shows toast message on error
    Toastification().dismissAll();
    Toastification().show(
      type: ToastificationType.error,
      alignment: Alignment.bottomCenter,
      style: ToastificationStyle.minimal,
      margin: const EdgeInsets.only(bottom: 50),
      backgroundColor: AppColors.errorToastBg,
      closeOnClick: close,
      foregroundColor: Colors.black,
      showProgressBar: false,
      primaryColor: AppColors.errorToastPrimaryColors,
      dragToClose: close,
      autoCloseDuration: duration ?? const Duration(seconds: 4),
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.cancel_rounded,
                size: 18,
                color: AppColors.errorToastPrimaryColors,
              ),
            ),
            const TextSpan(
              text: '  ',
              style: TextStyle(fontSize: 10),
            ),
            TextSpan(
              text: title ?? 'Error',
              style: TextStyle(
                color: AppColors.errorToastPrimaryColors,
                fontSize: 16,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      description: Text(
        description,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: 'SF Pro Text',
          color: AppColors.darkBlueColor,
          fontSize: 12,
        ),
      ),
      showIcon: false,
      borderRadius: BorderRadius.circular(0),
      pauseOnHover: false,
      applyBlurEffect: false,
      closeButtonShowType: CloseButtonShowType.always,
    );
  }

  static void warningToast(String msg) {
    // Call test callback if set
    _testCallback?.call('warning', 'Warning', msg);

    //  this function shows toast message on warning
    Toastification().dismissAll();
    Toastification().show(
      type: ToastificationType.warning,
      alignment: Alignment.bottomCenter,
      style: ToastificationStyle.minimal,
      margin: const EdgeInsets.only(bottom: 50),
      backgroundColor: AppColors.warningToastBg,
      closeOnClick: true,
      foregroundColor: Colors.black,
      showProgressBar: false,
      primaryColor: AppColors.warningToastPrimaryColors,
      dragToClose: true,
      autoCloseDuration: const Duration(seconds: 4),
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.error,
                size: 18,
                color: AppColors.warningToastPrimaryColors,
              ),
            ),
            const TextSpan(
              text: '  ',
              style: TextStyle(fontSize: 10),
            ),
            TextSpan(
              text: 'Warning',
              style: TextStyle(
                color: AppColors.warningToastPrimaryColors,
                fontSize: 16,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      description: Text(
        msg,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: 'SF Pro Text',
          color: AppColors.darkBlueColor,
          fontSize: 12,
        ),
      ),
      showIcon: false,
      borderRadius: BorderRadius.circular(0),
      pauseOnHover: false,
      applyBlurEffect: false,
      closeButtonShowType: CloseButtonShowType.always,
    );
  }

  static void infoToast(
    //  this function shows toast message on info
    String? title,
    String description, {
    int? time,
  }) {
    // Call test callback if set
    _testCallback?.call('info', title ?? 'Info', description);

    Toastification().dismissAll();
    Toastification().show(
      type: ToastificationType.info,
      alignment: Alignment.bottomCenter,
      style: ToastificationStyle.minimal,
      margin: const EdgeInsets.only(bottom: 50),
      foregroundColor: Colors.black,
      backgroundColor: AppColors.infoToastBg,
      closeOnClick: true,
      showProgressBar: false,
      primaryColor: AppColors.infoToastPrimaryColors,
      dragToClose: true,
      autoCloseDuration:
          (time == null) ? const Duration(seconds: 4) : Duration(seconds: time),
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.info_rounded,
                size: 18,
                color: AppColors.infoToastPrimaryColors,
              ),
            ),
            const TextSpan(
              text: '  ',
              style: TextStyle(fontSize: 10),
            ),
            TextSpan(
              text: title ?? 'Info',
              style: TextStyle(
                color: AppColors.infoToastPrimaryColors,
                fontSize: 16,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      description: Text(
        description,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: 'SF Pro Text',
          color: AppColors.darkBlueColor,
          fontSize: 12,
        ),
      ),
      showIcon: false,
      borderRadius: BorderRadius.circular(0),
      pauseOnHover: false,
      applyBlurEffect: false,
      closeButtonShowType: CloseButtonShowType.always,
    );
  }
}
