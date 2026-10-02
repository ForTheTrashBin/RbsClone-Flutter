//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'exchange2_custodian_list_item.g.dart';

/// Exchange2CustodianListItem
///
/// Properties:
/// * [idexchange] - This is the unique identifier of this data
/// * [value1] - This is the first special payload for testing
/// * [value2] - This is the second special payload for testing
@BuiltValue()
abstract class Exchange2CustodianListItem
    implements
        Built<Exchange2CustodianListItem, Exchange2CustodianListItemBuilder> {
  /// This is the unique identifier of this data
  @BuiltValueField(wireName: r'idexchange')
  String get idexchange;

  /// This is the first special payload for testing
  @BuiltValueField(wireName: r'value1')
  int get value1;

  /// This is the second special payload for testing
  @BuiltValueField(wireName: r'value2')
  int get value2;

  Exchange2CustodianListItem._();

  factory Exchange2CustodianListItem(
          [void updates(Exchange2CustodianListItemBuilder b)]) =
      _$Exchange2CustodianListItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(Exchange2CustodianListItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Exchange2CustodianListItem> get serializer =>
      _$Exchange2CustodianListItemSerializer();
}

class _$Exchange2CustodianListItemSerializer
    implements PrimitiveSerializer<Exchange2CustodianListItem> {
  @override
  final Iterable<Type> types = const [
    Exchange2CustodianListItem,
    _$Exchange2CustodianListItem
  ];

  @override
  final String wireName = r'Exchange2CustodianListItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Exchange2CustodianListItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'idexchange';
    yield serializers.serialize(
      object.idexchange,
      specifiedType: const FullType(String),
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
    Exchange2CustodianListItem object, {
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
    required Exchange2CustodianListItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'idexchange':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idexchange = valueDes;
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
  Exchange2CustodianListItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = Exchange2CustodianListItemBuilder();
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
