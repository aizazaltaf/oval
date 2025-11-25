import 'dart:io';

import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_asset_preview.dart';
import 'package:admin/pages/themes/componenets/theme_preview.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DoorbellThemePreview extends StatelessWidget {
  const DoorbellThemePreview({
    super.key,
    required this.themeId,
    required this.selectedDoorBell,
    this.file,
    this.thumbnail,
    this.aiImage,
  });
  final int? themeId;
  final UserDeviceModel selectedDoorBell;
  final File? file;
  final File? thumbnail;
  final String? aiImage;
  static const routeName = "themeScreen";

  static Future<void> push(
    final BuildContext context,
    final int? themeId,
    final UserDeviceModel selectedDoorBell, {
    final File? file,
    final String? aiImage,
    final File? thumbnail,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => DoorbellThemePreview(
        themeId: themeId,
        file: file,
        thumbnail: thumbnail,
        aiImage: aiImage,
        selectedDoorBell: selectedDoorBell,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);

    return AppScaffold(
      appTitle: context.appLocalizations.theme_preview,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: (file == null)
            ? ThemeBlocSelector.applyThemeApi(
                builder: (applyThemeApi) {
                  return CustomGradientButton(
                    isLoadingEnabled: applyThemeApi.isApiInProgress,
                    onSubmit: () {
                      if (!applyThemeApi.isApiInProgress) {
                        bloc.applyThemeApi(
                          context,
                          themeId: themeId,
                          deviceId: selectedDoorBell.deviceId!,
                        );
                      }
                    },
                    label: context.appLocalizations.apply_theme_on_doorbell,
                  );
                },
              )
            : ThemeBlocSelector.uploadThemeApi(
                builder: (applyThemeApi) {
                  return CustomGradientButton(
                    isLoadingEnabled: applyThemeApi.isApiInProgress,
                    onSubmit: () {
                      if (!applyThemeApi.isApiInProgress) {
                        bloc.uploadThemeApi(
                          context,
                          file: file,
                          thumbnail: thumbnail,
                          aiImage: aiImage,
                          deviceId: selectedDoorBell.deviceId,
                        );
                      }
                    },
                    label: context.appLocalizations.upload_theme,
                  );
                },
              ),
      ),
      appBarAction: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SvgPicture.asset(
              DefaultIcons.EDIT,
              colorFilter: ColorFilter.mode(
                Theme.of(context).textTheme.titleMedium!.color!,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
      body: Align(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 460,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                if (aiImage != null || file != null)
                  ThemeAssetPreview(
                    path: aiImage != null ? aiImage! : file!.path,
                    uploadPreview: true,
                    width: MediaQuery.of(context).size.width,
                    isNetwork: aiImage != null,
                  )
                else
                  ThemePreview(
                    isName: false,
                    height: MediaQuery.of(context).size.height,
                    themesList:
                        bloc.getThemeApiType(bloc.state.activeType).data == null
                            ? <ThemeDataModel>[].toBuiltList()
                            : bloc
                                .getThemeApiType(bloc.state.activeType)
                                .data!
                                .data,
                    fit: BoxFit.fill,
                    showForPreviewOnly: true,
                  ),
                Align(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Image.asset(
                            DefaultImages.APPLICATION_ICON_PNG,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            width: 60,
                          ),
                        ),
                        const SizedBox(height: 20),

                        ///TODO: dateTime and weather
                        Text(
                          DateFormat("EEEE, MMM d").format(DateTime.now()),
                          /* "FRIDAY, JUL 26"*/
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: bloc.state.timeZoneColor,
                                  ),
                        ),
                        Text(
                          DateFormat("hh:mm a").format(DateTime.now()),
                          // "08:30 PM",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: bloc.state.timeZoneColor,
                                    fontSize: 36,
                                  ),
                        ),
                        Text(
                          "         Weather ${bloc.state.weatherApi.data == null ? '30.0°C' : bloc.state.weatherApi.data!.currentWeather?.temperature.toString()}°C", // "weather  30°c",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: bloc.state.weatherColor,
                                    fontSize: 16,
                                  ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),

                        ///TODO: location
                        SizedBox(
                          width: 280,
                          child: Text(
                            "${selectedDoorBell.doorbellLocations!.houseNo} ${selectedDoorBell.doorbellLocations!.street}, ${selectedDoorBell.doorbellLocations!.city}, ${selectedDoorBell.doorbellLocations!.state}, ${selectedDoorBell.doorbellLocations!.country}", // "789 Maple St, Gotham",
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: bloc.state.locationColor,
                                  fontSize: 17,
                                  letterSpacing: 1.8,
                                ),
                          ),
                        ),
                        //     Positioned(
                        // top: 250,
                        // left: 80,
                        // child:
                        //     ),
                        const SizedBox(height: 80),
                        Text(
                          'Welcome to \n${selectedDoorBell.doorbellLocations!.name}',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: bloc.state.bottomTextColor,
                                  ),
                        ),
                        const SizedBox(
                          height: 20,
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
