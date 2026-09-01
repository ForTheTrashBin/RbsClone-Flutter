//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'map_exchange2_custodian.g.dart';

/// MapExchange2Custodian
///
/// Properties:
/// * [flags] - Some binary encoded flags for this data (see external documentation)
/// * [idexchange] - This is one of the two parts of the unique identifier of this data
/// * [value01] - A value01 for this data
/// * [value02] - A value01 for this data
@BuiltValue()
abstract class MapExchange2Custodian implements Built<MapExchange2Custodian, MapExchange2CustodianBuilder> {
  /// Some binary encoded flags for this data (see external documentation)
  @BuiltValueField(wireName: r'flags')
  int get flags;

  /// This is one of the two parts of the unique identifier of this data
  @BuiltValueField(wireName: r'idexchange')
  String get idexchange;

  /// A value01 for this data
  @BuiltValueField(wireName: r'value01')
  String get value01;

  /// A value01 for this data
  @BuiltValueField(wireName: r'value02')
  int get value02;

  MapExchange2Custodian._();

  factory MapExchange2Custodian([void updates(MapExchange2CustodianBuilder b)]) = _$MapExchange2Custodian;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MapExchange2CustodianBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MapExchange2Custodian> get serializer => _$MapExchange2CustodianSerializer();
}

class _$MapExchange2CustodianSerializer implements PrimitiveSerializer<MapExchange2Custodian> {
  @override
  final Iterable<Type> types = const [MapExchange2Custodian, _$MapExchange2Custodian];

  @override
  final String wireName = r'MapExchange2Custodian';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MapExchange2Custodian object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'flags';
    yield serializers.serialize(
      object.flags,
      specifiedType: const FullType(int),
    );
    yield r'idexchange';
    yield serializers.serialize(
      object.idexchange,
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
    MapExchange2Custodian object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MapExchange2CustodianBuilder result,
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
        case r'idexchange':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idexchange = valueDes;
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
  MapExchange2Custodian deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MapExchange2CustodianBuilder();
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


