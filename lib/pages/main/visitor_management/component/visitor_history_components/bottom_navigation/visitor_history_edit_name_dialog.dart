import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_profile_image.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class VisitorHistoryEditNameDialog extends StatefulWidget {
  const VisitorHistoryEditNameDialog({
    super.key,
    required this.bloc,
    required this.visitor,
    required this.imageUrl,
    required this.visitorId,
    this.fromVisitorHistory = false,
  });
  final VisitorManagementBloc bloc;
  final VisitorsModel visitor;
  final String imageUrl;
  final String visitorId;
  final bool fromVisitorHistory;

  @override
  State<VisitorHistoryEditNameDialog> createState() =>
      _VisitorHistoryEditNameDialogState();
}

class _VisitorHistoryEditNameDialogState
    extends State<VisitorHistoryEditNameDialog> {
  @override
  void initState() {
    //  implement initState
    super.initState();
    widget.bloc.updateVisitorNameSaveButtonEnabled(false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: Dialog(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                VisitorProfileImage(visitor: widget.visitor, size: 100),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    context.appLocalizations.general_name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: CommonFunctions.getThemeBasedWidgetColor(
                            context,
                          ),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                const SizedBox(height: 5),
                VisitorManagementBlocSelector(
                  selector: (state) => state.editVisitorNameApi.error,
                  builder: (final error) => NameTextFormField(
                    initialValue: widget.visitor.name.contains("A new")
                        ? "Unknown"
                        : widget.visitor.name,
                    hintText: context.appLocalizations.hint_visitor_name,
                    errorText: error?.message,
                    customDefaultBorderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    validator: Validators.compose([
                      Validators.required(
                        context.appLocalizations.edit_visitor_errRequired,
                      ),
                      Validators.patternRegExp(
                        Constants.noNumberSpecialCharacterRegex,
                        context.appLocalizations.edit_visitor_errRequired,
                      ),
                      Validators.minLength(
                        3,
                        context.appLocalizations.edit_visitor_errMinLength,
                      ),
                      Validators.maxLength(
                        25,
                        context.appLocalizations.edit_visitor_errMaxLength,
                      ),
                      (value) {
                        if (value?.trim() == widget.visitor.name ||
                            value?.trim().toLowerCase() == "unknown") {
                          return null;
                        }
                        return null;
                      }
                    ]),
                    onChanged: (name) {
                      widget.bloc.updateVisitorName(name.trim());
                      widget.bloc.getNameEditValidations(
                        changedName: name,
                        visitorName: widget.visitor.name,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textTheme: const TextTheme(
                        titleSmall: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        VisitorManagementBlocSelector
                            .visitorNameSaveButtonEnabled(
                          builder: (enabled) {
                            return CustomGradientButton(
                              onSubmit: () {
                                if (enabled) {
                                  widget.bloc.callEditVisitorName(
                                    widget.visitorId,
                                    fromVisitorHistory:
                                        widget.fromVisitorHistory,
                                  );
                                  Navigator.of(context).pop();
                                }
                              },
                              isButtonEnabled: enabled,
                              label: context.appLocalizations.general_save,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomCancelButton(
                          label: context.appLocalizations.general_cancel,
                          customWidth: 100.w,
                          onSubmit: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
