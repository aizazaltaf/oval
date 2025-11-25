import 'package:admin/pages/main/statistics/components/place_holder/statistics_shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StatisticsPlaceHolder extends StatelessWidget {
  const StatisticsPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[200]!,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width * 0.90,
        child: LayoutBuilder(
          builder: (context, constraints) {
            const barWidth = 20.0;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    statisticsShimmerWidget(
                      constraints.maxHeight,
                      30,
                      barWidth,
                    ),
                    statisticsShimmerWidget(
                      constraints.maxHeight,
                      20,
                      barWidth,
                    ),
                    statisticsShimmerWidget(
                      constraints.maxHeight,
                      20,
                      barWidth,
                    ),
                    statisticsShimmerWidget(
                      constraints.maxHeight,
                      37,
                      barWidth,
                    ),
                    statisticsShimmerWidget(
                      constraints.maxHeight,
                      37,
                      barWidth,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
