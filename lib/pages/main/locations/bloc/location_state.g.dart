// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LocationState extends LocationState {
  @override
  final String? search;
  @override
  final SubUserModel? selectedOwnershipUser;
  @override
  final BuiltList<SubUserModel>? locationSubUsersList;
  @override
  final String selectedReleaseLocationId;
  @override
  final ApiState<void> locationSubUsersApi;
  @override
  final ApiState<void> transferOwnershipApi;
  @override
  final ApiState<void> releaseLocationApi;

  factory _$LocationState([void Function(LocationStateBuilder)? updates]) =>
      (LocationStateBuilder()..update(updates))._build();

  _$LocationState._(
      {this.search,
      this.selectedOwnershipUser,
      this.locationSubUsersList,
      required this.selectedReleaseLocationId,
      required this.locationSubUsersApi,
      required this.transferOwnershipApi,
      required this.releaseLocationApi})
      : super._();
  @override
  LocationState rebuild(void Function(LocationStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LocationStateBuilder toBuilder() => LocationStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LocationState &&
        search == other.search &&
        selectedOwnershipUser == other.selectedOwnershipUser &&
        locationSubUsersList == other.locationSubUsersList &&
        selectedReleaseLocationId == other.selectedReleaseLocationId &&
        locationSubUsersApi == other.locationSubUsersApi &&
        transferOwnershipApi == other.transferOwnershipApi &&
        releaseLocationApi == other.releaseLocationApi;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, search.hashCode);
    _$hash = $jc(_$hash, selectedOwnershipUser.hashCode);
    _$hash = $jc(_$hash, locationSubUsersList.hashCode);
    _$hash = $jc(_$hash, selectedReleaseLocationId.hashCode);
    _$hash = $jc(_$hash, locationSubUsersApi.hashCode);
    _$hash = $jc(_$hash, transferOwnershipApi.hashCode);
    _$hash = $jc(_$hash, releaseLocationApi.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LocationState')
          ..add('search', search)
          ..add('selectedOwnershipUser', selectedOwnershipUser)
          ..add('locationSubUsersList', locationSubUsersList)
          ..add('selectedReleaseLocationId', selectedReleaseLocationId)
          ..add('locationSubUsersApi', locationSubUsersApi)
          ..add('transferOwnershipApi', transferOwnershipApi)
          ..add('releaseLocationApi', releaseLocationApi))
        .toString();
  }
}

class LocationStateBuilder
    implements Builder<LocationState, LocationStateBuilder> {
  _$LocationState? _$v;

  String? _search;
  String? get search => _$this._search;
  set search(String? search) => _$this._search = search;

  SubUserModelBuilder? _selectedOwnershipUser;
  SubUserModelBuilder get selectedOwnershipUser =>
      _$this._selectedOwnershipUser ??= SubUserModelBuilder();
  set selectedOwnershipUser(SubUserModelBuilder? selectedOwnershipUser) =>
      _$this._selectedOwnershipUser = selectedOwnershipUser;

  ListBuilder<SubUserModel>? _locationSubUsersList;
  ListBuilder<SubUserModel> get locationSubUsersList =>
      _$this._locationSubUsersList ??= ListBuilder<SubUserModel>();
  set locationSubUsersList(ListBuilder<SubUserModel>? locationSubUsersList) =>
      _$this._locationSubUsersList = locationSubUsersList;

  String? _selectedReleaseLocationId;
  String? get selectedReleaseLocationId => _$this._selectedReleaseLocationId;
  set selectedReleaseLocationId(String? selectedReleaseLocationId) =>
      _$this._selectedReleaseLocationId = selectedReleaseLocationId;

  ApiStateBuilder<void>? _locationSubUsersApi;
  ApiStateBuilder<void> get locationSubUsersApi =>
      _$this._locationSubUsersApi ??= ApiStateBuilder<void>();
  set locationSubUsersApi(ApiStateBuilder<void>? locationSubUsersApi) =>
      _$this._locationSubUsersApi = locationSubUsersApi;

  ApiStateBuilder<void>? _transferOwnershipApi;
  ApiStateBuilder<void> get transferOwnershipApi =>
      _$this._transferOwnershipApi ??= ApiStateBuilder<void>();
  set transferOwnershipApi(ApiStateBuilder<void>? transferOwnershipApi) =>
      _$this._transferOwnershipApi = transferOwnershipApi;

  ApiStateBuilder<void>? _releaseLocationApi;
  ApiStateBuilder<void> get releaseLocationApi =>
      _$this._releaseLocationApi ??= ApiStateBuilder<void>();
  set releaseLocationApi(ApiStateBuilder<void>? releaseLocationApi) =>
      _$this._releaseLocationApi = releaseLocationApi;

  LocationStateBuilder() {
    LocationState._initialize(this);
  }

  LocationStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _search = $v.search;
      _selectedOwnershipUser = $v.selectedOwnershipUser?.toBuilder();
      _locationSubUsersList = $v.locationSubUsersList?.toBuilder();
      _selectedReleaseLocationId = $v.selectedReleaseLocationId;
      _locationSubUsersApi = $v.locationSubUsersApi.toBuilder();
      _transferOwnershipApi = $v.transferOwnershipApi.toBuilder();
      _releaseLocationApi = $v.releaseLocationApi.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LocationState other) {
    _$v = other as _$LocationState;
  }

  @override
  void update(void Function(LocationStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LocationState build() => _build();

  _$LocationState _build() {
    _$LocationState _$result;
    try {
      _$result = _$v ??
          _$LocationState._(
            search: search,
            selectedOwnershipUser: _selectedOwnershipUser?.build(),
            locationSubUsersList: _locationSubUsersList?.build(),
            selectedReleaseLocationId: BuiltValueNullFieldError.checkNotNull(
                selectedReleaseLocationId,
                r'LocationState',
                'selectedReleaseLocationId'),
            locationSubUsersApi: locationSubUsersApi.build(),
            transferOwnershipApi: transferOwnershipApi.build(),
            releaseLocationApi: releaseLocationApi.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'selectedOwnershipUser';
        _selectedOwnershipUser?.build();
        _$failedField = 'locationSubUsersList';
        _locationSubUsersList?.build();

        _$failedField = 'locationSubUsersApi';
        locationSubUsersApi.build();
        _$failedField = 'transferOwnershipApi';
        transferOwnershipApi.build();
        _$failedField = 'releaseLocationApi';
        releaseLocationApi.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LocationState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
