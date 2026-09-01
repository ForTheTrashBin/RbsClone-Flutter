//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'custodian.g.dart';

/// Custodian
///
/// Properties:
/// * [depotno] - This dopot numer assocciated with this custodian
/// * [flags] - Some binary encoded flags for this data (see external documentation)
/// * [id] - This is the unique identifier a this data
/// * [idcountry] - A reference to a country, where the custodion is in
/// * [name] - A longer more descriptive description of this data
/// * [shortcode] - A unique short name for this data
@BuiltValue()
abstract class Custodian implements Built<Custodian, CustodianBuilder> {
  /// This dopot numer assocciated with this custodian
  @BuiltValueField(wireName: r'depotno')
  String? get depotno;

  /// Some binary encoded flags for this data (see external documentation)
  @BuiltValueField(wireName: r'flags')
  int get flags;

  /// This is the unique identifier a this data
  @BuiltValueField(wireName: r'id')
  String get id;

  /// A reference to a country, where the custodion is in
  @BuiltValueField(wireName: r'idcountry')
  String get idcountry;

  /// A longer more descriptive description of this data
  @BuiltValueField(wireName: r'name')
  String get name;

  /// A unique short name for this data
  @BuiltValueField(wireName: r'shortcode')
  String get shortcode;

  Custodian._();

  factory Custodian([void updates(CustodianBuilder b)]) = _$Custodian;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustodianBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Custodian> get serializer => _$CustodianSerializer();
}

class _$CustodianSerializer implements PrimitiveSerializer<Custodian> {
  @override
  final Iterable<Type> types = const [Custodian, _$Custodian];

  @override
  final String wireName = r'Custodian';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Custodian object, {
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
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
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
    Custodian object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustodianBuilder result,
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
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
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
  Custodian deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustodianBuilder();
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


