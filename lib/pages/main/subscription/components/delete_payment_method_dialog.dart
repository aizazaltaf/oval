import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/payment_methods_model.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:flutter/material.dart';

class DeletePaymentMethodDialog extends StatelessWidget {
  const DeletePaymentMethodDialog({
    super.key,
    required this.paymentMethod,
    required this.bloc,
  });

  final PaymentMethodsModel paymentMethod;
  final SubscriptionBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: AppDialogPopup(
        title: "Are you sure you want to delete payment method?",
        confirmButtonLabel: context.appLocalizations.general_yes,
        confirmButtonOnTap: () {
          bloc.callDeletePaymentMethod(paymentMethod.id);
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
