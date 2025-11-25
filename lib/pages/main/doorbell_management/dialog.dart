import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/pages/main/doorbell_management/bloc/doorbell_management_bloc.dart';
import 'package:admin/pages/main/doorbell_management/doorbell_name_page.dart';
import 'package:admin/widgets/app_drop_down_button.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class DoorbellLocationsDialog extends StatelessWidget {
  DoorbellLocationsDialog(
    this.bloc,
    this.parentContext, {
    super.key,
    this.fromLocationSettings = false,
    this.focus = false,
    this.updateLocation,
    required this.filterDoorbells,
  });

  final DoorbellManagementBloc bloc;
  final bool fromLocationSettings;
  final bool focus;
  final DoorbellLocations? updateLocation;
  final BuiltList<DoorbellLocations> filterDoorbells;
  final BuildContext parentContext;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocProvider.value(
        value: bloc,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Builder(
            builder: (final builderContext) =>
                DoorbellManagementBlocSelector.backPress(
              builder: (backPress) {
                return Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shrinkWrap: true,
                    children: [
                      if (!fromLocationSettings)
                        if (backPress)
                          if (filterDoorbells.isNotEmpty)
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                bloc
                                  ..updateLocationName("")
                                  ..updateBackPress(!backPress);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_left,
                                    color: CommonFunctions
                                        .getThemeBasedWidgetColor(
                                      context,
                                    ),
                                  ),
                                  Text(
                                    context.appLocalizations.new_location,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Text(
                          "*${context.appLocalizations.location_name}",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: !backPress
                            ? DoorbellManagementBlocSelector.selectedLocation(
                                builder: (selectedLocation) {
                                  if (selectedLocation == null) {
                                    bloc.updateSelectedLocation(
                                      filterDoorbells.first,
                                    );
                                  }
                                  return AppDropDownButton(
                                    dropDownTextStyle: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                    items: filterDoorbells,
                                    selectedValue: selectedLocation ??
                                        filterDoorbells.first,
                                    onChanged: bloc.updateSelectedLocation,
                                    displayDropDownItems: (item) => item.name!,
                                    buttonHeight: 6.h,
                                    dropdownRadius: 10,
                                    dropDownWidth: 70.w,
                                    dropDownHeight: 22.h,
                                  );
                                },
                              )
                            : NameTextFormField(
                                onChanged: (val) {
                                  bloc
                                    ..updateLocationName(val)
                                    ..onCheckProceed();
                                },
                                hintText: context.appLocalizations.home,
                                initialValue: updateLocation?.name ??
                                    bloc.state.locationName,
                                autoFocus: focus,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]'),
                                  ),
                                  LengthLimitingTextInputFormatter(
                                    15,
                                  ),
                                ],
                                validator: Validators.compose([
                                  Validators.required(
                                    context.appLocalizations.location_required,
                                  ),

                                  ///  Same Location Name check has been removed -> 467
                                  // (value) {
                                  //   final locationsList = singletonBloc
                                  //       .profileBloc.state!.locations!;
                                  //   if (fromLocationSettings) {
                                  //     if (locationsList.any(
                                  //       (location) =>
                                  //           location.name == value &&
                                  //           updateLocation!.name != value,
                                  //     )) {
                                  //       return context.appLocalizations
                                  //           .location_name_must_be_unique;
                                  //     }
                                  //   } else {
                                  //     if (locationsList.any(
                                  //       (location) => location.name == value,
                                  //     )) {
                                  //       return context.appLocalizations
                                  //           .location_name_must_be_unique;
                                  //     }
                                  //   }
                                  //   return null; // Return null if the validation passes
                                  // },
                                ]),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Text(
                          "*${context.appLocalizations.house_no}",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: !backPress
                            ? DoorbellManagementBlocSelector.selectedLocation(
                                builder: (selectedLocation) {
                                  if (selectedLocation == null) {
                                    bloc.updateSelectedLocation(
                                      filterDoorbells.first,
                                    );
                                  }
                                  final TextEditingController houseController =
                                      TextEditingController()
                                        ..text = selectedLocation!.houseNo ??
                                            filterDoorbells.first.houseNo ??
                                            '';
                                  return NameTextFormField(
                                    enabled: false,
                                    // controller: houseController,
                                    initialValue: houseController.text,
                                    validator: (val) {
                                      return null;
                                    },
                                    hintText: context.appLocalizations.house_no,
                                  );
                                },
                              )
                            : NameTextFormField(
                                onChanged: (val) {
                                  bloc
                                    ..updateCompanyAddress(
                                      val.trim(),
                                    )
                                    ..onCheckProceed();
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                    6,
                                  ),
                                ],
                                initialValue: updateLocation?.houseNo ??
                                    bloc.state.companyAddress,
                                hintText: context.appLocalizations.house_no,
                                validator: Validators.compose([
                                  Validators.required(
                                    context.appLocalizations.address_required,
                                  ),
                                ]),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Text(
                          "*${context.appLocalizations.street_block_no}",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: !backPress
                            ? DoorbellManagementBlocSelector.selectedLocation(
                                builder: (selectedLocation) {
                                  if (selectedLocation == null) {
                                    bloc.updateSelectedLocation(
                                      filterDoorbells.first,
                                    );
                                  }
                                  final TextEditingController streetController =
                                      TextEditingController()
                                        ..text = selectedLocation!.street ??
                                            filterDoorbells.first.street ??
                                            '';
                                  return NameTextFormField(
                                    enabled: false,
                                    // controller: streetController,
                                    initialValue: streetController.text,
                                    validator: (val) {
                                      return null;
                                    },
                                    hintText: context
                                        .appLocalizations.street_block_no,
                                  );
                                },
                              )
                            : NameTextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                    10,
                                  ),
                                ],
                                onChanged: (val) => bloc
                                  ..updateStreetBlockName(
                                    val.trim(),
                                  )
                                  ..updateProceedButtonEnabled(
                                    true,
                                  ),
                                initialValue: updateLocation?.street ??
                                    bloc.state.streetBlockName,
                                hintText:
                                    context.appLocalizations.street_block_no,
                                validator: Validators.compose([
                                  Validators.required(
                                    context.appLocalizations
                                        .street_block_no_required,
                                  ),
                                ]),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: DoorbellManagementBlocSelector.placeMark(
                          builder: (placeMark) {
                            if (placeMark == null) {
                              return const ButtonProgressIndicator();
                            }
                            Constants.dismissLoader();
                            return Text(
                              bloc.getAddress(placeMark),
                              style: Theme.of(context).textTheme.titleMedium,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (fromLocationSettings)
                              Expanded(
                                child: CustomCancelButton(
                                  label:
                                      context.appLocalizations.general_cancel,
                                  onSubmit: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            else
                              backPress
                                  ? const SizedBox.shrink()
                                  : Expanded(
                                      child: CustomGradientButton(
                                        onSubmit: () {
                                          bloc.updateBackPress(
                                            !backPress,
                                          );
                                        },
                                        label: context
                                            .appLocalizations.new_location,
                                      ),
                                    ),
                            if (fromLocationSettings)
                              Expanded(
                                child: DoorbellManagementBlocSelector(
                                  selector: (state) =>
                                      state.updateLocationApi.isApiInProgress,
                                  builder: (isLoading) {
                                    return CustomGradientButton(
                                      isLoadingEnabled: isLoading,
                                      onSubmit: () {
                                        if (!isLoading) {
                                          onLocationUpdateSubmit(
                                            builderContext,
                                            _formKey,
                                          );
                                        }
                                      },
                                      label:
                                          context.appLocalizations.general_save,
                                    );
                                  },
                                ),
                              )
                            else
                              Expanded(
                                child: DoorbellManagementBlocSelector(
                                  selector: (state) =>
                                      state.createLocationApi.isApiInProgress,
                                  builder: (isLoading) {
                                    return DoorbellManagementBlocSelector
                                        .proceedButtonEnabled(
                                      builder: (enabled) {
                                        return CustomGradientButton(
                                          isButtonEnabled:
                                              !backPress || enabled,
                                          isLoadingEnabled: isLoading,
                                          onSubmit: () {
                                            if (!isLoading &&
                                                (!backPress || enabled)) {
                                              _onSubmit(
                                                builderContext,
                                                _formKey,
                                              );
                                            }
                                          },
                                          label:
                                              context.appLocalizations.proceed,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  bool isFormValidate() {
    bool isLocationValidate = false;
    bool isHouseValidate = false;
    bool isStreetValidate = false;

    /// location validations
    if (bloc.state.locationName.trim().isEmpty) {
      isLocationValidate = false;
    } else {
      isLocationValidate = true;
    }

    ///  Same Location Name check has been removed -> 467
    // else {
    //   // location validations
    //   final locationsList = singletonBloc.profileBloc.state!.locations!;
    //   if (fromLocationSettings) {
    //     if (locationsList.any(
    //       (location) =>
    //           location.name == bloc.state.locationName.trim() &&
    //           updateLocation!.name != bloc.state.locationName.trim(),
    //     )) {
    //       isLocationValidate = false;
    //     } else {
    //       isLocationValidate = true;
    //     }
    //   } else {
    //     if (locationsList.any(
    //       (location) => location.name == bloc.state.locationName.trim(),
    //     )) {
    //       isLocationValidate = false;
    //     } else {
    //       isLocationValidate = true;
    //     }
    //   }
    // }

    /// house validation
    if (bloc.state.companyAddress.trim().isEmpty) {
      isHouseValidate = false;
    } else {
      isHouseValidate = true;
    }

    /// street validation
    if (bloc.state.streetBlockName.trim().isEmpty) {
      isStreetValidate = false;
    } else {
      isStreetValidate = true;
    }

    /// final validations
    if (!isLocationValidate || !isHouseValidate || !isStreetValidate) {
      return false;
    } else {
      return true;
    }
  }

  void onLocationUpdateSubmit(
    final BuildContext context,
    GlobalKey<FormState> formKey,
  ) {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (!isFormValidate()) {
      return;
    }
    bloc.callUpdateLocation(
      locationId: updateLocation!.id!,
      latitude: bloc.state.markerPosition!.latitude,
      longitude: bloc.state.markerPosition!.longitude,
      houseNo: bloc.state.companyAddress.trim(),
      street: bloc.state.streetBlockName.trim(),
      successFunction: () {
        StartupBloc.of(context).callEverything();
        Navigator.pop(context);
        Navigator.pop(parentContext);
      },
      locationName: bloc.state.locationName.trim(),
      address: bloc.state.placeMark!,
    );
  }

  Future<void> _onSubmit(
    final BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    // Validate the form using the FormState
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (bloc.state.backPress) {
      if (!isFormValidate()) {
        return;
      }
    }
    // if (!bloc.state.backPress) {
    Navigator.pop(context);
    unawaited(
      singletonBloc.socketEmitter(
        roomName: Constants.doorbell,
        roomId: bloc.state.deviceId,
        deviceId: bloc.state.deviceId,
        request: Constants.doorbellLocation,
        message: bloc.state.locationName.isNotEmpty
            ? bloc.state.locationName
            : bloc.state.selectedLocation!.name,
      ),
    );
    bloc.updateDoorbellNameSaveLoading(false);
    unawaited(DoorbellNamePage.push(parentContext));
  }
}
