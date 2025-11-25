import 'dart:convert';

import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/iot_devices/add_device_form.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/components/room_widget.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/loading_widget.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';

class AddManuallyScreen extends StatelessWidget {
  const AddManuallyScreen._();

  static const routeName = 'autoManually';

  static Future<void> push(final BuildContext context) {
    final bloc = IotBloc.of(context);
    if (bloc.state.getIotBrandsApi.data == null) {
      bloc.callIotBrandsApi();
    } else if (bloc.state.getIotBrandsApi.data!.isEmpty) {
      bloc.callIotBrandsApi();
    }
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const AddManuallyScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);
    return AppScaffold(
      appTitle: context.appLocalizations.supported_brands,
      body: IotBlocSelector(
        selector: (state) => state.getIotBrandsApi.isApiInProgress,
        builder: (isLoading) {
          return SingleChildScrollView(
            child: Center(
              child: LoadingWidget(
                isLoading: isLoading,
                label: bloc.state.getIotBrandsApi.data == null
                    ? Center(
                        child: Text(
                          context.appLocalizations.no_brands_available,
                        ),
                      )
                    : bloc.state.getIotBrandsApi.data!.isEmpty
                        ? Center(
                            child: Text(
                              context.appLocalizations.no_brands_available,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              bottom: 15,
                            ),
                            child: GridView.builder(
                              itemCount:
                                  bloc.state.getIotBrandsApi.data!.length,
                              shrinkWrap: true,
                              // padding: const EdgeInsets.only(right: 15),
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                crossAxisCount: 3,
                              ),
                              itemBuilder: (context, index) {
                                final brand =
                                    bloc.state.getIotBrandsApi.data![index];
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (!bloc.state.getDeviceConfigResponse
                                        .isSocketInProgress) {
                                      if (bloc.state.getIotRoomsApi.data !=
                                          null) {
                                        if (bloc.state.getIotRoomsApi.data!
                                            .isNotEmpty) {
                                          final isRingExist = bloc.isRing();
                                          if (isRingExist &&
                                              brand.brand!
                                                  .toLowerCase()
                                                  .contains("ring")) {
                                            ToastUtils.errorToast(
                                              context.appLocalizations
                                                  .already_configured,
                                            );
                                          } else {
                                            bloc.getDeviceConfig(
                                              data: {
                                                Constants.brand: brand.brand,
                                              },
                                              indexBrand: index,
                                              success: () {
                                                bloc.updateFormDevice(
                                                  FeatureModel(
                                                    brand: brand.brand,
                                                    title: "",
                                                    image:
                                                        (brand.type ?? "bulb")
                                                            .getIcon(),
                                                  ),
                                                );
                                                final mainData = jsonDecode(
                                                  bloc.state.newFormData ??
                                                      bloc
                                                          .state
                                                          .getDeviceConfigResponse
                                                          .data!["data"],
                                                );
                                                final List<
                                                    dynamic> schema = mainData[
                                                        "data_schema"] is String
                                                    ? jsonDecode(
                                                        mainData["data_schema"],
                                                      )
                                                    : mainData["data_schema"];
                                                if (schema.isEmpty &&
                                                    !brand.brand!
                                                        .contains("govee")) {
                                                  ToastUtils.errorToast(
                                                    context.appLocalizations
                                                        .already_configured,
                                                  );
                                                } else {
                                                  AddDeviceForm.push(
                                                    context,
                                                    fromAddManually: true,
                                                  );
                                                }
                                              },
                                            );
                                          }
                                        } else {
                                          ToastUtils.warningToast(
                                            context.appLocalizations
                                                .create_room_first,
                                          );
                                        }
                                      } else {
                                        ToastUtils.warningToast(
                                          context.appLocalizations
                                              .create_room_first,
                                        );
                                      }
                                    }
                                  },
                                  child: IotBlocSelector(
                                    selector: (state) => state.getIotBrandsApi
                                        .data![index].isSelected!,
                                    builder: (isLoadingBrand) {
                                      return IotBlocSelector(
                                        selector: (state) => state
                                            .getDeviceConfigResponse
                                            .isSocketInProgress,
                                        builder: (isLoading) {
                                          if (isLoading && isLoadingBrand) {
                                            Constants.showLoader(
                                              showCircularLoader: false,
                                            );
                                          } else {
                                            Constants.dismissLoader();
                                          }
                                          return
                                              // LoadingWidget(
                                              // isLoading:
                                              //     isLoading && isLoadingBrand,
                                              // label:
                                              RoomWidget(
                                            isNetwork: true,
                                            images:
                                                "${Constants.homeAssistantBrandUrl}${brand.brand}/icon.png",
                                            roomName: brand.brand
                                                    ?.capitalizeFirstOfEach() ??
                                                "Unknown",
                                          )
                                              // )
                                              ;
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ),
          );
        },
      ),
    );
  }
}
