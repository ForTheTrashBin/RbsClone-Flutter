//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'custodian2_exchange.g.dart';

/// Custodian2Exchange
///
/// Properties:
/// * [flags] - Some binary encoded flags for this data (see external documentation)
/// * [idcustodian] - This is one of the two parts of the unique identifier of this data
/// * [idexchange] - This is one of the two parts of the unique identifier of this data
/// * [value01] - A value01 for this data
/// * [value02] - A value01 for this data
@BuiltValue()
abstract class Custodian2Exchange implements Built<Custodian2Exchange, Custodian2ExchangeBuilder> {
  /// Some binary encoded flags for this data (see external documentation)
  @BuiltValueField(wireName: r'flags')
  int get flags;

  /// This is one of the two parts of the unique identifier of this data
  @BuiltValueField(wireName: r'idcustodian')
  String get idcustodian;

  /// This is one of the two parts of the unique identifier of this data
  @BuiltValueField(wireName: r'idexchange')
  String get idexchange;

  /// A value01 for this data
  @BuiltValueField(wireName: r'value01')
  String get value01;

  /// A value01 for this data
  @BuiltValueField(wireName: r'value02')
  int get value02;

  Custodian2Exchange._();

  factory Custodian2Exchange([void updates(Custodian2ExchangeBuilder b)]) = _$Custodian2Exchange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(Custodian2ExchangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Custodian2Exchange> get serializer => _$Custodian2ExchangeSerializer();
}

class _$Custodian2ExchangeSerializer implements PrimitiveSerializer<Custodian2Exchange> {
  @override
  final Iterable<Type> types = const [Custodian2Exchange, _$Custodian2Exchange];

  @override
  final String wireName = r'Custodian2Exchange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Custodian2Exchange object, {
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
    Custodian2Exchange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required Custodian2ExchangeBuilder result,
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
  Custodian2Exchange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = Custodian2ExchangeBuilder();
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


