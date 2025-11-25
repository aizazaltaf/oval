import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'translations/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @home_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_dashboard;

  /// No description provided for @visitor_log_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Visitors'**
  String get visitor_log_dashboard;

  /// No description provided for @neighbourhood_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Neighbourhoods'**
  String get neighbourhood_dashboard;

  /// No description provided for @more_dashboard.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more_dashboard;

  /// No description provided for @visit_your_profile.
  ///
  /// In en, this message translates to:
  /// **'Visit your profile'**
  String get visit_your_profile;

  /// No description provided for @general_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get general_cancel;

  /// No description provided for @general_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get general_back;

  /// No description provided for @general_okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get general_okay;

  /// No description provided for @set_date.
  ///
  /// In en, this message translates to:
  /// **'Set Date'**
  String get set_date;

  /// No description provided for @no_device_found.
  ///
  /// In en, this message translates to:
  /// **'No Device Found'**
  String get no_device_found;

  /// No description provided for @grant_microphone_permission.
  ///
  /// In en, this message translates to:
  /// **'Please grant microphone access to proceed with voice control feature'**
  String get grant_microphone_permission;

  /// No description provided for @grant_microphone_permission_setting.
  ///
  /// In en, this message translates to:
  /// **'If you deny the permission then you need to go to app settings and grant the permission.\n Setting> Apps > Oval > Microphone'**
  String get grant_microphone_permission_setting;

  /// No description provided for @server_issue.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the server. Please check your connection.'**
  String get server_issue;

  /// No description provided for @voice_control.
  ///
  /// In en, this message translates to:
  /// **'Voice Control'**
  String get voice_control;

  /// No description provided for @voice_control_chat.
  ///
  /// In en, this message translates to:
  /// **'Voice Control Chat'**
  String get voice_control_chat;

  /// No description provided for @app_setting_microphone.
  ///
  /// In en, this message translates to:
  /// **'To use this feature, please grant microphone permission in the app settings.'**
  String get app_setting_microphone;

  /// No description provided for @open_setting.
  ///
  /// In en, this message translates to:
  /// **'Open\nSettings'**
  String get open_setting;

  /// No description provided for @microphone_permission_required.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission required'**
  String get microphone_permission_required;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @stable_wifi.
  ///
  /// In en, this message translates to:
  /// **'Make sure the Wi-Fi is stable'**
  String get stable_wifi;

  /// No description provided for @general_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get general_ok;

  /// No description provided for @room_icon.
  ///
  /// In en, this message translates to:
  /// **'Select Room Icon'**
  String get room_icon;

  /// No description provided for @general_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get general_skip;

  /// No description provided for @general_proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get general_proceed;

  /// No description provided for @general_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get general_name;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @add_room.
  ///
  /// In en, this message translates to:
  /// **'Add Room'**
  String get add_room;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @add_to_my_themes.
  ///
  /// In en, this message translates to:
  /// **'Add to My Themes'**
  String get add_to_my_themes;

  /// No description provided for @general_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get general_delete;

  /// No description provided for @choose_color.
  ///
  /// In en, this message translates to:
  /// **'Choose Color'**
  String get choose_color;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @time_zone.
  ///
  /// In en, this message translates to:
  /// **'Time Zone'**
  String get time_zone;

  /// No description provided for @general_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get general_no;

  /// No description provided for @select_modes.
  ///
  /// In en, this message translates to:
  /// **'Select Modes'**
  String get select_modes;

  /// No description provided for @goto_recording.
  ///
  /// In en, this message translates to:
  /// **'Goto Recordings'**
  String get goto_recording;

  /// No description provided for @general_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get general_yes;

  /// No description provided for @general_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get general_save;

  /// No description provided for @general_message.
  ///
  /// In en, this message translates to:
  /// **'Chat history'**
  String get general_message;

  /// No description provided for @authSelection_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSelection_signup;

  /// No description provided for @login_btnDone.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_btnDone;

  /// No description provided for @login_forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'FORGOT PASSWORD'**
  String get login_forgotPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @login_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get login_email;

  /// No description provided for @login_email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get login_email_address;

  /// No description provided for @login_errEmailReq.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get login_errEmailReq;

  /// No description provided for @login_errEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get login_errEmailInvalid;

  /// No description provided for @invalid_email_err.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email Address'**
  String get invalid_email_err;

  /// No description provided for @login_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get login_password;

  /// No description provided for @login_errPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Password does not match'**
  String get login_errPasswordMismatch;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get name;

  /// No description provided for @name_required.
  ///
  /// In en, this message translates to:
  /// **'Full Name is required'**
  String get name_required;

  /// No description provided for @doorbell_name_required.
  ///
  /// In en, this message translates to:
  /// **'Doorbell Name is required'**
  String get doorbell_name_required;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get number;

  /// No description provided for @password_strength.
  ///
  /// In en, this message translates to:
  /// **'Password strength:'**
  String get password_strength;

  /// No description provided for @password_strength_hint.
  ///
  /// In en, this message translates to:
  /// **'\"Password must be 8+ characters with at least 1 uppercase, 1 lowercase, 1 number, and 1 special character.\"'**
  String get password_strength_hint;

  /// No description provided for @least_8.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 character'**
  String get least_8;

  /// No description provided for @least_1.
  ///
  /// In en, this message translates to:
  /// **'Use at least 1 upper & 1 lower case character'**
  String get least_1;

  /// No description provided for @least_1_number.
  ///
  /// In en, this message translates to:
  /// **'Use at least 1 number & 1 special character'**
  String get least_1_number;

  /// No description provided for @password_min_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long.'**
  String get password_min_length;

  /// No description provided for @password_uppercase_required.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter.'**
  String get password_uppercase_required;

  /// No description provided for @password_lowercase_required.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter.'**
  String get password_lowercase_required;

  /// No description provided for @password_number_required.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number.'**
  String get password_number_required;

  /// No description provided for @password_special_character_required.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character.'**
  String get password_special_character_required;

  /// No description provided for @password_error_required.
  ///
  /// In en, this message translates to:
  /// **'The password you entered doesn’t meet the minimum security requirements.'**
  String get password_error_required;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get registration;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'RESEND NEW CODE'**
  String get resend;

  /// No description provided for @resend_in.
  ///
  /// In en, this message translates to:
  /// **'RESEND NEW CODE IN'**
  String get resend_in;

  /// No description provided for @did_not_get.
  ///
  /// In en, this message translates to:
  /// **'Didn’t get a verification code?'**
  String get did_not_get;

  /// No description provided for @message_otp.
  ///
  /// In en, this message translates to:
  /// **'A message with a verification code has been sent to (***) *****99. Enter code to continue.'**
  String get message_otp;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Phone Number'**
  String get verify;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'Otp'**
  String get otp;

  /// No description provided for @login_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get login_confirm_password;

  /// No description provided for @check_box.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the'**
  String get check_box;

  /// No description provided for @terms_and_condition.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get terms_and_condition;

  /// No description provided for @login_errPasswordReq.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get login_errPasswordReq;

  /// No description provided for @phone_number_required.
  ///
  /// In en, this message translates to:
  /// **'Phone Number is required'**
  String get phone_number_required;

  /// No description provided for @incorrect_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number is incorrect'**
  String get incorrect_phone_number;

  /// No description provided for @hint_email.
  ///
  /// In en, this message translates to:
  /// **'abc@example.com'**
  String get hint_email;

  /// No description provided for @hint_password.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get hint_password;

  /// No description provided for @imagePicker_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get imagePicker_camera;

  /// No description provided for @forget_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forget_password;

  /// No description provided for @do_you_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get do_you_have_account;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @already_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already_have_an_account;

  /// No description provided for @imagePicker_gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get imagePicker_gallery;

  /// No description provided for @enter_email_verification.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to receive a password reset link.'**
  String get enter_email_verification;

  /// No description provided for @send_recovery_link.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send_recovery_link;

  /// No description provided for @remember_password.
  ///
  /// In en, this message translates to:
  /// **'Remember Password?'**
  String get remember_password;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcome_back;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @add_doorbell_to_view_location.
  ///
  /// In en, this message translates to:
  /// **'Add doorbell to view location'**
  String get add_doorbell_to_view_location;

  /// No description provided for @add_doorbell_to_access_feature.
  ///
  /// In en, this message translates to:
  /// **'Add doorbell to access the feature.'**
  String get add_doorbell_to_access_feature;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the terms and condition'**
  String get agree;

  /// No description provided for @search_visitors.
  ///
  /// In en, this message translates to:
  /// **'Search visitors here...'**
  String get search_visitors;

  /// No description provided for @search_themes.
  ///
  /// In en, this message translates to:
  /// **'Search themes here (Min 3 characters)'**
  String get search_themes;

  /// No description provided for @visitor_management.
  ///
  /// In en, this message translates to:
  /// **'Visitors'**
  String get visitor_management;

  /// No description provided for @enter_otp_code.
  ///
  /// In en, this message translates to:
  /// **'Enter your OTP code here'**
  String get enter_otp_code;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get no_internet_connection;

  /// No description provided for @shop_doorbell_url.
  ///
  /// In en, this message translates to:
  /// **'https://sale.irvinei.com/products/irvinei-ai-powered-touchscreen-doorbell?_gl=1*1srqyzn*_ga*MTEyMjQzNjc4My4xNzIxNDkxNjg5*_ga_J2RRNQXP0Q*MTcyMTc0NzgyOC4xLjAuMTcyMTc0Nzg5MC4wLjAuMA..*_gcl_au*MzA3NDQ1MTM1LjE3MjE0OTE2ODk.*_ga_C79Y2J9E57*MTcyMTc0Nzg0NS4zLjAuMTcyMTc0Nzg5MC4wLjAuMA..'**
  String get shop_doorbell_url;

  /// No description provided for @themes.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themes;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @my_themes.
  ///
  /// In en, this message translates to:
  /// **'My Themes'**
  String get my_themes;

  /// No description provided for @view_all_theme.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all_theme;

  /// No description provided for @set_to_doorbell_screen.
  ///
  /// In en, this message translates to:
  /// **'Set to Doorbell'**
  String get set_to_doorbell_screen;

  /// No description provided for @shop_doorbell.
  ///
  /// In en, this message translates to:
  /// **'Shop Doorbell'**
  String get shop_doorbell;

  /// No description provided for @scan_a_doorbell.
  ///
  /// In en, this message translates to:
  /// **'Scan a Doorbell'**
  String get scan_a_doorbell;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @quick_access.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quick_access;

  /// No description provided for @free_trial.
  ///
  /// In en, this message translates to:
  /// **'free trial'**
  String get free_trial;

  /// No description provided for @upgrade_now.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get upgrade_now;

  /// No description provided for @guard_basic.
  ///
  /// In en, this message translates to:
  /// **'guard basic'**
  String get guard_basic;

  /// No description provided for @guard_pro.
  ///
  /// In en, this message translates to:
  /// **'guard pro'**
  String get guard_pro;

  /// No description provided for @guard_free.
  ///
  /// In en, this message translates to:
  /// **'Guard Free'**
  String get guard_free;

  /// No description provided for @password_reset_link.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email. Check your spam folder if not received.'**
  String get password_reset_link;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @invite_a_friend_and_Neighbour.
  ///
  /// In en, this message translates to:
  /// **'Invite a friend/Neighbour'**
  String get invite_a_friend_and_Neighbour;

  /// No description provided for @logged_in_devices.
  ///
  /// In en, this message translates to:
  /// **'Logged-In Devices'**
  String get logged_in_devices;

  /// No description provided for @general_information.
  ///
  /// In en, this message translates to:
  /// **'General Information'**
  String get general_information;

  /// No description provided for @terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_and_conditions;

  /// No description provided for @whats_new.
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get whats_new;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @invalid_password.
  ///
  /// In en, this message translates to:
  /// **'Invalid Password'**
  String get invalid_password;

  /// No description provided for @logout_popup_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logout_popup_title;

  /// No description provided for @c.
  ///
  /// In en, this message translates to:
  /// **'Monitor Cameras'**
  String get c;

  /// No description provided for @two_section_warning.
  ///
  /// In en, this message translates to:
  /// **'Two sections at a time can be pinned.'**
  String get two_section_warning;

  /// No description provided for @search_camera_here.
  ///
  /// In en, this message translates to:
  /// **'Search camera here....'**
  String get search_camera_here;

  /// No description provided for @three_cameras_warning.
  ///
  /// In en, this message translates to:
  /// **'Three cameras/doorbell at a time can be pinned.'**
  String get three_cameras_warning;

  /// No description provided for @coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get coming_soon;

  /// No description provided for @visitor_book_available_soon.
  ///
  /// In en, this message translates to:
  /// **'Visitor Book will be available soon.'**
  String get visitor_book_available_soon;

  /// No description provided for @neighbourhood_available_soon.
  ///
  /// In en, this message translates to:
  /// **'Neighbourhoods will be available soon.'**
  String get neighbourhood_available_soon;

  /// No description provided for @share_to_neighbourhood_available_soon.
  ///
  /// In en, this message translates to:
  /// **'Share to Neighborhood will be available soon.'**
  String get share_to_neighbourhood_available_soon;

  /// No description provided for @message_available_soon.
  ///
  /// In en, this message translates to:
  /// **'Chat history will be available soon.'**
  String get message_available_soon;

  /// No description provided for @payment_history_available_soon.
  ///
  /// In en, this message translates to:
  /// **'Payment History will be available soon.'**
  String get payment_history_available_soon;

  /// No description provided for @feature_guide_available_soon.
  ///
  /// In en, this message translates to:
  /// **'Feature Guide will be available soon.'**
  String get feature_guide_available_soon;

  /// No description provided for @modes_settings_available_soon.
  ///
  /// In en, this message translates to:
  /// **'Modes Settings will be available soon.'**
  String get modes_settings_available_soon;

  /// No description provided for @payment_methods_available_soon.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods will be available soon.'**
  String get payment_methods_available_soon;

  /// No description provided for @system_modes_available_soon.
  ///
  /// In en, this message translates to:
  /// **'System Modes will be available soon.'**
  String get system_modes_available_soon;

  /// No description provided for @clear_filters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clear_filters;

  /// No description provided for @clear_filter.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get clear_filter;

  /// No description provided for @no_records_available.
  ///
  /// In en, this message translates to:
  /// **'No records available'**
  String get no_records_available;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @this_week.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get this_week;

  /// No description provided for @this_month.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get this_month;

  /// No description provided for @last_month.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get last_month;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @sent_email.
  ///
  /// In en, this message translates to:
  /// **'Email Verification Sent'**
  String get sent_email;

  /// No description provided for @sent_email_desc_1.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification email to '**
  String get sent_email_desc_1;

  /// No description provided for @sent_email_desc_2.
  ///
  /// In en, this message translates to:
  /// **'. Please check your inbox and spam folder if you don\'t see it.'**
  String get sent_email_desc_2;

  /// No description provided for @click_to_verify.
  ///
  /// In en, this message translates to:
  /// **'Click on the email verification link sent to you on '**
  String get click_to_verify;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @start_chat.
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get start_chat;

  /// No description provided for @video_call.
  ///
  /// In en, this message translates to:
  /// **'Video Call'**
  String get video_call;

  /// No description provided for @audio_call.
  ///
  /// In en, this message translates to:
  /// **'Audio Call'**
  String get audio_call;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @visitor_management_delete_dialog_desc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this visitor?'**
  String get visitor_management_delete_dialog_desc;

  /// No description provided for @delete_visitor.
  ///
  /// In en, this message translates to:
  /// **'Delete Visitor'**
  String get delete_visitor;

  /// No description provided for @delete_user.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get delete_user;

  /// No description provided for @delete_iot_device.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this device?'**
  String get delete_iot_device;

  /// No description provided for @delete_multi_camera.
  ///
  /// In en, this message translates to:
  /// **'Deleting this EZVIZ camera will also remove all connected EZVIZ cameras. Do you want to continue?'**
  String get delete_multi_camera;

  /// No description provided for @visitor_history.
  ///
  /// In en, this message translates to:
  /// **'Visitor History'**
  String get visitor_history;

  /// No description provided for @edit_name.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get edit_name;

  /// No description provided for @add_in_unwanted_visitor_list.
  ///
  /// In en, this message translates to:
  /// **'Add in unwanted visitor'**
  String get add_in_unwanted_visitor_list;

  /// No description provided for @remove_from_unwanted_list.
  ///
  /// In en, this message translates to:
  /// **'Remove from unwanted visitor'**
  String get remove_from_unwanted_list;

  /// No description provided for @share_to_neighbourhood.
  ///
  /// In en, this message translates to:
  /// **'Share to Neighborhood'**
  String get share_to_neighbourhood;

  /// No description provided for @smart_devices.
  ///
  /// In en, this message translates to:
  /// **'Smart Devices'**
  String get smart_devices;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @turnUnlock.
  ///
  /// In en, this message translates to:
  /// **'lock/unlock'**
  String get turnUnlock;

  /// No description provided for @turnLock.
  ///
  /// In en, this message translates to:
  /// **'lock/lock'**
  String get turnLock;

  /// No description provided for @turnOn.
  ///
  /// In en, this message translates to:
  /// **'light/turn_on'**
  String get turnOn;

  /// No description provided for @turnOff.
  ///
  /// In en, this message translates to:
  /// **'light/turn_off'**
  String get turnOff;

  /// No description provided for @climate.
  ///
  /// In en, this message translates to:
  /// **'climate'**
  String get climate;

  /// No description provided for @switchBot.
  ///
  /// In en, this message translates to:
  /// **'switchbot'**
  String get switchBot;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'camera'**
  String get camera;

  /// No description provided for @lock.
  ///
  /// In en, this message translates to:
  /// **'lock'**
  String get lock;

  /// No description provided for @add_unwanted_visitor_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Mark as Unwanted?'**
  String get add_unwanted_visitor_dialog_title;

  /// No description provided for @add_unwanted_visitor_dialog_desc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to mark this visitor to unwanted visitor list?'**
  String get add_unwanted_visitor_dialog_desc;

  /// No description provided for @remove_unwanted_visitor_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Remove from Unwanted?'**
  String get remove_unwanted_visitor_dialog_title;

  /// No description provided for @remove_unwanted_visitor_dialog_desc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this visitor from the unwanted visitor list?'**
  String get remove_unwanted_visitor_dialog_desc;

  /// No description provided for @hint_visitor_name.
  ///
  /// In en, this message translates to:
  /// **'Enter visitor name'**
  String get hint_visitor_name;

  /// No description provided for @no_samples.
  ///
  /// In en, this message translates to:
  /// **'No samples available for display.'**
  String get no_samples;

  /// No description provided for @edit_visitor_errRequired.
  ///
  /// In en, this message translates to:
  /// **'Visitor name cannot be empty or have special characters or numbers'**
  String get edit_visitor_errRequired;

  /// No description provided for @edit_visitor_errMinLength.
  ///
  /// In en, this message translates to:
  /// **'Visitor name must be at least 3 characters long.'**
  String get edit_visitor_errMinLength;

  /// No description provided for @edit_visitor_errMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Visitor name must be more than 25 characters long.'**
  String get edit_visitor_errMaxLength;

  /// No description provided for @delete_visitor_history_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove the visitor record(s)?'**
  String get delete_visitor_history_dialog_title;

  /// No description provided for @delete_visits_errCheckBox.
  ///
  /// In en, this message translates to:
  /// **'Please select at least any checkbox to delete visits.'**
  String get delete_visits_errCheckBox;

  /// No description provided for @unwanted_visitor.
  ///
  /// In en, this message translates to:
  /// **'Unwanted Visitor'**
  String get unwanted_visitor;

  /// No description provided for @peak_visiting_hours.
  ///
  /// In en, this message translates to:
  /// **'Peak Visiting Hours'**
  String get peak_visiting_hours;

  /// No description provided for @days_of_the_week.
  ///
  /// In en, this message translates to:
  /// **'Days of the Week'**
  String get days_of_the_week;

  /// No description provided for @frequency_of_visits.
  ///
  /// In en, this message translates to:
  /// **'Frequency of Visits'**
  String get frequency_of_visits;

  /// No description provided for @unknown_visitors.
  ///
  /// In en, this message translates to:
  /// **'Unknown Visitors'**
  String get unknown_visitors;

  /// No description provided for @timings.
  ///
  /// In en, this message translates to:
  /// **'Timings'**
  String get timings;

  /// No description provided for @add_doorbell.
  ///
  /// In en, this message translates to:
  /// **'Add Doorbell'**
  String get add_doorbell;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @described_desired_themes.
  ///
  /// In en, this message translates to:
  /// **'Describe your desired theme'**
  String get described_desired_themes;

  /// No description provided for @create_a_theme.
  ///
  /// In en, this message translates to:
  /// **'Customized Theme'**
  String get create_a_theme;

  /// No description provided for @file_size_5_mb.
  ///
  /// In en, this message translates to:
  /// **'Please select file less than 5 mb'**
  String get file_size_5_mb;

  /// No description provided for @correct_image_error.
  ///
  /// In en, this message translates to:
  /// **'Please upload the correct image'**
  String get correct_image_error;

  /// No description provided for @correct_gif_error.
  ///
  /// In en, this message translates to:
  /// **'Please upload the correct gif'**
  String get correct_gif_error;

  /// No description provided for @correct_video_error.
  ///
  /// In en, this message translates to:
  /// **'Please upload the correct video'**
  String get correct_video_error;

  /// No description provided for @uploading_format.
  ///
  /// In en, this message translates to:
  /// **'Please upload the format in the following formats: .png, .jpg, .jpeg, .gif, .mp4, .mov'**
  String get uploading_format;

  /// No description provided for @purchase_doorbell.
  ///
  /// In en, this message translates to:
  /// **'Purchase/add an Irvinei Doorbell to have full access to themes.'**
  String get purchase_doorbell;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @name_of_visitors.
  ///
  /// In en, this message translates to:
  /// **'Name of Visitors'**
  String get name_of_visitors;

  /// No description provided for @no_of_visits.
  ///
  /// In en, this message translates to:
  /// **'No. of Visits'**
  String get no_of_visits;

  /// No description provided for @no_of_visitors.
  ///
  /// In en, this message translates to:
  /// **'No. of Visitors'**
  String get no_of_visitors;

  /// No description provided for @smart.
  ///
  /// In en, this message translates to:
  /// **'smart'**
  String get smart;

  /// No description provided for @monitor.
  ///
  /// In en, this message translates to:
  /// **'monitor'**
  String get monitor;

  /// No description provided for @feature.
  ///
  /// In en, this message translates to:
  /// **'feature'**
  String get feature;

  /// No description provided for @monitor_cameras.
  ///
  /// In en, this message translates to:
  /// **'Monitor Cameras'**
  String get monitor_cameras;

  /// No description provided for @recent_devices.
  ///
  /// In en, this message translates to:
  /// **'Recent Devices'**
  String get recent_devices;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @no_rooms.
  ///
  /// In en, this message translates to:
  /// **'No rooms added.'**
  String get no_rooms;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @room_name.
  ///
  /// In en, this message translates to:
  /// **'Room Name'**
  String get room_name;

  /// No description provided for @enter_room_name.
  ///
  /// In en, this message translates to:
  /// **'Enter Room Name'**
  String get enter_room_name;

  /// No description provided for @recent_rooms.
  ///
  /// In en, this message translates to:
  /// **'Recent Rooms'**
  String get recent_rooms;

  /// No description provided for @smart_control_panel.
  ///
  /// In en, this message translates to:
  /// **'Smart Home Control Panel'**
  String get smart_control_panel;

  /// No description provided for @recently_used.
  ///
  /// In en, this message translates to:
  /// **'Recently used devices will be'**
  String get recently_used;

  /// No description provided for @listed_here.
  ///
  /// In en, this message translates to:
  /// **'listed here.'**
  String get listed_here;

  /// No description provided for @living_room.
  ///
  /// In en, this message translates to:
  /// **'Living Room'**
  String get living_room;

  /// No description provided for @by_date.
  ///
  /// In en, this message translates to:
  /// **'By Date'**
  String get by_date;

  /// No description provided for @by_alert.
  ///
  /// In en, this message translates to:
  /// **'By Alert'**
  String get by_alert;

  /// No description provided for @by_device.
  ///
  /// In en, this message translates to:
  /// **'By Device'**
  String get by_device;

  /// No description provided for @one_way_calling.
  ///
  /// In en, this message translates to:
  /// **'One Way Calling'**
  String get one_way_calling;

  /// No description provided for @two_way_calling.
  ///
  /// In en, this message translates to:
  /// **'Two Way Calling'**
  String get two_way_calling;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get recording;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading ...'**
  String get loading;

  /// No description provided for @already_configured.
  ///
  /// In en, this message translates to:
  /// **'Device already configured'**
  String get already_configured;

  /// No description provided for @invite_friend_neighbour_available_soon.
  ///
  /// In en, this message translates to:
  /// **'Invite a friend/Neighbour will be available soon.'**
  String get invite_friend_neighbour_available_soon;

  /// No description provided for @general_information_available_soon.
  ///
  /// In en, this message translates to:
  /// **'General Information will be available soon.'**
  String get general_information_available_soon;

  /// No description provided for @terms_and_conditions_available_soon.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions will be available soon.'**
  String get terms_and_conditions_available_soon;

  /// No description provided for @whats_new_available_soon.
  ///
  /// In en, this message translates to:
  /// **'What\'s New will be available soon.'**
  String get whats_new_available_soon;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @select_an_item.
  ///
  /// In en, this message translates to:
  /// **'Select an Item'**
  String get select_an_item;

  /// No description provided for @select_room.
  ///
  /// In en, this message translates to:
  /// **'Select Room'**
  String get select_room;

  /// No description provided for @select_position.
  ///
  /// In en, this message translates to:
  /// **'Camera Location'**
  String get select_position;

  /// No description provided for @start_two_way.
  ///
  /// In en, this message translates to:
  /// **'Start two way video call'**
  String get start_two_way;

  /// No description provided for @start_one_way.
  ///
  /// In en, this message translates to:
  /// **'Start one way video call'**
  String get start_one_way;

  /// No description provided for @video_call_dialog_description.
  ///
  /// In en, this message translates to:
  /// **'Please choose your preferred call type.'**
  String get video_call_dialog_description;

  /// No description provided for @no_records_available_for_this_search.
  ///
  /// In en, this message translates to:
  /// **'No records available for this search.'**
  String get no_records_available_for_this_search;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @change_password_button.
  ///
  /// In en, this message translates to:
  /// **'Change Password?'**
  String get change_password_button;

  /// No description provided for @edit_profile_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get edit_profile_name;

  /// No description provided for @edit_profile_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get edit_profile_email;

  /// No description provided for @edit_profile_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get edit_profile_phone_number;

  /// No description provided for @update_profile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get update_profile;

  /// No description provided for @enter_password_confirm_changes.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to confirm changes.'**
  String get enter_password_confirm_changes;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @old_password.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get old_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @old_password_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid password. For password recovery, log out and click \'Forgot Password\' on login screen'**
  String get old_password_error;

  /// No description provided for @new_password_error.
  ///
  /// In en, this message translates to:
  /// **'Old and new password cannot be same'**
  String get new_password_error;

  /// No description provided for @new_password_security_error.
  ///
  /// In en, this message translates to:
  /// **'The password you entered does not meet the minimum security requirements'**
  String get new_password_security_error;

  /// No description provided for @confirm_change_password_error.
  ///
  /// In en, this message translates to:
  /// **'Confirm password must match new password'**
  String get confirm_change_password_error;

  /// No description provided for @resend_email_verification.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get resend_email_verification;

  /// No description provided for @email_not_verified.
  ///
  /// In en, this message translates to:
  /// **'Email Not Verified'**
  String get email_not_verified;

  /// No description provided for @resend_dialog_text.
  ///
  /// In en, this message translates to:
  /// **'Your email is not verified. Please check your inbox and verify your email to continue.'**
  String get resend_dialog_text;

  /// No description provided for @email_verification.
  ///
  /// In en, this message translates to:
  /// **'Email Verification'**
  String get email_verification;

  /// No description provided for @no_notification_found.
  ///
  /// In en, this message translates to:
  /// **'No Notification'**
  String get no_notification_found;

  /// No description provided for @visitor_has_left.
  ///
  /// In en, this message translates to:
  /// **'Visitor has Left'**
  String get visitor_has_left;

  /// No description provided for @visitor_left.
  ///
  /// In en, this message translates to:
  /// **'Looks like your visitor has gone. Click on the notification to view recording.'**
  String get visitor_left;

  /// No description provided for @no_device_available.
  ///
  /// In en, this message translates to:
  /// **'No Device Available'**
  String get no_device_available;

  /// No description provided for @no_brands_available.
  ///
  /// In en, this message translates to:
  /// **'No Brands Available'**
  String get no_brands_available;

  /// No description provided for @exit_popup.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit? This will terminate the setup process, and you will need to restart'**
  String get exit_popup;

  /// No description provided for @unable_location.
  ///
  /// In en, this message translates to:
  /// **'Unable to get your location. Please try again or restart the device'**
  String get unable_location;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @unique_doorbellName.
  ///
  /// In en, this message translates to:
  /// **'Doorbell name must be unique at the same location.'**
  String get unique_doorbellName;

  /// No description provided for @unique_cameraName.
  ///
  /// In en, this message translates to:
  /// **'Camera name must be unique at the same location.'**
  String get unique_cameraName;

  /// No description provided for @create_room_first.
  ///
  /// In en, this message translates to:
  /// **'Please create a room first'**
  String get create_room_first;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @applied_filter.
  ///
  /// In en, this message translates to:
  /// **' against the Applied Filter'**
  String get applied_filter;

  /// No description provided for @user_management.
  ///
  /// In en, this message translates to:
  /// **'Manage Users'**
  String get user_management;

  /// No description provided for @user_info.
  ///
  /// In en, this message translates to:
  /// **'User Info'**
  String get user_info;

  /// No description provided for @search_user_here.
  ///
  /// In en, this message translates to:
  /// **'Search user here...'**
  String get search_user_here;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @select_role.
  ///
  /// In en, this message translates to:
  /// **'Select role'**
  String get select_role;

  /// No description provided for @delete_user_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete user?'**
  String get delete_user_dialog_title;

  /// No description provided for @delete_room_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete room?'**
  String get delete_room_dialog_title;

  /// No description provided for @room_deleted.
  ///
  /// In en, this message translates to:
  /// **'Room successfully deleted'**
  String get room_deleted;

  /// No description provided for @add_new_user.
  ///
  /// In en, this message translates to:
  /// **'Add New User'**
  String get add_new_user;

  /// No description provided for @add_user.
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get add_user;

  /// No description provided for @name_only.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name_only;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @select_relationship.
  ///
  /// In en, this message translates to:
  /// **'Select relationship'**
  String get select_relationship;

  /// No description provided for @user_email_address_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter Email Address'**
  String get user_email_address_hint;

  /// No description provided for @user_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get user_name_hint;

  /// No description provided for @user_phone_number_hint.
  ///
  /// In en, this message translates to:
  /// **'3001234567'**
  String get user_phone_number_hint;

  /// No description provided for @user_relation_hint.
  ///
  /// In en, this message translates to:
  /// **'i.e: Friend, Brother, Wife ...'**
  String get user_relation_hint;

  /// No description provided for @name_required_error.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get name_required_error;

  /// No description provided for @device_name_required_error.
  ///
  /// In en, this message translates to:
  /// **'Device name is required'**
  String get device_name_required_error;

  /// No description provided for @connecting_near_device.
  ///
  /// In en, this message translates to:
  /// **'Connecting to Nearby Devices'**
  String get connecting_near_device;

  /// No description provided for @relation_required_error.
  ///
  /// In en, this message translates to:
  /// **'Relation is required'**
  String get relation_required_error;

  /// No description provided for @email_unique_error.
  ///
  /// In en, this message translates to:
  /// **'Email should be unique'**
  String get email_unique_error;

  /// No description provided for @login_activity.
  ///
  /// In en, this message translates to:
  /// **'Login Activity'**
  String get login_activity;

  /// No description provided for @scan_doorbell.
  ///
  /// In en, this message translates to:
  /// **'Scan Doorbell'**
  String get scan_doorbell;

  /// No description provided for @scan_barcode_on_doorbell.
  ///
  /// In en, this message translates to:
  /// **'Scan the barcode displayed on the Doorbell'**
  String get scan_barcode_on_doorbell;

  /// No description provided for @meter_radius_doorbell.
  ///
  /// In en, this message translates to:
  /// **'You can adjust the marker within a 10-meter radius.'**
  String get meter_radius_doorbell;

  /// No description provided for @location_marker_text.
  ///
  /// In en, this message translates to:
  /// **'* This address is based on the map location. You can tap the pointer on the map to adjust the location within a 10-meter radius for more accurate/precise location mark.'**
  String get location_marker_text;

  /// No description provided for @logout_all_sessions.
  ///
  /// In en, this message translates to:
  /// **'Logout of all Sessions'**
  String get logout_all_sessions;

  /// No description provided for @logins.
  ///
  /// In en, this message translates to:
  /// **'Logins'**
  String get logins;

  /// No description provided for @current_session.
  ///
  /// In en, this message translates to:
  /// **'Current Session'**
  String get current_session;

  /// No description provided for @search_location.
  ///
  /// In en, this message translates to:
  /// **'Search location'**
  String get search_location;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @locations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locations;

  /// No description provided for @release.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get release;

  /// No description provided for @admin_viewer_release_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to release your location access?\n\nOnce released, you will no longer be able to interact with connected devices.'**
  String get admin_viewer_release_title;

  /// No description provided for @location_release.
  ///
  /// In en, this message translates to:
  /// **'Location Release'**
  String get location_release;

  /// No description provided for @ownership_transfer.
  ///
  /// In en, this message translates to:
  /// **'Ownership Transfer'**
  String get ownership_transfer;

  /// No description provided for @owner_release_desc.
  ///
  /// In en, this message translates to:
  /// **'Releasing will revoke access for you and all other users, including connected devices.'**
  String get owner_release_desc;

  /// No description provided for @owner_release_title.
  ///
  /// In en, this message translates to:
  /// **'it is recommended to transfer ownership instead of releasing the location.'**
  String get owner_release_title;

  /// No description provided for @select_user_role.
  ///
  /// In en, this message translates to:
  /// **'Select User Role'**
  String get select_user_role;

  /// No description provided for @your_doorbell_location.
  ///
  /// In en, this message translates to:
  /// **'Your Doorbell Location'**
  String get your_doorbell_location;

  /// No description provided for @upload_theme_on_doorbell.
  ///
  /// In en, this message translates to:
  /// **'Upload Theme On Doorbell'**
  String get upload_theme_on_doorbell;

  /// No description provided for @house_no.
  ///
  /// In en, this message translates to:
  /// **'House No.#'**
  String get house_no;

  /// No description provided for @street_block_no.
  ///
  /// In en, this message translates to:
  /// **'Street # / Block'**
  String get street_block_no;

  /// No description provided for @location_required.
  ///
  /// In en, this message translates to:
  /// **'Location name is required'**
  String get location_required;

  /// No description provided for @address_required.
  ///
  /// In en, this message translates to:
  /// **'House no. is required'**
  String get address_required;

  /// No description provided for @street_block_no_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get street_block_no_required;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @house.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get house;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @enter_theme_name.
  ///
  /// In en, this message translates to:
  /// **'Enter Theme Name'**
  String get enter_theme_name;

  /// No description provided for @theme_name.
  ///
  /// In en, this message translates to:
  /// **'Theme Name'**
  String get theme_name;

  /// No description provided for @add_theme_info.
  ///
  /// In en, this message translates to:
  /// **'Add Theme Info'**
  String get add_theme_info;

  /// No description provided for @theme_preview.
  ///
  /// In en, this message translates to:
  /// **'Theme Preview'**
  String get theme_preview;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @delete_theme_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this theme?'**
  String get delete_theme_dialog_title;

  /// No description provided for @apply_theme_on_doorbell.
  ///
  /// In en, this message translates to:
  /// **'Apply Theme'**
  String get apply_theme_on_doorbell;

  /// No description provided for @upload_theme.
  ///
  /// In en, this message translates to:
  /// **'Upload Theme'**
  String get upload_theme;

  /// No description provided for @new_location.
  ///
  /// In en, this message translates to:
  /// **'New Location'**
  String get new_location;

  /// No description provided for @add_to_favourite.
  ///
  /// In en, this message translates to:
  /// **'Add To\nFavorites'**
  String get add_to_favourite;

  /// No description provided for @set_to_doorbell.
  ///
  /// In en, this message translates to:
  /// **'Set It to\nDoorbell'**
  String get set_to_doorbell;

  /// No description provided for @remove_favourite.
  ///
  /// In en, this message translates to:
  /// **'Remove \nFavorite'**
  String get remove_favourite;

  /// No description provided for @remove_from_doorbell.
  ///
  /// In en, this message translates to:
  /// **'Remove from\nDoorbell'**
  String get remove_from_doorbell;

  /// No description provided for @applied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get applied;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @location_name_must_be_unique.
  ///
  /// In en, this message translates to:
  /// **'Location name must be unique.'**
  String get location_name_must_be_unique;

  /// No description provided for @name_doorbell.
  ///
  /// In en, this message translates to:
  /// **'Would you like to name this IRVINEI doorbell?'**
  String get name_doorbell;

  /// No description provided for @enter_doorbell_name.
  ///
  /// In en, this message translates to:
  /// **'Enter Doorbell Name'**
  String get enter_doorbell_name;

  /// No description provided for @doorbell_success.
  ///
  /// In en, this message translates to:
  /// **'Doorbell added successfully'**
  String get doorbell_success;

  /// No description provided for @supported_brands.
  ///
  /// In en, this message translates to:
  /// **'Supported Brands'**
  String get supported_brands;

  /// No description provided for @device_success.
  ///
  /// In en, this message translates to:
  /// **'Device added successfully'**
  String get device_success;

  /// No description provided for @add_new_device.
  ///
  /// In en, this message translates to:
  /// **'Add New Device'**
  String get add_new_device;

  /// No description provided for @device_name.
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get device_name;

  /// No description provided for @device_type.
  ///
  /// In en, this message translates to:
  /// **'Device Type'**
  String get device_type;

  /// No description provided for @device_name_exist.
  ///
  /// In en, this message translates to:
  /// **'Device name already exists'**
  String get device_name_exist;

  /// No description provided for @add_manually.
  ///
  /// In en, this message translates to:
  /// **'Add Manually'**
  String get add_manually;

  /// No description provided for @on_network.
  ///
  /// In en, this message translates to:
  /// **'On Network'**
  String get on_network;

  /// No description provided for @connected_on_irvinei_app.
  ///
  /// In en, this message translates to:
  /// **'Connected on Irvinei App'**
  String get connected_on_irvinei_app;

  /// No description provided for @all_devices.
  ///
  /// In en, this message translates to:
  /// **'All Devices'**
  String get all_devices;

  /// No description provided for @doorbell_controls.
  ///
  /// In en, this message translates to:
  /// **'Doorbell Controls'**
  String get doorbell_controls;

  /// No description provided for @camera_controls.
  ///
  /// In en, this message translates to:
  /// **'Camera Controls'**
  String get camera_controls;

  /// No description provided for @doorbell_name.
  ///
  /// In en, this message translates to:
  /// **'Doorbell Name'**
  String get doorbell_name;

  /// No description provided for @camera_name.
  ///
  /// In en, this message translates to:
  /// **'Camera Name'**
  String get camera_name;

  /// No description provided for @bottom_text.
  ///
  /// In en, this message translates to:
  /// **'Bottom Text'**
  String get bottom_text;

  /// No description provided for @new_notification.
  ///
  /// In en, this message translates to:
  /// **'New Notification(s) Available'**
  String get new_notification;

  /// No description provided for @new_visitor.
  ///
  /// In en, this message translates to:
  /// **'New Visitor(s) has Arrived'**
  String get new_visitor;

  /// No description provided for @release_doorbell.
  ///
  /// In en, this message translates to:
  /// **'Release Doorbell'**
  String get release_doorbell;

  /// No description provided for @are_sure_to_release_permanently.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to release the doorbell permanently?'**
  String get are_sure_to_release_permanently;

  /// No description provided for @action_will_delete_data.
  ///
  /// In en, this message translates to:
  /// **'This action will delete all the data associated with your Doorbell'**
  String get action_will_delete_data;

  /// No description provided for @admin_cannot_release_doorbell.
  ///
  /// In en, this message translates to:
  /// **'As an admin user you cannot release this doorbell as its the only doorbell remaining to this location\n\nOnly homeowner can release this doorbell.'**
  String get admin_cannot_release_doorbell;

  /// No description provided for @viewer_cannot_release_doorbell.
  ///
  /// In en, this message translates to:
  /// **'As a Viewer! You cannot release this doorbell'**
  String get viewer_cannot_release_doorbell;

  /// No description provided for @viewer_cannot_add_device.
  ///
  /// In en, this message translates to:
  /// **'As a Viewer! You cannot add devices'**
  String get viewer_cannot_add_device;

  /// No description provided for @viewer_cannot_add_room.
  ///
  /// In en, this message translates to:
  /// **'As a Viewer! You cannot add room'**
  String get viewer_cannot_add_room;

  /// No description provided for @viewer_cannot_move_room.
  ///
  /// In en, this message translates to:
  /// **'As a Viewer! You cannot move device'**
  String get viewer_cannot_move_room;

  /// No description provided for @viewer_cannot_edit_room.
  ///
  /// In en, this message translates to:
  /// **'As a Viewer! You cannot edit room'**
  String get viewer_cannot_edit_room;

  /// No description provided for @viewer_cannot_edit_device.
  ///
  /// In en, this message translates to:
  /// **'As a Viewer! You cannot edit device'**
  String get viewer_cannot_edit_device;

  /// No description provided for @viewer_cannot_delete_room.
  ///
  /// In en, this message translates to:
  /// **'As a Viewer! You cannot delete room'**
  String get viewer_cannot_delete_room;

  /// No description provided for @viewer_cannot_delete_device.
  ///
  /// In en, this message translates to:
  /// **'As a Viewer! You cannot delete device'**
  String get viewer_cannot_delete_device;

  /// No description provided for @viewer_cannot_edit_location.
  ///
  /// In en, this message translates to:
  /// **'As a Viewer! You cannot change the location of the doorbells'**
  String get viewer_cannot_edit_location;

  /// No description provided for @email_verification_popup_title.
  ///
  /// In en, this message translates to:
  /// **'Your email address is updated. Please verify your email address.'**
  String get email_verification_popup_title;

  /// No description provided for @release_location.
  ///
  /// In en, this message translates to:
  /// **'Release Location'**
  String get release_location;

  /// No description provided for @release_access.
  ///
  /// In en, this message translates to:
  /// **'Release Access'**
  String get release_access;

  /// No description provided for @release_without_users_title.
  ///
  /// In en, this message translates to:
  /// **'Before releasing the location, consider transferring ownership to maintain access for future users.'**
  String get release_without_users_title;

  /// No description provided for @release_without_users_desc.
  ///
  /// In en, this message translates to:
  /// **'However, ownership transfer requires a registered user for this location. Please create a user first if you wish to transfer ownership.'**
  String get release_without_users_desc;

  /// No description provided for @active_session.
  ///
  /// In en, this message translates to:
  /// **'Active Session'**
  String get active_session;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get color;

  /// No description provided for @whites.
  ///
  /// In en, this message translates to:
  /// **'Whites'**
  String get whites;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Modes'**
  String get mode;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @move_to.
  ///
  /// In en, this message translates to:
  /// **'Move to:'**
  String get move_to;

  /// No description provided for @location_name.
  ///
  /// In en, this message translates to:
  /// **'Location Name'**
  String get location_name;

  /// No description provided for @visitor_filter_guide_title.
  ///
  /// In en, this message translates to:
  /// **'Filter Recent Visitors'**
  String get visitor_filter_guide_title;

  /// No description provided for @visitor_filter_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Select the desired filter option to rapidly observe visitor activity within the given period.'**
  String get visitor_filter_guide_desc;

  /// No description provided for @visitor_list_guide_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Visitor Record'**
  String get visitor_list_guide_title;

  /// No description provided for @visitor_list_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Long press to delete entry\nfrom the visitor list.'**
  String get visitor_list_guide_desc;

  /// No description provided for @chart_guide_title.
  ///
  /// In en, this message translates to:
  /// **'STATISTICS'**
  String get chart_guide_title;

  /// No description provided for @chart_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Discover the statistics about your visitors by clicking this icon.'**
  String get chart_guide_desc;

  /// No description provided for @history_list_guide_title.
  ///
  /// In en, this message translates to:
  /// **'View Visitor History'**
  String get history_list_guide_title;

  /// No description provided for @history_list_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Click on the visitor record to view complete history.'**
  String get history_list_guide_desc;

  /// No description provided for @history_edit_name_guide_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Visitor Name'**
  String get history_edit_name_guide_title;

  /// No description provided for @history_edit_name_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Tap on edit name option to\nenter in the editing mode.'**
  String get history_edit_name_guide_desc;

  /// No description provided for @history_unwanted_title.
  ///
  /// In en, this message translates to:
  /// **'Add Visitor in\nUnwanted List'**
  String get history_unwanted_title;

  /// No description provided for @history_unwanted_desc.
  ///
  /// In en, this message translates to:
  /// **'Click below to add\na new visitor to the\nunwanted list.'**
  String get history_unwanted_desc;

  /// No description provided for @history_neighbourhood_title.
  ///
  /// In en, this message translates to:
  /// **'Share Visitor History'**
  String get history_neighbourhood_title;

  /// No description provided for @history_neighbourhood_desc.
  ///
  /// In en, this message translates to:
  /// **'To share your visitor\nhistory to Neighbourhood,\ntap the icon below.'**
  String get history_neighbourhood_desc;

  /// No description provided for @history_message_title.
  ///
  /// In en, this message translates to:
  /// **'Visitors Chat History'**
  String get history_message_title;

  /// No description provided for @history_message_desc.
  ///
  /// In en, this message translates to:
  /// **'Click on the icon below to visit\nchat history of the visitors.'**
  String get history_message_desc;

  /// No description provided for @disable_notification_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications Unavailable!'**
  String get disable_notification_title;

  /// No description provided for @disable_notification_desc.
  ///
  /// In en, this message translates to:
  /// **'Purchase and add an IRVINEi doorbell to enable the feature and receive relevant notifications.'**
  String get disable_notification_desc;

  /// No description provided for @successfully_updated.
  ///
  /// In en, this message translates to:
  /// **'Successfully Updated'**
  String get successfully_updated;

  /// No description provided for @statistics_dropdown_guide_title.
  ///
  /// In en, this message translates to:
  /// **'Graph Selection'**
  String get statistics_dropdown_guide_title;

  /// No description provided for @statistics_dropdown_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'View your visitor data by\nselecting the graph that\nbest suits your needs.'**
  String get statistics_dropdown_guide_desc;

  /// No description provided for @statistics_chips_guide_title.
  ///
  /// In en, this message translates to:
  /// **'Filter Visitor Statistics'**
  String get statistics_chips_guide_title;

  /// No description provided for @statistics_chips_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Select the desired filter option\nto rapidly observe visitor\nactivity within the given period.'**
  String get statistics_chips_guide_desc;

  /// No description provided for @statistics_calendar_guide_title.
  ///
  /// In en, this message translates to:
  /// **'Visitor Statistics'**
  String get statistics_calendar_guide_title;

  /// No description provided for @statistics_calendar_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Select a range to quickly\nmonitor visitor activity \nthroughout the time frame specified.'**
  String get statistics_calendar_guide_desc;

  /// No description provided for @circle_marker_guide_title.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get circle_marker_guide_title;

  /// No description provided for @circle_marker_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'“A” is your current location\non the map.'**
  String get circle_marker_guide_desc;

  /// No description provided for @map_address_guide_title.
  ///
  /// In en, this message translates to:
  /// **'Location Address'**
  String get map_address_guide_title;

  /// No description provided for @map_address_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Address change when you\nmove the red location pin.'**
  String get map_address_guide_desc;

  /// No description provided for @pin_marker_guide_title.
  ///
  /// In en, this message translates to:
  /// **'Location Marker'**
  String get pin_marker_guide_title;

  /// No description provided for @pin_marker_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'The red location pin can be\ntapped to adjust within the\n10-meter radius..'**
  String get pin_marker_guide_desc;

  /// No description provided for @notification_filter_guide_title.
  ///
  /// In en, this message translates to:
  /// **'FILTER'**
  String get notification_filter_guide_title;

  /// No description provided for @notification_filter_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Select the desired filter option\nto filter notifications based\non specific criteria.'**
  String get notification_filter_guide_desc;

  /// No description provided for @visitor_notification_guide_title.
  ///
  /// In en, this message translates to:
  /// **'Interact with Visitors from Notifications'**
  String get visitor_notification_guide_title;

  /// No description provided for @audio_call_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Tap the audio call option to start a call.'**
  String get audio_call_guide_desc;

  /// No description provided for @video_call_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Tap the video call option to see the visitor live.'**
  String get video_call_guide_desc;

  /// No description provided for @chat_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Tap the chat option to send messages.'**
  String get chat_guide_desc;

  /// No description provided for @add_room_guide_title.
  ///
  /// In en, this message translates to:
  /// **'ADD ROOM'**
  String get add_room_guide_title;

  /// No description provided for @add_room_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Click to add a new room.'**
  String get add_room_guide_desc;

  /// No description provided for @thermostat_guide_title.
  ///
  /// In en, this message translates to:
  /// **'ADD THERMOSTAT'**
  String get thermostat_guide_title;

  /// No description provided for @thermostat_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Click to add a thermostat with the Irvinei app.'**
  String get thermostat_guide_desc;

  /// No description provided for @add_device_guide_title.
  ///
  /// In en, this message translates to:
  /// **'ADD DEVICE'**
  String get add_device_guide_title;

  /// No description provided for @add_device_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Click to add a new device.'**
  String get add_device_guide_desc;

  /// No description provided for @recent_devices_guide_title.
  ///
  /// In en, this message translates to:
  /// **'RECENT DEVICES'**
  String get recent_devices_guide_title;

  /// No description provided for @recent_devices_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Access recently used devices for quick control.'**
  String get recent_devices_guide_desc;

  /// No description provided for @three_dot_menu_guide_title.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Devices'**
  String get three_dot_menu_guide_title;

  /// No description provided for @three_dot_menu_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'Tap the 3-dot menu for more options:'**
  String get three_dot_menu_guide_desc;

  /// No description provided for @edit_guide_title.
  ///
  /// In en, this message translates to:
  /// **' Edit Device'**
  String get edit_guide_title;

  /// No description provided for @edit_guide_desc.
  ///
  /// In en, this message translates to:
  /// **'  – Change the name or settings.'**
  String get edit_guide_desc;

  /// No description provided for @move_guide_title.
  ///
  /// In en, this message translates to:
  /// **'Move Device'**
  String get move_guide_title;

  /// No description provided for @move_guide_desc.
  ///
  /// In en, this message translates to:
  /// **' – Reassign it to a different room.'**
  String get move_guide_desc;

  /// No description provided for @delete_guide_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Device'**
  String get delete_guide_title;

  /// No description provided for @delete_guide_desc.
  ///
  /// In en, this message translates to:
  /// **' – Remove it permanently.'**
  String get delete_guide_desc;

  /// No description provided for @link_sent.
  ///
  /// In en, this message translates to:
  /// **'Link Sent'**
  String get link_sent;

  /// No description provided for @resent_email.
  ///
  /// In en, this message translates to:
  /// **'\"A password reset link has been sent to abcd@gmail.com. Please check your email.\"'**
  String get resent_email;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @otp_verification_text.
  ///
  /// In en, this message translates to:
  /// **'Your number (***) *****99 has been successfully verified!'**
  String get otp_verification_text;

  /// No description provided for @visit_log.
  ///
  /// In en, this message translates to:
  /// **'Visit Log'**
  String get visit_log;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Click to schedule the update for Doorbell device {deviceName}.'**
  String schedule(Object deviceName);

  /// No description provided for @subscription_plans.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plans'**
  String get subscription_plans;

  /// No description provided for @payment_and_Subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Payment & Subscriptions'**
  String get payment_and_Subscriptions;

  /// No description provided for @add_payment_method.
  ///
  /// In en, this message translates to:
  /// **'Add Payment Method'**
  String get add_payment_method;

  /// No description provided for @payment_methods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get payment_methods;

  /// No description provided for @transaction_history.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transaction_history;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @change_plan.
  ///
  /// In en, this message translates to:
  /// **'Change Plan'**
  String get change_plan;

  /// No description provided for @current_subscription.
  ///
  /// In en, this message translates to:
  /// **'Current Subscription'**
  String get current_subscription;

  /// No description provided for @subscription_plan.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plan'**
  String get subscription_plan;

  /// No description provided for @expires_on.
  ///
  /// In en, this message translates to:
  /// **'Expires on'**
  String get expires_on;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @camera_control.
  ///
  /// In en, this message translates to:
  /// **'Camera Control'**
  String get camera_control;

  /// No description provided for @light_settings.
  ///
  /// In en, this message translates to:
  /// **'Light Settings'**
  String get light_settings;

  /// No description provided for @doorbell_control.
  ///
  /// In en, this message translates to:
  /// **'Doorbell Control'**
  String get doorbell_control;

  /// No description provided for @move_camera.
  ///
  /// In en, this message translates to:
  /// **'Move Camera'**
  String get move_camera;

  /// No description provided for @remove_camera.
  ///
  /// In en, this message translates to:
  /// **'Remove Camera'**
  String get remove_camera;

  /// No description provided for @set_system_date_and_time.
  ///
  /// In en, this message translates to:
  /// **'Set system date & time'**
  String get set_system_date_and_time;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @sleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// No description provided for @reboot.
  ///
  /// In en, this message translates to:
  /// **'Reboot'**
  String get reboot;

  /// No description provided for @pan_and_tilt.
  ///
  /// In en, this message translates to:
  /// **'Pan and Tilt'**
  String get pan_and_tilt;

  /// No description provided for @control_ptz_panel.
  ///
  /// In en, this message translates to:
  /// **'Please change the camera view by controlling PTZ panel.'**
  String get control_ptz_panel;

  /// No description provided for @get_api_key_id.
  ///
  /// In en, this message translates to:
  /// **'Get Api Key and Key ID'**
  String get get_api_key_id;

  /// No description provided for @upgrade_downgrade_subscription_plan.
  ///
  /// In en, this message translates to:
  /// **'Do you want to upgrade or downgrade the current subscription plan?'**
  String get upgrade_downgrade_subscription_plan;

  /// No description provided for @upgrade_your_plan_to_unlock_this_feature.
  ///
  /// In en, this message translates to:
  /// **'Upgrade your plan to unlock this feature.'**
  String get upgrade_your_plan_to_unlock_this_feature;

  /// No description provided for @no_internet_connection_dialog_desc.
  ///
  /// In en, this message translates to:
  /// **'Your phone is not connected to the internet. Please check your internet connection and try again.'**
  String get no_internet_connection_dialog_desc;

  /// No description provided for @bluetooth_devices.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Devices'**
  String get bluetooth_devices;

  /// No description provided for @bluetooth_permission_required.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Permission Required'**
  String get bluetooth_permission_required;

  /// No description provided for @bluetooth_permission_description.
  ///
  /// In en, this message translates to:
  /// **'This app needs Bluetooth permission to scan and connect to nearby devices.'**
  String get bluetooth_permission_description;

  /// No description provided for @grant_permission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grant_permission;

  /// No description provided for @bluetooth_disabled.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Disabled'**
  String get bluetooth_disabled;

  /// No description provided for @bluetooth_enable_description.
  ///
  /// In en, this message translates to:
  /// **'Please enable Bluetooth to scan for nearby devices.'**
  String get bluetooth_enable_description;

  /// No description provided for @enable_bluetooth.
  ///
  /// In en, this message translates to:
  /// **'Enable Bluetooth'**
  String get enable_bluetooth;

  /// No description provided for @bluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get bluetooth;

  /// No description provided for @start_scan.
  ///
  /// In en, this message translates to:
  /// **'Start Scan'**
  String get start_scan;

  /// No description provided for @stop_scan.
  ///
  /// In en, this message translates to:
  /// **'Stop Scan'**
  String get stop_scan;

  /// No description provided for @no_ble_devices_found.
  ///
  /// In en, this message translates to:
  /// **'No BLE Devices Found. Tap to scan BLE devices again'**
  String get no_ble_devices_found;

  /// No description provided for @start_scanning_to_find_devices.
  ///
  /// In en, this message translates to:
  /// **'Start scanning to find nearby Bluetooth devices.'**
  String get start_scanning_to_find_devices;

  /// No description provided for @unknown_device.
  ///
  /// In en, this message translates to:
  /// **'Unknown Device'**
  String get unknown_device;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @available_devices.
  ///
  /// In en, this message translates to:
  /// **'Available Devices'**
  String get available_devices;

  /// No description provided for @available_wifi.
  ///
  /// In en, this message translates to:
  /// **'Available WIFI'**
  String get available_wifi;

  /// No description provided for @ble_connection.
  ///
  /// In en, this message translates to:
  /// **'BLE connection'**
  String get ble_connection;

  /// No description provided for @ble_connection_established_desc.
  ///
  /// In en, this message translates to:
  /// **'BLE connection is established with the doorbell.'**
  String get ble_connection_established_desc;

  /// No description provided for @ble_connection_device_not_found.
  ///
  /// In en, this message translates to:
  /// **'Device not found. Please move closer.'**
  String get ble_connection_device_not_found;

  /// No description provided for @ble_wifi_desc.
  ///
  /// In en, this message translates to:
  /// **'Only Wi-Fi networks with RSSI stronger than –50 dBm (3 bars and above) are displayed in the Change Network flow.'**
  String get ble_wifi_desc;

  /// No description provided for @network_settings.
  ///
  /// In en, this message translates to:
  /// **'Change Wifi Network'**
  String get network_settings;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quit;

  /// No description provided for @quit_process.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to quit the process?'**
  String get quit_process;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
