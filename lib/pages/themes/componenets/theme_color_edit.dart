import 'dart:io';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_doorbell_preview.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/app_drop_down_button.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ThemeColorEdit extends StatelessWidget {
  const ThemeColorEdit({
    super.key,
    this.themeId,
    this.isEdit = false,
    this.file,
    this.thumbnail,
    this.doorbell,
    this.aiImage,
  });
  final int? themeId;
  final bool isEdit;
  final File? file;
  final File? thumbnail;
  final String? aiImage;
  final UserDeviceModel? doorbell;
  static const routeName = "themeColorEdit";

  static Future<void> push(
    final BuildContext context, {
    final bool isEdit = false,
    final int? themeId,
    File? file,
    UserDeviceModel? doorbell,
    String? aiImage,
    File? thumbnail,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => ThemeColorEdit(
        themeId: themeId,
        doorbell: doorbell,
        isEdit: isEdit,
        file: file,
        thumbnail: thumbnail,
        aiImage: aiImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    final startupBloc = StartupBloc.of(context);
    final List<UserDeviceModel> list = startupBloc.state.userDeviceModel!
        .toList()
      ..removeWhere(
        (e) =>
            e.locationId.toString() !=
                // singletonBloc.profileBloc.state!.locationId ||
                singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
                    .toString() ||
            e.entityId != null,
      );
    UserDeviceModel selectedDoorBell = bloc.state.selectedDoorBell!;
    final DoorbellLocations locations = selectedDoorBell.doorbellLocations!;
    final String role = singletonBloc.profileBloc.state!.locations!
        .singleWhere((e) => e.id == selectedDoorBell.locationId)
        .roles[0];

    return PopScope(
      onPopInvokedWithResult: (result, child) {},
      child: AppScaffold(
        appTitle: isEdit
            ? context.appLocalizations.edit
            : context.appLocalizations.set_to_doorbell_screen,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              Text(
                context.appLocalizations.time_zone,
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => bloc.openDialog(context, 0),
                child: NameTextFormField(
                  hintText: "${locations.country}/${locations.city}",
                  textInputAction: TextInputAction.next,
                  enabled: false,

                  validator: (value) {
                    return null;
                  },
                  suffix:
                      const Image(image: AssetImage(DefaultImages.COLOR_WHEEL)),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z\s]'),
                    ), // Allow alphabets and spaces
                    LengthLimitingTextInputFormatter(30),
                  ],
                  // onChanged: bloc.updateName,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.appLocalizations.weather,
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => bloc.openDialog(context, 1),
                child: NameTextFormField(
                  hintText: bloc.state.weatherApi.data == null
                      ? ""
                      : "${bloc.state.weatherApi.data!.currentWeather?.temperature}°C",
                  textInputAction: TextInputAction.next,
                  enabled: false,

                  validator: (value) {
                    return null;
                  },
                  suffix:
                      const Image(image: AssetImage(DefaultImages.COLOR_WHEEL)),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z\s]'),
                    ), // Allow alphabets and spaces
                    LengthLimitingTextInputFormatter(30),
                  ],
                  // onChanged: bloc.updateName,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.appLocalizations.location,
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => bloc.openDialog(context, 2),
                child: NameTextFormField(
                  hintText: "${locations.houseNo}, "
                      "${locations.street}, "
                      "${locations.city}, "
                      "${locations.state}, "
                      "${locations.country}.",
                  textInputAction: TextInputAction.next,
                  enabled: false,

                  validator: (value) {
                    return null;
                  },
                  suffix:
                      const Image(image: AssetImage(DefaultImages.COLOR_WHEEL)),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z\s]'),
                    ), // Allow alphabets and spaces
                    LengthLimitingTextInputFormatter(30),
                  ],
                  // onChanged: bloc.updateName,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.appLocalizations.doorbell_name,
              ),
              SizedBox(height: 1.h),
              if (doorbell == null)
                ThemeBlocSelector.selectedDoorBell(
                  builder: (themeSelectedDoorbell) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: AppDropDownButton(
                        items: list.toBuiltList(),
                        selectedValue: role == "viewer"
                            ? null
                            : list.length == 1
                                ? list.first
                                : themeSelectedDoorbell ?? list.first,
                        onChanged: (value) {
                          selectedDoorBell = value!;
                          bloc
                            ..updateSelectedDoorBell(selectedDoorBell)
                            ..weatherApi(value: value.doorbellLocations);
                        },
                        displayDropDownItems: (item) => item.name!,
                        buttonHeight: 6.h,
                        dropdownRadius: 10,
                        dropDownWidth: MediaQuery.of(context).size.width - 45,
                        dropDownHeight: 22.h,
                      ),
                    );
                  },
                )
              else
                NameTextFormField(
                  initialValue: doorbell!.name ?? "",
                  textInputAction: TextInputAction.next,
                  enabled: false,

                  validator: (value) {
                    return null;
                  },

                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z\s]'),
                    ), // Allow alphabets and spaces
                    LengthLimitingTextInputFormatter(30),
                  ],
                  // onChanged: bloc.updateName,
                ),
              const SizedBox(height: 20),
              Text(
                context.appLocalizations.bottom_text,
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => bloc.openDialog(context, 4),
                child: NameTextFormField(
                  hintText: 'Welcome to ${locations.name}',

                  textInputAction: TextInputAction.next,
                  enabled: false,

                  validator: (value) {
                    return null;
                  },
                  suffix:
                      const Image(image: AssetImage(DefaultImages.COLOR_WHEEL)),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z\s]'),
                    ), // Allow alphabets and spaces
                    LengthLimitingTextInputFormatter(30),
                  ],
                  // onChanged: bloc.updateName,
                ),
              ),
              const SizedBox(height: 50),
              CustomGradientButton(
                onSubmit: () async {
                  await DoorbellThemePreview.push(
                    context,
                    themeId,
                    doorbell ?? selectedDoorBell,
                    file: file,
                    thumbnail: thumbnail,
                    aiImage: aiImage,
                  );
                },
                label: context.appLocalizations.proceed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
