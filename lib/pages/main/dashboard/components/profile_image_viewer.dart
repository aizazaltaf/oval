import 'dart:convert';

import 'package:admin/core/images.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/widgets/face_cropper_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImageViewer extends StatelessWidget {
  const ProfileImageViewer({
    super.key,
    required this.visitor,
  });
  final VisitorsModel visitor;

  @override
  Widget build(BuildContext context) {
    bool hasFaceCoordinates = false;
    double? xCoordinate;
    double? yCoordinate;
    double? faceWidth;
    double? faceHeight;

    final List<dynamic>? coordinates = jsonDecode(visitor.faceCoordinate!);

    if (coordinates != null && coordinates.length == 4) {
      hasFaceCoordinates = coordinates[0] != null &&
          coordinates[1] != null &&
          coordinates[2] != null &&
          coordinates[3] != null;
      if (hasFaceCoordinates) {
        xCoordinate = coordinates[0].toDouble();
        yCoordinate = coordinates[1].toDouble();
        faceWidth = coordinates[2].toDouble();
        faceHeight = coordinates[3].toDouble();
      }
    }

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(),
      child: Stack(
        children: [
          Align(
            child: hasFaceCoordinates
                ? FaceCropperWidget(
                    imageUrl: visitor.imageUrl.toString(),
                    height: 300,
                    faceRect: Rect.fromCenter(
                      center: Offset(
                        xCoordinate! + (faceWidth! / 2),
                        yCoordinate! + (faceHeight! / 2),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: faceHeight,
                    ),
                  )
                : buildFullImage(imageUrl: visitor.imageUrl.toString()),
          ),
          Positioned(
            top: 10,
            left: 5,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  visitor.name.contains("A new") ? "Unknown" : visitor.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFullImage({required String imageUrl}) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fill,
      useOldImageOnUrlChange: true,
      errorWidget: (context, exception, trace) {
        return Image.asset(
          fit: BoxFit.cover,
          height: 500,
          width: 500,
          DefaultImages.USER_IMG_PLACEHOLDER,
        );
      },
      height: 500,
      width: 500,
    );
  }
}
