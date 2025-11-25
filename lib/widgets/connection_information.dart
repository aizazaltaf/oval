import 'package:admin/constants.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ConnectionInformation extends StatelessWidget {
  const ConnectionInformation({
    super.key,
    required this.error,
    required this.onRetry,
  });
  final String? error;
  final VoidCallback? onRetry;

  @override
  Widget build(final BuildContext context) {
    if (error == null) {
      return const ButtonProgressIndicator();
    }
    Constants.dismissLoader();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          error!,
          maxLines: 20,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text(
            'Retry',
          ),
        ),
      ],
    );
  }
}

class ConnectionInformationListItem extends StatefulWidget {
  const ConnectionInformationListItem({
    super.key,
    required this.error,
    required this.onLoadMore,
  });
  final String? error;
  final VoidCallback onLoadMore;

  @override
  State<ConnectionInformationListItem> createState() =>
      _ConnectionInformationListItemState();
}

class _ConnectionInformationListItemState
    extends State<ConnectionInformationListItem>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    widget.onLoadMore();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: Center(
        child: ConnectionInformation(
          error: widget.error,
          onRetry: widget.onLoadMore,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SliverConnectionInformationListItem extends StatelessWidget {
  const SliverConnectionInformationListItem({
    required super.key,
    required this.error,
    required this.onLoadMore,
  });
  final String? error;
  final VoidCallback onLoadMore;

  @override
  Widget build(final BuildContext context) {
    return _SliverConnectionInformationListItem(
      onLoadMore: onLoadMore,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Center(
          child: ConnectionInformation(
            error: error,
            onRetry: onLoadMore,
          ),
        ),
      ),
    );
  }
}

class _SliverConnectionInformationListItem
    extends SingleChildRenderObjectWidget {
  const _SliverConnectionInformationListItem({
    required this.onLoadMore,
    super.child,
  });
  final VoidCallback onLoadMore;

  @override
  RenderObject createRenderObject(final BuildContext context) =>
      _SliverConnectionInformationListItemRenderObject(
        onLoadMore: onLoadMore,
      );
}

class _SliverConnectionInformationListItemRenderObject
    extends RenderSliverSingleBoxAdapter {
  _SliverConnectionInformationListItemRenderObject({
    required this.onLoadMore,
  });
  bool isLoadMoreCalled = false;
  final VoidCallback onLoadMore;

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
      case Axis.vertical:
        childExtent = child!.size.height;
    }
    final double paintedChildSize = calculatePaintOffset(
      constraints,
      from: 0,
      to: childExtent,
    );
    final double cacheExtent = calculateCacheOffset(
      constraints,
      from: 0,
      to: childExtent,
    );
    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);

    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child!, constraints, geometry!);
    if (!isLoadMoreCalled &&
        constraints.remainingPaintExtent > child!.size.height / 2) {
      isLoadMoreCalled = true;
      onLoadMore();
    }
  }
}
