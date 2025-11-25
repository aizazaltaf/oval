import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/loading_widget.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';

class ViewAllScannedDevices extends StatelessWidget {
  const ViewAllScannedDevices._();

  static const routeName = 'ViewAllScannedDevices';

  static Future<void> push(final BuildContext context) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const ViewAllScannedDevices._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);
    return AppScaffold(
      appTitle: "All Devices",
      body: (bloc.state.viewDevicesAll?.isEmpty ?? true)
          ? Center(child: Text(context.appLocalizations.no_device_available))
          : NoGlowListViewWrapper(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 2.w);
                  },
                  shrinkWrap: true,
                  itemCount: bloc.state.viewDevicesAll?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = bloc.state.viewDevicesAll![index];
                    return GestureDetector(
                      onTap: () {
                        bloc.onTapScannedDevices(
                          bloc.state.viewDevicesAll!.toList(),
                          index,
                          context,
                          fromMoreScannedDevices: true,
                        );
                      },
                      child: Card(
                        color: CommonFunctions.getThemeBasedWidgetColorInverted(
                          context,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Row(
                            spacing: 10,
                            children: [
                              if (item.image.contains(".svg"))
                                SvgPicture.asset(
                                  item.image,
                                  width: 30,
                                  height: 30,
                                  colorFilter:
                                      item.image.contains(Constants.thermostat)
                                          ? ColorFilter.mode(
                                              CommonFunctions
                                                  .getThemeBasedWidgetColor(
                                                context,
                                              ),
                                              BlendMode.srcIn,
                                            )
                                          : null,
                                )
                              else
                                Image.asset(
                                  item.image,
                                  width: 30,
                                  height: 30,
                                ),
                              SizedBox(
                                width: 50.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 2,
                                  children: [
                                    Text(
                                      (item.brand ?? "")
                                          .capitalizeFirstOfEach(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: CommonFunctions
                                                .getThemeBasedWidgetColor(
                                              context,
                                            ),
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      item.title.isNotEmpty &&
                                              item.roomId == null
                                          ? item.title
                                          : bloc.state.getIotRoomsApi.data!
                                                  .firstWhereOrNull(
                                                    (e) =>
                                                        e.roomId == item.roomId,
                                                  )
                                                  ?.roomName ??
                                              "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: CommonFunctions
                                                .getThemeBasedWidgetColor(
                                              context,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              if (bloc.state.scannedDevices
                                      .any((e) => e.value == item.value) &&
                                  item.roomId == null)
                                IotBlocSelector(
                                  selector: (state) =>
                                      state.getDeviceConfigResponse
                                          .isSocketInProgress ||
                                      state.curtainAddAPI.isApiInProgress,
                                  builder: (isLoading) {
                                    return IotBlocSelector(
                                      selector: (state) =>
                                          state.scannedDevices.isNotEmpty
                                              ? state
                                                  .scannedDevices[bloc
                                                      .state.scannedDevices
                                                      .indexWhere(
                                                  (e) => e.value == item.value,
                                                )]
                                                  .isSelected
                                              : false,
                                      builder: (isSelected) {
                                        return LoadingWidget(
                                          isLoading: isLoading && isSelected,
                                          label: Icon(
                                            Icons.navigate_next,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
