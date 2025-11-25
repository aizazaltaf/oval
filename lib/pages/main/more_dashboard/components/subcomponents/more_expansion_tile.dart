import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MoreExpansionTile extends StatelessWidget {
  const MoreExpansionTile({
    super.key,
    required this.tileLeading,
    required this.title,
    required this.isExpanded,
    required this.list,
    required this.onTapTile,
  });

  final Widget tileLeading;
  final String title;
  final bool isExpanded;
  final VoidCallback onTapTile;
  final List<FeatureModel> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          shape: const Border(),
          leading: tileLeading,
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
          ),
          trailing: Icon(
            color: CommonFunctions.getThemeBasedWidgetColor(
              context,
            ),
            isExpanded
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp,
          ),
          onTap: onTapTile,
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.darkBluePrimaryColor.withValues(
                      alpha: Theme.of(context).brightness == Brightness.light
                          ? 0.1
                          : 0.45,
                    ),
                    child: SvgPicture.asset(
                      list[index].image,
                      height: 24,
                      width: 24,
                      colorFilter: ColorFilter.mode(
                        CommonFunctions.getThemeBasedPrimaryWhiteColor(context),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  title: Text(
                    list[index].title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  onTap: () => list[index].route!(context),
                );
              },
            ),
          ),
      ],
    );
  }
}
