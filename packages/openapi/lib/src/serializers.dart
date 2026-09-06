//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:openapi/src/date_serializer.dart';
import 'package:openapi/src/model/date.dart';

import 'package:openapi/src/model/country.dart';
import 'package:openapi/src/model/country_list_item.dart';
import 'package:openapi/src/model/country_no_pk.dart';
import 'package:openapi/src/model/custodian.dart';
import 'package:openapi/src/model/custodian2_exchange.dart';
import 'package:openapi/src/model/custodian_list_item.dart';
import 'package:openapi/src/model/custodian_no_pk.dart';
import 'package:openapi/src/model/error_detail.dart';
import 'package:openapi/src/model/error_model.dart';
import 'package:openapi/src/model/exchange.dart';
import 'package:openapi/src/model/exchange_list_item.dart';
import 'package:openapi/src/model/exchange_no_pk.dart';
import 'package:openapi/src/model/map_custodian2_exchange.dart';
import 'package:openapi/src/model/map_exchange2_custodian.dart';

part 'serializers.g.dart';

@SerializersFor([
  Country,
  CountryListItem,
  CountryNoPK,
  Custodian,
  Custodian2Exchange,
  CustodianListItem,
  CustodianNoPK,
  ErrorDetail,
  ErrorModel,
  Exchange,
  ExchangeListItem,
  ExchangeNoPK,
  MapCustodian2Exchange,
  MapExchange2Custodian,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(MapCustodian2Exchange)]),
        () => ListBuilder<MapCustodian2Exchange>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CountryListItem)]),
        () => ListBuilder<CountryListItem>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ErrorDetail)]),
        () => ListBuilder<ErrorDetail>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CustodianListItem)]),
        () => ListBuilder<CustodianListItem>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(MapExchange2Custodian)]),
        () => ListBuilder<MapExchange2Custodian>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Custodian2Exchange)]),
        () => ListBuilder<Custodian2Exchange>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ExchangeListItem)]),
        () => ListBuilder<ExchangeListItem>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
