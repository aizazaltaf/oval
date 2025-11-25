import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/room_items_model.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class IotRoomDialog extends StatelessWidget {
  IotRoomDialog(
    this.bloc,
    this.parentContext, {
    this.room,
    this.isEdit = false,
    super.key,
  });

  final IotBloc bloc;
  final bool isEdit;
  final BuildContext parentContext;
  final RoomItemsModel? room;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocProvider.value(
        value: bloc,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Builder(
            builder: (final builderContext) => Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  IotBlocSelector(
                    selector: (final state) => state.postIotRoomsApi.error,
                    builder: (error) {
                      return NameTextFormField(
                        onChanged: bloc.updateRoomName,
                        errorText: error?.message,
                        hintText: context.appLocalizations.room_name,
                        initialValue: room?.roomName,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
                          // Allow alphabets & spaces
                          LengthLimitingTextInputFormatter(
                            15,
                          ),
                          // Limit to 15 characters
                        ],
                        validator: Validators.compose([
                          Validators.required(
                            context.appLocalizations.enter_room_name,
                          ),
                        ]),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomCancelButton(
                            label: context.appLocalizations.general_cancel,
                            onSubmit: () {
                              Navigator.pop(context);
                              bloc.updateSelectedValue(
                                false,
                                bloc.state.index!,
                                context,
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: IotBlocSelector(
                            selector: (state) =>
                                state.postIotRoomsApi.isApiInProgress,
                            builder: (isLoading) {
                              return IotBlocSelector.roomName(
                                builder: (name) {
                                  return CustomGradientButton(
                                    isLoadingEnabled: isLoading,
                                    isButtonEnabled:
                                        bloc.state.roomName.isNotEmpty,
                                    //!bloc.state.backPress,
                                    onSubmit: () {
                                      _onSubmit(
                                        context,
                                        _formKey,
                                      );
                                    },
                                    label: context.appLocalizations.save,
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
            ),
          ),
        ),
      ),
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
    if (isEdit) {
      ///TODO: Edit Room
    } else {
      ///TODO: Create Room
      await bloc.createRoom(() {
        Navigator.pop(context);
        Navigator.pop(parentContext);
      });
    }
  }
}
