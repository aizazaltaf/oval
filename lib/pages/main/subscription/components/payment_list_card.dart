import 'dart:async';

import 'package:admin/core/images.dart';
import 'package:admin/models/data/payment_methods_model.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/subscription/components/default_payment_method_dialog.dart';
import 'package:admin/pages/main/subscription/components/delete_payment_method_dialog.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_tooltip/super_tooltip.dart';

class PaymentListCard extends StatelessWidget {
  PaymentListCard({super.key, required this.paymentMethod});

  final PaymentMethodsModel paymentMethod;

  final SuperTooltipController superTooltipController =
      SuperTooltipController();

  String maskCardNumber(String cardNumber) {
    // Remove spaces first
    final String digitsOnly = cardNumber.replaceAll(' ', '');

    if (digitsOnly.length <= 4) {
      return digitsOnly;
    }

    final String last4 = digitsOnly.substring(digitsOnly.length - 4);
    final String maskedDigits = '*' * (digitsOnly.length - 4) + last4;

    // Insert spaces every 4 characters
    return maskedDigits.replaceAllMapped(
      RegExp(r".{4}"),
      (match) => "${match.group(0)} ",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: SvgPicture.asset(getIcon()),
        title: Text(
          "**** **** **** ${paymentMethod.last4}",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
        subtitle: Text(
          "Expires on ${getExpMonth()}/${paymentMethod.expYear}",
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(color: Theme.of(context).disabledColor),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (paymentMethod.isDefault == true)
              Text(
                "Default",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Theme.of(context).disabledColor,
                      fontSize: 12,
                    ),
              ),
            tooltip(context),
          ],
        ),
      ),
    );
  }

  String getExpMonth() {
    final int? month = int.tryParse(paymentMethod.expMonth ?? "");
    if (month == null) {
      return "00";
    } else {
      if (month < 10) {
        return "0${paymentMethod.expMonth}";
      } else {
        return paymentMethod.expMonth ?? "";
      }
    }
  }

  String getIcon() {
    switch (paymentMethod.brand?.toLowerCase()) {
      case "visa":
        return DefaultImages.VISA_CARD;
      case "jcb":
        return DefaultImages.JCB_CARD;
      case "discover":
        return DefaultImages.DISCOVER_CARD;
      case "master":
        return DefaultImages.MASTER_CARD;
      default:
        return DefaultImages.MASTER_CARD;
    }
  }

  Widget tooltip(BuildContext context) {
    final SubscriptionBloc bloc = SubscriptionBloc.of(context);
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: CommonFunctions.getThemeBasedWidgetColor(context),
          fontWeight: FontWeight.w400,
          fontSize: 12,
        );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: superTooltipController.showTooltip,
      child: SuperTooltip(
        arrowTipDistance: 20,
        arrowLength: 8,
        arrowTipRadius: 6,
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
        backgroundColor:
            CommonFunctions.getThemePrimaryLightWhiteColor(context),
        borderColor: Colors.white,
        barrierColor: Colors.transparent,
        shadowBlurRadius: 7,
        shadowSpreadRadius: 0,
        showBarrier: true,
        content: IntrinsicWidth(
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    unawaited(
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return DefaultPaymentMethodDialog(
                            paymentMethodId: paymentMethod.id,
                            bloc: bloc,
                          );
                        },
                      ),
                    );
                    await superTooltipController.hideTooltip();
                  },
                  child: SizedBox(
                    width: 27.w,
                    child: Text(
                      "Make this Default",
                      style: textStyle,
                    ),
                  ),
                ),
                const PopupMenuDivider(),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    unawaited(
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return DeletePaymentMethodDialog(
                            bloc: bloc,
                            paymentMethod: paymentMethod,
                          );
                        },
                      ),
                    );
                    await superTooltipController.hideTooltip();
                  },
                  child: SizedBox(
                    width: 27.w,
                    child: Text(
                      "Delete",
                      style: textStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        controller: superTooltipController,
        child: Icon(
          Icons.more_horiz_rounded,
          size: 24,
          color: CommonFunctions.getThemeBasedWidgetColor(context),
        ),
      ),
    );
  }
}
