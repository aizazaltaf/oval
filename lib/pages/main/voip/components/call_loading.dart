import 'package:admin/core/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CallLoading extends StatelessWidget {
  const CallLoading({
    super.key,
    required this.visitorName,
    required this.visitorImage,
    this.status = "Connecting...",
  });
  final String visitorName;
  final String visitorImage;
  final String status;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            if (visitorImage.isEmpty)
              Image.asset(
                DefaultImages.FRONT_CAMERA_THUMBNAIL,
                fit: BoxFit.fill,
                width: size.width,
                height: size.height,
              )
            else
              CachedNetworkImage(
                imageUrl: visitorImage,
                useOldImageOnUrlChange: true,
                fit: BoxFit.fill,
                width: size.width,
                height: size.height,
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 20),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.pop(context),
                      child: const Icon(CupertinoIcons.back),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.05),
                Image.asset(
                  DefaultImages.APPLICATION_ICON_PNG,
                  width: 150,
                ),
                const SizedBox(height: 60),
                Text(
                  visitorName,
                  style: TextStyle(
                    color: Theme.of(context).tabBarTheme.indicatorColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  status,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
