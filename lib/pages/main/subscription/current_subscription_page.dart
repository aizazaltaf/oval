import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/subscription_location_model.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class CurrentSubscriptionPage extends StatefulWidget {
  const CurrentSubscriptionPage({super.key});

  static const routeName = "CurrentSubscriptionPage";

  static Future<void> push(BuildContext context) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const CurrentSubscriptionPage(),
    );
  }

  @override
  State<CurrentSubscriptionPage> createState() =>
      _CurrentSubscriptionPageState();
}

class _CurrentSubscriptionPageState extends State<CurrentSubscriptionPage> {
  // late StartupBloc startupBloc;

  // @override
  // void initState() {
  //   //  implement initState
  //   WidgetsBinding.instance.addObserver(this); // Add observer
  //   startupBloc = StartupBloc.of(context);
  //   super.initState();
  // }
  //
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {
  //     startupBloc
  //       ..callUserDetails()
  //       ..callPlanFeaturesManagement();
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this); // Remove observer
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return StartupBlocSelector.everythingApi(
      builder: (userDetailApi) {
        if (userDetailApi.isApiInProgress) {
          return const Center(child: CircularProgressIndicator());
        }
        final SubscriptionLocationModel? subscription = singletonBloc
            .profileBloc.state?.locations
            ?.where(
              (e) =>
                  e.id ==
                  singletonBloc.profileBloc.state?.selectedDoorBell?.locationId,
            )
            .first
            .subscription;
        final planExpired =
            CommonFunctions.isExpired(subscription?.expiresAt ?? "");
        final planCancelled = subscription?.subscriptionStatus == "canceled";
        return AppScaffold(
          appTitle: context.appLocalizations.current_subscription,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!planCancelled &&
                    !planExpired &&
                    subscription?.amount != "00.00")
                  CustomCancelButton(
                    label: "Upgrade/Downgrade",
                    customWidth: 100.w,
                    onSubmit: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AppDialogPopup(
                            title: context.appLocalizations
                                .upgrade_downgrade_subscription_plan,
                            confirmButtonLabel:
                                context.appLocalizations.general_yes,
                            confirmButtonOnTap: () {
                              CommonFunctions.openUrl(
                                // context,
                                // pageKey: "upgrade_downgrade",
                                // needNavigation: true,
                                // url:
                                Constants.upgradeDowngradeUrl,
                              );
                              Navigator.pop(dialogContext);
                            },
                            cancelButtonLabel:
                                context.appLocalizations.general_cancel,
                            cancelButtonOnTap: () {
                              Navigator.pop(dialogContext);
                            },
                          );
                        },
                      );
                    },
                  ),
                const SizedBox(height: 10),
                CustomGradientButton(
                  isButtonEnabled: planExpired ||
                      planCancelled ||
                      subscription?.amount == "00.00",
                  onSubmit: () {
                    CommonFunctions.openUrl(
                      // context,
                      // pageKey: "change_plan",
                      // needNavigation: true,
                      // url:
                      Constants.subscribeOnboardingUrl,
                    );
                  },
                  label: context.appLocalizations.change_plan,
                ),
              ],
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SizedBox(height: 1.h),
                Card(
                  color: CommonFunctions.getThemeWidgetColor(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (planCancelled || planExpired)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "(${planExpired ? "Expired" : planCancelled ? "Cancelled" : ""})",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.red,
                                  ),
                            ),
                          ),
                        if (planCancelled || planExpired)
                          const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${context.appLocalizations.subscription_plan}:",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            Text(
                              subscription?.name ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: (planExpired || planCancelled)
                                        ? Colors.red
                                        : null,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${context.appLocalizations.expires_on}:",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            Text(
                              CommonFunctions.formatDateForApi(
                                DateTime.parse(subscription?.expiresAt ?? '')
                                    .toLocal(),
                                dateFormat: 'MM-dd-yyyy',
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: (planExpired || planCancelled)
                                        ? Colors.red
                                        : null,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${context.appLocalizations.amount}:",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            Text(
                              "\$${subscription?.amount}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: (planExpired || planCancelled)
                                        ? Colors.red
                                        : null,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
