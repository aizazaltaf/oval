import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/main/dashboard/monitor_cameras.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

typedef RefreshCallback = Future<void> Function(StartupBloc);

class ViewAllCamera extends StatefulWidget {
  const ViewAllCamera({super.key});

  static const routeName = 'viewAllCamera';

  static Future<void> push(final BuildContext context) {
    StartupBloc.of(context).updateSearchCamera(null);
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const ViewAllCamera(),
    );
  }

  @override
  State<ViewAllCamera> createState() => _ViewAllCameraState();
}

class _ViewAllCameraState extends State<ViewAllCamera> {
  @override
  void initState() {
    // implement initState
    super.initState();
    final bloc = StartupBloc.of(context);
    final String? cameras = singletonBloc.getBox.read(Constants.pinnedCameras);
    if (cameras != null && cameras.isNotEmpty) {
      final BuiltList<String> camerasList = cameras
          .split(',') // Split by comma and space
          .map((item) => item) // Remove quotes
          .toBuiltList();
      bloc.updateMonitorCameraPinnedList(camerasList);
    }
  }

  BuiltList<UserDeviceModel> getListLength(
    BuiltList<UserDeviceModel>? list,
    StartupBloc bloc,
  ) {
    if (list == null) {
      return <UserDeviceModel>[].toBuiltList();
    }
    return getPinnedCamerasList(
      list
          .where(
            (x) =>
                x.locationId ==
                singletonBloc.profileBloc.state!.selectedDoorBell!.locationId,
          )
          .toBuiltList(),
      bloc,
    );
  }

  BuiltList<UserDeviceModel> getPinnedCamerasList(
    BuiltList<UserDeviceModel> devices,
    StartupBloc bloc,
  ) {
    logger.fine(bloc.state.monitorCameraPinnedList);

    final Map<String, int> pinnedIndex = {
      for (int i = 0; i < bloc.state.monitorCameraPinnedList.length; i++)
        bloc.state.monitorCameraPinnedList[i]: i,
    };

    final List<UserDeviceModel> list = devices.toList()
      ..sort((a, b) {
        final int indexA = pinnedIndex.containsKey(
          a.isExternalCamera == true ? a.entityId.toString() : a.deviceId,
        )
            ? pinnedIndex[a.isExternalCamera == true
                ? a.entityId.toString()
                : a.deviceId]!
            : bloc.state.monitorCameraPinnedList.length;
        final int indexB = pinnedIndex.containsKey(
          b.isExternalCamera == true ? b.entityId.toString() : b.deviceId,
        )
            ? pinnedIndex[b.isExternalCamera == true
                ? b.entityId.toString()
                : b.deviceId]!
            : bloc.state.monitorCameraPinnedList.length;
        return indexA.compareTo(indexB);
      });

    return list.toBuiltList();
  }

  bool getPinValue(BuiltList<String> pinnedList, UserDeviceModel device) {
    if (pinnedList.isEmpty) {
      return false;
    } else {
      if (device.isExternalCamera == true) {
        return pinnedList.contains(device.entityId.toString());
      } else {
        return pinnedList.contains(device.deviceId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = StartupBloc.of(context);
    return StartupBlocSelector(
      selector: (state) => state.isInternetConnected,
      builder: (isInternetConnected) {
        if (!isInternetConnected) {
          CommonFunctions.showNoInternetConnectionDialog(context);
        }
        return StartupBlocSelector.userDeviceModel(
          builder: (list) {
            return AppScaffold(
              needShowNoInternetBar: false,
              appTitle: context.appLocalizations.monitor_cameras,
              body: RefreshIndicator(
                color: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context)
                    .cupertinoOverrideTheme!
                    .barBackgroundColor,
                onRefresh: bloc.onRefresh,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      NameTextFormField(
                        hintText: context.appLocalizations.search_camera_here,
                        onChanged: bloc.updateSearchCamera,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        prefix: const Icon(Icons.search),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: StartupBlocSelector.monitorCameraPinnedList(
                          builder: (pinnedList) {
                            return StartupBlocSelector.refreshSnapshots(
                              builder: (snapshot) {
                                return StartupBlocSelector.searchCamera(
                                  builder: (search) {
                                    bool searchContains = false;
                                    return ListViewSeparatedWidget(
                                      list: getListLength(list, bloc),
                                      separatorBuilder: (context, i) =>
                                          const SizedBox.shrink(),
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemBuilder: (_, index) {
                                        final name =
                                            getListLength(list, bloc)[index]
                                                .name
                                                .toString()
                                                .toLowerCase();
                                        if (search != null) {
                                          if (name.contains(
                                            search.toLowerCase().trim(),
                                          )) {
                                            searchContains = true;
                                            return Column(
                                              children: [
                                                MonitorCamerasWidget(
                                                  deviceModel: getListLength(
                                                    list,
                                                    bloc,
                                                  )[index],
                                                  length: getListLength(
                                                    list,
                                                    bloc,
                                                  ).length,
                                                  needPinIcon:
                                                      ViewAllCamera.routeName ==
                                                          "viewAllCamera",
                                                  pinValue: getPinValue(
                                                    pinnedList, // camera pinned list
                                                    getListLength(
                                                      list,
                                                      bloc, // doorbell or camera device
                                                    )[index],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            );
                                          } else {
                                            if (!searchContains &&
                                                index ==
                                                    getListLength(list, bloc)
                                                            .length -
                                                        1) {
                                              return CommonFunctions
                                                  .noSearchRecord(
                                                context,
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          }
                                        }
                                        return Column(
                                          children: [
                                            MonitorCamerasWidget(
                                              deviceModel: getListLength(
                                                list,
                                                bloc,
                                              )[index],
                                              length: getListLength(list, bloc)
                                                  .length,
                                              needPinIcon:
                                                  ViewAllCamera.routeName ==
                                                      "viewAllCamera",
                                              pinValue: getPinValue(
                                                pinnedList, // camera pinned list
                                                getListLength(
                                                  list,
                                                  bloc, // doorbell or camera device
                                                )[index],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget monitorCamerasList(
    BuiltList<UserDeviceModel> list,
    StartupBloc bloc,
    int index,
  ) {
    return Column(
      children: [
        StartupBlocSelector.monitorCameraPinnedList(
          builder: (pinnedList) {
            return MonitorCamerasWidget(
              deviceModel: getListLength(list, bloc)[index],
              length: getListLength(list, bloc).length,
              needPinIcon: ViewAllCamera.routeName == "viewAllCamera",
              pinValue: getPinValue(
                pinnedList, // camera pinned list
                getListLength(
                  list,
                  bloc, // doorbell or camera device
                )[index],
              ),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
