import 'package:flutter/material.dart';

class AppMaterialPageRoute extends MaterialPageRoute<dynamic> {
  AppMaterialPageRoute({
    required super.builder,
    super.settings,
  });
  dynamic Function()? beforePopScope;

  @override
  void didComplete(final result) {
    super.didComplete(result ?? beforePopScope?.call());
  }

  static AppMaterialPageRoute? of(final BuildContext context) {
    return ModalRoute.of(context) as AppMaterialPageRoute?;
  }
}
