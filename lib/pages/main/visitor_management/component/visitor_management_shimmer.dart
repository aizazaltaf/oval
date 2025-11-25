import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';

class VisitorManagementShimmer extends StatelessWidget {
  const VisitorManagementShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 8,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemBuilder: (_, __) => const FittedBox(
        child: ListTileShimmer(
          height: 16,
          padding: EdgeInsets.zero,
        ),
      ),
      separatorBuilder: (_, __) => const Divider(),
    );
  }
}
