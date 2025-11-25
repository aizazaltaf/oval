import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';

extension XBuildContext on BuildContext {
  AppLocalizations get appLocalizations => AppLocalizations.of(this)!;
}
