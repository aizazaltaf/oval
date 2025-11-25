import 'dart:async';

import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:super_tooltip/super_tooltip.dart';

class TransactionHistoryFilterPanel extends StatelessWidget {
  TransactionHistoryFilterPanel({
    super.key,
  });

  TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: CommonFunctions.getThemeBasedWidgetColor(context),
          fontWeight: FontWeight.w400,
          fontSize: 12,
        );
  }

  final SuperTooltipController superTooltipController =
      SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: superTooltipController.showTooltip,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
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
                  tooTipTap(context, "Monthly", "monthly"),
                  const PopupMenuDivider(),
                  tooTipTap(context, "Annually", "annually"),
                ],
              ),
            ),
          ),
          controller: superTooltipController,
          child: Icon(
            MdiIcons.tuneVerticalVariant,
            size: 24,
            color: CommonFunctions.getThemeBasedWidgetColor(context),
          ),
        ),
      ),
    );
  }

  Widget tooTipTap(BuildContext context, String text, String filter) {
    final bloc = SubscriptionBloc.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        bloc.updateTransactionFilter(filter);
        unawaited(bloc.callTransactionHistory());
        await superTooltipController.hideTooltip();
      },
      child: SizedBox(
        width: 27.w,
        child: Text(
          text,
          style: textStyle(context),
        ),
      ),
    );
  }
}
