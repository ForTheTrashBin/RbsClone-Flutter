//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'exchange.g.dart';

/// Exchange
///
/// Properties:
/// * [flags] - Some binary encoded flags for this data (see external documentation)
/// * [id] - This is the unique identifier a this data
/// * [name] - A longer more descriptive description of this data
/// * [shortcode] - A unique short name for this data
@BuiltValue()
abstract class Exchange implements Built<Exchange, ExchangeBuilder> {
  /// Some binary encoded flags for this data (see external documentation)
  @BuiltValueField(wireName: r'flags')
  int get flags;

  /// This is the unique identifier a this data
  @BuiltValueField(wireName: r'id')
  String get id;

  /// A longer more descriptive description of this data
  @BuiltValueField(wireName: r'name')
  String get name;

  /// A unique short name for this data
  @BuiltValueField(wireName: r'shortcode')
  String get shortcode;

  Exchange._();

  factory Exchange([void updates(ExchangeBuilder b)]) = _$Exchange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExchangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Exchange> get serializer => _$ExchangeSerializer();
}

class _$ExchangeSerializer implements PrimitiveSerializer<Exchange> {
  @override
  final Iterable<Type> types = const [Exchange, _$Exchange];

  @override
  final String wireName = r'Exchange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Exchange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'flags';
    yield serializers.serialize(
      object.flags,
      specifiedType: const FullType(int),
    );
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
    Exchange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExchangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'flags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.flags = valueDes;
          break;
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
  Exchange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExchangeBuilder();
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


