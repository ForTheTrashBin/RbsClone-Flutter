//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'country_response_create_header.g.dart';

/// CountryResponseCreateHeader
///
/// Properties:
/// * [location] - URL of the newly created entity
@BuiltValue()
abstract class CountryResponseCreateHeader
    implements
        Built<CountryResponseCreateHeader, CountryResponseCreateHeaderBuilder> {
  /// URL of the newly created entity
  @BuiltValueField(wireName: r'Location')
  String get location;

  CountryResponseCreateHeader._();

  factory CountryResponseCreateHeader(
          [void updates(CountryResponseCreateHeaderBuilder b)]) =
      _$CountryResponseCreateHeader;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CountryResponseCreateHeaderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CountryResponseCreateHeader> get serializer =>
      _$CountryResponseCreateHeaderSerializer();
}

class _$CountryResponseCreateHeaderSerializer
    implements PrimitiveSerializer<CountryResponseCreateHeader> {
  @override
  final Iterable<Type> types = const [
    CountryResponseCreateHeader,
    _$CountryResponseCreateHeader
  ];

  @override
  final String wireName = r'CountryResponseCreateHeader';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CountryResponseCreateHeader object, {
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
    CountryResponseCreateHeader object, {
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
    required CountryResponseCreateHeaderBuilder result,
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
  CountryResponseCreateHeader deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CountryResponseCreateHeaderBuilder();
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
