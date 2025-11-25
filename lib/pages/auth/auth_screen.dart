import 'package:admin/pages/auth/auth_page.dart';
import 'package:flutter/material.dart';

class AuthScreen extends Page {
  const AuthScreen();

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (_) => const AuthPage());
  }
}
