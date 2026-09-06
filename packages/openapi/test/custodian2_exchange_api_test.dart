import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

/// tests for Custodian2ExchangeApi
void main() {
  final instance = Openapi().getCustodian2ExchangeApi();

  group(Custodian2ExchangeApi, () {
    // Get a list of all mappings by idcustodian supplied
    //
    // Get a list of all mappings by idcustodian supplied
    //
    //Future<BuiltList<Custodian2Exchange>> getCustodian2ExchangeByIdCustodian(String idcustodian) async
    test('test getCustodian2ExchangeByIdCustodian', () async {
      // TODO
    });

    // Get a list of all mappings by idexchange supplied
    //
    // Get a list of all mappings by idexchange supplied
    //
    //Future<BuiltList<Custodian2Exchange>> getCustodian2ExchangeByIdExchange(String idexchange) async
    test('test getCustodian2ExchangeByIdExchange', () async {
      // TODO
    });

    // Update the mapping of multiple custodians to a single exchange
    //
    // Update the mapping of multiple custodians to a single exchange
    //
    //Future mapCustodians2Exchange(String idexchange, BuiltList<MapCustodian2Exchange> mapCustodian2Exchange) async
    test('test mapCustodians2Exchange', () async {
      // TODO
    });

    // Update the mapping of multiple exchanges to a single custodian
    //
    // Update the mapping of multiple exchanges to a single custodian
    //
    //Future mapExchanges2Custodian(String idcustodian, BuiltList<MapExchange2Custodian> mapExchange2Custodian) async
    test('test mapExchanges2Custodian', () async {
      // TODO
    });
  });
}
