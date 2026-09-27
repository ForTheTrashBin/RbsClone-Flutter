//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'custodian_response_create_header.g.dart';

/// CustodianResponseCreateHeader
///
/// Properties:
/// * [location] - URL of the newly created entity
@BuiltValue()
abstract class CustodianResponseCreateHeader
    implements
        Built<CustodianResponseCreateHeader,
            CustodianResponseCreateHeaderBuilder> {
  /// URL of the newly created entity
  @BuiltValueField(wireName: r'Location')
  String get location;

  CustodianResponseCreateHeader._();

  factory CustodianResponseCreateHeader(
          [void updates(CustodianResponseCreateHeaderBuilder b)]) =
      _$CustodianResponseCreateHeader;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustodianResponseCreateHeaderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustodianResponseCreateHeader> get serializer =>
      _$CustodianResponseCreateHeaderSerializer();
}

class _$CustodianResponseCreateHeaderSerializer
    implements PrimitiveSerializer<CustodianResponseCreateHeader> {
  @override
  final Iterable<Type> types = const [
    CustodianResponseCreateHeader,
    _$CustodianResponseCreateHeader
  ];

  @override
  final String wireName = r'CustodianResponseCreateHeader';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustodianResponseCreateHeader object, {
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
    CustodianResponseCreateHeader object, {
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
    required CustodianResponseCreateHeaderBuilder result,
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
  CustodianResponseCreateHeader deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustodianResponseCreateHeaderBuilder();
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
