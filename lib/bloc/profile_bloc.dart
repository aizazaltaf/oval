import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/guide_data.dart';
import 'package:admin/models/data/plan_features_model.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/serializers.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'profile_bloc.bloc.g.dart';

final _logger = Logger('profile_bloc.dart');

@BlocGen(
  hydrateState: true,
)
class ProfileBloc extends WCCubit<UserData?>
    with HydratedMixin, _ProfileBlocHydratedMixin {
  ProfileBloc() : super(null) {
    hydrate();
  }

  factory ProfileBloc.of(final BuildContext context) =>
      BlocProvider.of<ProfileBloc>(context);

  void updateProfile(final UserData? profile) {
    ///before cursor
    // emit(profile);
    // if (profile != null) {
    //   if (profile.locations != null && profile.locations!.isNotEmpty) {
    //     if (singletonBloc.profileBloc.state!.locationId == null) {
    //       updateLocationId(profile.locations![0].id.toString());
    //     }
    //   }
    //    else {
    //     updateLocationId(null);
    //   }
    // }
    ///after cursor
    final updatedProfile = profile;

    emit(updatedProfile);

    // if (updatedProfile != null) {
    //   if (updatedProfile.locations != null &&
    //       updatedProfile.locations!.isNotEmpty) {
    //     // Check the directly passed profile instead of going through singleton
    //     if (updatedProfile.locationId == null) {
    //       updateLocationId(updatedProfile.locations?.first.id.toString());
    //     }
    //   } else {
    //     updateLocationId(null);
    //   }
    // }
  }

  // void updateLocationId(String? locationId) {
  //   emit(state!.rebuild((e) => e..locationId = locationId));
  // }

  void updateUserRole(String? role) {
    emit(state?.rebuild((e) => e..userRole = role));
  }

  void updateSelectedDoorBell(final UserDeviceModel userDeviceModel) {
    emit(state?.rebuild((a) => a..selectedDoorBell.replace(userDeviceModel)));
    // updateLocationId(userDeviceModel.locationId.toString());
  }

  void updateSelectedDoorBellToNull() {
    emit(state?.rebuild((a) => a..selectedDoorBell = null));
  }

  void updateAiThemeCounter({bool isNegative = false, int? counter}) {
    emit(
      state?.rebuild(
        (a) => a
          ..aiThemeCounter = counter ??
              (isNegative ? a.aiThemeCounter! - 1 : a.aiThemeCounter! + 1),
      ),
    );
  }

  void updatePlanFeaturesList(
    final BuiltList<PlanFeaturesModel> planFeaturesList,
  ) {
    emit(
      state?.rebuild((a) {
        a.planFeaturesList.replace(planFeaturesList);
      }),
    );
  }

  void updateStreamingId(final String streamingId) {
    emit(state?.rebuild((a) => a..streamingId = streamingId));
  }

  void canPinned(final bool canPin) {
    emit(state?.rebuild((a) => a..canPinned = canPin));
  }

  void updateSectionList(final BuiltList<String> section) {
    emit(
      state?.rebuild((a) {
        a.sectionList.replace(section);
      }),
    );
  }
}
