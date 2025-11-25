import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ListViewSeparatedWidget<T> extends StatelessWidget {
  const ListViewSeparatedWidget({
    super.key,
    required this.itemBuilder,
    this.list,
    this.controller,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.physics = const NeverScrollableScrollPhysics(),
    this.separatorBuilder,
  });
  final NullableIndexedWidgetBuilder itemBuilder;
  final BuiltList<T>? list;
  final ScrollPhysics? physics;
  final IndexedWidgetBuilder? separatorBuilder;
  final Axis? scrollDirection;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: padding,
      physics: physics,
      controller: controller,
      scrollDirection: scrollDirection!,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder ??
          (context, index) {
            return SizedBox(
              height: scrollDirection == Axis.vertical ? 2.h : 0,
              width: scrollDirection == Axis.vertical ? 0 : 2.h,
            );
          },
      itemCount: list == null ? 10 : list!.length,
    );
  }
}
