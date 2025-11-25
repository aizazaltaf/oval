import 'package:flutter/material.dart';

Future<T?> pushMaterialPageRoute<T>(
  final BuildContext context, {
  required final String? name,
  required final WidgetBuilder builder,
}) {
  return Navigator.push<T>(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0); // Slide from right
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}

Future pushReplacementMaterialPageRoute<T>(
  final BuildContext context, {
  required final String? name,
  required final WidgetBuilder builder,
}) {
  FocusManager.instance.primaryFocus?.unfocus();
  return Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0); // Slide from right
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}

Future<void> navigateToFirstAppScreen(
  final BuildContext context, {
  required final WidgetBuilder builder,
}) {
  FocusManager.instance.primaryFocus?.unfocus();
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: builder,
    ),
    (route) => route.isFirst, // Keep only the first route
  );
}

Future<void> pushAndRemoveUntil(
  final BuildContext context, {
  required final WidgetBuilder builder,
}) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: builder,
    ),
    (route) => false, // Keep only the first route
  );
}

Future<void> pushAndRemoveUntilTrue(
  final BuildContext context, {
  required final WidgetBuilder builder,
}) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: builder,
    ),
    (route) => false, // Keep only the first route
  );
}

void popUntil(final BuildContext context) {
  return Navigator.popUntil(context, (route) => route.isFirst);
}
