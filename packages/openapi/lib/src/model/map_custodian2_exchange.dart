//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'map_custodian2_exchange.g.dart';

/// MapCustodian2Exchange
///
/// Properties:
/// * [flags] - Some binary encoded flags for this data (see external documentation)
/// * [idcustodian] - This is one of the two parts of the unique identifier of this data
/// * [value01] - A value01 for this data
/// * [value02] - A value01 for this data
@BuiltValue()
abstract class MapCustodian2Exchange implements Built<MapCustodian2Exchange, MapCustodian2ExchangeBuilder> {
  /// Some binary encoded flags for this data (see external documentation)
  @BuiltValueField(wireName: r'flags')
  int get flags;

  /// This is one of the two parts of the unique identifier of this data
  @BuiltValueField(wireName: r'idcustodian')
  String get idcustodian;

  /// A value01 for this data
  @BuiltValueField(wireName: r'value01')
  String get value01;

  /// A value01 for this data
  @BuiltValueField(wireName: r'value02')
  int get value02;

  MapCustodian2Exchange._();

  factory MapCustodian2Exchange([void updates(MapCustodian2ExchangeBuilder b)]) = _$MapCustodian2Exchange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MapCustodian2ExchangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MapCustodian2Exchange> get serializer => _$MapCustodian2ExchangeSerializer();
}

class _$MapCustodian2ExchangeSerializer implements PrimitiveSerializer<MapCustodian2Exchange> {
  @override
  final Iterable<Type> types = const [MapCustodian2Exchange, _$MapCustodian2Exchange];

  @override
  final String wireName = r'MapCustodian2Exchange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MapCustodian2Exchange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'flags';
    yield serializers.serialize(
      object.flags,
      specifiedType: const FullType(int),
    );
    yield r'idcustodian';
    yield serializers.serialize(
      object.idcustodian,
      specifiedType: const FullType(String),
    );
    yield r'value01';
    yield serializers.serialize(
      object.value01,
      specifiedType: const FullType(String),
    );
    yield r'value02';
    yield serializers.serialize(
      object.value02,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MapCustodian2Exchange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MapCustodian2ExchangeBuilder result,
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
        case r'idcustodian':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idcustodian = valueDes;
          break;
        case r'value01':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.value01 = valueDes;
          break;
        case r'value02':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.value02 = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MapCustodian2Exchange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MapCustodian2ExchangeBuilder();
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


