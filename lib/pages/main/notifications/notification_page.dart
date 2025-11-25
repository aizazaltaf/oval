import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/notification_data.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/notifications/bloc/notification_state.dart';
import 'package:admin/pages/main/notifications/components/dialog.dart';
import 'package:admin/pages/main/notifications/components/dummy_visitor_notification.dart';
import 'package:admin/pages/main/notifications/components/notification_tile.dart';
import 'package:admin/pages/main/notifications/guides/notification_filter_guide.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:super_tooltip/super_tooltip.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, this.fromVoiceControl = false});

  final bool fromVoiceControl;
  static const routeName = "Notification";

  static Future<void> push(
    final BuildContext context, {
    bool forDevice = false,
    bool shouldNew = true,
    bool fromVoiceControl = false,
  }) {
    final bloc = NotificationBloc.of(context)..updateNoDeviceAvailable("");
    if (!fromVoiceControl) {
      if (bloc.state.newNotification) {
        bloc.callNotificationApi(refresh: true);
      } else if (!forDevice) {
        if (bloc.state.notificationApi.data == null ||
            bloc.state.notificationApi.data!.data.isEmpty ||
            bloc.state.filter) {
          if (bloc.state.filter) {
            bloc.updateFilter(false);
          }
          bloc.callNotificationApi(refresh: true);
        }
      }
      // if (singletonBloc.profileBloc.state!.locationId != null) {
      if (singletonBloc.profileBloc.state!.selectedDoorBell?.locationId !=
          null) {
        bloc.markAllAsRead(shouldNew: shouldNew);
      }
      bloc.callDevicesApi();
    }
    // bloc.resetFilters();

    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) =>
          NotificationPage(fromVoiceControl: fromVoiceControl),
    );
  }

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationBloc? bloc;
  @override
  void initState() {
    super.initState();
    // ChatBloc.of(context)
    //   ..reInitializeState()
    //   ..socketListener(context, null);
    bloc = NotificationBloc.of(context)..isOnNotificationPage = true;
    if (singletonBloc.profileBloc.state?.guides == null ||
        singletonBloc.profileBloc.state?.guides?.notificationGuide == null ||
        singletonBloc.profileBloc.state?.guides?.notificationGuide == 0) {
      bloc!
        ..updateNotificationGuideShow(false)
        ..updateCurrentGuideKey("filter");
    } else {
      bloc?.updateNotificationGuideShow(true);
    }
  }

  @override
  void dispose() {
    bloc?.isOnNotificationPage = false;
    // singletonBloc.socket?.off(Constants.chat);
    if (context.mounted) {
      NotificationBloc.of(context).detachScrollController();
    }
    super.dispose();
  }

  Widget noNotificationFound(BuildContext context, NotificationBloc bloc) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        textAlign: TextAlign.center,
        bloc.state.noDeviceAvailable.isNotEmpty
            ? bloc.state.noDeviceAvailable
            : context.appLocalizations.no_notification_found +
                (bloc.state.filter
                    ? context.appLocalizations.applied_filter
                    : ""),
      ),
    );
  }

  final _superToolTipController = SuperTooltipController();

  bool isExpanded(NotificationState state, int index) {
    if (state.notificationApi.data == null) {
      return false;
    } else if (state.notificationApi.data!.data.length - 1 >= index) {
      return state.notificationApi.data?.data[index].expanded ?? false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = NotificationBloc.of(context)

      // Attach scroll controller when building the page
      ..attachScrollController();
    logger.fine(bloc.state.aiAlertsFilters);
    return NotificationBlocSelector(
      selector: (state) => state.notificationGuideShow,
      builder: (guideShow) {
        return ShowCaseWidget(
          builder: (_) => Builder(
            builder: (innerContext) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                if (!guideShow) {
                  ShowCaseWidget.of(innerContext).startShowCase(
                    [
                      bloc.getCurrentGuide(),
                    ],
                  );
                }
              });
              return AppScaffold(
                appTitle: context.appLocalizations.notifications,
                appBarAction: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SuperTooltip(
                      arrowTipDistance: 20,
                      arrowLength: 8,
                      arrowTipRadius: 6,
                      shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
                      backgroundColor:
                          CommonFunctions.getThemePrimaryLightWhiteColor(
                        context,
                      ),
                      borderColor: Colors.white,
                      barrierColor: Colors.transparent,
                      shadowBlurRadius: 7,
                      shadowSpreadRadius: 0,
                      showBarrier: true,
                      controller: _superToolTipController,
                      content: IntrinsicWidth(
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _superToolTipController.hideTooltip();
                                  showDialogForFilters(
                                    context,
                                    context.appLocalizations.by_date,
                                    widget.fromVoiceControl,
                                  );
                                },
                                child: SizedBox(
                                  width: 27.w,
                                  child: Text(
                                    context.appLocalizations.by_date,
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              const PopupMenuDivider(),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _superToolTipController.hideTooltip();
                                  showDialogForFilters(
                                    context,
                                    context.appLocalizations.by_alert,
                                    widget.fromVoiceControl,
                                  );
                                },
                                child: SizedBox(
                                  width: 27.w,
                                  child: Text(
                                    context.appLocalizations.by_alert,
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              const PopupMenuDivider(),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  await bloc.callDevicesApi(context: context);
                                  unawaited(
                                    _superToolTipController.hideTooltip(),
                                  );
                                  if (context.mounted) {
                                    if (bloc.state.deviceFilters.isNotEmpty) {
                                      showDialogForFilters(
                                        context,
                                        context.appLocalizations.by_device,
                                        widget.fromVoiceControl,
                                      );
                                    } else {
                                      // ToastUtils.warningToast(
                                      //   context.appLocalizations
                                      //       .no_device_available,
                                      // );
                                      bloc
                                        ..updateFilter(true)
                                        ..updateNoDeviceAvailable(
                                          context.appLocalizations
                                              .no_device_available,
                                        );

                                      await bloc.callNotificationApi(
                                        refresh: true,
                                      );
                                    }
                                  }
                                },
                                child: SizedBox(
                                  width: 27.w,
                                  child: Text(
                                    context.appLocalizations.by_device,
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      child: Showcase.withWidget(
                        key: bloc.notificationFilterGuideKey,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        targetBorderRadius: BorderRadius.circular(30),
                        tooltipPosition: TooltipPosition.bottom,
                        container: NotificationFilterGuide(
                          innerContext: innerContext,
                          bloc: bloc,
                        ),
                        child: Icon(
                          MdiIcons.tuneVerticalVariant,
                          size: 24,
                          color:
                              CommonFunctions.getThemeBasedWidgetColor(context),
                        ),
                      ),
                    ),
                  ),
                ],
                body: RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Colors.white,
                  onRefresh: () async {
                    unawaited(bloc.callNotificationApi(refresh: true));
                  },
                  child: NoGlowListViewWrapper(
                    child: Column(
                      children: [
                        NotificationBlocSelector.newNotification(
                          builder: (isNew) {
                            if (!isNew) {
                              return const SizedBox.shrink();
                            }
                            return NotificationBlocSelector(
                              selector: (state) =>
                                  state.unReadNotificationApi.isApiInProgress,
                              builder: (isApiInProgress) {
                                if (isApiInProgress) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    bloc
                                      ..resetFilters()
                                      ..callNotificationApi(isRead: 0);
                                    // ..markAllAsRead();
                                  },
                                  child: Container(
                                    height: 4.h,
                                    width: double.infinity,
                                    color: Colors.grey,
                                    child: Center(
                                      child: Text(
                                        context
                                            .appLocalizations.new_notification,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        NotificationBlocSelector.filter(
                          builder: (isEnabled) {
                            return isEnabled
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        bloc
                                          ..resetFilters()
                                          ..callNotificationApi(
                                            refresh: true,
                                          );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Text(
                                          context
                                              .appLocalizations.clear_filters,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                color: CommonFunctions
                                                    .getThemeBasedWidgetColor(
                                                  context,
                                                ),
                                                fontSize: 14,
                                              ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                        NotificationBlocSelector.filter(
                          builder: (isEnabled) {
                            return isEnabled
                                ? SizedBox(
                                    height: 0.1.h,
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                        if (!guideShow)
                          DummyVisitorNotification(
                            innerContext: innerContext,
                            bloc: bloc,
                          )
                        else
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: NotificationBlocSelector(
                                selector: (state) => state.notificationApi.data,
                                builder: (_) {
                                  return NotificationBlocSelector(
                                    selector: (state) =>
                                        state.notificationApi.isApiInProgress,
                                    builder: (isLoading) {
                                      if (bloc.state.notificationApi.data ==
                                              null &&
                                          isLoading) {
                                        return const Center(
                                          child: ButtonProgressIndicator(),
                                        );
                                      }
                                      Constants.dismissLoader();

                                      if (bloc.state.notificationApi.data ==
                                          null) {
                                        return noNotificationFound(
                                          context,
                                          bloc,
                                        );
                                      }
                                      if (bloc.state.notificationApi.data!.data
                                          .isEmpty) {
                                        return noNotificationFound(
                                          context,
                                          bloc,
                                        );
                                      }

                                      final groupedNotifications = groupBy(
                                        bloc.state.notificationApi.data!.data,
                                        (notification) =>
                                            DateFormat('MMM dd, yyyy').format(
                                          DateTime.parse(notification.createdAt)
                                              .toLocal(),
                                        ),
                                      );

                                      final groupedEntries =
                                          groupedNotifications.entries
                                              .toBuiltList();

                                      return Column(
                                        children: [
                                          Expanded(
                                            child: ListViewSeparatedWidget(
                                              controller: bloc.scrollController,
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (context, groupIndex) {
                                                final dateTitle =
                                                    groupedEntries[groupIndex]
                                                        .key;
                                                final BuiltList<
                                                        NotificationData>
                                                    notifications =
                                                    groupedEntries[groupIndex]
                                                        .value
                                                        .toBuiltList();

                                                return StickyHeader(
                                                  header: Column(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                          context,
                                                        ).size.width,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                        child: Text(
                                                          dateTitle,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headlineLarge
                                                                  ?.copyWith(
                                                                    color: CommonFunctions
                                                                        .getThemeBasedWidgetColor(
                                                                      context,
                                                                    ),
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                    ],
                                                  ),
                                                  content:
                                                      ListViewSeparatedWidget(
                                                    padding: EdgeInsets.zero,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final notification =
                                                          notifications[index];
                                                      final originalIndex = bloc
                                                          .state
                                                          .notificationApi
                                                          .data!
                                                          .data
                                                          .indexWhere(
                                                        (n) =>
                                                            n.id ==
                                                            notification.id,
                                                      );
                                                      String callUserId =
                                                          notification.doorbell!
                                                              .callUserId;
                                                      if (notification
                                                              .iotDevice !=
                                                          null) {
                                                        callUserId =
                                                            notification
                                                                .iotDevice!
                                                                .callUserId!;
                                                      }

                                                      return NotificationBlocSelector(
                                                        selector: (state) =>
                                                            isExpanded(
                                                          state,
                                                          originalIndex,
                                                        ),
                                                        builder: (isExpanded) {
                                                          return NotificationTile(
                                                            notification:
                                                                notification,
                                                            body: notification
                                                                .text,
                                                            visitor:
                                                                notification
                                                                    .visitor,
                                                            onChange: () {
                                                              bloc.lastUpdated(
                                                                originalIndex,
                                                              );
                                                            },
                                                            title: notification
                                                                .title,
                                                            date: bloc
                                                                .state
                                                                .notificationApi
                                                                .data
                                                                ?.data[
                                                                    originalIndex]
                                                                .createdAt,
                                                            createdAt:
                                                                notification
                                                                    .createdAt,
                                                            receiveType:
                                                                notification
                                                                    .receiveType,
                                                            image: notification
                                                                .imageUrl,
                                                            doorbell:
                                                                notification
                                                                    .doorbell,
                                                            callUserId:
                                                                callUserId,
                                                            isExpanded:
                                                                isExpanded,
                                                          );
                                                        },
                                                      );
                                                    },
                                                    separatorBuilder: (
                                                      context,
                                                      index,
                                                    ) =>
                                                        const Divider(
                                                      color: Colors.grey,
                                                    ),
                                                    list: notifications,
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const Divider(
                                                color: Colors.grey,
                                              ),
                                              list: groupedEntries,
                                            ),
                                          ),
                                          if (isLoading)
                                            const Padding(
                                              padding: EdgeInsets.all(8),
                                              child: ButtonProgressIndicator(),
                                            ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogForFilters(
    BuildContext parentContext,
    String filterType,
    bool fromVoiceControl,
  ) {
    final bloc = NotificationBloc.of(parentContext);
    if (!fromVoiceControl) {
      bloc.setTempList();
    }
    if (bloc.state.deviceId.isNotEmpty) {
      for (int i = 0; i < bloc.state.deviceFilters.length; i++) {
        if (bloc.state.deviceFilters[i].value == bloc.state.deviceId) {
          bloc.state.deviceFilters[i].isSelected = true;
          break;
        }
      }
    }
    logger.fine(bloc.state.aiAlertsFilters);
    showDialog(
      context: parentContext,
      builder: (context) {
        return NotificationDialog(filterType, bloc);
      },
    );
  }
}
