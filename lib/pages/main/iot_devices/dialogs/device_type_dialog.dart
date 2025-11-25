import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/custom_checkbox_list_tile.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class DeviceTypeDialog extends StatefulWidget {
  const DeviceTypeDialog(this.bloc, {super.key});

  final IotBloc bloc;

  @override
  State<DeviceTypeDialog> createState() => _DeviceTypeDialogState();
}

class _DeviceTypeDialogState extends State<DeviceTypeDialog> {
  /// Selected device types
  final Set<String> _selectedTypes = {};

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: CommonFunctions.getThemeBasedWidgetColor(context),
          fontSize: 16,
        );
    final uniqueTypes = widget.bloc.state.getIotBrandsApi.data!
        .where((e) => e.type != null && e.type!.isNotEmpty && e.type != 'hub')
        .fold<Map<String, dynamic>>({}, (map, item) {
          // Keep only one item per unique type (last one wins)
          map[item.type!] = item;
          return map;
        })
        .values
        .toList();
    for (final d in widget.bloc.state.getIotBrandsApi.data!) {
      if (d.isSelected!) {
        _selectedTypes.add(d.type!);
      }
    }
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: BlocProvider.value(
        value: widget.bloc,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child:
              // BlocBuilder<IotBloc, IotState>(
              //   bloc: widget.bloc,
              //   buildWhen: (prev, curr) =>
              //       prev.scannedDialogDevices != curr.scannedDialogDevices ||
              //       prev.viewDevicesAll != curr.viewDevicesAll,
              //   builder: (context, state) {
              //     // ✅ Combine scanned + server devices, dedup by type
              //     final scannedDevices = state.scannedDialogDevices;
              //     final viewDevices = state.viewDevicesAll ?? BuiltList();
              //
              //     final mergedMap = <String, FeatureModel>{};
              //
              //     for (final d in scannedDevices) {
              //       mergedMap[widget.bloc.getType(d.image)] = d;
              //     }
              //     for (final d in viewDevices) {
              //       mergedMap[widget.bloc.getType(d.image)] = d;
              //     }
              //
              //     final mergedDevices = mergedMap.values.toList();
              //
              //     // ✅ Initialize selected set once
              //     for (final d in mergedDevices) {
              //       if (d.isSelected) {
              //         _selectedTypes.add(widget.bloc.getType(d.image));
              //       }
              //     }

              // return
              Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ❌ Close icon
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: AppColors.darkBluePrimaryColor,
                    size: 26,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Title
              Text(
                context.appLocalizations.device_type.capitalizeFirstOfEach(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: CommonFunctions.getThemeBasedWidgetColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
              ),
              const PopupMenuDivider(),

              // ✅ Device Type Checkboxes
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: uniqueTypes.length,
                  itemBuilder: (context, index) {
                    // final device = mergedDevices[index];
                    // final type = widget.bloc.getType(device.image);
                    // final isChecked = _selectedTypes.contains(type);

                    return IotBlocSelector(
                      selector: (state) =>
                          state.getIotBrandsApi.data?[index].isSelected ??
                          false,
                      builder: (isSelected) {
                        return CustomCheckboxListTile(
                          value: isSelected,
                          onChanged: (checked) {
                            widget.bloc.updateIotBrandSelected(
                              checked!,
                              uniqueTypes[index].type.toString(),
                            );
                            setState(() {
                              if (checked) {
                                _selectedTypes.add(
                                  uniqueTypes[index].type.toString(),
                                );
                              } else {
                                _selectedTypes.remove(
                                  uniqueTypes[index].type.toString(),
                                );
                              }
                            });
                            //
                            // // ✅ Update BLoC state
                            // final updated = mergedDevices.map((d) {
                            //   if (widget.bloc.getType(d.image) == type) {
                            //     d.isSelected = checked ?? false;
                            //   }
                            //   return d;
                            // }).toBuiltList();
                            //
                            // widget.bloc.updateScannedDialogDevices(updated);
                          },
                          style: textStyle,
                          title: uniqueTypes[index]
                              .type
                              .toString()
                              .capitalizeFirstOfEach(),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              // ✅ Action Buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 10,
                children: [
                  CustomGradientButton(
                    onSubmit: () {
                      Navigator.pop(context, _selectedTypes);
                    },
                    label: context.appLocalizations.apply,
                  ),
                  CustomCancelButton(
                    onSubmit: () {
                      _selectedTypes.clear();
                      widget.bloc.clearIotBrandSelected();
                      // widget.bloc.updateScannedDialogDevices(
                      //   state.scannedDialogDevices.map((f) {
                      //     f.isSelected = false;
                      //     return f;
                      //   }).toBuiltList(),
                      // );
                      Navigator.pop(context, <String>{});
                    },
                    customWidth: 100.w,
                    label: context.appLocalizations.clear,
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
          // },
          // ),
        ),
      ),
    );
  }
}
