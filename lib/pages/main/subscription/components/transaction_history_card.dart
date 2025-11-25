import 'package:admin/extensions/string.dart';
import 'package:admin/models/data/transaction_history_model.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/subscription/components/transaction_history_detail_dialog.dart';
import 'package:flutter/material.dart';

class TransactionHistoryCard extends StatelessWidget {
  const TransactionHistoryCard({super.key, required this.transactionHistory});
  final TransactionHistoryModel transactionHistory;

  Color _getAccentColor() {
    if (transactionHistory.status.toLowerCase() == 'success') {
      return const Color(0xFF4CAF50); // Green for success
    }
    return const Color(0xFFE74C3C); // Red for fail
  }

  Color _getStatusColor() {
    if (transactionHistory.status.toLowerCase() == 'success') {
      return const Color(0xFF4CAF50);
    }
    return const Color(0xFFE74C3C);
  }

  Color _getAmountColor() {
    if (transactionHistory.status.toLowerCase() == 'success') {
      return const Color(0xFF4CAF50);
    }
    return const Color(0xFFE74C3C);
  }

  @override
  Widget build(BuildContext context) {
    final SubscriptionBloc bloc = SubscriptionBloc.of(context);
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (dialogContext) {
            return TransactionHistoryDetailDialog(
              transactionHistory: transactionHistory,
              bloc: bloc,
            );
          },
        );
      },
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Left accent line
              Container(
                width: 4,
                height: 54,
                decoration: BoxDecoration(
                  color: _getAccentColor(),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Left side - Transaction details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${transactionHistory.planName} (${transactionHistory.doorbellLocations?.name})"
                                  .capitalizeFirstOfEach(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              transactionHistory.status.capitalizeFirstOfEach(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _getStatusColor(),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              transactionHistory.expiryDate,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF7F8C8D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Right side - Amount
                      Text(
                        "\$${transactionHistory.amount}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _getAmountColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
