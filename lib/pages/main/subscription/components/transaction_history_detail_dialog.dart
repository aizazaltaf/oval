import 'package:admin/models/data/transaction_history_model.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:flutter/material.dart';

class TransactionHistoryDetailDialog extends StatelessWidget {
  const TransactionHistoryDetailDialog({
    super.key,
    required this.bloc,
    required this.transactionHistory,
  });

  final SubscriptionBloc bloc;
  final TransactionHistoryModel transactionHistory;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Dialog(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Transaction Details",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Amount Deducted:",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "\$${transactionHistory.amount}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Date",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    CommonFunctions.formatDateToLocal(
                      transactionHistory.dateTime,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Time:",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    CommonFunctions.formatTimeToLocal(
                      transactionHistory.dateTime,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tax Deducted:",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "\$${transactionHistory.taxDeducted}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Expiry of the Package:",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    CommonFunctions.formatDateToLocal(
                      transactionHistory.expiryDate,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              SubscriptionBlocSelector.downloadingPDF(
                builder: (isDownloading) {
                  return CustomGradientButton(
                    isLoadingEnabled: isDownloading,
                    isButtonEnabled: !isDownloading,
                    onSubmit: () async {
                      bloc.updateDownloadingPdf(true);
                      await bloc.callDownloadInvoice(
                        context: context,
                        subscriptionId:
                            transactionHistory.subscriptionId.toString(),
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    label: "Download Invoice",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
