// import 'package:admin/models/data/user_device_model.dart';
// import 'package:admin/widgets/scaffold.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_svg/svg.dart';
//
// class SettingsScreen extends StatefulWidget {
//   UserDeviceModel userDeviceModel;
//   DoorbellSettingsScreen({super.key, required this.userDeviceModel});
//
//   @override
//   State<DoorbellSettingsScreen> createState() => _DoorbellSettingsScreenState();
// }
//
// class _DoorbellSettingsScreenState extends State<DoorbellSettingsScreen> {
//   TextEditingController nameEditTextController = TextEditingController();
//
//
//   bool isDoorbellIotConnected(String deviceId) {
//     bool isDeviceConnected = false;
//
//     for (int i = 0; i < iotController.iotDevices.length; i++) {
//       if (iotController.iotDevices[i].device_id == deviceId) {
//         isDeviceConnected = true;
//         break;
//       }
//     }
//
//     return isDeviceConnected;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String role = widget.userDeviceModel.role.toString().toLowerCase();
//     return PopScope(
//       canPop: canPop,
//       onPopInvokedWithResult: (bool, dynamic) {
//         if (isEditing) {
//           isEditing = false;
//           canPop = true;
//           nameEditTextController.text = widget.userDeviceModel.name.toString();
//           errorMessage = '';
//           setState(() {});
//         }
//       },
//       child: AppScaffold(
//         appTitle: "Doorbell Controls",
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 // height: 150,
//                 decoration: ShapeDecoration(
//                   color: const Color(0xFFFAFDFD),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   shadows: [
//                     const BoxShadow(
//                       color: Color(0x19000000),
//                       blurRadius: 7,
//                       offset: Offset(0, 2),
//                       spreadRadius: 0,
//                     )
//                   ],
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16, vertical: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Doorbell Name',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontFamily: Constants.fontFamily,
//                           color: AppColors.textGreyColor,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const PopupMenuDivider(),
//                       const SizedBox(
//                         height: 3,
//                       ),
//                       Row(
//                         crossAxisAlignment:
//                         CrossAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             child: Row(
//                               children: [
//                                 SvgPicture.asset(
//                                   LocalAssets.doorbellSettingsIcon,
//                                   width: 20,
//                                   height: 20,
//                                   colorFilter: ColorFilter.mode(
//                                     AppColors.textGreyColor,
//                                     BlendMode.srcIn,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 15,
//                                 ),
//                                 isEditing == false
//                                     ? SizedBox(
//                                   width:
//                                   MediaQuery.of(context)
//                                       .size
//                                       .width *
//                                       0.6,
//                                   child: Text(
//                                     nameEditTextController
//                                         .text,
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontFamily: Constants
//                                           .fontFamily,
//                                       color: AppColors
//                                           .textGreyColor,
//                                       fontWeight:
//                                       FontWeight.w400,
//                                     ),
//                                   ),
//                                 )
//                                     : SizedBox(
//                                   width:
//                                   MediaQuery.of(context)
//                                       .size
//                                       .width *
//                                       0.6,
//                                   child: Column(
//                                     children: [
//                                       TextField(
//                                         controller:
//                                         nameEditTextController,
//                                         decoration:
//                                         InputDecoration(
//                                           focusedBorder: OutlineInputBorder(
//                                               borderRadius: const BorderRadius
//                                                   .all(Radius
//                                                   .circular(
//                                                   10)),
//                                               borderSide: BorderSide(
//                                                   color: AppColors
//                                                       .modesUnselected)),
//                                           enabledBorder: OutlineInputBorder(
//                                               borderRadius: const BorderRadius
//                                                   .all(Radius
//                                                   .circular(
//                                                   10)),
//                                               borderSide: BorderSide(
//                                                   color: AppColors
//                                                       .modesUnselected)),
//                                           filled:
//                                           true, // Enables the background color
//                                           fillColor:
//                                           Colors.white,
//                                           contentPadding:
//                                           const EdgeInsets.only(
//                                               left: 10),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           (isEditing == false)
//                               ? GestureDetector(behavior: HitTestBehavior.opaque,
//                             onTap: () {
//                               isEditing = true;
//                               canPop = false;
//                               setState(() {});
//                             },
//                             child: Icon(
//                               Icons.edit_outlined,
//                               size: 20,
//                               color: AppColors.textGreyColor,
//                             ),
//                           )
//                               : GestureDetector(behavior: HitTestBehavior.opaque,
//                             onTap: () async {
//                               if (nameEditTextController.text
//                                   .trim()
//                                   .isEmpty ||
//                                   Constants
//                                       .noSpecialCharactersRegex
//                                       .hasMatch(
//                                       nameEditTextController
//                                           .text) ==
//                                       false) {
//                                 errorMessage =
//                                 "Doorbell name cannot be empty or have special characters.";
//                                 setState(() {});
//                               } else if (nameEditTextController
//                                   .text
//                                   .trim()
//                                   .toLowerCase() ==
//                                   widget.userDeviceModel.name
//                                       .toString()
//                                       .trim()
//                                       .toLowerCase()) {
//                                 errorMessage =
//                                 'Doorbell Name should be unique.';
//                                 setState(() {});
//                               } else {
//                                 bool result = CommonFunctions
//                                     .checkIsCameraNameExist(
//                                     dashboardController
//                                         .userDevices,
//                                     iotController
//                                         .iotDevices,
//                                     widget.userDeviceModel
//                                         .deviceId,
//                                     nameEditTextController
//                                         .text);
//                                 if (result == true) {
//                                   errorMessage =
//                                   'Doorbell Name should be unique.';
//                                   setState(() {});
//                                 } else {
//                                   errorMessage = '';
//                                   EasyLoading.show(
//                                       maskType:
//                                       EasyLoadingMaskType
//                                           .black,
//                                       indicator:
//                                       CircularProgressIndicator(
//                                         color: AppColors
//                                             .primaryColor,
//                                       ));
//                                   bool result = await Api
//                                       .editDoorbellName(
//                                       context,
//                                       widget
//                                           .userDeviceModel
//                                           .deviceId,
//                                       nameEditTextController
//                                           .text);
//                                   if (result == true) {
//                                     iotController
//                                         .selectedDoorbellIotDeviceName =
//                                         nameEditTextController
//                                             .text;
//                                     iotController.notify();
//                                   }
//                                   isEditing = false;
//                                   canPop = true;
//                                   setState(() {});
//                                 }
//                               }
//                             },
//                             child: Container(
//                               width: 28,
//                               height: 28,
//                               decoration: ShapeDecoration(
//                                 gradient: const LinearGradient(
//                                   begin:
//                                   Alignment(0.00, -1.00),
//                                   end: Alignment(0, 1),
//                                   colors: [
//                                     Color(0xFF43CEFF),
//                                     Color(0xFF0082B0)
//                                   ],
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                   BorderRadius.circular(
//                                       10),
//                                 ),
//                               ),
//                               child: const Icon(
//                                 Icons.check_rounded,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       errorMessage.isEmpty
//                           ? const SizedBox.shrink()
//                           : Container(
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 35),
//                         child: Text(
//                           errorMessage,
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.red,
//                               fontFamily:
//                               Constants.fontFamily),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               GestureDetector(behavior: HitTestBehavior.opaque,
//                 onTap: () async {
//                   String? phone = await Api.getUserPhone();
//                   print(phone);
//                   if (role == 'viewer') {
//                     const SizedBox();
//                   } else {
//                     if (filterDoorbells.length == 1) {
//                       if (role == 'owner') {
//                         showDialog(
//                             context: context,
//                             builder: (context) {
//                               return Dialog(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                   BorderRadius.circular(16.0),
//                                 ),
//                                 child: Container(
//                                   padding:
//                                   const EdgeInsets.symmetric(
//                                     horizontal: 20.0,
//                                     vertical: 20.0,
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.center,
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       // Icon(
//                                       //   Icons.warning_rounded,
//                                       //   color: Colors.black,
//                                       //   size: 30,
//                                       // ),
//                                       // SizedBox(
//                                       //   height: 10,
//                                       // ),
//                                       // Text(
//                                       //   "Attention Required",
//                                       //   style: TextStyle(
//                                       //       fontWeight:
//                                       //           FontWeight.w600,
//                                       //       fontSize: 18,
//                                       //       color: AppColors
//                                       //           .textGreyColor,
//                                       //       fontFamily: Constants
//                                       //           .fontFamily),
//                                       // ),
//                                       // SizedBox(
//                                       //   height: 10,
//                                       // ),
//                                       Text(
//                                           'Are you sure you want to release the doorbell permanently?',
//                                           textAlign:
//                                           TextAlign.center,
//                                           style: TextStyle(
//                                               fontWeight:
//                                               FontWeight.w600,
//                                               fontSize: 18,
//                                               color: AppColors
//                                                   .textGreyColor,
//                                               fontFamily: Constants
//                                                   .fontFamily)),
//                                       const SizedBox(
//                                         height: 8,
//                                       ),
//                                       Text(
//                                           'This action will delete all the data associated with your Doorbell ${isDoorbellIotConnected(widget.userDeviceModel.deviceId) == false ? "device" : "including connected smart devices"}.',
//                                           textAlign:
//                                           TextAlign.center,
//                                           style: TextStyle(
//                                               fontWeight:
//                                               FontWeight.w600,
//                                               fontSize: 18,
//                                               color: AppColors
//                                                   .textGreyColor,
//                                               fontFamily: Constants
//                                                   .fontFamily)),
//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment
//                                             .start,
//                                         children: [
//                                           Expanded(
//                                             child: GestureDetector(behavior: HitTestBehavior.opaque,
//                                               onTap: () {
//                                                 Navigator.of(
//                                                     context)
//                                                     .pop();
//                                               },
//                                               child: Container(
//                                                 height: 55,
//                                                 alignment: Alignment
//                                                     .center,
//                                                 decoration:
//                                                 ShapeDecoration(
//                                                   color:
//                                                   Colors.white,
//                                                   shape:
//                                                   RoundedRectangleBorder(
//                                                     side: BorderSide(
//                                                         width: 1,
//                                                         color: AppColors
//                                                             .moreShopDBCancel),
//                                                     borderRadius:
//                                                     BorderRadius
//                                                         .circular(
//                                                         10),
//                                                   ),
//                                                 ),
//                                                 child: Text(
//                                                   "Cancel",
//                                                   style: TextStyle(
//                                                       fontSize: 17,
//                                                       color: AppColors
//                                                           .moreShopDBCancel,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             width: 8,
//                                           ),
//                                           Expanded(
//                                             child: GestureDetector(behavior: HitTestBehavior.opaque,
//                                               onTap: () async {
//                                                 Navigator.pop(
//                                                     context);
//
//                                                 Navigator.of(
//                                                     context)
//                                                     .push(
//                                                   MaterialPageRoute(
//                                                     builder:
//                                                         (context) =>
//                                                         OTPVerificationScreen(
//                                                           processType:
//                                                           Constants
//                                                               .releaseDoorbellProcessType,
//                                                           isEmailOTP:
//                                                           false,
//                                                           phoneNumber:
//                                                           phone!,
//                                                           payload: {
//                                                             "device_id":
//                                                             "${widget.userDeviceModel.id}",
//                                                             "device_name": widget
//                                                                 .userDeviceModel
//                                                                 .deviceId,
//                                                             "devices_remains":
//                                                             filterDoorbells.length -
//                                                                 1,
//                                                             "user_role":
//                                                             role,
//                                                           },
//                                                         ),
//                                                   ),
//                                                 );
//                                               },
//                                               child: Container(
//                                                 height: 55,
//                                                 alignment: Alignment
//                                                     .center,
//                                                 decoration:
//                                                 BoxDecoration(
//                                                   borderRadius:
//                                                   BorderRadius
//                                                       .circular(
//                                                       10.0),
//                                                   gradient:
//                                                   const LinearGradient(
//                                                     begin: Alignment
//                                                         .topCenter,
//                                                     end: Alignment
//                                                         .bottomCenter,
//                                                     colors: [
//                                                       Color(
//                                                           0xFF44CEFF),
//                                                       Color(
//                                                           0xFF0082B0),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 child: const Text(
//                                                   "Proceed",
//                                                   style: TextStyle(
//                                                       fontSize: 17,
//                                                       color: Colors
//                                                           .white,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             });
//                       } else if (role == 'admin') {
//                         showDialog(
//                             context: context,
//                             builder: (context) {
//                               return Dialog(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                   BorderRadius.circular(16.0),
//                                 ),
//                                 child: Container(
//                                   padding:
//                                   const EdgeInsets.symmetric(
//                                     horizontal: 20.0,
//                                     vertical: 20.0,
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.center,
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text(
//                                         "As an admin user you cannot release this doorbell as its the only doorbell remaining to this location",
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontWeight:
//                                             FontWeight.w600,
//                                             fontSize: 18,
//                                             color: AppColors
//                                                 .textGreyColor,
//                                             fontFamily: Constants
//                                                 .fontFamily),
//                                       ),
//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text(
//                                           'Only homeowner can release this doorbell.',
//                                           textAlign:
//                                           TextAlign.center,
//                                           style: TextStyle(
//                                               fontWeight:
//                                               FontWeight.w600,
//                                               fontSize: 18,
//                                               color: AppColors
//                                                   .textGreyColor,
//                                               fontFamily: Constants
//                                                   .fontFamily)),
//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       GestureDetector(behavior: HitTestBehavior.opaque,
//                                         onTap: () async {
//                                           Navigator.pop(context);
//                                         },
//                                         child: Container(
//                                           height: 55,
//                                           alignment:
//                                           Alignment.center,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                             BorderRadius
//                                                 .circular(10.0),
//                                             gradient:
//                                             const LinearGradient(
//                                               begin: Alignment
//                                                   .topCenter,
//                                               end: Alignment
//                                                   .bottomCenter,
//                                               colors: [
//                                                 Color(0xFF44CEFF),
//                                                 Color(0xFF0082B0),
//                                               ],
//                                             ),
//                                           ),
//                                           child: const Text(
//                                             "Ok",
//                                             style: TextStyle(
//                                                 fontSize: 17,
//                                                 color: Colors.white,
//                                                 fontWeight:
//                                                 FontWeight
//                                                     .w700),
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             });
//                       }
//                     } else {
//                       showDialog(
//                           context: context,
//                           builder: (context) {
//                             return Dialog(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                 BorderRadius.circular(16.0),
//                               ),
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 20.0,
//                                   vertical: 20.0,
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.center,
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                         'Are you sure you want to release the doorbell permanently?',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontWeight:
//                                             FontWeight.w600,
//                                             fontSize: 18,
//                                             color: AppColors
//                                                 .textGreyColor,
//                                             fontFamily: Constants
//                                                 .fontFamily)),
//                                     const SizedBox(
//                                       height: 8,
//                                     ),
//                                     Text(
//                                         'This action will delete all the data associated with your Doorbell ${isDoorbellIotConnected(widget.userDeviceModel.deviceId) == false ? "device" : "including connected smart devices"}.',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontWeight:
//                                             FontWeight.w600,
//                                             fontSize: 18,
//                                             color: AppColors
//                                                 .textGreyColor,
//                                             fontFamily: Constants
//                                                 .fontFamily)),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           child: GestureDetector(behavior: HitTestBehavior.opaque,
//                                             onTap: () {
//                                               Navigator.of(context)
//                                                   .pop();
//                                             },
//                                             child: Container(
//                                               height: 55,
//                                               alignment:
//                                               Alignment.center,
//                                               decoration:
//                                               ShapeDecoration(
//                                                 color: Colors.white,
//                                                 shape:
//                                                 RoundedRectangleBorder(
//                                                   side: BorderSide(
//                                                       width: 1,
//                                                       color: AppColors
//                                                           .moreShopDBCancel),
//                                                   borderRadius:
//                                                   BorderRadius
//                                                       .circular(
//                                                       10),
//                                                 ),
//                                               ),
//                                               child: Text(
//                                                 "Cancel",
//                                                 style: TextStyle(
//                                                     fontSize: 17,
//                                                     color: AppColors
//                                                         .moreShopDBCancel,
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .w700),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 8,
//                                         ),
//                                         Expanded(
//                                           child: GestureDetector(behavior: HitTestBehavior.opaque,
//                                             onTap: () async {
//                                               Navigator.pop(
//                                                   context);
//
//                                               Navigator.of(context)
//                                                   .push(
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       OTPVerificationScreen(
//                                                         processType:
//                                                         Constants
//                                                             .releaseDoorbellProcessType,
//                                                         isEmailOTP:
//                                                         false,
//                                                         phoneNumber:
//                                                         phone!,
//                                                         payload: {
//                                                           "device_id":
//                                                           "${widget.userDeviceModel.id}",
//                                                           "device_name": widget
//                                                               .userDeviceModel
//                                                               .deviceId,
//                                                           "devices_remains":
//                                                           filterDoorbells
//                                                               .length -
//                                                               1,
//                                                           "user_role":
//                                                           role,
//                                                         },
//                                                       ),
//                                                 ),
//                                               );
//                                             },
//                                             child: Container(
//                                               height: 55,
//                                               alignment:
//                                               Alignment.center,
//                                               decoration:
//                                               BoxDecoration(
//                                                 borderRadius:
//                                                 BorderRadius
//                                                     .circular(
//                                                     10.0),
//                                                 gradient:
//                                                 const LinearGradient(
//                                                   begin: Alignment
//                                                       .topCenter,
//                                                   end: Alignment
//                                                       .bottomCenter,
//                                                   colors: [
//                                                     Color(
//                                                         0xFF44CEFF),
//                                                     Color(
//                                                         0xFF0082B0),
//                                                   ],
//                                                 ),
//                                               ),
//                                               child: const Text(
//                                                 "Proceed",
//                                                 style: TextStyle(
//                                                     fontSize: 17,
//                                                     color: Colors
//                                                         .white,
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .w700),
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             );
//                           });
//                     }
//                   }
//                 },
//                 child: Container(
//                   height: 50,
//                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   decoration: ShapeDecoration(
//                     color: const Color(0xFFFAFDFD),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     shadows: [
//                       const BoxShadow(
//                         color: Color(0x19000000),
//                         blurRadius: 7,
//                         offset: Offset(0, 2),
//                         spreadRadius: 0,
//                       )
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(
//                         LocalAssets.release_doorbell_more,
//                         height: 20,
//                         width: 20,
//                         colorFilter: ColorFilter.mode(
//                           AppColors.textGreyColor,
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       Text("Release Doorbell",
//                           style: TextStyle(
//                               fontFamily: Constants.fontFamily,
//                               color: AppColors.textGreyColor,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w400)),
//                     ],
//                   ),
//                 ),
//               )
//               // _getConnectedDevices(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
