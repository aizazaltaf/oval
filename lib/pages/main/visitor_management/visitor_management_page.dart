import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_filter_panel.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_management_clear_filters.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_management_components/visitor_card.dart';
import 'package:admin/pages/main/visitor_management/guides/visitor_management_guide/filter_visitor_guide.dart';
import 'package:admin/pages/main/visitor_management/guides/visitor_management_guide/visitor_listview_guide.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:showcaseview/showcaseview.dart';

class VisitorManagementPage extends StatefulWidget {
  const VisitorManagementPage({super.key, this.noInitState = false});
  final bool noInitState;
  static const routeName = "visitorManagementPage";

  static Future<void> push(final BuildContext context) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const VisitorManagementPage(),
    );
  }

  @override
  State<VisitorManagementPage> createState() => _VisitorManagementPageState();
}

class _VisitorManagementPageState extends State<VisitorManagementPage> {
  final visitorFilterGuideKey = GlobalKey();
  final visitorListGuideKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (!widget.noInitState) {
      final bloc = VisitorManagementBloc.of(context);
      if (singletonBloc.profileBloc.state?.guides == null ||
          singletonBloc.profileBloc.state?.guides?.visitorGuide == null ||
          singletonBloc.profileBloc.state?.guides?.visitorGuide == 0) {
        bloc
          ..updateVisitorGuideShow(false)
          ..updateCurrentGuideKey("filter");
      } else {
        bloc.updateVisitorGuideShow(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = VisitorManagementBloc.of(context);
    bloc.visitorManagementScrollController
        .addListener(bloc.onVisitorManagementScroll);
    return VisitorManagementBlocSelector(
      selector: (state) => state.visitorManagementApi,
      builder: (api) {
        return VisitorManagementBlocSelector(
          selector: (state) => state.visitorGuideShow,
          builder: (guideShow) {
            return ShowCaseWidget(
              builder: (innerContext) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  if (!(api.isApiInProgress ||
                      bloc.state.visitorManagementApi.data == null ||
                      bloc.state.visitorManagementApi.data!.data.isEmpty)) {
                    if (!guideShow) {
                      ShowCaseWidget.of(innerContext).startShowCase(
                        [visitorFilterGuideKey, visitorListGuideKey],
                      );
                    }
                  }
                });
                return Column(
                  children: [
                    SizedBox(
                      height: kToolbarHeight,
                      child: Stack(
                        children: [
                          Align(
                            child: Text(
                              context.appLocalizations.visitor_management,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                          Positioned(
                            right: 5,
                            top: 15,
                            child: Showcase.withWidget(
                              key: visitorFilterGuideKey,
                              height: MediaQuery.of(context).size.height / 2,
                              targetBorderRadius: BorderRadius.circular(10),
                              width: MediaQuery.of(context).size.width,
                              container: FilterVisitorGuide(
                                innerContext: innerContext,
                                bloc: bloc,
                              ),
                              child: VisitorFilterPanel(bloc: bloc),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: NameTextFormField(
                        hintText: context.appLocalizations.search_visitors,
                        textInputAction: TextInputAction.next,
                        onChanged: bloc.updateSearch,
                        prefix: const Icon(Icons.search),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ), // Allow alphabets and spaces
                          LengthLimitingTextInputFormatter(30),
                        ],
                        // onChanged: bloc.updateName,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    VisitorManagementBlocSelector.visitorNewNotification(
                      builder: (isNew) {
                        if (!isNew) {
                          return const SizedBox.shrink();
                        }
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            bloc.initialCall(isRefresh: true);
                          },
                          child: Container(
                            height: 4.h,
                            width: double.infinity,
                            color: Colors.grey,
                            child: Center(
                              child: Text(
                                context.appLocalizations.new_visitor,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: VisitorManagementBlocSelector.filterValue(
                        builder: (filter) {
                          return filter == null
                              ? const SizedBox.shrink()
                              : VisitorManagementClearFilters(
                                  bloc: bloc,
                                  onTap: bloc.callFilters,
                                );
                        },
                      ),
                    ),
                    visitorManagementList(
                      context: context,
                      innerContext: innerContext,
                      bloc: bloc,
                    ),
                    VisitorManagementBlocSelector(
                      selector: (state) =>
                          state.visitorManagementApi.isApiInProgress,
                      builder: (isLoading) {
                        if (isLoading &&
                            (bloc.state.visitorManagementApi.data != null &&
                                bloc.state.visitorManagementApi.data!.data
                                    .isNotEmpty)) {
                          return const ButtonProgressIndicator();
                        } else {
                          Constants.dismissLoader();

                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget visitorManagementList({
    required BuildContext context,
    required BuildContext innerContext,
    required VisitorManagementBloc bloc,
  }) {
    return VisitorManagementBlocSelector(
      selector: (state) => state.visitorManagementApi,
      builder: (api) {
        if (api.data == null || api.data!.data.isEmpty) {
          if (api.isApiInProgress) {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 30.h),
              child: const ButtonProgressIndicator(),
            );
          } else {
            Constants.dismissLoader();

            return Container(
              padding: EdgeInsets.only(top: 30.h),
              child: Text(
                "${context.appLocalizations.no_records_available}"
                "${getEmptyListError(context, bloc)}",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: CommonFunctions.getThemeBasedWidgetColor(
                        context,
                      ),
                      letterSpacing: 2,
                      fontSize: 16,
                    ),
              ),
            );
          }
        } else {
          return VisitorManagementBlocSelector.search(
            builder: (search) {
              bool searchContains = false;
              return Expanded(
                child: ListViewSeparatedWidget(
                  controller: bloc.visitorManagementScrollController,
                  list: bloc.state.visitorManagementApi.data!.data,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: kBottomNavigationBarHeight - 20,
                  ),
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    if (search != null) {
                      String visitorName = bloc
                          .state.visitorManagementApi.data!.data[index].name
                          .toLowerCase();
                      if (visitorName.contains("a new visitor")) {
                        visitorName = "unknown";
                      }
                      if (visitorName.contains(
                        search.toLowerCase().trim(),
                      )) {
                        searchContains = true;
                        return VisitorCard(
                          bloc: bloc,
                          visitor:
                              bloc.state.visitorManagementApi.data!.data[index],
                        );
                      } else {
                        if (!searchContains &&
                            index ==
                                bloc.state.visitorManagementApi.data!.data
                                        .length -
                                    1) {
                          return CommonFunctions.noSearchRecord(context);
                        }
                        return const SizedBox.shrink();
                      }
                    }
                    if (index == 0) {
                      return Showcase.withWidget(
                        key: visitorListGuideKey,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        tooltipPosition: TooltipPosition.bottom,
                        targetBorderRadius: BorderRadius.circular(12),
                        container: VisitorListviewGuide(
                          innerContext: innerContext,
                          bloc: bloc,
                        ),
                        child: VisitorCard(
                          bloc: bloc,
                          visitor:
                              bloc.state.visitorManagementApi.data!.data[index],
                        ),
                      );
                    }
                    return VisitorCard(
                      bloc: bloc,
                      visitor:
                          bloc.state.visitorManagementApi.data!.data[index],
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  String getEmptyListError(BuildContext context, VisitorManagementBloc bloc) {
    return "${(bloc.state.filterValue == null || bloc.state.filterValue!.isEmpty) ? "" : ""
        " of ${bloc.getAppliedFilterTitle(bloc.state.filterValue, context)}"}.";
  }
}
