import 'package:flutter/material.dart';

class MoreListTileCard extends StatelessWidget {
  const MoreListTileCard({
    super.key,
    required this.title,
    required this.leadingWidget,
    this.leadingPadding,
    required this.onSubmit,
  });
  final String? title;
  final Widget leadingWidget;
  final VoidCallback onSubmit;
  final EdgeInsets? leadingPadding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(padding: leadingPadding, child: leadingWidget),
      title: Text(
        title?.toUpperCase() ?? '',
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      onTap: onSubmit,
    );
  }
}
