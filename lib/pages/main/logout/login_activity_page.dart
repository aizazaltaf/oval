import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/logout/bloc/logout_bloc.dart';
import 'package:admin/pages/main/logout/components/login_activity_card.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/validate_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class LoginActivityPage extends StatefulWidget {
  const LoginActivityPage({super.key});

  static const routeName = "loginActivity";

  static Future<void> push(final BuildContext context) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const LoginActivityPage(),
    );
  }

  @override
  State<LoginActivityPage> createState() => _LoginActivityPageState();
}

class _LoginActivityPageState extends State<LoginActivityPage> {
  @override
  void initState() {
    LogoutBloc.of(context)
      ..callDeviceToken()
      ..callLoginActivities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LogoutBloc.of(context);
    final userProfileBloc = UserProfileBloc.of(context);
    return AppScaffold(
      appTitle: context.appLocalizations.login_activity,
      bottomNavigationBar: LogoutBlocSelector(
        selector: (state) => state.loginActivityApi.isApiInProgress,
        builder: (isApiInProgress) {
          if (isApiInProgress ||
              bloc.state.loginActivities == null ||
              bloc.state.loginActivities!.isEmpty) {
            return const SizedBox.shrink();
          } else {
            return Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: CustomGradientButton(
                onSubmit: () {
                  userProfileBloc.updatePasswordErrorMessage("");
                  showDialog(
                    context: context,
                    builder: (innerContext) => ValidatePasswordDialog(
                      successFunction: () async {
                        await bloc.callLogoutAllSessions();
                      },
                      userProfileBloc: userProfileBloc,
                    ),
                  );
                },
                label: context.appLocalizations.logout_all_sessions,
              ),
            );
          }
        },
      ),
      body: NoGlowListViewWrapper(
        child: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          backgroundColor:
              Theme.of(context).cupertinoOverrideTheme!.barBackgroundColor,
          onRefresh: bloc.callOnRefreshLoginActivities,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  context.appLocalizations.logins,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            CommonFunctions.getThemeBasedWidgetColor(context),
                      ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              loginDevicesList(bloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginDevicesList(final LogoutBloc bloc) {
    return LogoutBlocSelector.loginActivities(
      builder: (list) {
        return LogoutBlocSelector(
          selector: (state) => state.loginActivityApi.isApiInProgress,
          builder: (isApiInProgress) {
            if (isApiInProgress) {
              return Padding(
                padding: EdgeInsets.only(top: 30.h),
                child: const Center(child: ButtonProgressIndicator()),
              );
            } else {
              Constants.dismissLoader();

              if (bloc.state.loginActivities == null ||
                  bloc.state.loginActivities!.isEmpty) {
                return Container(
                  padding: EdgeInsets.only(top: 30.h),
                  child: Text(
                    "${context.appLocalizations.no_records_available}.",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              CommonFunctions.getThemeBasedWidgetColor(context),
                          fontSize: 16,
                        ),
                  ),
                );
              } else {
                return ListViewSeparatedWidget(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  padding: EdgeInsets.zero,
                  list: bloc.state.loginActivities,
                  itemBuilder: (context, index) {
                    return LoginActivityCard(
                      loginActivity: bloc.state.loginActivities![index],
                    );
                  },
                );
              }
            }
          },
        );
      },
    );
  }
}
