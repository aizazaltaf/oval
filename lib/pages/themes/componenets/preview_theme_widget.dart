import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';

class PreviewThemeWidget extends StatelessWidget {
  const PreviewThemeWidget({super.key, this.selectedDoorBell});
  final UserDeviceModel? selectedDoorBell;

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Theme Name",
          style:
              Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 16),
        ),
        Text(
          bloc.state.themeNameField.toString().trim(),
          style:
              Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Text(
          "Theme Category",
          style:
              Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 16),
        ),
        Text(
          bloc.state.categorySelectedValue ?? "",
          style:
              Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Text(
          "Apply on doorbell",
          style:
              Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 16),
        ),
        Text(
          bloc.state.uploadOnDoorBell
              ? "Yes ${selectedDoorBell == null ? '' : ' (${selectedDoorBell!.name})'}"
              : "No",
          style:
              Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16),
        ),
      ],
    );
  }
}
