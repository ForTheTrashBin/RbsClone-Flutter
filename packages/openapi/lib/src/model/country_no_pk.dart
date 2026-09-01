//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'country_no_pk.g.dart';

/// CountryNoPK
///
/// Properties:
/// * [flags] - Some binary encoded flags for this data (see external documentation)
/// * [ibanlenth] - The exact length of the IBAN required in that country
/// * [name] - A longer more descriptive description of this data
/// * [risktype] - This risk profile of this country
/// * [shortcode] - A unique short name for this data
@BuiltValue()
abstract class CountryNoPK implements Built<CountryNoPK, CountryNoPKBuilder> {
  /// Some binary encoded flags for this data (see external documentation)
  @BuiltValueField(wireName: r'flags')
  int get flags;

  /// The exact length of the IBAN required in that country
  @BuiltValueField(wireName: r'ibanlenth')
  int? get ibanlenth;

  /// A longer more descriptive description of this data
  @BuiltValueField(wireName: r'name')
  String get name;

  /// This risk profile of this country
  @BuiltValueField(wireName: r'risktype')
  int get risktype;

  /// A unique short name for this data
  @BuiltValueField(wireName: r'shortcode')
  String get shortcode;

  CountryNoPK._();

  factory CountryNoPK([void updates(CountryNoPKBuilder b)]) = _$CountryNoPK;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CountryNoPKBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CountryNoPK> get serializer => _$CountryNoPKSerializer();
}

class _$CountryNoPKSerializer implements PrimitiveSerializer<CountryNoPK> {
  @override
  final Iterable<Type> types = const [CountryNoPK, _$CountryNoPK];

  @override
  final String wireName = r'CountryNoPK';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CountryNoPK object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'flags';
    yield serializers.serialize(
      object.flags,
      specifiedType: const FullType(int),
    );
    if (object.ibanlenth != null) {
      yield r'ibanlenth';
      yield serializers.serialize(
        object.ibanlenth,
        specifiedType: const FullType(int),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'risktype';
    yield serializers.serialize(
      object.risktype,
      specifiedType: const FullType(int),
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
    CountryNoPK object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CountryNoPKBuilder result,
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
        case r'ibanlenth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.ibanlenth = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'risktype':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.risktype = valueDes;
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
  CountryNoPK deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CountryNoPKBuilder();
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


