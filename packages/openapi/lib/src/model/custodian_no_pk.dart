//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'custodian_no_pk.g.dart';

/// CustodianNoPK
///
/// Properties:
/// * [depotno] - This dopot numer assocciated with this custodian
/// * [flags] - Some binary encoded flags for this data (see external documentation)
/// * [idcountry] - A reference to a country, where the custodion is in
/// * [name] - A longer more descriptive description of this data
/// * [shortcode] - A unique short name for this data
@BuiltValue()
abstract class CustodianNoPK
    implements Built<CustodianNoPK, CustodianNoPKBuilder> {
  /// This dopot numer assocciated with this custodian
  @BuiltValueField(wireName: r'depotno')
  String? get depotno;

  /// Some binary encoded flags for this data (see external documentation)
  @BuiltValueField(wireName: r'flags')
  int get flags;

  /// A reference to a country, where the custodion is in
  @BuiltValueField(wireName: r'idcountry')
  String get idcountry;

  /// A longer more descriptive description of this data
  @BuiltValueField(wireName: r'name')
  String get name;

  /// A unique short name for this data
  @BuiltValueField(wireName: r'shortcode')
  String get shortcode;

  CustodianNoPK._();

  factory CustodianNoPK([void updates(CustodianNoPKBuilder b)]) =
      _$CustodianNoPK;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustodianNoPKBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustodianNoPK> get serializer =>
      _$CustodianNoPKSerializer();
}

class _$CustodianNoPKSerializer implements PrimitiveSerializer<CustodianNoPK> {
  @override
  final Iterable<Type> types = const [CustodianNoPK, _$CustodianNoPK];

  @override
  final String wireName = r'CustodianNoPK';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustodianNoPK object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.depotno != null) {
      yield r'depotno';
      yield serializers.serialize(
        object.depotno,
        specifiedType: const FullType(String),
      );
    }
    yield r'flags';
    yield serializers.serialize(
      object.flags,
      specifiedType: const FullType(int),
    );
    yield r'idcountry';
    yield serializers.serialize(
      object.idcountry,
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
    CustodianNoPK object, {
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
    required CustodianNoPKBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'depotno':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.depotno = valueDes;
          break;
        case r'flags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.flags = valueDes;
          break;
        case r'idcountry':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idcountry = valueDes;
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
  CustodianNoPK deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustodianNoPKBuilder();
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
