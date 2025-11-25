import 'package:flutter/material.dart';

class AppForm extends StatelessWidget {
  const AppForm({
    super.key,
    this.disable = false,
    required this.child,
  });
  final bool disable;
  final Widget child;

  static AppFormInherited? of(final BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppFormInherited>();
  }

  @override
  Widget build(final BuildContext context) {
    return AppFormInherited(
      disable: disable,
      child: Form(
        child: child,
      ),
    );
  }
}

class AppFormInherited extends InheritedWidget {
  const AppFormInherited({
    super.key,
    required this.disable,
    required super.child,
  });
  final bool disable;

  @override
  bool updateShouldNotify(covariant final AppFormInherited oldWidget) {
    if (oldWidget.disable != disable) {
      return true;
    }
    return false;
  }
}
