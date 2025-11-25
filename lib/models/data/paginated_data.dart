import 'package:admin/models/serializers.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paginated_data.g.dart';

// Genetic Pagination
abstract class PaginatedData<T>
    implements Built<PaginatedData<T>, PaginatedDataBuilder<T>> {
  factory PaginatedData([void Function(PaginatedDataBuilder<T>)? updates]) =
      _$PaginatedData<T>;

  PaginatedData._();
  @BuiltValueField(wireName: 'current_page')
  int get currentPage;

  @BuiltValueField(wireName: 'last_page')
  int get lastPage;

  @BuiltValueField(wireName: 'next_page_url')
  String? get nextPageUrl;

  @BuiltValueField(wireName: 'data')
  BuiltList<T> get data;

  static Serializer<PaginatedData<T>> serializer<T>(
    Serializer<T> itemSerializer,
  ) {
    return _PaginatedDataSerializer<T>(itemSerializer);
  }

  static PaginatedData<T> fromDynamic<T>(
    final json,
    Serializer<T> itemSerializer,
    Serializers serializeWith,
  ) {
    json['current_page'] = json["pagination"]['current_page'];
    json['last_page'] = json["pagination"]['last_page'];
    json['next_page_url'] = json["pagination"]['next_page_url'];
    return serializeWith.deserializeWith(
      PaginatedData.serializer(itemSerializer),
      json,
    )!;
  }
}

class _PaginatedDataSerializer<T>
    implements StructuredSerializer<PaginatedData<T>> {
  _PaginatedDataSerializer(this.itemSerializer);
  final Serializer<T> itemSerializer;

  @override
  Iterable<Type> get types => [PaginatedData, _$PaginatedData];

  @override
  String get wireName => 'PaginatedData';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    PaginatedData<T> object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return [
      'current_page',
      object.currentPage,
      'last_page',
      object.lastPage,
      'next_page_url',
      object.nextPageUrl,
      'prev_page_url',
      object.data,
      'data',
      serializers.serialize(
        object.data,
        specifiedType: FullType(BuiltList, [FullType(T)]),
      ),
    ];
  }

  @override
  PaginatedData<T> deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaginatedDataBuilder<T>();
    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String?;
      iterator.moveNext();
      final value = iterator.current;
      switch (key) {
        case 'current_page':
          result.currentPage = value as int?;
        case 'last_page':
          result.lastPage = value as int?;
        case 'next_page_url':
          result.nextPageUrl = value as String?;

        case 'data':
          try {
            result.data.replace(
              serializers.deserialize(
                value,
                specifiedType: FullType(BuiltList, [FullType(T)]),
              )! as BuiltList<T>,
            );
          } catch (e) {
            logger.severe("Failed to deserialize 'data' field: $e");
            rethrow;
          }
      }
    }
    return result.build();
  }
}

abstract class PaginatedDataNew
    implements Built<PaginatedDataNew, PaginatedDataNewBuilder> {
  factory PaginatedDataNew([
    final void Function(PaginatedDataNewBuilder) updates,
  ]) = _$PaginatedDataNew;

  // @BuiltValueField(wireName: 'prev_page_url')
  // String? get prevPageUrl;
  //
  // int? get total;
  //
  // @BuiltValueField(wireName: 'per_page')
  // int? get perPage;
  //
  // @BuiltValueField(wireName: 'last_page_url')
  // String? get lastPageUrl;
  //
  // String? get path;

  PaginatedDataNew._();
  @BuiltValueField(wireName: 'current_page')
  int get currentPage;

  @BuiltValueField(wireName: 'last_page')
  int get lastPage;

  @BuiltValueField(wireName: 'next_page_url')
  String? get nextPageUrl;

  static Serializer<PaginatedDataNew> get serializer =>
      _$paginatedDataNewSerializer;

  static PaginatedDataNew fromDynamic(
    final json,
  ) {
    return serializers.deserializeWith(
      PaginatedDataNew.serializer,
      json,
    )!;
  }
}
