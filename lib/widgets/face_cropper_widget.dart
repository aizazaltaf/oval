import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:admin/core/images.dart';
import 'package:admin/pages/main/user_profile/components/profile_shimmer_widget.dart';
import 'package:flutter/material.dart';

class FaceCropperWidget extends StatelessWidget {
  const FaceCropperWidget({
    super.key,
    this.imagePath,
    this.imageUrl,
    required this.faceRect,
    this.width,
    this.height,
    this.shape,
  });

  final String? imagePath;
  final String? imageUrl;
  final Rect faceRect;
  final double? width;
  final double? height;
  final BoxShape? shape;

  static Future<ui.Image> getUiImage({
    String? imageUrl,
    String? imagePath,
  }) async {
    final Completer<ImageInfo> completer = Completer();
    ImageProvider? img;

    if (imageUrl != null) {
      img = NetworkImage(imageUrl);
    } else if (imagePath != null) {
      img = FileImage(File(imagePath));
    } else {
      throw Exception("No image provided");
    }

    img.resolve(ImageConfiguration.empty).addListener(
          ImageStreamListener(
            (info, _) {
              if (!completer.isCompleted) {
                completer.complete(info);
              }
            },
            onError: (error, stackTrace) {
              if (!completer.isCompleted) {
                completer.completeError(error);
              }
            },
          ),
        );

    final ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: shape ?? BoxShape.rectangle,
      ),
      alignment: Alignment.center,
      child: FutureBuilder<ui.Image>(
        future: getUiImage(
          imageUrl: imageUrl,
          imagePath: imagePath,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Fallback to placeholder if error
            return ClipOval(
              child: Image.asset(
                DefaultImages.USER_IMG_PLACEHOLDER,
                fit: BoxFit.cover,
                height: 40,
                width: 40,
              ),
            );
          } else if (snapshot.hasData) {
            return paintImage(snapshot.data!);
          } else {
            // Otherwise, display a loading indicator.
            return const PrimaryShimmer(
              child: CircleAvatar(
                radius: 60,
              ),
            );
          }
        },
      ),
    );
  }

  Widget paintImage(ui.Image image) {
    return CustomPaint(
      painter: FaceImagePainter(
        image,
        faceRect,
      ),
      child: SizedBox(
        width: faceRect.width,
        height: faceRect.height,
      ),
    );
  }
}

class FaceImagePainter extends CustomPainter {
  FaceImagePainter(this.resImage, this.rectCrop);
  final ui.Image resImage;
  final Rect rectCrop;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Size imageSize =
        Size(resImage.width.toDouble(), resImage.height.toDouble());
    final FittedSizes sizes = applyBoxFit(BoxFit.fill, imageSize, size);

    final Rect inputSubRect = rectCrop;
    final Rect outputSubRect =
        Alignment.center.inscribe(sizes.destination, rect);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 4;

    canvas
      ..drawRect(rect, paint)
      ..drawImageRect(resImage, inputSubRect, outputSubRect, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
