import 'dart:async';

import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/subscription/components/payment_list_card.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  static const routeName = "PaymentMethodsPage";

  static Future<void> push({required BuildContext context}) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const PaymentMethodsPage(),
    );
  }

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage>
    with WidgetsBindingObserver {
  late SubscriptionBloc subscriptionBloc;

  @override
  void initState() {
    //  implement initState
    WidgetsBinding.instance.addObserver(this); // Add observer
    subscriptionBloc = SubscriptionBloc.of(context);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      subscriptionBloc.callPaymentMethods();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      backgroundColor:
          Theme.of(context).cupertinoOverrideTheme!.barBackgroundColor,
      onRefresh: () async {
        unawaited(SubscriptionBloc.of(context).callPaymentMethods());
        return Future.value();
      },
      child: AppScaffold(
        appTitle: context.appLocalizations.payment_methods,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: CustomGradientButton(
            onSubmit: () {
              CommonFunctions.openUrl(
                // context,
                // pageKey: "add_payment_method",
                // url:
                Constants.addPaymentMethodUrl,
              );
            },
            label: context.appLocalizations.add_payment_method,
          ),
        ),
        body: SubscriptionBlocSelector(
          selector: (state) => state.paymentMethodsApi,
          builder: (api) {
            if (api.isApiInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SubscriptionBlocSelector.paymentMethodsList(
                builder: (paymentMethodsList) {
                  if (paymentMethodsList.isEmpty) {
                    return const Center(
                      child: Text("No Payment Methods Available"),
                    );
                  }
                  return ListViewSeparatedWidget(
                    list: paymentMethodsList,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PaymentListCard(
                        paymentMethod: paymentMethodsList[index],
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
