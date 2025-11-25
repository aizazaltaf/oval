import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:flutter/material.dart';

class DefaultPaymentMethodDialog extends StatelessWidget {
  const DefaultPaymentMethodDialog({
    super.key,
    required this.paymentMethodId,
    required this.bloc,
  });

  final int paymentMethodId;
  final SubscriptionBloc bloc;

  @override
  Widget build(BuildContext context) {
    // final bloc = SubscriptionBloc.of(context);
    return BlocProvider.value(
      value: bloc,
      child: AppDialogPopup(
        title: "Are you sure you want to make this default?",
        confirmButtonLabel: context.appLocalizations.general_yes,
        confirmButtonOnTap: () {
          bloc.callMakeDefaultPaymentMethod(paymentMethodId);
          Navigator.pop(context);
        },
        cancelButtonLabel: context.appLocalizations.general_cancel,
        cancelButtonOnTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
