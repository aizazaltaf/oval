import 'dart:convert';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/components/app_switch.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/pages/main/iot_devices/room_all_devices.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ThermostatCard extends StatefulWidget {
  const ThermostatCard({super.key});

  @override
  State<ThermostatCard> createState() => _ThermostatCardState();
}

class _ThermostatCardState extends State<ThermostatCard> {
  final carouselController = CarouselSliderController();
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);

    // if(model.checkStatus == false){
    return IotBlocSelector.iotDeviceModel(
      builder: (data) {
        final List<IotDeviceModel>? thermostatList = (() {
          final matches = (data ?? <IotDeviceModel>[])
              .where(
                (e) =>
                    e.entityId!.isThermostat() &&
                    singletonBloc
                            .profileBloc.state!.selectedDoorBell?.locationId
                            .toString() ==
                        e.locationId.toString(),
              )
              .toList();
          return matches.isEmpty ? null : matches;
        })();
        if (thermostatList == null) {
          return Container(
            height: 202,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              DefaultIcons.DISABLED_THERMOSTAT,
              fit: BoxFit.fill,
            ),
          );
        } else {
          return Column(
            children: [
              CarouselSlider.builder(
                carouselController: carouselController,
                itemCount: thermostatList.length,
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _activeIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final IotDeviceModel thermostat = thermostatList[index];
                  if (thermostat.stateAvailable == 3) {
                    return Container(
                      height: 202,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        DefaultIcons.DISABLED_THERMOSTAT,
                        fit: BoxFit.fill,
                      ),
                    );
                  } else {
                    final json = jsonDecode(thermostat.configuration ?? "{}");
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (bloc.state.getIotRoomsApi.data != null) {
                          bloc.updateSelectedRoom(
                            bloc.state.getIotRoomsApi.data!.firstWhereOrNull(
                              (e) => e.roomId == thermostat.roomId,
                            ),
                          );
                        }
                        if (bloc.state.inRoomIotDeviceModel != null) {
                          bloc.updateSelectedIotIndex(
                            bloc.state.inRoomIotDeviceModel!
                                .indexWhere((e) => e.id == thermostat.id),
                          );
                        }
                        if (bloc.state.getIotRoomsApi.data != null &&
                            bloc.state.inRoomIotDeviceModel != null) {
                          RoomAllDevices.push(context);
                        }
                      },
                      child: Container(
                        height: 202,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage(DefaultImages.THERMOSTATBG),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Thermostat: ${thermostat.deviceName}",
                              // "Thermostat",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 35),
                                    child: Column(
                                      spacing: 2,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        rowWidget(
                                          title: "State:",
                                          body: (thermostat.mode ?? "heat")
                                              .capitalizeFirstOfEach(),
                                          context: context,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          // "${controller.getThermostatCurrentTemperature.toString()} C",
                                          "${double.parse(
                                            (thermostat.temperature ?? 40)
                                                .toString(),
                                          ).round()}${thermostat.thermostatTemperatureUnit}",

                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        rowWidget(
                                          image: DefaultVectors.HUMIDITY,
                                          title: "Humidity:",
                                          body:
                                              "${json["a"]?["current_humidity"] ?? 40}%",
                                          context: context,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        right: 35,
                                        bottom: 10,
                                      ),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            DefaultIcons.THERMOSTAT_CARD_UP,
                                            height: 18,
                                            width: 10,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            // "${controller.getThermostatCurrentTemperature.toString()} C",
                                            "${double.parse(
                                              (thermostat.temperature ?? 40)
                                                  .toString(),
                                            ).round()}${thermostat.thermostatTemperatureUnit}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SvgPicture.asset(
                                            DefaultIcons.THERMOSTAT_CARD_DOWN,
                                            height: 18,
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 35),
                              child: Row(
                                children: [
                                  Text(
                                    "Operation",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    "Off",
                                    // "${controller.thermostatProgress.toString()} F",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  AppSwitchWidget(
                                    thumbSize: 15,
                                    value:
                                        thermostat.mode!.toLowerCase() != "off",
                                    onChanged: (val) async {},
                                  ),
                                  if (thermostat.mode!.toLowerCase() != "off")
                                    Text(
                                      (thermostat.mode ?? "heat")
                                          .capitalizeFirstOfEach(),
                                      // "${controller.thermostatProgress.toString()} F",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              if (thermostatList.length > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AnimatedSmoothIndicator(
                    activeIndex: _activeIndex,
                    count: thermostatList.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 6,
                      activeDotColor: Color.fromRGBO(
                        4,
                        130,
                        176,
                        1,
                      ), // Change color as needed
                    ),
                    onDotClicked: (index) {
                      carouselController.animateToPage(index);
                    },
                  ),
                ),
            ],
          );

          // }
        }
      },
    );
  }

  Row rowWidget({
    required String title,
    required String body,
    required BuildContext context,
    String? image,
  }) {
    return Row(
      spacing: 5,
      children: [
        if (image != null)
          Image.asset(
            image,
            height: 15,
            width: 15,
            color: CommonFunctions.getThemeBasedWidgetColor(context),
          ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
        ),
        Text(
          body,
          // "${controller.thermostatProgress.toString()} F",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}
