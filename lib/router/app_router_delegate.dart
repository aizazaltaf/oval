import 'dart:async';

import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/pages/auth/auth_screen.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/main_screen.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

final _logger = Logger("app_router_delegate.dart");

class AppRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  Future<void> splashInitialize(
    BuildContext context,
    bool needDashboardInitialize,
  ) async {
    final bloc = StartupBloc.of(context);
    unawaited(completeSplash(bloc));
    if (needDashboardInitialize) {
      if (singletonBloc.profileBloc.state != null &&
          bloc.state.isInternetConnected) {
        Future.delayed(const Duration(seconds: 3), () async {
          bloc.updateDashboardApiCalling(true);
          await bloc.callEverything(
            id: singletonBloc.profileBloc.state?.selectedDoorBell?.locationId,
          );
          if (singletonBloc.profileBloc.state?.selectedDoorBell != null &&
              singletonBloc.profileBloc.state?.selectedDoorBell?.locationId !=
                  null) {
            await IotBloc.of(context.mounted ? context : context)
                .iotInitializer();
            unawaited(
              Future.delayed(const Duration(seconds: 3), () {
                bloc.updateDashboardApiCalling(false);
              }),
            );
          } else {
            bloc.updateDashboardApiCalling(false);
          }
        });
      }
    }
  }

  Future<void> completeSplash(StartupBloc bloc) async {
    await Future.delayed(const Duration(seconds: 5)); // Simulating a delay
    if (bloc.state.appIsUpdated!) {
      bloc.updateSplashEnd(true);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final bloc = StartupBloc.of(context);
    return StartupBlocSelector(
      selector: (state) => state.splashEnd,
      builder: (isEnd) {
        return ProfileBlocSelector(
          selector: (final state) => state != null,
          builder: (final isLoggedIn) {
            FlutterNativeSplash.remove();
            // singletonBloc.profileBloc.updateProfile(null);
            if (!isEnd) {
              splashInitialize(context, isLoggedIn);
              // this will call only when already logged in
              if (isLoggedIn) {
                bloc.updateNeedDashboardCall(!isLoggedIn);
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: AppColors.scaffoldBgColor,
                child: Image.asset(
                  DefaultImages.NEW_SPLASH,
                ),
              );
            }

            if (!isLoggedIn) {
              singletonBloc.joinRoom = false;
            }
            // return IndexedStack(
            //   index: isLoggedIn ? 0 : 1,
            //   children: const [
            //     MainPage(),
            //     AuthPage(),
            //   ],
            // );

            return Navigator(
              key: navigatorKey,
              pages: [
                if (isLoggedIn) ...[
                  const MainScreen(),
                ] else ...[
                  const AuthScreen(),
                ],
              ],
              onDidRemovePage: (final page) {
                // You can add custom logic here for handling page removal.
                debugPrint('Page removed: ${page.name}');
              },
            );
          },
        );
      },
    );
  }

  @override
  Future<void> setNewRoutePath(final configuration) async {
    _logger.severe(configuration.toString());
  }
}
