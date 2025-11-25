import 'dart:io';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/custom_classes/cache_files.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/serializers.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/themes/bloc/theme_state.dart';
import 'package:admin/pages/themes/componenets/theme_asset_preview_screen.dart';
import 'package:admin/pages/themes/main_theme_screen.dart';
import 'package:admin/pages/themes/model/ai_theme_model.dart';
import 'package:admin/pages/themes/model/theme_category_model.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:admin/pages/themes/model/weather_model.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/dio.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_crop/multi_image_crop.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'theme_bloc.bloc.g.dart';

final _logger = Logger('theme.bloc');

enum UploadFileType { image, gif, video, mov }

@BlocGen()
class ThemeBloc extends BVCubit<ThemeState, ThemeStateBuilder>
    with _ThemeBlocMixin {
  ThemeBloc() : super(ThemeState()) {
    callCategoryThemesApi(refresh: true);
    // callApis("Feed");
    // callApis("My Themes");
  }

  factory ThemeBloc.of(final BuildContext context) =>
      BlocProvider.of<ThemeBloc>(context);

  Future<void> callApis(String type) async {
    await callThemesApi(type: type);

    if (getThemeApiType(type).data != null) {
      saveThemesToCache(getThemeApiType(type).data!, type);
    }
  }

  Future<void> updateDoorBell() async {
    if (singletonBloc.profileBloc.state!.selectedDoorBell != null) {
      emit(
        state.rebuild(
          (b) => b
            ..selectedDoorBell
                .replace(singletonBloc.profileBloc.state!.selectedDoorBell!),
        ),
      );
    }
  }

  final _categoryScrollController = ScrollController();
  final _scrollController = ScrollController();
  RefreshController refreshController = RefreshController();
  RefreshController categoryRefreshController = RefreshController();

  ScrollController get notificationScroll => _scrollController;
  // ScrollController get categoryScroll => _scrollController;
  // ScrollController get myThemesScroll => _scrollController;

  ScrollController get categoryNotificationScroll => _categoryScrollController;
  Timer? _debounce;
  Timer? _debounceFav;
  Timer? _debounceTimer;

  void onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final ApiState<PaginatedData<ThemeDataModel>> apiState =
          getThemeApiType(state.activeType);
      // Cancel any existing debounce timer
      _debounceTimer?.cancel();

      // Start a new timer with a delay of 300ms (adjust as needed)
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        if (!apiState.isApiInProgress &&
            apiState.currentPage < apiState.totalCount) {
          callThemesApi(justPaginate: true, type: state.activeType);
        }
      });
    }
  }

  void onCategoryIdScroll() {
    if (_categoryScrollController.position.pixels >=
        _categoryScrollController.position.maxScrollExtent - 200) {
      final ApiState<PaginatedData<ThemeDataModel>> apiState =
          getThemeApiType(state.activeType);
      // Cancel any existing debounce timer
      _debounceTimer?.cancel();

      // Start a new timer with a delay of 300ms (adjust as needed)
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        if (!apiState.isApiInProgress &&
            apiState.currentPage < apiState.totalCount) {
          callThemesApi(
            justPaginate: true,
            type: "Category",
            categoryId: state.apiCategoryId,
          );
        }
      });
    }
  }

  void updateCategoryApiId(int id) {
    emit(state.rebuild((b) => b..apiCategoryId = id));
  }

  void onPop() {
    // Future.delayed(const Duration(seconds: 1), () {
    emit(
      state.rebuild(
        (b) => b
          ..activeType = "Feed"
          ..myThemes.replace(ApiState())
          ..feedThemes.replace(ApiState())
          ..favouriteThemes.replace(ApiState())
          // ..trendingThemes.replace(ApiState())
          ..popularThemes.replace(ApiState())
          ..videosThemes.replace(ApiState())
          ..gifsThemes.replace(ApiState()),
        // ..recentThemes.replace(ApiState())
      ),
    );
    // });
  }

  List<FeatureModel> getFilters(bool isViewer) => [
        FeatureModel(
          controller: RefreshController(),
          title: "Home",
          value: "Feed",
          isSelected: true,
        ),
        // if (!isViewer &&
        //     singletonBloc.profileBloc.state != null &&
        //     singletonBloc.profileBloc.state!.selectedDoorBell != null)
        //   FeatureModel(
        //     controller: RefreshController(),
        //     title: "My Themes",
        //     value: "My Themes",
        //   ),
        FeatureModel(
          controller: RefreshController(),
          title: "Popular",
          value: "Popular",
        ),
        FeatureModel(
          controller: RefreshController(),
          title: "Favorite",
          value: "Favourite",
        ),
        // FeatureModel(
        //   controller: RefreshController(),
        //   title: "Category",
        //   value: "Category",
        // ),
        // FeatureModel(
        //   controller: RefreshController(initialRefresh: false),
        //   title: "Trending",
        //   value: "Trending",
        //   isSelected: false,
        // ),
        FeatureModel(
          controller: RefreshController(),
          title: "Videos",
          value: "Videos",
        ),
        FeatureModel(
          controller: RefreshController(),
          title: "Gif",
          value: "Gif",
        ),
        // FeatureModel(
        //   controller: RefreshController(initialRefresh: false),
        //   title: "Recent",
        //   value: "Recent",
        //   isSelected: false,
        // ),
      ];

  void isUploadOnDoorBell(bool value) {
    updateUploadOnDoorBell(value);
  }

  void updateSelectedValue(String value) {
    updateCategorySelectedValue(value);

    emit(
      state.rebuild(
        (final b) => b
          ..categoryId = state.categoryThemesApi.data!.data
              .firstWhere((e) => e.name == value)
              .id,
      ),
    );
  }

  void clearSearchFromCategories() {
    emit(
      state.rebuild(
        (final b) => b
          ..search = ""
          ..searchField!.clear(),
      ),
    );
  }

  void clearSearch() {
    emit(
      state.rebuild(
        (final b) => b
          ..search = ""
          ..canPop = true
          ..searchField!.clear(),
      ),
    );
  }

  @override
  void $onUpdateSearch() {
    if (state.search.isNotEmpty) {
      updateCanPop(false);
    } else {
      updateCanPop(true);
    }

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _logger.fine(state.search.length);
      if (state.search.length >= 3) {
        if (state.activeType == "Category") {
          if (state.categoryThemesApi.data == null ||
              state.categoryThemesApi.data!.data.isEmpty) {
            callCategoryThemesApi(refresh: true);
          }
        } else {
          callThemesApi(type: state.activeType, refresh: true, fromLike: true);
        }
      } else if (state.search.isEmpty) {
        if (state.activeType == "Category") {
          if (state.categoryThemesApi.data == null ||
              state.categoryThemesApi.data!.data.isEmpty) {
            callCategoryThemesApi(refresh: true);
          }
        } else {
          callThemesApi(type: state.activeType, refresh: true, fromLike: true);
        }
      }
    });
    super.$onUpdateSearch();
  }

  void updateOnPop() {
    emit(
      state.rebuild(
        (final b) => b
          ..canPop = true
          ..activeType = "Feed"
          ..searchField!.clear()
          ..search = "",
      ),
    );
    if (state.activeType == "Category") {
      if (state.categoryThemesApi.data == null ||
          state.categoryThemesApi.data!.data.isEmpty) {
        callCategoryThemesApi(refresh: true);
      }
    } else {
      callThemesApi(type: state.activeType, refresh: true, fromLike: true);
    }
    // _onSearchChanged("");
  }

  Future<void> callThemesApi({
    justPaginate = false,
    refresh = false,
    onTabChange = false,
    isPageChangeRefreshTheme = false,
    int? categoryId,
    required String type,
    int pageSize = 8,
    fromLike = false,
  }) {
    if (refresh) {
      if (fromLike) {
        resetThemeState(type);
      } else {
        refreshTheme(type);
      }
    } else if (isPageChangeRefreshTheme == true) {
      isPageChangeRefreshThemeMethod(type);
    }
    final ApiState<PaginatedData<ThemeDataModel>> apiStates =
        getThemeApiType(type);

    return CubitUtils.makePaginatedApiCall<ThemeState, ThemeStateBuilder,
        PaginatedData<ThemeDataModel>>(
      cubit: this,
      apiState: apiStates,
      updateApiState: (final b, final apiState) =>
          updateApiState(b, apiState, type),
      onError: (error) {
        refreshTheme(type);
        error as DioException;
        if (error.type == DioExceptionType.connectionError) {
          emit(
            state.rebuild(
              (b) => b..simpleThemesError = "no internet connection",
            ),
          );
        }
      },
      callApi: (final page) async {
        _logger.severe(apiStates.pagination);
        final int p = isPageChangeRefreshTheme == true
            ? page == 1
                ? 1
                : page - 1
            : page;
        final paginatedData = await apiService.getThemes(
          type,
          p,
          search: state.search,
          categoryId: type == "Category" ? categoryId : null,
        );
        emit(state.rebuild((b) => b..simpleThemesError = ""));

        final PaginatedData list = PaginatedData.fromDynamic(
          paginatedData.data,
          ThemeDataModel.serializer,
          serializersThemeDataModel,
        );

        if (apiStates.data != null) {
          final PaginatedData<ThemeDataModel> updatedList1 = list.rebuild(
            (b) => b
              ..data.replace(
                list.data.where(
                  (item) =>
                      !apiStates.data!.data.any((other) => other.id == item.id),
                ),
              ),
          ) as PaginatedData<ThemeDataModel>;

          return updatedList1;
        }
        return PaginatedData.fromDynamic(
          paginatedData.data,
          ThemeDataModel.serializer,
          serializersThemeDataModel,
        );
      },
      currentPage: apiStates.currentPage,
      totalPages: apiStates.totalCount,
      onPageUpdate: (final newPage) {
        _logger.fine('Updating Page to: $newPage');
        currentPageEmit(type, newPage);
      },
    );
  }

  Future<void> callCategoryThemesApi({
    justPaginate = false,
    refresh = false,
    isPageChangeRefreshTheme = false,
    int pageSize = 100,
  }) {
    if (refresh) {
      emit(
        state.rebuild(
          (b) => b
            ..categoryThemesApi.replace(ApiState())
            ..categoryThemesApi.totalCount = 0
            ..categoryThemesApi.isApiInProgress = true
            ..categoryThemesApi.currentPage = 0,
        ),
      );
    } else if (isPageChangeRefreshTheme) {
      emit(state.rebuild((b) => b..categoryThemesApi.replace(ApiState())));
    }

    return CubitUtils.makePaginatedApiCall<ThemeState, ThemeStateBuilder,
        PaginatedData<ThemeCategoryModel>>(
      cubit: this,
      apiState: state.categoryThemesApi,
      onError: (err) {
        // Catching Error
      },
      updateApiState: (final b, final apiState) =>
          b.categoryThemesApi.replace(apiState),
      callApi: (final page) async {
        final paginatedData = await apiService.getThemesCategory(
          pageSize: pageSize,
          page: page,
          search: state.search,
        );
        final BuiltList<String> temp = BuiltList<String>.from(
          paginatedData.data["data"].map((e) => e["name"]),
        );
        updateGetThemeCategoryNameList(temp);

        return PaginatedData.fromDynamic(
          paginatedData.data,
          ThemeCategoryModel.serializer,
          serializersThemeCategoryModel,
        );
      },
      currentPage: state.categoryThemesApi.currentPage,
      totalPages: state.categoryThemesApi.totalCount,
      onPageUpdate: (final newPage) {
        _logger.fine('Updating Page to: $newPage');
        emit(state.rebuild((b) => b..categoryThemesApi.currentPage = newPage));
      },
    );
  }

  UploadFileType? checkIsImageFile(String ext) {
    UploadFileType? type;
    if (ext == 'png' || ext == 'jpg' || ext == 'jpeg') {
      type = UploadFileType.image;
    } else if (ext == 'gif') {
      type = UploadFileType.gif;
    } else if (ext == 'mp4') {
      type = UploadFileType.video;
    } else if (ext == 'mov') {
      type = UploadFileType.mov;
    }
    return type;
  }

  Future<bool> isValidImageOrGif(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final decodedImage = img.decodeImage(bytes);
      return decodedImage != null;
    } catch (e) {
      _logger.severe("Error decoding image: $e");
      return false;
    }
  }

  Future<bool> isValidVideo(File videoFile) async {
    try {
      final VideoPlayerController controller =
          VideoPlayerController.file(videoFile);
      await controller.initialize();
      await controller.dispose();
      return true;
    } catch (e) {
      _logger.severe("Invalid video: $e");
      return false;
    }
  }

  Future<void> pickThemeAsset(BuildContext context) async {
    final picker = ImagePicker();
    // await EasyLoading.show();
    // Constants.showLoader();

    final media = await picker.pickMedia();
    if (media != null) {
      final int length = File(media.path).readAsBytesSync().lengthInBytes;

      const int maxSize = 5 * 1024 * 1024; // 5MB in bytes

      if (length <= maxSize) {
        final UploadFileType? fileType =
            checkIsImageFile(media.path.split('.').last);
        if (fileType == null) {
          if (context.mounted) {
            ToastUtils.errorToast(context.appLocalizations.uploading_format);
          }
          return;
        } else if (fileType == UploadFileType.image) {
          final bool result = await isValidImageOrGif(File(media.path));
          if (!result) {
            if (context.mounted) {
              ToastUtils.errorToast(
                context.appLocalizations.correct_image_error,
              );
            }
            return;
          }
        }
        if (fileType == UploadFileType.video ||
            fileType == UploadFileType.mov) {
          final bool result = await isValidVideo(File(media.path));

          if (!result) {
            if (context.mounted) {
              ToastUtils.errorToast(
                context.appLocalizations.correct_video_error,
              );
            }
            return;
          }
          // Get media info to check video duration
          MediaInfo? mediaInfo = await VideoCompress.getMediaInfo(media.path);

          if (mediaInfo.duration! <= 60000) {
            try {
              mediaInfo = await VideoCompress.compressVideo(
                media.path,
                quality: VideoQuality.Res960x540Quality,
                includeAudio: false,
              );
            } catch (e) {
              _logger.severe(e);
            }

            final File file = File(mediaInfo?.path ?? media.path);
            final String? thumbnail = await VideoThumbnail.thumbnailFile(
              video: file.path,
              thumbnailPath: (await getTemporaryDirectory()).path,
              quality: 30,
            );
            if (thumbnail != null) {
              if (context.mounted) {
                unawaited(
                  ThemeAssetPreviewScreen.push(
                    context,
                    file,
                    File(thumbnail),
                    noBackIcon: true,
                  ),
                );
              }
            } else {
              if (context.mounted) {
                unawaited(
                  ThemeAssetPreviewScreen.push(
                    context,
                    file,
                    file,
                    noBackIcon: true,
                  ),
                );
                // );
              }
            }
          } else {
            // Video is longer than 60 seconds
            ToastUtils.errorToast(Constants.videoLengthMsg);
          }
        } else {
          File croppedFile = File(media.path);
          if (media.path.split(".").last.toLowerCase() == "gif") {
            final bool result = await isValidImageOrGif(File(media.path));
            if (!result) {
              if (context.mounted) {
                ToastUtils.errorToast(
                  context.appLocalizations.correct_gif_error,
                );
              }
              return;
            }
            // croppedFile = await testCompressAndGetFile(croppedFile,quality: 70);
            final File thumbnail = await gifCompressor(croppedFile);
            if (context.mounted) {
              unawaited(
                ThemeAssetPreviewScreen.push(
                  context,
                  croppedFile,
                  thumbnail,
                ),
              );
            }
          } else {
            if (context.mounted) {
              MultiImageCrop.startCropping(
                context: context,
                aspectRatio: 8 / 16,
                noBack: true,
                activeColor: Theme.of(context).primaryColor,
                pixelRatio: 3,
                isLeading: false,
                files: [File(media.path)],
                callBack: (List<File> images) async {
                  if (images.isNotEmpty) {
                    croppedFile = File(images[0].path);
                    croppedFile = await testCompressAndGetFile(
                      croppedFile,
                      quality: 70,
                    );
                    final File thumbnail =
                        await testCompressAndGetFile(croppedFile);
                    if (context.mounted) {
                      unawaited(
                        ThemeAssetPreviewScreen.push(
                          context,
                          croppedFile,
                          thumbnail,
                        ),
                      );
                    }
                  }
                },
              );
            }
          }
        }
      } else {
        if (context.mounted) {
          ToastUtils.errorToast(context.appLocalizations.file_size_5_mb);
        }
      }
      await EasyLoading.dismiss();
    } else {
      await EasyLoading.dismiss();
    }
  }

  Future<void> uploadThemeApi(
    BuildContext context, {
    File? file,
    String? aiImage,
    File? thumbnail,
    String? deviceId,
  }) {
    emit(
      state.rebuild(
        (b) => b
          ..uploadThemeApi.replace(ApiState())
          ..uploadThemeApi.isApiInProgress = true,
      ),
    );
    return CubitUtils.makeApiCall<ThemeState, ThemeStateBuilder, void>(
      cubit: this,
      apiState: state.uploadThemeApi,
      updateApiState: (final b, final apiState) =>
          b.uploadThemeApi.replace(apiState),
      callApi: () async {
        final startupBloc = StartupBloc.of(context);
        String coverUrl;
        String thumbnailUrl;
        if (aiImage != null) {
          coverUrl = aiImage;
          thumbnailUrl = aiImage;
        } else {
          coverUrl = await apiService.uploadFile(
            file!,
            fromTheme: true,
            fileName:
                "theme/media/${DateTime.now().microsecondsSinceEpoch}.${file.path.split(".").last}",
          );
          thumbnailUrl = await apiService.uploadFile(
            thumbnail!,
            fromTheme: true,
            fileName:
                "theme/media/thumbnail/${DateTime.now().microsecondsSinceEpoch}.${file.path.split(".").last}",
          );
        }
        final response = await apiService.uploadTheme(
          file: coverUrl,
          thumbnail: thumbnailUrl,
          title: state.themeNameField ?? "",
          categoryId: state.categoryId,
        );
        if (state.uploadOnDoorBell) {
          if (context.mounted) {
            await applyThemeApi(
              context,
              themeId: response.data["data"]["theme_id"],
              deviceId: deviceId!,
            );
          }
        }
        changeActiveType(startupBloc, "Feed", refresh: true);
        if (context.mounted) {
          refreshCreateTheme();
          unawaited(MainThemeScreen.pushAndRemoveUntil(context, true));
        }
      },
      onError: (e) {
        emit(
          state.rebuild(
            (b) => b
              ..uploadThemeApi.replace(ApiState())
              ..uploadThemeApi.isApiInProgress = false,
          ),
        );
      },
    );
  }

  Future<void> applyThemeApi(
    BuildContext context, {
    int? themeId,
    required String deviceId,
  }) {
    emit(
      state.rebuild(
        (b) => b
          ..applyThemeApi.replace(ApiState())
          ..applyThemeApi.isApiInProgress = true,
      ),
    );
    return CubitUtils.makeApiCall<ThemeState, ThemeStateBuilder, void>(
      cubit: this,
      apiState: state.applyThemeApi,
      onError: (error) {
        emit(
          state.rebuild(
            (b) => b
              ..applyThemeApi.replace(ApiState())
              ..applyThemeApi.isApiInProgress = false,
          ),
        );
        applyThemeSuccessErrorDialog(context, false);
      },
      updateApiState: (final b, final apiState) {
        return b.applyThemeApi.replace(apiState);
      },
      callApi: () async {
        await apiService.applyThemeOnDoorBell(
          themeId!,
          timeZone: toHex(state.timeZoneColor),
          weather: toHex(state.weatherColor),
          location: toHex(state.locationColor),
          text: toHex(state.textColor),
          deviceId: deviceId,
          bottomText: toHex(state.bottomTextColor),
        );
        emit(state.rebuild((b) => b..uploadOnDoorBell = false));

        if (context.mounted) {
          await callThemesApi(type: state.activeType, refresh: true);
          // unawaited(callThemesApi(type: "My Themes"));

          if (context.mounted) {
            updateApplyThemeWidget(
              context,
              state.activeType,
              themeId,
            );
          }
          unawaited(
            singletonBloc.socketEmitter(
              roomName: Constants.theme,
              themeId: themeId,
              deviceId: deviceId,
            ),
          );

          // ToastUtils.successToast("Theme applied successfully");

          if (context.mounted) {
            applyThemeSuccessErrorDialog(context, true);
            updateActiveType("Feed");
          }

          await Future.delayed(const Duration(seconds: 2));

          if (context.mounted) {
            unawaited(MainThemeScreen.pushAndRemoveUntil(context, true));
            updateIndex(0);
          }
        }
      },
    );
  }

  void applyThemeSuccessErrorDialog(BuildContext context, bool isSuccess) {
    final color = CommonFunctions.getThemeBasedWidgetColor(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        Future.delayed(const Duration(seconds: 2), () {
          if (dialogContext.mounted) {
            Navigator.pop(dialogContext);
          }
        });
        return Dialog(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSuccess ? Icons.check_circle : Icons.warning_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 70,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    isSuccess ? "Successful" : "Error",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: isSuccess ? color : Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isSuccess
                        ? "Your theme has been applied successfully."
                        : "Theme application failed. Please try again or contact support.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> removeThemeApi(
    BuildContext context,
    UserDeviceModel doorbell,
    int themeId, {
    required String deviceId,
  }) {
    emit(
      state.rebuild(
        (b) => b
          ..removeThemeApi.replace(ApiState())
          ..removeThemeApi.isApiInProgress = true,
      ),
    );
    return CubitUtils.makeApiCall<ThemeState, ThemeStateBuilder, void>(
      cubit: this,
      apiState: state.removeThemeApi,
      onError: (error) {
        emit(
          state.rebuild(
            (b) => b
              ..removeThemeApi.replace(ApiState())
              ..removeThemeApi.isApiInProgress = false,
          ),
        );
      },
      updateApiState: (final b, final apiState) =>
          b.removeThemeApi.replace(apiState),
      callApi: () async {
        await apiService.removeThemeFromDoorbell(
          deviceId: deviceId,
        );
        emit(state.rebuild((b) => b..uploadOnDoorBell = false));
        if (context.mounted) {
          updateRemoveThemeWidget(
            context,
            state.activeType,
            themeId,
          );
          unawaited(callThemesApi(type: "My Themes"));
          updateActiveType("Feed");
          unawaited(
            singletonBloc.socketEmitter(
              roomName: Constants.theme,
              deviceId: deviceId,
            ),
          );

          ToastUtils.successToast(
            title: "Theme Removed!",
            "The applied theme has been removed from your doorbell named as ${doorbell.name}.",
          );

          unawaited(MainThemeScreen.pushAndRemoveUntil(context, true));
        }
      },
    );
  }

  String toHex(Color color) =>
      color.toHexString().replaceFirst("F", "#").replaceFirst("F", "");

  Future<void> deleteTheme(context, int id) {
    return CubitUtils.makeApiCall<ThemeState, ThemeStateBuilder, void>(
      cubit: this,
      apiState: state.deleteThemeApi,
      onError: (error) {
        if (error is DioException && error.response != null) {
          ToastUtils.errorToast(error.message!);
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
        emit(
          state.rebuild(
            (b) => b
              ..deleteThemeApi.replace(ApiState())
              ..deleteThemeApi.isApiInProgress = false,
          ),
        );
        EasyLoading.dismiss();
      },
      updateApiState: (final b, final apiState) =>
          b.deleteThemeApi.replace(apiState),
      callApi: () async {
        final startupBloc = StartupBloc.of(context);
        await EasyLoading.show(indicator: const CircularProgressIndicator());
        await apiService.deleteThemes(id);

        ToastUtils.successToast(
          title: "Theme Deleted!",
          "The theme has been successfully removed from the system.",
        );
        await EasyLoading.dismiss();
        changeActiveType(startupBloc, "Feed", refresh: true);
        Navigator.pop(context);
      },
    );
  }

  void refreshCreateTheme() {
    emit(
      state.rebuild(
        (b) => b
          ..generateAiThemeApi.replace(ApiState())
          ..uploadThemeApi.replace(ApiState())
          ..categorySelectedValue = null
          ..themeNameField = ""
          ..uploadOnDoorBell = false
          ..aiError = ""
          ..aiThemeText = ""
          ..generatedImage = null,
      ),
    );
    // callCategoryThemesApi();
  }

  Future<void> processAITheme() async {
    updateAiError('');

    if (state.aiThemeText.isNotEmpty) {
      emit(
        state.rebuild(
          (b) => b
            ..generateAiThemeApi.replace(ApiState())
            ..generateAiThemeApi.isApiInProgress = true
            ..generatedImage = null,
        ),
      );
      return CubitUtils.makeApiCall<ThemeState, ThemeStateBuilder, void>(
        cubit: this,
        apiState: state.generateAiThemeApi,
        onError: (error) {
          if (error is DioException && error.response != null) {
            updateAiError(error.response!.data["message"].toString());
          } else {
            ToastUtils.errorToast("An unexpected error occurred.");
          }
          emit(
            state.rebuild(
              (b) => b
                ..generateAiThemeApi.replace(ApiState())
                ..generateAiThemeApi.isApiInProgress = false
                ..generatedImage = null,
            ),
          );
        },
        updateApiState: (final b, final apiState) =>
            b.generateAiThemeApi.replace(apiState),
        callApi: () async {
          final AiThemeModel model =
              await apiService.createAiTheme(state.aiThemeText);
          singletonBloc.profileBloc
              .updateAiThemeCounter(counter: model.counter);
          updateGeneratedImage(model.url);
        },
      );
    }
  }

  Future<File> testCompressAndGetFile(File file, {quality = 20}) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        path.join(dir.path, 'compressed_${path.basename(file.path)}');
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
      );

      return File(result!.path);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<File> gifCompressor(File file, {quality = 20}) async {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(
      dir.path,
      'compressed_${DateTime.now().millisecondsSinceEpoch}${path.basename(file.path)}',
    );
    try {
      final result = await FlutterImageCompress.compressAssetImage(
        file.absolute.path,
        quality: quality,
      );
      final File resultFile = await File(targetPath).create();

      await resultFile.writeAsBytes(result!);

      return File(resultFile.path);
    } catch (e) {
      // throw Exception(e);
      return file;
    }
  }

  Future<void> themeLike(
    BuildContext context, {
    required String locationId,
    required bool isLike,
    required String type,
    required int index,
    required int totalLikes,
    required ThemeDataModel data,
  }) {
    // emit(
    //   state.rebuild(
    //     (b) => b
    //       ..themeLikeApi.replace(ApiState())
    //       ..themeLikeApi.isApiInProgress = true
    //       ..themeLikeApi.currentPage = 0,
    //   ),
    // );

    return CubitUtils.makeApiCall<ThemeState, ThemeStateBuilder, void>(
      cubit: this,
      apiState: state.themeLikeApi,
      onError: (error) {
        emit(
          state.rebuild(
            (b) => b
              ..themeLikeApi.replace(ApiState())
              ..themeLikeApi.isApiInProgress = false,
          ),
        );
      },
      updateApiState: (final b, final apiState) =>
          b.themeLikeApi.replace(apiState),
      callApi: () async {
        // if (state.activeType != "Favourite") {
        updateThemeLikeType(
          context,
          type,
          isLike ? 1 : 0,
          isLike
              ? totalLikes + 1
              : totalLikes == 0
                  ? 0
                  : totalLikes - 1,
          data.id,
          data,
        );
        // }
        // _debounceLikeTimer?.cancel();
        //
        // // Start a new timer with a delay of 300ms (adjust as needed)
        // _debounceLikeTimer = Timer(const Duration(milliseconds: 200), () async {
        final response = await apiService.themeLike(
          locationId: locationId,
          themeId: data.id.toString(),
          isLike: isLike,
        );
        if (context.mounted) {
          updateThemeLikeType(
            context,
            type,
            response.data["data"]["user_like"] == true ? 1 : 0,
            response.data["data"]["total_likes"],
            data.id,
            data,
          );
        }
        // });
      },
    );
  }

  void changeColor(Color color) {
    _logger.severe(color);
    emit(state.rebuild((b) => b..pickerColor = color));
    _logger.severe(state.pickerColor);
  }

  void openDialog(BuildContext context, int field) {
    final availableColors = [
      AppColors.purple,
      AppColors.lightPurple,
      AppColors.pink,
      AppColors.darkPurple,
      AppColors.white,
      AppColors.lavender,
      AppColors.green,
      AppColors.yellow,
      AppColors.lightRed,
      AppColors.redOrange,
      AppColors.red,
      AppColors.black,
      AppColors.blue,
    ];
    setPickerColor(field);
    showDialog(
      context: context,
      builder: (contexts) {
        return BlocProvider.value(
          value: this,
          child: ThemeBlocSelector.pickerColor(
            builder: (c) {
              return AlertDialog(
                title: Center(
                  child: Text(
                    context.appLocalizations.choose_color,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 22,
                          color:
                              CommonFunctions.getThemeBasedWidgetColor(context),
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      ColorPicker(
                        paletteType: PaletteType.hueWheel,
                        pickerColor: state.pickerColor,
                        onColorChanged: changeColor,
                        enableAlpha: false,
                        portraitOnly: true,
                        labelTypes: const [ColorLabelType.hex],
                      ),
                      const Divider(),
                      BlockPicker(
                        availableColors: availableColors,
                        layoutBuilder: (context, colors, child) {
                          return SizedBox(
                            width: 300,
                            height: 100,
                            child: GridView.count(
                              crossAxisCount: 7,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              children: [
                                for (final Color color in colors) child(color),
                              ],
                            ),
                          );
                        },
                        itemBuilder: (color, isCurrentColor, changeColor) {
                          return InkWell(
                            onTap: changeColor,
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              padding: const EdgeInsets.all(0.4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isCurrentColor
                                      ? color
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color,
                                ),
                              ),
                            ),
                          );
                        },
                        useInShowDialog: false,
                        pickerColor: state.pickerColor,
                        onColorChanged: changeColor,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: CustomCancelButton(
                          onSubmit: () {
                            changeColor(const Color(0xff443a49));
                            setColor(field);
                            Navigator.pop(contexts);
                          },
                          label: context.appLocalizations.reset,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomGradientButton(
                          onSubmit: () {
                            setColor(field);
                            Navigator.pop(contexts);
                          },
                          label: context.appLocalizations.apply,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void setColor(int field) {
    switch (field) {
      case 0:
        emit(state.rebuild((b) => b..timeZoneColor = b.pickerColor));
      case 1:
        emit(state.rebuild((b) => b..weatherColor = b.pickerColor));
      case 2:
        emit(state.rebuild((b) => b..locationColor = b.pickerColor));
      case 3:
        emit(state.rebuild((b) => b..textColor = b.pickerColor));
      case 4:
        emit(state.rebuild((b) => b..bottomTextColor = b.pickerColor));
    }
  }

  void setPickerColor(int field) {
    switch (field) {
      case 0:
        changeColor(state.timeZoneColor);
      case 1:
        changeColor(state.weatherColor);
      case 2:
        changeColor(state.locationColor);
      case 3:
        changeColor(state.textColor);
      case 4:
        changeColor(state.bottomTextColor);
    }
  }

  Future<void> weatherApi({DoorbellLocations? value}) {
    return CubitUtils.makeApiCall<ThemeState, ThemeStateBuilder, WeatherModel>(
      cubit: this,
      apiState: state.weatherApi,
      onError: (err) {
        // Catching Error
      },
      updateApiState: (final b, final apiState) =>
          b.weatherApi.replace(apiState),
      callApi: () async {
        return apiService.getWeather(
          value != null
              ? value.latitude
              : singletonBloc.profileBloc.state!.selectedDoorBell!
                  .doorbellLocations!.latitude,
          value != null
              ? value.longitude
              : singletonBloc.profileBloc.state!.selectedDoorBell!
                  .doorbellLocations!.longitude,
        );
      },
    );
  }

  void updateCacheEmit(String type, int i, String filePath) {
    switch (type) {
      case "Feed":
        emit(
          state.rebuild(
            (b) => b
              ..feedThemes.data = b.feedThemes.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..cover = filePath,
                ),
              ),
          ),
        );
      case "Category":
        emit(
          state.rebuild(
            (b) => b
              ..categoryDetailsThemesApi.data =
                  b.categoryDetailsThemesApi.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..cover = filePath,
                ),
              ),
          ),
        );
      case "My Themes":
        emit(
          state.rebuild(
            (b) => b
              ..myThemes.data = b.myThemes.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..cover = filePath,
                ),
              ),
          ),
        );
      case "Favourite":
        emit(
          state.rebuild(
            (b) => b
              ..favouriteThemes.data = b.favouriteThemes.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..cover = filePath,
                ),
              ),
          ),
        );
      // case "Trending":
      //   emit(state.rebuild((b) => b
      //     ..trendingThemes.data = b.trendingThemes.data?.rebuild(
      //       (d) => d.data[i] = d.data[i].rebuild((n) => n
      //         ..fromCache = true
      //         ..cover = filePath),
      //     )));
      //   break;
      case "Popular":
        emit(
          state.rebuild(
            (b) => b
              ..popularThemes.data = b.popularThemes.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..cover = filePath,
                ),
              ),
          ),
        );
      case "Videos":
        emit(
          state.rebuild(
            (b) => b
              ..videosThemes.data = b.videosThemes.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..cover = filePath,
                ),
              ),
          ),
        );
      case "Gif":
        emit(
          state.rebuild(
            (b) => b
              ..gifsThemes.data = b.gifsThemes.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..cover = filePath,
                ),
              ),
          ),
        );
      // case "Recent":
      //   emit(state.rebuild((b) => b
      //     ..recentThemes.data = b.recentThemes.data?.rebuild(
      //       (d) => d.data[i] = d.data[i].rebuild((n) => n
      //         ..fromCache = true
      //         ..cover = filePath),
      //     )));
      //   break;
      default:
        emit(
          state.rebuild(
            (b) => b
              ..feedThemes.data = b.feedThemes.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..cover = filePath,
                ),
              ),
          ),
        );
    }
  }

  void updateThumbnailCacheEmit(String type, int i, String filePath) {
    switch (type) {
      case "Feed":
        emit(
          state.rebuild(
            (b) => b
              ..feedThemes.data = b.feedThemes.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..thumbnail = filePath,
                ),
              ),
          ),
        );
      case "Category":
        emit(
          state.rebuild(
            (b) => b
              ..categoryDetailsThemesApi.data =
                  b.categoryDetailsThemesApi.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..thumbnail = filePath,
                ),
              ),
          ),
        );
      case "My Themes":
        emit(
          state.rebuild(
            (b) => b
              ..myThemes.data = b.myThemes.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..thumbnail = filePath,
                ),
              ),
          ),
        );
      case "Favourite":
        emit(
          state.rebuild(
            (b) => b
              ..favouriteThemes.data = b.favouriteThemes.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..thumbnail = filePath,
                ),
              ),
          ),
        );
      // case "Trending":
      //   emit(state.rebuild((b) => b
      //     ..trendingThemes.data = b.trendingThemes.data?.rebuild(
      //       (d) => d.data[i] = d.data[i].rebuild((n) => n
      //         ..fromCache = true
      //         ..thumbnail = filePath),
      //     )));
      //   break;
      case "Popular":
        emit(
          state.rebuild(
            (b) => b
              ..popularThemes.data = b.popularThemes.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..thumbnail = filePath,
                ),
              ),
          ),
        );
      case "Videos":
        emit(
          state.rebuild(
            (b) => b
              ..videosThemes.data = b.videosThemes.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..thumbnail = filePath,
                ),
              ),
          ),
        );
      case "Gif":
        emit(
          state.rebuild(
            (b) => b
              ..gifsThemes.data = b.gifsThemes.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..thumbnail = filePath,
                ),
              ),
          ),
        );
      // case "Recent":
      //   emit(state.rebuild((b) => b
      //     ..recentThemes.data = b.recentThemes.data?.rebuild(
      //       (d) => d.data[i] = d.data[i].rebuild((n) => n
      //         ..fromCache = true
      //         ..thumbnail = filePath),
      //     )));
      //   break;
      default:
        emit(
          state.rebuild(
            (b) => b
              ..feedThemes.data = b.feedThemes.data?.rebuild(
                (d) => d.data[i] = d.data[i].rebuild(
                  (n) => n
                    ..fromCache = true
                    ..thumbnail = filePath,
                ),
              ),
          ),
        );
    }
  }

  void changeActiveType(
    StartupBloc startupBloc,
    String type, {
    bool onThemeTabChange = false,
    bool refresh = false,
    bool isPageChangeRefreshTheme = false,
  }) {
    emit(
      state.rebuild(
        (b) => b
          ..search = ""
          ..searchField!.clear()
          ..activeType = type,
      ),
    );
    if (type == "Feed") {
      if (startupBloc.state.userDeviceModel != null &&
          startupBloc.state.userDeviceModel!.isNotEmpty) {
        callThemesApi(
          type: "My Themes",
          refresh: refresh,
          onTabChange: onThemeTabChange,
          isPageChangeRefreshTheme: isPageChangeRefreshTheme,
        );
      }
      if (state.categoryThemesApi.data == null ||
          state.categoryThemesApi.data!.data.isEmpty) {
        callCategoryThemesApi(refresh: true);
      }
      callThemesApi(
        type: "Feed",
        refresh: refresh,
        onTabChange: onThemeTabChange,
        isPageChangeRefreshTheme: isPageChangeRefreshTheme,
      );
    } else {
      callThemesApi(
        type: type,
        refresh: refresh,
        onTabChange: onThemeTabChange,
        isPageChangeRefreshTheme: isPageChangeRefreshTheme,
      );
    }
  }

  // void paginatedEmit(String type, Response paginatedData) {
  //   switch (type) {
  //     case "Feed":
  //       emit(state.rebuild((a) => a.feedThemes.pagination
  //           .replace(ApiMetaData.fromDynamic(paginatedData.data).pagination!)));
  //       break;
  //     case "Category":
  //       emit(state.rebuild((a) => a.categoryDetailsThemesApi.pagination
  //           .replace(ApiMetaData.fromDynamic(paginatedData.data).pagination!)));
  //       break;
  //     case "My Themes":
  //       emit(state.rebuild((a) => a.myThemes.pagination
  //           .replace(ApiMetaData.fromDynamic(paginatedData.data).pagination!)));
  //       break;
  //     case "Favourite":
  //       emit(state.rebuild((a) => a.favouriteThemes.pagination
  //           .replace(ApiMetaData.fromDynamic(paginatedData.data).pagination!)));
  //       break;
  //     case "Trending":
  //       emit(state.rebuild((a) => a.trendingThemes.pagination
  //           .replace(ApiMetaData.fromDynamic(paginatedData.data).pagination!)));
  //       break;
  //     case "Popular":
  //       emit(state.rebuild((a) => a.popularThemes.pagination
  //           .replace(ApiMetaData.fromDynamic(paginatedData.data).pagination!)));
  //       break;
  //     case "Videos":
  //       emit(state.rebuild((a) => a.videosThemes.pagination
  //           .replace(ApiMetaData.fromDynamic(paginatedData.data).pagination!)));
  //       break;
  //     case "Gif":
  //       emit(state.rebuild((a) => a.gifsThemes.pagination
  //           .replace(ApiMetaData.fromDynamic(paginatedData.data).pagination!)));
  //       break;
  //     case "Recent":
  //       emit(state.rebuild((a) => a.recentThemes.pagination
  //           .replace(ApiMetaData.fromDynamic(paginatedData.data).pagination!)));
  //       break;
  //     default:
  //       emit(state.rebuild((a) => a.feedThemes.pagination
  //           .replace(ApiMetaData.fromDynamic(paginatedData.data).pagination!)));
  //       break;
  //   }
  // }

  // void totalCountEmit(String type) {
  //   switch (type) {
  //     case "Feed":
  //       emit(state.rebuild((b) => b
  //         ..feedThemes.totalCount = state.feedThemes.pagination!.lastPage
  //         ..feedThemes.currentPage = state.feedThemes.pagination!.currentPage));
  //       break;
  //     case "Category":
  //       emit(state.rebuild((b) => b
  //         ..categoryDetailsThemesApi.totalCount =
  //             state.categoryDetailsThemesApi.pagination!.lastPage
  //         ..categoryDetailsThemesApi.currentPage =
  //             state.categoryDetailsThemesApi.pagination!.currentPage));
  //       break;
  //     case "My Themes":
  //       emit(state.rebuild((b) => b
  //         ..myThemes.totalCount = state.myThemes.pagination!.lastPage
  //         ..myThemes.currentPage = state.myThemes.pagination!.currentPage));
  //       break;
  //     case "Favourite":
  //       emit(state.rebuild((b) => b
  //         ..favouriteThemes.totalCount =
  //             state.favouriteThemes.pagination!.lastPage
  //         ..favouriteThemes.currentPage =
  //             state.favouriteThemes.pagination!.currentPage));
  //       break;
  //     case "Trending":
  //       emit(state.rebuild((b) => b
  //         ..trendingThemes.totalCount =
  //             state.trendingThemes.pagination!.lastPage
  //         ..trendingThemes.currentPage =
  //             state.trendingThemes.pagination!.currentPage));
  //       break;
  //     case "Popular":
  //       emit(state.rebuild((b) => b
  //         ..popularThemes.totalCount = state.popularThemes.pagination!.lastPage
  //         ..popularThemes.currentPage =
  //             state.popularThemes.pagination!.currentPage));
  //       break;
  //     case "Videos":
  //       emit(state.rebuild((b) => b
  //         ..videosThemes.totalCount = state.videosThemes.pagination!.lastPage
  //         ..videosThemes.currentPage =
  //             state.videosThemes.pagination!.currentPage));
  //       break;
  //     case "Gif":
  //       emit(state.rebuild((b) => b
  //         ..gifsThemes.totalCount = state.gifsThemes.pagination!.lastPage
  //         ..gifsThemes.currentPage = state.gifsThemes.pagination!.currentPage));
  //       break;
  //     case "Recent":
  //       emit(state.rebuild((b) => b
  //         ..recentThemes.totalCount = state.recentThemes.pagination!.lastPage
  //         ..recentThemes.currentPage =
  //             state.recentThemes.pagination!.currentPage));
  //       break;
  //     default:
  //       emit(state.rebuild((b) => b
  //         ..feedThemes.totalCount = state.feedThemes.pagination!.lastPage
  //         ..feedThemes.currentPage = state.feedThemes.pagination!.currentPage));
  //       break;
  //   }
  // }

  void currentPageEmit(String type, int newPage) {
    switch (type) {
      case "Feed":
        emit(state.rebuild((b) => b..feedThemes.currentPage = newPage));
      case "Category":
        emit(
          state.rebuild(
            (b) => b..categoryDetailsThemesApi.currentPage = newPage,
          ),
        );
      case "My Themes":
        emit(state.rebuild((b) => b..myThemes.currentPage = newPage));
      case "Favourite":
        emit(state.rebuild((b) => b..favouriteThemes.currentPage = newPage));
      // case "Trending":
      //   emit(state.rebuild((b) => b..trendingThemes.currentPage = newPage));
      //   break;
      case "Popular":
        emit(state.rebuild((b) => b..popularThemes.currentPage = newPage));
      case "Videos":
        emit(state.rebuild((b) => b..videosThemes.currentPage = newPage));
      case "Gif":
        emit(state.rebuild((b) => b..gifsThemes.currentPage = newPage));
      // case "Recent":
      //   emit(state.rebuild((b) => b..recentThemes.currentPage = newPage));
      //   break;
      default:
        emit(state.rebuild((b) => b..feedThemes.currentPage = newPage));
    }
  }

  ApiState<PaginatedData<ThemeDataModel>> getThemeApiType(String type) {
    switch (type) {
      case "Feed":
        return state.feedThemes;
      case "Category":
        return state.categoryDetailsThemesApi;
      case "My Themes":
        return state.myThemes;
      case "Favourite":
        return state.favouriteThemes;
      // case "Trending":
      //   return state.trendingThemes;
      case "Popular":
        return state.popularThemes;
      case "Videos":
        return state.videosThemes;
      case "Gif":
        return state.gifsThemes;
      // case "Recent":
      //   return state.recentThemes;
      default:
        return state.feedThemes;
    }
  }

  void updateThemeLikeType(
    BuildContext context,
    String type,
    int isLike,
    int totalLikes,
    int id,
    ThemeDataModel model,
  ) {
    if (state.feedThemes.data != null &&
        state.feedThemes.data!.data.isNotEmpty) {
      final int index =
          state.feedThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..feedThemes.data = b.feedThemes.data?.rebuild(
                (d) => d.data[index] = d.data[index].rebuild(
                  (n) => n
                    ..totalLikes = totalLikes
                    ..userLike = isLike,
                ),
              ),
          ),
        );
      }
    }

    // My themes
    if (state.myThemes.data != null && state.myThemes.data!.data.isNotEmpty) {
      final int index = state.myThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..myThemes.data = b.myThemes.data?.rebuild(
                (d) => d.data[index] = d.data[index].rebuild(
                  (n) => n
                    ..totalLikes = totalLikes
                    ..userLike = isLike,
                ),
              ),
          ),
        );
      }
    }

    // Favourite themes
    if (isLike == 1) {
      if (state.favouriteThemes.data != null &&
          state.favouriteThemes.data!.data.isNotEmpty) {
        _debounceFav?.cancel();

        // Start a new timer with a delay of 300ms (adjust as needed)
        _debounceFav = Timer(const Duration(milliseconds: 500), () {
          callThemesApi(
            justPaginate: true,
            type: "Favourite",
            refresh: true,
            fromLike: true,
          );
        });
      }
    } else {
      if (state.favouriteThemes.data != null &&
          state.favouriteThemes.data!.data.isNotEmpty) {
        if (state.activeType == "Favourite") {
          final int index =
              state.favouriteThemes.data!.data.indexWhere((e) => e.id == id);
          if (index != -1) {
            emit(
              state.rebuild(
                (b) => b
                  ..favouriteThemes.data = b.favouriteThemes.data
                      ?.rebuild((d) => d.data.removeAt(index)),
              ),
            );
            if (state.isDetailThemePage) {
              if (state.favouriteThemes.data!.data.isNotEmpty) {
                if (state.index != 0) {
                  updateThemeId(
                    state.favouriteThemes.data!.data[state.index - 1].id,
                  );
                  emit(state.rebuild((b) => b..index = b.index! - 1));
                } else {
                  Navigator.pop(context);
                }
              } else {
                Navigator.pop(context);
              }
            }
          }
        } else {
          _debounceFav?.cancel();

          // Start a new timer with a delay of 300ms (adjust as needed)
          _debounceFav = Timer(const Duration(milliseconds: 500), () {
            callThemesApi(
              justPaginate: true,
              type: "Favourite",
              refresh: true,
              fromLike: true,
            );
          });
        }
      }
    }

    // if (state.trendingThemes.data != null &&
    //     state.trendingThemes.data!.data.isNotEmpty) {
    //   int index = state.trendingThemes.data!.data.indexWhere((e) => e.id == id);
    //   if (index != -1) {
    //     emit(state.rebuild((b) => b
    //       ..trendingThemes.data = b.trendingThemes.data?.rebuild(
    //         (d) => d.data[index] = d.data[index].rebuild((n) => n
    //           ..totalLikes = totalLikes
    //           ..userLike = isLike),
    //       )));
    //   }
    // }

    if (state.popularThemes.data != null &&
        state.popularThemes.data!.data.isNotEmpty) {
      final int index =
          state.popularThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..popularThemes.data = b.popularThemes.data?.rebuild(
                (d) => d.data[index] = d.data[index].rebuild(
                  (n) => n
                    ..totalLikes = totalLikes
                    ..userLike = isLike,
                ),
              ),
          ),
        );
      }
    }

    if (state.videosThemes.data != null &&
        state.videosThemes.data!.data.isNotEmpty) {
      final int index =
          state.videosThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..videosThemes.data = b.videosThemes.data?.rebuild(
                (d) => d.data[index] = d.data[index].rebuild(
                  (n) => n
                    ..totalLikes = totalLikes
                    ..userLike = isLike,
                ),
              ),
          ),
        );
      }
    }

    if (state.categoryDetailsThemesApi.data != null &&
        state.categoryDetailsThemesApi.data!.data.isNotEmpty) {
      final int index = state.categoryDetailsThemesApi.data!.data
          .indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..categoryDetailsThemesApi.data =
                  b.categoryDetailsThemesApi.data?.rebuild(
                (d) => d.data[index] = d.data[index].rebuild(
                  (n) => n
                    ..totalLikes = totalLikes
                    ..userLike = isLike,
                ),
              ),
          ),
        );
      }
    }

    if (state.gifsThemes.data != null &&
        state.gifsThemes.data!.data.isNotEmpty) {
      final int index =
          state.gifsThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..gifsThemes.data = b.gifsThemes.data?.rebuild(
                (d) => d.data[index] = d.data[index].rebuild(
                  (n) => n
                    ..totalLikes = totalLikes
                    ..userLike = isLike,
                ),
              ),
          ),
        );
      }
    }

    // if (state.recentThemes.data != null &&
    //     state.recentThemes.data!.data.isNotEmpty) {
    //   int index = state.recentThemes.data!.data.indexWhere((e) => e.id == id);
    //   if (index != -1) {
    //     emit(state.rebuild((b) => b
    //       ..recentThemes.data = b.recentThemes.data?.rebuild(
    //         (d) => d.data[index] = d.data[index].rebuild((n) => n
    //           ..totalLikes = totalLikes
    //           ..userLike = isLike),
    //       )));
    //   }
    // }
  }

  void updateApplyThemeWidget(BuildContext context, String type, int id) {
    if (state.feedThemes.data != null &&
        state.feedThemes.data!.data.isNotEmpty) {
      final int index =
          state.feedThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..feedThemes.data = b.feedThemes.data?.rebuild(
                (d) => d.data[index] =
                    d.data[index].rebuild((n) => n..isApplied = true),
              ),
          ),
        );
      }
    }

    if (state.myThemes.data != null && state.myThemes.data!.data.isNotEmpty) {
      final int index = state.myThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..myThemes.data = b.myThemes.data?.rebuild(
                (d) => d.data[index] =
                    d.data[index].rebuild((n) => n..isApplied = true),
              ),
          ),
        );
      }
    }

    if (state.favouriteThemes.data != null &&
        state.favouriteThemes.data!.data.isNotEmpty) {
      final int index =
          state.favouriteThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..favouriteThemes.data = b.favouriteThemes.data?.rebuild(
                (d) => d.data[index] =
                    d.data[index].rebuild((n) => n..isApplied = true),
              ),
          ),
        );
      }
    }

    if (state.popularThemes.data != null &&
        state.popularThemes.data!.data.isNotEmpty) {
      final int index =
          state.popularThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..popularThemes.data = b.popularThemes.data?.rebuild(
                (d) => d.data[index] =
                    d.data[index].rebuild((n) => n..isApplied = true),
              ),
          ),
        );
      }
    }

    if (state.videosThemes.data != null &&
        state.videosThemes.data!.data.isNotEmpty) {
      final int index =
          state.videosThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..videosThemes.data = b.videosThemes.data?.rebuild(
                (d) => d.data[index] =
                    d.data[index].rebuild((n) => n..isApplied = true),
              ),
          ),
        );
      }
    }

    if (state.categoryDetailsThemesApi.data != null &&
        state.categoryDetailsThemesApi.data!.data.isNotEmpty) {
      final int index = state.categoryDetailsThemesApi.data!.data
          .indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..categoryDetailsThemesApi.data =
                  b.categoryDetailsThemesApi.data?.rebuild(
                (d) => d.data[index] =
                    d.data[index].rebuild((n) => n..isApplied = true),
              ),
          ),
        );
      }
    }

    if (state.gifsThemes.data != null &&
        state.gifsThemes.data!.data.isNotEmpty) {
      final int index =
          state.gifsThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..gifsThemes.data = b.gifsThemes.data?.rebuild(
                (d) => d.data[index] =
                    d.data[index].rebuild((n) => n..isApplied = true),
              ),
          ),
        );
      }
    }

    // if (state.recentThemes.data != null &&
    //     state.recentThemes.data!.data.isNotEmpty) {
    //   int index = state.recentThemes.data!.data.indexWhere((e) => e.id == id);
    //   if (index != -1) {
    //     emit(state.rebuild((b) => b
    //       ..recentThemes.data = b.recentThemes.data?.rebuild(
    //         (d) => d.data[index] =
    //             d.data[index].rebuild((n) => n..isApplied = true),
    //       )));
    //   }
    // }
  }

  void updateRemoveThemeWidget(BuildContext context, String type, int id) {
    if (state.feedThemes.data != null &&
        state.feedThemes.data!.data.isNotEmpty) {
      final int index =
          state.feedThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..feedThemes.data = b.feedThemes.data?.rebuild(
                (d) => d.data[index] =
                    d.data[index].rebuild((n) => n..isApplied = false),
              ),
          ),
        );
      }
    }

    if (state.myThemes.data != null && state.myThemes.data!.data.isNotEmpty) {
      final int index = state.myThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..myThemes.data = b.myThemes.data?.rebuild(
                (d) => d.data[index] =
                    d.data[index].rebuild((n) => n..isApplied = false),
              ),
          ),
        );
      }
    }

    if (state.favouriteThemes.data != null &&
        state.favouriteThemes.data!.data.isNotEmpty) {
      final int index =
          state.favouriteThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..favouriteThemes.data = b.favouriteThemes.data?.rebuild(
                (d) => d.data[index] =
                    d.data[index].rebuild((n) => n..isApplied = false),
              ),
          ),
        );
      }
    }

    if (state.popularThemes.data != null &&
        state.popularThemes.data!.data.isNotEmpty) {
      final int index =
          state.popularThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..popularThemes.data = b.popularThemes.data?.rebuild(
                (d) => d.data[index] =
                    d.data[index].rebuild((n) => n..isApplied = false),
              ),
          ),
        );
      }
    }

    if (state.videosThemes.data != null &&
        state.videosThemes.data!.data.isNotEmpty) {
      final int index =
          state.videosThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..videosThemes.data = b.videosThemes.data?.rebuild(
                (d) => d.data[index] =
                    d.data[index].rebuild((n) => n..isApplied = false),
              ),
          ),
        );
      }
    }

    if (state.categoryDetailsThemesApi.data != null &&
        state.categoryDetailsThemesApi.data!.data.isNotEmpty) {
      final int index = state.categoryDetailsThemesApi.data!.data
          .indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..categoryDetailsThemesApi.data =
                  b.categoryDetailsThemesApi.data?.rebuild(
                (d) => d.data[index] =
                    d.data[index].rebuild((n) => n..isApplied = false),
              ),
          ),
        );
      }
    }

    if (state.gifsThemes.data != null &&
        state.gifsThemes.data!.data.isNotEmpty) {
      final int index =
          state.gifsThemes.data!.data.indexWhere((e) => e.id == id);
      if (index != -1) {
        emit(
          state.rebuild(
            (b) => b
              ..gifsThemes.data = b.gifsThemes.data?.rebuild(
                (d) => d.data[index] =
                    d.data[index].rebuild((n) => n..isApplied = false),
              ),
          ),
        );
      }
    }

    // if (state.recentThemes.data != null &&
    //     state.recentThemes.data!.data.isNotEmpty) {
    //   int index = state.recentThemes.data!.data.indexWhere((e) => e.id == id);
    //   if (index != -1) {
    //     emit(state.rebuild((b) => b
    //       ..recentThemes.data = b.recentThemes.data?.rebuild(
    //         (d) => d.data[index] =
    //             d.data[index].rebuild((n) => n..isApplied = false),
    //       )));
    //   }
    // }
  }

  @override
  void updateIsDetailThemePage(bool isDetailThemePage) {
    //  implement updateIsDetailThemePage
    super.updateIsDetailThemePage(isDetailThemePage);
  }

  void refreshTheme(String type) {
    emit(
      state.rebuild(
        (b) => b
          ..feedThemes.replace(ApiState())
          ..feedThemes.totalCount = 0
          ..feedThemes.isApiInProgress = true
          ..feedThemes.currentPage = 0,
      ),
    );

    emit(
      state.rebuild(
        (b) => b
          ..myThemes.replace(ApiState())
          ..myThemes.totalCount = 0
          ..myThemes.isApiInProgress = true
          ..myThemes.currentPage = 0,
      ),
    );

    emit(
      state.rebuild(
        (b) => b
          ..favouriteThemes.replace(ApiState())
          ..favouriteThemes.totalCount = 0
          ..favouriteThemes.isApiInProgress = true
          ..favouriteThemes.currentPage = 0,
      ),
    );
    // case "Trending":
    //   emit(state.rebuild((b) => b
    //     ..trendingThemes.replace(ApiState())
    //     ..trendingThemes.totalCount = 0
    //     ..trendingThemes.isApiInProgress = true
    //     ..trendingThemes.currentPage = 0));
    //   break;

    emit(
      state.rebuild(
        (b) => b
          ..categoryDetailsThemesApi.replace(ApiState())
          ..categoryDetailsThemesApi.totalCount = 0
          ..categoryDetailsThemesApi.isApiInProgress = true
          ..categoryDetailsThemesApi.currentPage = 0,
      ),
    );

    emit(
      state.rebuild(
        (b) => b
          ..popularThemes.replace(ApiState())
          ..popularThemes.totalCount = 0
          ..popularThemes.isApiInProgress = true
          ..popularThemes.currentPage = 0,
      ),
    );

    emit(
      state.rebuild(
        (b) => b
          ..videosThemes.replace(ApiState())
          ..videosThemes.totalCount = 0
          ..videosThemes.isApiInProgress = true
          ..videosThemes.currentPage = 0,
      ),
    );

    emit(
      state.rebuild(
        (b) => b
          ..gifsThemes.replace(ApiState())
          ..gifsThemes.totalCount = 0
          ..gifsThemes.isApiInProgress = true
          ..gifsThemes.currentPage = 0,
      ),
    );
  }

  void resetThemeState(String type) {
    emit(
      state.rebuild((b) {
        switch (type) {
          case "Feed":
            b.feedThemes
              ..replace(ApiState())
              ..totalCount = 0
              ..isApiInProgress = true
              ..currentPage = 0;

          case "My Themes":
            b.myThemes
              ..replace(ApiState())
              ..totalCount = 0
              ..isApiInProgress = true
              ..currentPage = 0;

          case "Favourite":
            b.favouriteThemes
              ..replace(ApiState())
              ..totalCount = 0
              ..isApiInProgress = true
              ..currentPage = 0;

          case "Category":
            b.categoryDetailsThemesApi
              ..replace(ApiState())
              ..totalCount = 0
              ..isApiInProgress = true
              ..currentPage = 0;

          case "Popular":
            b.popularThemes
              ..replace(ApiState())
              ..totalCount = 0
              ..isApiInProgress = true
              ..currentPage = 0;

          case "Videos":
            b.videosThemes
              ..replace(ApiState())
              ..totalCount = 0
              ..isApiInProgress = true
              ..currentPage = 0;

          case "Gif":
            b.gifsThemes
              ..replace(ApiState())
              ..totalCount = 0
              ..isApiInProgress = true
              ..currentPage = 0;
        }
      }),
    );
  }

  void isPageChangeRefreshThemeMethod(String type) {
    switch (type) {
      case "Feed":
        emit(
          state.rebuild(
            (b) => b
              ..feedThemes.currentPage =
                  b.feedThemes.currentPage! > 1 ? b.feedThemes.currentPage! : 0,
          ),
        );
      case "My Themes":
        emit(
          state.rebuild(
            (b) => b
              ..myThemes.currentPage =
                  b.myThemes.currentPage! > 1 ? b.myThemes.currentPage! : 0,
          ),
        );
      case "Favourite":
        emit(
          state.rebuild(
            (b) => b
              ..favouriteThemes.currentPage = b.favouriteThemes.currentPage! > 1
                  ? b.favouriteThemes.currentPage!
                  : 0,
          ),
        );
      // case "Trending":
      //   emit(state.rebuild((b) => b
      //     ..trendingThemes.currentPage = b.trendingThemes.currentPage! > 1
      //         ? b.trendingThemes.currentPage!
      //         : 0));
      //   break;
      case "Category":
        emit(
          state.rebuild(
            (b) => b
              ..categoryDetailsThemesApi.currentPage =
                  b.categoryDetailsThemesApi.currentPage! > 1
                      ? b.categoryDetailsThemesApi.currentPage!
                      : 0,
          ),
        );
      case "Popular":
        emit(
          state.rebuild(
            (b) => b
              ..popularThemes.currentPage = b.popularThemes.currentPage! > 1
                  ? b.popularThemes.currentPage!
                  : 0,
          ),
        );
      case "Videos":
        emit(
          state.rebuild(
            (b) => b
              ..videosThemes.currentPage = b.videosThemes.currentPage! > 1
                  ? b.videosThemes.currentPage!
                  : 0,
          ),
        );
      case "Gif":
        emit(
          state.rebuild(
            (b) => b
              ..gifsThemes.currentPage =
                  b.gifsThemes.currentPage! > 1 ? b.gifsThemes.currentPage! : 0,
          ),
        );

      default:
        emit(
          state.rebuild(
            (b) => b
              ..feedThemes.currentPage =
                  b.feedThemes.currentPage! > 1 ? b.feedThemes.currentPage! : 0,
          ),
        );
    }
  }

  void updateApiState(
    final ThemeStateBuilder b,
    final ApiState<PaginatedData<ThemeDataModel>> apiState,
    String type,
  ) {
    switch (type) {
      case "Feed":
        b.feedThemes.replace(apiState);
      case "Category":
        b.categoryDetailsThemesApi.replace(apiState);
      case "My Themes":
        b.myThemes.replace(apiState);
      case "Favourite":
        b.favouriteThemes.replace(apiState);
      // case "Trending":
      //   b.trendingThemes.replace(apiState);
      //   break;
      case "Popular":
        b.popularThemes.replace(apiState);
      case "Videos":
        b.videosThemes.replace(apiState);
      case "Gif":
        b.gifsThemes.replace(apiState);
      // case "Recent":
      //   b.recentThemes.replace(apiState);
      //   break;
      default:
        b.feedThemes.replace(apiState);
    }
  }

  void saveThemesToCache(PaginatedData<ThemeDataModel> data, String type) {
    if (data.data.isNotEmpty) {
      for (int i = 0; i < data.data.length; i++) {
        if (data.data[i].cover.isNotEmpty &&
            data.data[i].cover.contains("http")) {
          CacheFiles.downloadAndGetFile(data.data[i].cover).then((value) {
            if (value != null) {
              updateCacheEmit(type, i, value.file.path);
            }
          });
          if (data.data[i].thumbnail.isNotEmpty &&
              data.data[i].thumbnail != data.data[i].cover &&
              data.data[i].thumbnail.contains("http")) {
            CacheFiles.downloadAndGetFile(data.data[i].thumbnail).then((value) {
              if (value != null) {
                updateThumbnailCacheEmit(type, i, value.file.path);
              }
            });
          }
        }
      }
    }
  }

  void updateIndex(int index) {
    emit(state.rebuild((b) => b..index = index));
  }

  int changeVideoTheme(int total, bool isForward) {
    if (isForward) {
      if (state.index < total - 1) {
        updateIndex(state.index + 1);
      }
    } else {
      if (state.index > 0) {
        updateIndex(state.index - 1);
      }
    }
    return state.index;
  }
}
