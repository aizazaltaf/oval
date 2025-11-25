// ignore_for_file: type=lint, unused_element

part of 'profile_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class ProfileBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<UserData?>? buildWhen;
  final BlocWidgetBuilder<UserData?> builder;

  const ProfileBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<ProfileBloc, UserData?>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class ProfileBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<UserData?, T> selector;
  final Widget Function(T state) builder;
  final ProfileBloc? bloc;

  const ProfileBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static ProfileBlocSelector<int?> id({
    final Key? key,
    required Widget Function(int? id) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.id,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<String?> name({
    final Key? key,
    required Widget Function(String? name) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.name,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<String?> email({
    final Key? key,
    required Widget Function(String? email) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.email,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<String?> phone({
    final Key? key,
    required Widget Function(String? phone) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.phone,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<String?> pushNotificationToken({
    final Key? key,
    required Widget Function(String? pushNotificationToken) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.pushNotificationToken,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<int?> aiThemeCounter({
    final Key? key,
    required Widget Function(int? aiThemeCounter) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.aiThemeCounter,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<String?> callUserId({
    final Key? key,
    required Widget Function(String? callUserId) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.callUserId,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<String?> streamingId({
    final Key? key,
    required Widget Function(String? streamingId) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.streamingId,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<UserDeviceModel?> selectedDoorBell({
    final Key? key,
    required Widget Function(UserDeviceModel? selectedDoorBell) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.selectedDoorBell,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<BuiltList<String>?> sectionList({
    final Key? key,
    required Widget Function(BuiltList<String>? sectionList) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.sectionList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<BuiltList<PlanFeaturesModel>?> planFeaturesList({
    final Key? key,
    required Widget Function(BuiltList<PlanFeaturesModel>? planFeaturesList)
        builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.planFeaturesList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<bool?> canPinned({
    final Key? key,
    required Widget Function(bool? canPinned) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.canPinned,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<String?> image({
    final Key? key,
    required Widget Function(String? image) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.image,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<String?> apiToken({
    final Key? key,
    required Widget Function(String? apiToken) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.apiToken,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<String?> refreshToken({
    final Key? key,
    required Widget Function(String? refreshToken) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.refreshToken,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<String?> pendingEmail({
    final Key? key,
    required Widget Function(String? pendingEmail) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.pendingEmail,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<bool?> phoneVerified({
    final Key? key,
    required Widget Function(bool? phoneVerified) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.phoneVerified,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<bool?> emailVerified({
    final Key? key,
    required Widget Function(bool? emailVerified) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.emailVerified,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<GuideModel?> guides({
    final Key? key,
    required Widget Function(GuideModel? guides) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.guides,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<String?> userRole({
    final Key? key,
    required Widget Function(String? userRole) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.userRole,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ProfileBlocSelector<BuiltList<DoorbellLocations>?> locations({
    final Key? key,
    required Widget Function(BuiltList<DoorbellLocations>? locations) builder,
    final ProfileBloc? bloc,
  }) {
    return ProfileBlocSelector(
      key: key,
      selector: (state) => state?.locations,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<ProfileBloc, UserData?, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _ProfileBlocMixin on Cubit<UserData?> {
  @mustCallSuper
  void updateUserRole(final String? userRole) {
    if (this.state?.userRole == userRole) {
      return;
    }

    emit(this.state?.rebuild((final b) => b.userRole = userRole));

    $onUpdateUserRole();
  }

  @protected
  void $onUpdateUserRole() {}
}

mixin _ProfileBlocHydratedMixin on HydratedMixin<UserData?> {
  @override
  Map<String, dynamic>? toJson(UserData? state) {
    final json = <String, dynamic>{};

    try {
      json['UserData'] = serializers.serialize(
        state,
        specifiedType: const FullType.nullable(UserData, []),
      );
    } catch (e) {
      _logger.severe('toJson->UserData: $e');
    }

    return json;
  }

  @override
  UserData? fromJson(Map<String, dynamic> json) {
    try {
      return serializers.deserialize(
        json['UserData'],
        specifiedType: const FullType.nullable(UserData, []),
      ) as UserData?;
    } catch (e) {
      _logger.severe('fromJson->UserData: $e');
      return null;
    }
  }
}
