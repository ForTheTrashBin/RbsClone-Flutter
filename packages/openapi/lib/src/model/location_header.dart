//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'location_header.g.dart';

/// LocationHeader
///
/// Properties:
/// * [location] - URL of the newly created entity
@BuiltValue()
abstract class LocationHeader
    implements Built<LocationHeader, LocationHeaderBuilder> {
  /// URL of the newly created entity
  @BuiltValueField(wireName: r'Location')
  String get location;

  LocationHeader._();

  factory LocationHeader([void updates(LocationHeaderBuilder b)]) =
      _$LocationHeader;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LocationHeaderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LocationHeader> get serializer =>
      _$LocationHeaderSerializer();
}

class _$LocationHeaderSerializer
    implements PrimitiveSerializer<LocationHeader> {
  @override
  final Iterable<Type> types = const [LocationHeader, _$LocationHeader];

  @override
  final String wireName = r'LocationHeader';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LocationHeader object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'Location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LocationHeader object, {
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
    required LocationHeaderBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'Location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.location = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LocationHeader deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LocationHeaderBuilder();
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
