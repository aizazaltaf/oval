import 'package:admin/inheritance/app_route.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:flutter/material.dart';

@immutable
abstract class Pilot<PBloc extends PilotBloc> extends StatelessWidget {
  const Pilot({
    super.key,
    required this.initialRoute,
  });
  final String initialRoute;

  Widget? getPage(final BuildContext context, final RouteSettings settings);

  PBloc createBloc(final BuildContext context);

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: createBloc,
      child: Builder(
        builder: (final context) {
          final navigatorKey =
              BlocProvider.of<PBloc>(context).state.navigatorKey;
          return PopScope(
            canPop: navigatorKey.currentState!.canPop(),
            child: Navigator(
              key: navigatorKey,
              initialRoute: initialRoute,
              onGenerateRoute: _onGenerateRoute,
              onDidRemovePage: (final page) {
                final route = navigatorKey.currentState?.overlay?.context
                    .findAncestorWidgetOfExactType<Navigator>();

                // Perform actions related to page removal logic
                if (route != null) {
                  // Handle logic when a page is removed (e.g., popping the route)
                  navigatorKey.currentState?.maybePop();
                }
              },
              // onPopPage: (final route, final result) {
              //   return route.didPop(result);
              // },
            ),
          );
        },
      ),
    );
  }

  Route<dynamic>? _onGenerateRoute(final RouteSettings settings) {
    FocusManager.instance.primaryFocus?.unfocus();
    return AppMaterialPageRoute(
      builder: (final context) {
        final page = getPage(context, settings);
        if (page == null) {
          throw ArgumentError('Route ${settings.name} not handled yet');
        }
        return page;
      },
      settings: settings,
    );
  }
}
