import 'package:admin/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeatureItems extends StatelessWidget {
  const FeatureItems({
    super.key,
    required this.title,
    required this.image,
    required this.color,
    this.svgBool,
    this.cardColor,
    required this.route,
  });

  final String title;
  final String image;
  final bool? svgBool;
  final Color color;
  final Color? cardColor;
  final Function(BuildContext) route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => route(context),
      child: Container(
        height: 130,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: cardColor ??
              (Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Theme.of(context)
                      .textSelectionTheme
                      .cursorColor!
                      .withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(15),
          boxShadow: Theme.of(context).brightness == Brightness.dark
              ? []
              : [
                  const BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2,
                    blurRadius: 3,
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (svgBool == false)
              Image.asset(
                image,
                height: 60,
                width: 60,
              )
            else
              SvgPicture.asset(
                image,
                height: 60,
                width: 60,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            const SizedBox(height: 9),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickAccessItems extends StatelessWidget {
  const QuickAccessItems({
    super.key,
    required this.title,
    required this.image,
    this.color,
    this.isDisabled = false,
    required this.route,
  });

  final String title;
  final String image;
  final Color? color;
  final bool isDisabled;
  final Function(BuildContext) route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => route(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular button with microphone icon
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDisabled ? AppColors.darkGreyBg : color,
            ),
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              image,
              height: 24,
              width: 24,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: isDisabled ? AppColors.darkGreyBg : color,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}
