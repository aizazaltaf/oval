import 'dart:convert';

import 'package:admin/core/images.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/dashboard/components/profile_image_viewer.dart';
import 'package:admin/widgets/face_cropper_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VisitorProfileImage extends StatelessWidget {
  const VisitorProfileImage({super.key, required this.visitor, this.size});

  final VisitorsModel visitor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    bool hasFaceCoordinates = false;
    double? xCoordinate;
    double? yCoordinate;
    double? faceWidth;
    double? faceHeight;

    if (visitor.faceCoordinate != null) {
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
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ProfileImageViewer(
            visitor: visitor,
          ),
        );
      },
      child: ClipOval(
        child: hasFaceCoordinates
            ? FaceCropperWidget(
                imageUrl: visitor.imageUrl.toString(),
                width: size ?? 50,
                height: size ?? 50,
                shape: BoxShape.circle,
                faceRect: Rect.fromCenter(
                  center: Offset(
                    xCoordinate! + (faceWidth! / 2),
                    yCoordinate! + (faceHeight! / 2),
                  ),
                  width: faceWidth + 150,
                  height: faceHeight + 50,
                ),
              )
            : buildFullImage(imageUrl: visitor.imageUrl.toString()),
      ),
    );
  }

  Widget buildFullImage({required String imageUrl}) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      useOldImageOnUrlChange: true,
      fit: BoxFit.fill,
      errorWidget: (context, exception, trace) {
        return Image.asset(
          fit: BoxFit.cover,
          height: size ?? 50,
          width: size ?? 50,
          DefaultImages.USER_IMG_PLACEHOLDER,
        );
      },
      height: size ?? 50,
      width: size ?? 50,
    );
  }
}
