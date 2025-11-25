import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmerWidget extends StatelessWidget {
  const ProfileShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PrimaryShimmer(
          child: CircleAvatar(
            radius: 70,
          ),
        ),
        const SizedBox(height: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Full Name"),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 40),
                PrimaryShimmer(
                  child: Container(
                    width: 250,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Email Address"),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 40),
                PrimaryShimmer(
                  child: Container(
                    width: 250,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Phone Number"),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 40),
                PrimaryShimmer(
                  child: Container(
                    width: 250,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class PrimaryShimmer extends StatelessWidget {
  const PrimaryShimmer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: child,
    );
  }
}
