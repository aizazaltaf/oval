import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/user_profile/components/profile_shimmer_widget.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_add_info_screen.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:cached_network_image/cached_network_image.dart' as cache;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class CreateAIThemeScreen extends StatefulWidget {
  const CreateAIThemeScreen({super.key, this.text});
  final String? text;
  static const routeName = "createAiTheme";

  static Future<void> push(final BuildContext context, {String? text}) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => CreateAIThemeScreen(text: text),
    );
  }

  @override
  State<CreateAIThemeScreen> createState() => _CreateAIThemeScreenState();
}

class _CreateAIThemeScreenState extends State<CreateAIThemeScreen> {
  @override
  void initState() {
    createTheme();
    super.initState();
  }

  void createTheme() {
    final bloc = ThemeBloc.of(context);
    if (widget.text != null) {
      bloc.updateAiThemeText(widget.text!);
      Future.delayed(const Duration(seconds: 1), bloc.processAITheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    return PopScope(
      onPopInvokedWithResult: (_, r) {
        bloc.refreshCreateTheme();
      },
      child: AppScaffold(
        appTitle: context.appLocalizations.create_a_theme,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Text",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(
                  height: 14,
                ),
                NameTextFormField(
                  initialValue: widget.text,
                  hintText: context.appLocalizations.described_desired_themes,
                  textInputAction: TextInputAction.done,
                  maxLines: 10,
                  textCapitalization: TextCapitalization.none,
                  onChanged: bloc.updateAiThemeText,
                  validator: (value) {
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z\s]'),
                    ), // Allow alphabets and spaces
                    LengthLimitingTextInputFormatter(100),
                  ],
                  // onChanged: bloc.updateName,
                ),
                const SizedBox(height: 40),
                ThemeBlocSelector(
                  selector: (state) => state.generateAiThemeApi.isApiInProgress,
                  builder: (progress) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Remaining ${singletonBloc.profileBloc.state!.aiThemeCounter} Attempts Only",
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomGradientButton(
                          customWidth: 40.w,
                          customHeight: 5.h,
                          isLoadingEnabled: progress,
                          onSubmit: () {
                            if (!progress) {
                              bloc.processAITheme();
                            }
                          },
                          label: (bloc.state.generatedImage != null &&
                                      bloc.state.aiThemeText.isNotEmpty) ||
                                  bloc.state.aiError.isNotEmpty
                              ? "Re-Create"
                              : "Create",
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                ThemeBlocSelector.aiError(
                  builder: (aiError) {
                    if (aiError.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Oops! Unable to create your theme.",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          aiError,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
                ThemeBlocSelector.generatedImage(
                  builder: (generatedImage) {
                    if (generatedImage != null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: cache.CachedNetworkImage(
                                      imageUrl: generatedImage,
                                      fit: BoxFit.fill,
                                      width: 250,
                                      height: 350,
                                      placeholder: (c_, _) => PrimaryShimmer(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    right: 10,
                                    child: ThemeBlocSelector.aiThemeText(
                                      builder: (aiThemeText) {
                                        return Text(
                                          aiThemeText,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                          textAlign: TextAlign.center,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ThemeBlocSelector(
                            selector: (state) =>
                                state.generateAiThemeApi.isApiInProgress,
                            builder: (progress) {
                              return progress
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => ThemeAddInfoScreen.push(
                                        context,
                                        aiImageFile: bloc.state.generatedImage,
                                      ),
                                      child: Text(
                                        context
                                            .appLocalizations.add_to_my_themes,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
