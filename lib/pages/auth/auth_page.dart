import 'package:admin/pages/auth/login/login_page.dart';
import 'package:admin/widgets/navigator/nested_navigator.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedNavigator(
      firstPageBuilder: (final _) => const LoginPage(),
    );
  }
}
