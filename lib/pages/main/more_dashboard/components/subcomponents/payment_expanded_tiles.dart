import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/more_dashboard/components/subcomponents/more_expansion_tile.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/subscription/current_subscription_page.dart';
import 'package:admin/pages/main/subscription/payment_methods_page.dart';
import 'package:admin/pages/main/subscription/transaction_history_page.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';

class PaymentExpandedTiles extends StatelessWidget {
  PaymentExpandedTiles({super.key});

  final List<FeatureModel> subscriptionsElements = [
    FeatureModel(
      title: "Subscription",
      image: DefaultIcons.PAYMENT_METHOD_MORE,
      route: (context) {
        // SubscriptionPlanPage.push(context: context);
        CurrentSubscriptionPage.push(context);
      },
    ),
    FeatureModel(
      title: "Payment Methods",
      image: DefaultIcons.PAYMENT_METHOD_MORE,
      route: (context) {
        SubscriptionBloc.of(context).callPaymentMethods();
        PaymentMethodsPage.push(context: context);
      },
    ),
    FeatureModel(
      title: "Transaction History",
      image: DefaultIcons.PAYMENT_METHOD_MORE,
      route: (context) {
        SubscriptionBloc.of(context).callTransactionHistory();
        TransactionHistoryPage.push(context: context);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return StartupBlocSelector.moreCustomPaymentsTileExpanded(
      builder: (paymentsTileExpansion) {
        return MoreExpansionTile(
          title:
              context.appLocalizations.payment_and_Subscriptions.toUpperCase(),
          isExpanded: paymentsTileExpansion,
          list: subscriptionsElements,
          tileLeading: Icon(
            Icons.payments_outlined,
            size: 24,
            color: CommonFunctions.getThemeBasedPrimaryWhiteColor(context),
          ),
          onTapTile: () {
            StartupBloc.of(context)
                .updateMoreCustomPaymentsTileExpanded(!paymentsTileExpansion);
            if (!paymentsTileExpansion) {
              StartupBloc.of(context)
                ..updateMoreCustomFeatureTileExpanded(false)
                ..updateMoreCustomSettingsTileExpanded(false);
            }
          },
        );
      },
    );
  }
}
