import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/subscription/components/transaction_history_card.dart';
import 'package:admin/pages/main/subscription/components/transaction_history_filter_panel.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  static const routeName = "TransactionHistoryPage";

  static Future<void> push({required BuildContext context}) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const TransactionHistoryPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = SubscriptionBloc.of(context);
    return AppScaffold(
      appTitle: context.appLocalizations.transaction_history,
      appBarAction: [
        TransactionHistoryFilterPanel(),
      ],
      body: SubscriptionBlocSelector.transactionHistoryApi(
        builder: (api) {
          if (api.isApiInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SubscriptionBlocSelector.transactionHistoryList(
              builder: (transactionHistoryList) {
                if (transactionHistoryList.isEmpty) {
                  return const Center(
                    child: Text("No Transaction History Available"),
                  );
                }
                return ListView(
                  children: [
                    SubscriptionBlocSelector.transactionFilter(
                      builder: (filter) {
                        if (filter == null) {
                          return const SizedBox.shrink();
                        } else {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              bloc
                                ..updateTransactionFilter(null)
                                ..callTransactionHistory();
                            },
                            child: Column(
                              children: [
                                SizedBox(height: 1.h),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    context.appLocalizations.clear_filter,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          color: CommonFunctions
                                              .getThemeBasedWidgetColor(
                                            context,
                                          ),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    ListViewSeparatedWidget(
                      list: transactionHistoryList,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      itemBuilder: (context, index) {
                        return TransactionHistoryCard(
                          transactionHistory: transactionHistoryList[index],
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
