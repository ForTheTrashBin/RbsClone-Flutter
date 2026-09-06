//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'country_list_item.g.dart';

/// CountryListItem
///
/// Properties:
/// * [id] - This is the unique identifier a this data
/// * [name] - A longer more descriptive description of this data
/// * [shortcode] - A unique short name for this data
@BuiltValue()
abstract class CountryListItem
    implements Built<CountryListItem, CountryListItemBuilder> {
  /// This is the unique identifier a this data
  @BuiltValueField(wireName: r'id')
  String get id;

  /// A longer more descriptive description of this data
  @BuiltValueField(wireName: r'name')
  String get name;

  /// A unique short name for this data
  @BuiltValueField(wireName: r'shortcode')
  String get shortcode;

  CountryListItem._();

  factory CountryListItem([void updates(CountryListItemBuilder b)]) =
      _$CountryListItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CountryListItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CountryListItem> get serializer =>
      _$CountryListItemSerializer();
}

class _$CountryListItemSerializer
    implements PrimitiveSerializer<CountryListItem> {
  @override
  final Iterable<Type> types = const [CountryListItem, _$CountryListItem];

  @override
  final String wireName = r'CountryListItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CountryListItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'shortcode';
    yield serializers.serialize(
      object.shortcode,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CountryListItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CountryListItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'shortcode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.shortcode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CountryListItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CountryListItemBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
