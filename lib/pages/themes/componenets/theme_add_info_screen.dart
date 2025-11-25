import 'dart:async';
import 'dart:io';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_asset_preview.dart';
import 'package:admin/pages/themes/componenets/theme_upload_scren.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_drop_down_button.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/form.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class ThemeAddInfoScreen extends StatelessWidget {
  const ThemeAddInfoScreen({
    super.key,
    this.selectedAsset,
    this.aiImageFile,
    this.thumbnail,
  });
  final File? selectedAsset;
  final File? thumbnail;
  final String? aiImageFile;

  static const routeName = "themeAddInfoScreen";

  static Future<void> push(
    final BuildContext context, {
    final File? selectedAsset,
    final File? thumbnail,
    final String? aiImageFile,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => ThemeAddInfoScreen(
        selectedAsset: selectedAsset,
        thumbnail: thumbnail,
        aiImageFile: aiImageFile,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    if (bloc.state.categoryId == null) {
      bloc.updateSelectedValue(
        bloc.state.categoryThemesApi.data!.data.first.name,
      );
    }
    return PopScope(
      onPopInvokedWithResult: (_, r) {
        bloc.updateUploadOnDoorBell(false);
      },
      child: AppScaffold(
        appTitle: context.appLocalizations.add_theme_info,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 60),
                      height: 400,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ThemeAssetPreview(
                          path: aiImageFile != null
                              ? aiImageFile!
                              : selectedAsset!.path,
                          uploadPreview: true,
                          isNetwork: aiImageFile != null,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      child: ThemeEditingWidget(
                        selectedAsset: selectedAsset,
                        aiImageFile: aiImageFile,
                        thumbnail: thumbnail,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeEditingWidget extends StatelessWidget {
  const ThemeEditingWidget({
    super.key,
    this.selectedAsset,
    this.aiImageFile,
    this.thumbnail,
  });
  final File? selectedAsset;
  final File? thumbnail;
  final String? aiImageFile;

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
    final String role = singletonBloc.profileBloc.state!.locations!
        .singleWhere((e) => e.id == selectedDoorBell.locationId)
        .roles[0];
    return ThemeBlocSelector(
      selector: (state) => state.themeNameField,
      builder: (disableForm) {
        return AppForm(
          child: Builder(
            builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.appLocalizations.theme_name,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  NameTextFormField(
                    hintText: context.appLocalizations.enter_theme_name,
                    textInputAction: TextInputAction.next,
                    onChanged: bloc.updateThemeNameField,
                    validator: Validators.required(
                      context.appLocalizations.enter_theme_name,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z\s]'),
                      ), // Allow alphabets and spaces
                      LengthLimitingTextInputFormatter(30),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    context.appLocalizations.category,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (bloc.state.categoryThemesApi.data == null ||
                      bloc.state.categoryThemesApi.data!.data.isEmpty)
                    Text(
                      "No categories available",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 14),
                    )
                  else
                    ThemeBlocSelector(
                      selector: (state) => state.categorySelectedValue,
                      builder: (selectedCategory) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: AppDropDownButton(
                            items: bloc.state.categoryThemesApi.data!.data
                                .map((e) => e.name)
                                .toBuiltList(),
                            selectedValue: bloc.state.categorySelectedValue ??
                                bloc.state.categoryThemesApi.data!.data.first
                                    .name,
                            onChanged: (value) {
                              bloc.updateSelectedValue(value!);
                            },
                            displayDropDownItems: (item) => item,
                            buttonHeight: 6.h,
                            dropdownRadius: 10,
                            dropDownWidth:
                                MediaQuery.of(context).size.width - 40,
                            dropDownHeight: 22.h,
                          ),
                        );
                      },
                    ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomWidgetCardButton(
                    height: 6.h,
                    onSubmit: () {},
                    isButtonEnabled: true,
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).primaryColorLight
                        : Colors.white,
                    borderColor: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).primaryColorLight
                        : Colors.white,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.appLocalizations.upload_theme_on_doorbell,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                          ThemeBlocSelector.uploadOnDoorBell(
                            builder: (uploadOnDoorBell) {
                              return Switch(
                                thumbColor:
                                    WidgetStateProperty.all(Colors.white),
                                activeTrackColor:
                                    Theme.of(context).primaryColorDark,
                                activeColor: Theme.of(context).primaryColor,
                                value: uploadOnDoorBell,
                                onChanged: (newValue) {
                                  if (singletonBloc.profileBloc.state!
                                          .selectedDoorBell !=
                                      null) {
                                    bloc.isUploadOnDoorBell(newValue);
                                  }
                                  if (newValue) {
                                    bloc.updateSelectedDoorBell(
                                      selectedDoorBell,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ThemeBlocSelector.uploadOnDoorBell(
                    builder: (uploadOnDoorBell) {
                      return Visibility(
                        visible: uploadOnDoorBell,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            ThemeBlocSelector.selectedDoorBell(
                              builder: (doorbell) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: AppDropDownButton(
                                    items: list.toBuiltList(),
                                    selectedValue:
                                        role == "viewer" ? null : doorbell,
                                    onChanged: (value) {
                                      selectedDoorBell = value!;
                                      bloc
                                        ..updateSelectedDoorBell(
                                          selectedDoorBell,
                                        )
                                        ..weatherApi(
                                          value: value.doorbellLocations,
                                        );
                                    },
                                    displayDropDownItems: (item) => item.name!,
                                    buttonHeight: 6.h,
                                    dropdownRadius: 10,
                                    dropDownWidth:
                                        MediaQuery.of(context).size.width - 40,
                                    dropDownHeight: 22.h,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomGradientButton(
                    onSubmit: () async {
                      if (Form.of(context).validate()) {
                        if (bloc.state.themeNameField!.isNotEmpty) {
                          if (bloc.state.categorySelectedValue == null ||
                              bloc.state.categorySelectedValue!.isEmpty) {
                            bloc.updateSelectedValue(
                              bloc.state.categoryThemesApi.data!.data[0].name,
                            );
                          }
                          unawaited(
                            ThemeUploadScreen.push(
                              context,
                              selectedAsset,
                              thumbnail,
                              aiImageFile,
                              selectedDoorBell: bloc.state.uploadOnDoorBell
                                  ? selectedDoorBell
                                  : null,
                            ),
                          );
                        } else {
                          ToastUtils.errorToast("Please enter theme name");
                        }
                      }
                      return;
                    },
                    label: context.appLocalizations.preview,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
