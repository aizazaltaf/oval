import 'package:flutter/cupertino.dart';

class MockAppLocalizations {
  String get welcomeBack => 'Welcome Back!';
  String get signUp => 'Sign Up';
  String get forgotPassword => 'Forgot Password?';
}

class MockAppLocalizationsDelegate
    extends LocalizationsDelegate<MockAppLocalizations> {
  const MockAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MockAppLocalizations> load(Locale locale) async =>
      MockAppLocalizations();

  @override
  bool shouldReload(
    covariant LocalizationsDelegate<MockAppLocalizations> old,
  ) =>
      false;
}
