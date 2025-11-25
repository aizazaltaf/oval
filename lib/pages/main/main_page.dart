import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/main/dashboard/main_dashboard.dart';
import 'package:admin/widgets/navigator/nested_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(final BuildContext context) {
    final bloc = LoginBloc.of(context);
    return MultiBlocProvider(
      providers: bloc.providers,
      child: NestedNavigator(
        firstPageBuilder: (final _) => const MainDashboard(
          fromOneTimeInitialize: true,
        ),
      ),
    );
  }
}
