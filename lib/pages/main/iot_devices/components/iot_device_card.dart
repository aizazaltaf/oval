// import 'package:admin/core/images.dart';
// import 'package:admin/extensions/context.dart';
// import 'package:admin/extensions/string.dart';
// import 'package:admin/pages/main/iot_devices/components/app_switch.dart';
// import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
// import 'package:admin/widgets/app_colors.dart';
// import 'package:admin/widgets/common_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class IotDeviceCard extends StatefulWidget {
//   const IotDeviceCard({
//     super.key,
//     required this.deviceItem,
//     required this.onChanged,
//   });
//
//   final IotDeviceModel deviceItem;
//   final ValueChanged<bool> onChanged;
//
//   @override
//   State<IotDeviceCard> createState() => _IotDeviceCardState();
// }
//
// class _IotDeviceCardState extends State<IotDeviceCard> {
//   Color getDeviceColor(BuildContext context, IotDeviceModel deviceItem) {
//     if (deviceItem.stateAvailable == 3) {
//       return AppColors.darkGreyBg;
//     }
//
//     final isSwitchBot =
//         deviceItem.entityId?.split('.').first.contains('switchbot') ?? false;
//
//     if (isSwitchBot) {
//       if (deviceItem.curtainDeviceId == null) {
//         return AppColors.darkGreyBg;
//       } else {
//         return CommonFunctions.getThemeWidgetColor(context);
//       }
//     }
//
//     // Fallback color (optional)
//     return CommonFunctions.getThemeWidgetColor(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: getDeviceColor(context, widget.deviceItem),
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12, // Shadow color
//             blurRadius: 15, // Spread of the shadow
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               if ((widget.deviceItem.stateAvailable == 3) &&
//                   !widget.deviceItem.entityId!
//                       .split('.')
//                       .first
//                       .contains('switchbot'))
//                 SvgPicture.asset(
//                   widget.deviceItem.imagePreview!,
//                   colorFilter: const ColorFilter.mode(
//                     Colors.white,
//                     BlendMode.srcIn,
//                   ),
//                   height: 30,
//                   width: 30,
//                 )
//               else
//                 SvgPicture.asset(
//                   widget.deviceItem.imagePreview!,
//                   height: 30,
//                   width: 30,
//                 ),
//               if (widget.deviceItem.entityId!
//                   .split('.')
//                   .first
//                   .contains('switchbot'))
//                 const SizedBox.shrink()
//               else
//                 ((widget.deviceItem.stateAvailable == 3) &&
//                         !widget.deviceItem.entityId!
//                             .split('.')
//                             .first
//                             .contains('switchbot'))
//                     ? GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         onTap: () {
//                           // CommonFunctions.warningToast(
//                           //     context, AppMessages.lightPoweredOff);
//                         },
//                         child: SvgPicture.asset(DefaultIcons.DISABLED_SWITCH),
//                       )
//                     : AppSwitchWidget(
//                         thumbSize: 20,
//                         value: (widget.deviceItem.entityId?.isLock() ?? false)
//                             ? widget.deviceItem.stateAvailable == 2
//                             : widget.deviceItem.stateAvailable == 1,
//                         onChanged: widget.onChanged,
//                       ),
//             ],
//           ),
//           const SizedBox(
//             height: 25,
//           ),
//           Expanded(
//             child: Text(
//               widget.deviceItem.deviceName ?? "",
//               overflow: TextOverflow.ellipsis,
//               // maxLines: 1,
//               style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                     fontSize: 12,
//                     color: ((widget.deviceItem.stateAvailable == 3) &&
//                             !widget.deviceItem.entityId!
//                                 .split('.')
//                                 .first
//                                 .contains('switchbot'))
//                         ? Theme.of(context)
//                             .cupertinoOverrideTheme!
//                             .barBackgroundColor
//                         : Theme.of(context).tabBarTheme.indicatorColor,
//                   ),
//             ),
//           ),
//           Text(
//             widget.deviceItem.room == null
//                 ? context.appLocalizations.living_room
//                 : widget.deviceItem.room!.roomName ?? "",
//             maxLines: 1,
//             style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                   fontSize: 12,
//                   color: ((widget.deviceItem.stateAvailable == 3) &&
//                           !widget.deviceItem.entityId!
//                               .split('.')
//                               .first
//                               .contains('switchbot'))
//                       ? Theme.of(context)
//                           .cupertinoOverrideTheme!
//                           .barBackgroundColor
//                       : Theme.of(context).tabBarTheme.indicatorColor,
//                 ),
//           ),
//         ],
//       ),
//     );
//   }
// }
