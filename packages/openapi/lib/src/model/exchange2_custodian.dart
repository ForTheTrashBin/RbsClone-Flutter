//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'exchange2_custodian.g.dart';

/// Exchange2Custodian
///
/// Properties:
/// * [idcustodian] - This is one of the two parts of the unique identifier of this data
/// * [idexchange] - This is one of the two parts of the unique identifier of this data
/// * [sequenceno] - Determines the order of the stock exchanges
/// * [value1] - This is the first special payload for testing
/// * [value2] - This is the second special payload for testing
@BuiltValue()
abstract class Exchange2Custodian
    implements Built<Exchange2Custodian, Exchange2CustodianBuilder> {
  /// This is one of the two parts of the unique identifier of this data
  @BuiltValueField(wireName: r'idcustodian')
  String get idcustodian;

  /// This is one of the two parts of the unique identifier of this data
  @BuiltValueField(wireName: r'idexchange')
  String get idexchange;

  /// Determines the order of the stock exchanges
  @BuiltValueField(wireName: r'sequenceno')
  int get sequenceno;

  /// This is the first special payload for testing
  @BuiltValueField(wireName: r'value1')
  int get value1;

  /// This is the second special payload for testing
  @BuiltValueField(wireName: r'value2')
  int get value2;

  Exchange2Custodian._();

  factory Exchange2Custodian([void updates(Exchange2CustodianBuilder b)]) =
      _$Exchange2Custodian;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(Exchange2CustodianBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Exchange2Custodian> get serializer =>
      _$Exchange2CustodianSerializer();
}

class _$Exchange2CustodianSerializer
    implements PrimitiveSerializer<Exchange2Custodian> {
  @override
  final Iterable<Type> types = const [Exchange2Custodian, _$Exchange2Custodian];

  @override
  final String wireName = r'Exchange2Custodian';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Exchange2Custodian object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'sequenceno';
    yield serializers.serialize(
      object.sequenceno,
      specifiedType: const FullType(int),
    );
    yield r'value1';
    yield serializers.serialize(
      object.value1,
      specifiedType: const FullType(int),
    );
    yield r'value2';
    yield serializers.serialize(
      object.value2,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Exchange2Custodian object, {
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
    required Exchange2CustodianBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'sequenceno':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sequenceno = valueDes;
          break;
        case r'value1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.value1 = valueDes;
          break;
        case r'value2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.value2 = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Exchange2Custodian deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = Exchange2CustodianBuilder();
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
