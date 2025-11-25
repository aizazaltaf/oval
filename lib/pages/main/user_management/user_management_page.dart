import 'dart:async';

import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/user_management/add_new_user_page.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_bloc.dart';
import 'package:admin/pages/main/user_management/components/user_management_card.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  static const routeName = "userManagement";

  static Future<void> push(final BuildContext context) {
    UserManagementBloc.of(context).callSubUsers();
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const UserManagementPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = UserManagementBloc.of(context);
    return AppScaffold(
      appTitle: context.appLocalizations.user_management,
      floatingActionButton: UserManagementBlocSelector.loggedInUserRoleId(
        builder: (userRoleId) {
          return (userRoleId == 4)
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      bloc.reInitializeAddUserFields();
                      unawaited(AddNewUserPage.push(context));
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 46,
                      ),
                    ),
                  ),
                );
        },
      ),
      body: NoGlowListViewWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RefreshIndicator(
            color: Theme.of(context).primaryColor,
            backgroundColor:
                Theme.of(context).cupertinoOverrideTheme!.barBackgroundColor,
            onRefresh: bloc.callOnRefreshSubUsers,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                SizedBox(height: 2.h),
                NameTextFormField(
                  hintText: context.appLocalizations.search_user_here,
                  textInputAction: TextInputAction.done,
                  onChanged: bloc.updateSearch,
                  prefix: const Icon(Icons.search),
                  // onChanged: bloc.updateName,
                ),
                userManagementList(context, bloc),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userManagementList(BuildContext context, UserManagementBloc bloc) {
    return UserManagementBlocSelector.subUsersList(
      builder: (list) {
        return UserManagementBlocSelector(
          selector: (state) => state.getSubUsersApi.isApiInProgress,
          builder: (inProgress) => inProgress
              ? Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : bloc.state.subUsersList == null ||
                      bloc.state.subUsersList!.isEmpty
                  ? Container(
                      padding: EdgeInsets.only(top: 30.h),
                      child: Text(
                        "${context.appLocalizations.no_records_available}.",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: CommonFunctions.getThemeBasedWidgetColor(
                                context,
                              ),
                              fontSize: 16,
                            ),
                      ),
                    )
                  : UserManagementBlocSelector.search(
                      builder: (search) {
                        bool searchContains = false;
                        return ListViewSeparatedWidget(
                          physics: const ScrollPhysics(),
                          list: bloc.state.subUsersList,
                          separatorBuilder: (context, index) =>
                              const SizedBox.shrink(),
                          itemBuilder: (context, index) {
                            final String userName = bloc
                                .state.subUsersList![index].name
                                .toString()
                                .toLowerCase();
                            final String email = bloc
                                .state.subUsersList![index].email
                                .toLowerCase();
                            final String role = bloc
                                .state.subUsersList![index].role!.name
                                .toLowerCase();
                            if (search != null) {
                              if (userName.contains(
                                    search.toLowerCase().trim(),
                                  ) ||
                                  email.contains(
                                    search.toLowerCase().trim(),
                                  ) ||
                                  role.contains(
                                    search.toLowerCase().trim(),
                                  )) {
                                searchContains = true;
                                return Column(
                                  children: [
                                    SizedBox(height: 2.h),
                                    UserManagementCard(
                                      subUser: bloc.state.subUsersList![index],
                                    ),
                                  ],
                                );
                              } else {
                                if (!searchContains &&
                                    index ==
                                        bloc.state.subUsersList!.length - 1) {
                                  return CommonFunctions.noSearchRecord(
                                    context,
                                  );
                                }
                                return const SizedBox.shrink();
                              }
                            }
                            return Column(
                              children: [
                                SizedBox(height: 2.h),
                                UserManagementCard(
                                  subUser: bloc.state.subUsersList![index],
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
        );
      },
    );
  }
}
