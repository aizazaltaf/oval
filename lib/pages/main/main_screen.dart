import 'package:admin/pages/main/main_page.dart';
import 'package:flutter/material.dart';

class MainScreen extends Page {
  const MainScreen({super.key});

  @override
  Route createRoute(final BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (final _) => const MainPage(),
    );
  }
}
