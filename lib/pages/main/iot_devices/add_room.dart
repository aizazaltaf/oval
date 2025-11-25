import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/room_items_model.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/components/room_widget.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class AddRoom extends StatelessWidget {
  const AddRoom({super.key});

  const AddRoom._();

  static const routeName = 'addRoom';

  static Future<void> push(final BuildContext context) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const AddRoom._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);
    return SizedBox(
      // height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom, // shift up with keyboard
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              IotBlocSelector.getConstantRooms(
                builder: (v) {
                  return IotBlocSelector(
                    selector: (final state) => state.postIotRoomsApi.error,
                    builder: (error) {
                      // if (bloc.state.getConstantRooms
                      //         .asList()
                      //         .firstWhereOrNull((e) => e.selectedValue) ==
                      //     null) {
                      //   return const SizedBox();
                      // }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Text(
                            context.appLocalizations.room_name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          NameTextFormField(
                            onChanged: bloc.updateRoomName,
                            errorText: error?.message,
                            hintText: context.appLocalizations.room_name,
                            initialValue: bloc.state.getConstantRooms
                                    .asList()
                                    .firstWhereOrNull((e) => e.selectedValue)
                                    ?.roomName ??
                                "",
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
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Text(
                context.appLocalizations.room_icon,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IotBlocSelector.getConstantRooms(
                builder: (v) {
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      // childAspectRatio: 0.95,
                      childAspectRatio: 1.2,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: bloc.state.getConstantRooms.length,
                    itemBuilder: (context, index) {
                      final RoomItemsModel room =
                          bloc.state.getConstantRooms[index];
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          bloc
                            ..updateSelectedValue(
                              !bloc.state.getConstantRooms[index].selectedValue,
                              index,
                              context,
                            )
                            ..updateRoomName(
                              bloc.state.getConstantRooms[index].roomName!,
                            );
                        },
                        child: RoomWidget(
                          roomName: room.roomName,
                          images: room.image,
                          color: room.color,
                          roomSelected: v[index].selectedValue,
                          newWidget: true,
                        ),
                      );
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: IotBlocSelector.isEnabled(
                  builder: (isEnabled) {
                    return IotBlocSelector(
                      selector: (state) =>
                          state.postIotRoomsApi.isApiInProgress,
                      builder: (isLoading) {
                        return IotBlocSelector.roomName(
                          builder: (name) {
                            return CustomGradientButton(
                              isLoadingEnabled: isLoading,
                              isButtonEnabled: isEnabled,
                              //!bloc.state.backPress,
                              onSubmit: () {
                                _onSubmit(
                                  context,
                                  bloc,
                                );
                              },
                              label: context.appLocalizations.save,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 4.h),
              // IotBlocSelector.isEnabled(
              //   builder: (isEnabled) {
              //     return Padding(
              //       padding:
              //           const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              //       child: CustomGradientButton(
              //         isButtonEnabled: isEnabled,
              //         onSubmit: () {
              //           isEnabled
              //               ? showDialog(
              //                   context: context,
              //                   builder: (childContext) {
              //                     return IotRoomDialog(
              //                       bloc,
              //                       context,
              //                       room: bloc
              //                           .state.getConstantRooms[bloc.state.index!],
              //                     );
              //                   },
              //                 )
              //               : ToastUtils.infoToast(
              //                   null,
              //                   Constants.addRoomButtonDisableMsg,
              //                 );
              //         },
              //         label: context.appLocalizations.add,
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit(
    final BuildContext context,
    IotBloc bloc,
  ) async {
    ///TODO: Create Room
    await bloc.createRoom(() {
      Navigator.pop(context);
    });
  }
}
