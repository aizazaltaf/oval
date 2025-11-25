import 'package:admin/core/config.dart';
import 'package:admin/models/enums/environment.dart';
import 'package:flutter/material.dart';

class EnvModeBanner extends StatelessWidget {
  const EnvModeBanner({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    final dartEnv = config.environment;
    if (dartEnv == Environment.production) {
      return child;
    }
    return Banner(
      message: dartEnv.name,
      textDirection: TextDirection.ltr,
      location: BannerLocation.topEnd,
      child: child,
    );
  }
}
