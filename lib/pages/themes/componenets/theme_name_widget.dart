import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

class ThemeNameWidget extends StatelessWidget {
  const ThemeNameWidget({
    super.key,
    required this.theme,
  });

  final ThemeDataModel theme;

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            theme.title.contains("-") ? theme.title.split("-")[0] : theme.title,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColors.selectedTabColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
          ),
          Text(
            theme.description,
            maxLines: 5,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColors.selectedTabColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          ThemeBlocSelector.index(
            builder: (index) {
              final BuiltList<ThemeDataModel>? dataModel =
                  bloc.getThemeApiType(bloc.state.activeType).data?.data;
              return dataModel == null ||
                      index > dataModel.length - 1 ||
                      dataModel[index].userUploaded != null
                  ? const SizedBox.shrink()
                  : ThemeBlocSelector(
                      selector: (state) =>
                          bloc.getThemeApiType(state.activeType).data == null
                              ? 0
                              : index >
                                      bloc
                                              .getThemeApiType(state.activeType)
                                              .data!
                                              .data
                                              .length -
                                          1
                                  ? null
                                  : bloc
                                      .getThemeApiType(state.activeType)
                                      .data!
                                      .data[index]
                                      .userLike,
                      builder: (userLike) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              userLike == 0
                                  ? Icons.favorite_border
                                  : Icons.favorite,
                              color: userLike == 1
                                  ? Colors.red
                                  : Theme.of(context).primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${bloc.getThemeApiType(bloc.state.activeType).data != null && index > bloc.getThemeApiType(bloc.state.activeType).data!.data.length - 1 ? 0 : bloc.getThemeApiType(bloc.state.activeType).data?.data[index].totalLikes}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        );
                      },
                    );
            },
          ),
        ],
      ),
    );
  }
}
