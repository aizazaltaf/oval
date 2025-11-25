import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_bloc.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/app_drop_down_button.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/email_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class AddNewUserPage extends StatelessWidget {
  const AddNewUserPage({super.key});

  static const routeName = "addNewUser";

  static Future<void> push(
    final BuildContext context,
  ) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const AddNewUserPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = UserManagementBloc.of(context);
    return AppScaffold(
      appTitle: context.appLocalizations.add_new_user,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
        child: UserManagementBlocSelector(
          selector: (state) => state.createUserInviteApi.isApiInProgress,
          builder: (isApiInProgress) {
            return UserManagementBlocSelector.addUserButtonEnabled(
              builder: (enable) {
                return CustomGradientButton(
                  isButtonEnabled: enable,
                  label: context.appLocalizations.add_user,
                  isLoadingEnabled: isApiInProgress,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 22,
                      ),
                  onSubmit: () {
                    if (enable && !isApiInProgress) {
                      bloc.callCreateUserInvite(
                        successFunction: () {
                          Navigator.pop(context);
                        },
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
      body: NoGlowListViewWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              const SizedBox(height: 20),
              addUserTitle(
                context: context,
                title: context.appLocalizations.login_email_address,
              ),
              EmailTextFormField(
                hintText: context.appLocalizations.hint_email,
                validator: Validators.compose([
                  Validators.required(
                    context.appLocalizations.login_errEmailReq,
                  ),
                  Validators.patternRegExp(
                    Constants.emailRegex,
                    context.appLocalizations.invalid_email_err,
                  ),
                  (val) {
                    if (!bloc.getAddEmailCheck()) {
                      return context.appLocalizations.email_unique_error;
                    }
                    return null;
                  }
                ]),
                onChanged: (email) {
                  bloc.updateAddEmail(email.trim());
                  if (bloc.state.addEmail.isEmpty) {
                    bloc.updateAddEmailError(
                      context.appLocalizations.login_errEmailReq,
                    );
                  } else if (!Constants.emailRegex
                      .hasMatch(bloc.state.addEmail)) {
                    bloc.updateAddEmailError(
                      context.appLocalizations.invalid_email_err,
                    );
                  } else if (!bloc.getAddEmailCheck()) {
                    bloc.updateAddEmailError(
                      context.appLocalizations.email_unique_error,
                    );
                  } else {
                    bloc.updateAddEmailError("");
                  }
                  bloc.addUserButtonEnableValidation();
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              addUserTitle(
                context: context,
                title: context.appLocalizations.relationship,
              ),
              UserManagementBlocSelector.addRelation(
                builder: (relation) {
                  return AppDropDownButton(
                    items: bloc.state.relationshipList,
                    hintText: context.appLocalizations.select_relationship,
                    selectedValue: relation.isEmpty
                        ? bloc.state.relationshipList.first
                        : relation,
                    onChanged: (val) {
                      bloc.updateAddRelation(
                        val ?? bloc.state.relationshipList.first,
                      );
                    },
                    dropdownRadius: 10,
                    displayDropDownItems: (item) => item,
                    buttonHeight: 6.h,
                    dropDownWidth: 90.w,
                    dropDownHeight: 36.h,
                    prefixWidget: SvgPicture.asset(
                      DefaultIcons.FAMILY_TREE_ICON,
                      height: 18,
                      width: 18,
                      colorFilter: ColorFilter.mode(
                        CommonFunctions.getThemeBasedWidgetColor(
                          context,
                        ),
                        BlendMode.srcIn,
                      ),
                    ),
                  );
                },
              ),
              // NameTextFormField(
              //   hintText: context.appLocalizations.user_relation_hint,
              //   validator: Validators.compose([
              //     Validators.required(
              //       context.appLocalizations.relation_required_error,
              //     ),
              //   ]),
              //   onChanged: (relation) {
              //     bloc.updateAddRelation(relation.trim());
              //     if (bloc.state.addRelation.isEmpty) {
              //       bloc.updateAddRelationError(
              //         context.appLocalizations.relation_required_error,
              //       );
              //     } else {
              //       bloc.updateAddRelationError("");
              //     }
              //     bloc.addUserButtonEnableValidation();
              //   },
              //   inputFormatters: [
              //     FilteringTextInputFormatter.allow(
              //       RegExp(r'[a-zA-Z\s]'),
              //     ), // Allow alphabets and spaces
              //     LengthLimitingTextInputFormatter(30),
              //   ],
              // ),
              SizedBox(
                height: 2.h,
              ),
              addUserTitle(
                context: context,
                title: context.appLocalizations.role,
              ),
              UserManagementBlocSelector.addRole(
                builder: (role) {
                  return AppDropDownButton(
                    items: bloc.state.roles,
                    hintText: context.appLocalizations.select_role,
                    selectedValue: role ?? bloc.state.roles.first,
                    onChanged: bloc.updateAddRole,
                    dropdownRadius: 10,
                    displayDropDownItems: (item) => item.name,
                    buttonHeight: 6.h,
                    dropDownWidth: 90.w,
                    dropDownHeight: 22.h,
                    prefixWidget: Icon(
                      Icons.people_outline,
                      size: 20,
                      color: CommonFunctions.getThemeBasedWidgetColor(
                        context,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addUserTitle({required BuildContext context, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: CommonFunctions.getThemeBasedWidgetColor(context),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
