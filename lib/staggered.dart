import 'dart:math' as math;

import 'package:flutter/material.dart';

/// An optimized StaggeredGridView widget that works better with existing device widgets
class StaggeredGridView extends StatelessWidget {
  /// Creates a [StaggeredGridView] with the given parameters
  const StaggeredGridView({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 4.0,
    this.crossAxisSpacing = 4.0,
    this.randomSeed,
    this.maxItemHeight,
    this.minItemHeight,
    this.preserveAspectRatio = false,
  });

  /// The list of widgets to display in the staggered grid
  final List<Widget> children;

  /// The number of columns in the grid
  final int crossAxisCount;

  /// The spacing between items along the main axis (vertical)
  final double mainAxisSpacing;

  /// The spacing between items along the cross axis (horizontal)
  final double crossAxisSpacing;

  /// Optional seed for random positioning (for consistent layouts)
  final int? randomSeed;

  /// Maximum height for individual items (prevents overflow)
  final double? maxItemHeight;

  /// Minimum height for individual items
  final double? minItemHeight;

  /// Whether to preserve the aspect ratio of child widgets
  final bool preserveAspectRatio;

  @override
  Widget build(BuildContext context) {
    return _StaggeredGridRenderWidget(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      randomSeed: randomSeed,
      maxItemHeight: maxItemHeight,
      minItemHeight: minItemHeight,
      preserveAspectRatio: preserveAspectRatio,
      children: children,
    );
  }
}

/// Internal widget that handles the rendering logic
class _StaggeredGridRenderWidget extends StatelessWidget {
  const _StaggeredGridRenderWidget({
    required this.children,
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    this.randomSeed,
    this.maxItemHeight,
    this.minItemHeight,
    this.preserveAspectRatio = false,
  });

  final List<Widget> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final int? randomSeed;
  final double? maxItemHeight;
  final double? minItemHeight;
  final bool preserveAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use more conservative padding for better spacing
        final availableWidth =
            constraints.maxWidth - 60; // 30px padding on each side
        final itemWidth =
            (availableWidth - (crossAxisCount - 1) * crossAxisSpacing) /
                crossAxisCount;

        // Generate more predictable sizes for each child
        final random = math.Random(randomSeed);
        final positionedChildren = <Widget>[];

        // Track the height of each column
        final columnHeights = List<double>.filled(crossAxisCount, 0);

        for (int i = 0; i < children.length; i++) {
          // Use more conservative sizing to prevent overlapping
          final crossAxisSpan = _getConservativeCrossAxisSpan(random, i);
          final mainAxisHeight = _getConservativeMainAxisHeight(
            random,
            itemWidth,
            constraints.maxHeight,
          );

          // Find the shortest column to place this item
          final targetColumn = _findShortestColumn(columnHeights);

          // Calculate position with proper spacing
          final left = 30 + targetColumn * (itemWidth + crossAxisSpacing);
          final top = columnHeights[targetColumn];

          // Calculate actual item dimensions with safety margins
          final actualWidth = math.min(
            crossAxisSpan * (itemWidth + crossAxisSpacing) - crossAxisSpacing,
            itemWidth * 1.5, // Limit max width to prevent overflow
          );
          final actualHeight =
              math.min(mainAxisHeight, itemWidth * 1.3); // Limit max height

          // Ensure item doesn't go outside viewport horizontally
          if (left + actualWidth > constraints.maxWidth - 30) {
            // Force single column placement for safety
            final singleColumnWidth = itemWidth;
            final singleColumnLeft =
                30 + targetColumn * (itemWidth + crossAxisSpacing);

            positionedChildren.add(
              Positioned(
                left: singleColumnLeft,
                top: columnHeights[targetColumn],
                child: _OverflowSafeContainer(
                  width: singleColumnWidth,
                  height: actualHeight,
                  preserveAspectRatio: preserveAspectRatio,
                  child: children[i],
                ),
              ),
            );
            columnHeights[targetColumn] += actualHeight + mainAxisSpacing;
            continue;
          }

          // Update column height
          columnHeights[targetColumn] += actualHeight + mainAxisSpacing;

          positionedChildren.add(
            Positioned(
              left: left,
              top: top,
              child: _OverflowSafeContainer(
                width: actualWidth,
                height: actualHeight,
                preserveAspectRatio: preserveAspectRatio,
                child: children[i],
              ),
            ),
          );
        }

        // Calculate total height needed
        final totalHeight = columnHeights.reduce(math.max) - mainAxisSpacing;

        return SizedBox(
          height: totalHeight,
          child: Stack(
            children: positionedChildren,
          ),
        );
      },
    );
  }

  /// Get a conservative cross-axis span to prevent overlapping
  int _getConservativeCrossAxisSpan(math.Random random, int itemIndex) {
    // For the first few items, prefer single column to establish a good base
    if (itemIndex < 2) {
      return 1;
    }

    // For remaining items, use more conservative distribution
    final weights = [0.8, 0.2]; // 80% single column, 20% double column
    final randomValue = random.nextDouble();

    if (randomValue < weights[0]) {
      return 1;
    }
    if (randomValue < weights[0] + weights[1] && crossAxisCount >= 2) {
      return 2;
    }
    return 1; // Default to single column for safety
  }

  /// Get a random cross-axis span (1 to crossAxisCount) - kept for backward compatibility
  // int _getRandomCrossAxisSpan(math.Random random) {
  //   // More balanced weights for better variety while maintaining safety
  //   final weights = [0.6, 0.25, 0.15]; // More variety in spans
  //   final randomValue = random.nextDouble();
  //
  //   if (randomValue < weights[0]) {
  //     return 1;
  //   }
  //   if (randomValue < weights[0] + weights[1]) {
  //     return 2;
  //   }
  //   // Only allow 3+ spans if we have enough columns
  //   if (crossAxisCount >= 3 &&
  //       randomValue < weights[0] + weights[1] + weights[2]) {
  //     return 3;
  //   }
  //   return 1; // Default to single column for safety
  // }

  /// Get a conservative main-axis height to prevent overlapping
  double _getConservativeMainAxisHeight(
    math.Random random,
    double itemWidth,
    double maxAvailableHeight,
  ) {
    if (preserveAspectRatio) {
      // For device widgets, use more conservative sizing
      final baseHeight =
          itemWidth * 0.8; // Slightly taller for better visibility
      final variation = random.nextDouble() * 0.2 +
          0.9; // 0.9 to 1.1 multiplier (conservative)
      final calculatedHeight = baseHeight * variation;

      // Apply stricter min/max constraints
      final minHeight = minItemHeight ?? itemWidth * 0.7;
      final maxHeight =
          maxItemHeight ?? math.min(itemWidth * 1.1, maxAvailableHeight * 0.2);

      return math.max(minHeight, math.min(calculatedHeight, maxHeight));
    } else {
      // For general widgets, use conservative sizing
      final baseHeight = itemWidth * 0.5;
      final variation = random.nextDouble() * 0.2 +
          0.9; // 0.9 to 1.1 multiplier (conservative)
      final calculatedHeight = baseHeight * variation;

      final minHeight = minItemHeight ?? itemWidth * 0.4;
      final maxHeight =
          maxItemHeight ?? math.min(itemWidth * 1.0, maxAvailableHeight * 0.25);

      return math.max(minHeight, math.min(calculatedHeight, maxHeight));
    }
  }

  /// Get a random main-axis height with overflow protection - kept for backward compatibility
  // double _getRandomMainAxisHeight(
  //   math.Random random,
  //   double itemWidth,
  //   double maxAvailableHeight,
  // ) {
  //   if (preserveAspectRatio) {
  //     // For device widgets, use more varied sizing for better visual interest
  //     final baseHeight = itemWidth * 0.7;
  //     final variation = random.nextDouble() * 0.3 +
  //         0.7; // 0.7 to 1.0 multiplier (more variation)
  //     final calculatedHeight = baseHeight * variation;
  //
  //     // Apply min/max constraints
  //     final minHeight = minItemHeight ?? itemWidth * 0.6;
  //     final maxHeight =
  //         maxItemHeight ?? math.min(itemWidth * 1.2, maxAvailableHeight * 0.25);
  //
  //     return math.max(minHeight, math.min(calculatedHeight, maxHeight));
  //   } else {
  //     // For general widgets, use more varied sizing
  //     final baseHeight = itemWidth * 0.4;
  //     final variation = random.nextDouble() * 0.4 +
  //         0.6; // 0.6 to 1.0 multiplier (more variation)
  //     final calculatedHeight = baseHeight * variation;
  //
  //     final minHeight = minItemHeight ?? itemWidth * 0.3;
  //     final maxHeight =
  //         maxItemHeight ?? math.min(itemWidth * 1.1, maxAvailableHeight * 0.3);
  //
  //     return math.max(minHeight, math.min(calculatedHeight, maxHeight));
  //   }
  // }

  /// Find the column with the minimum height, with some randomness for variety
  int _findShortestColumn(List<double> columnHeights) {
    // Find all columns with minimum height (or close to it)
    final minHeight = columnHeights.reduce(math.min);
    final tolerance = minHeight * 0.1; // 10% tolerance for "shortest" columns

    final shortestColumns = <int>[];
    for (int i = 0; i < columnHeights.length; i++) {
      if (columnHeights[i] <= minHeight + tolerance) {
        shortestColumns.add(i);
      }
    }

    // If multiple columns are similarly short, randomly pick one for variety
    if (shortestColumns.length > 1) {
      final random = math.Random();
      return shortestColumns[random.nextInt(shortestColumns.length)];
    }

    return shortestColumns.first;
  }
}

/// A container that prevents overflow by clipping content
class _OverflowSafeContainer extends StatelessWidget {
  const _OverflowSafeContainer({
    required this.width,
    required this.height,
    required this.child,
    this.preserveAspectRatio = false,
  });

  final double width;
  final double height;
  final Widget child;
  final bool preserveAspectRatio;

  @override
  Widget build(BuildContext context) {
    if (preserveAspectRatio) {
      // For device widgets, use AspectRatio to maintain proportions
      return SizedBox(
        width: width,
        height: height,
        child: AspectRatio(
          aspectRatio: width / height,
          child: ClipRect(
            child: OverflowBox(
              maxWidth: width,
              maxHeight: height,
              child: child,
            ),
          ),
        ),
      );
    } else {
      // For general widgets, use standard overflow protection
      return SizedBox(
        width: width,
        height: height,
        child: ClipRect(
          child: OverflowBox(
            maxWidth: width,
            maxHeight: height,
            child: child,
          ),
        ),
      );
    }
  }
}
