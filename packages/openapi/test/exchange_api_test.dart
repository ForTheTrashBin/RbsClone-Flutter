import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ExchangeApi
void main() {
  final instance = Openapi().getExchangeApi();

  group(ExchangeApi, () {
    // Create a new exchange
    //
    // Create a new exchange
    //
    //Future createExchange(ExchangeNoPK exchangeNoPK) async
    test('test createExchange', () async {
      // TODO
    });

    // Delete a single exchange based on the id supplied
    //
    // Delete a single exchange based on the id supplied
    //
    //Future deleteExchange(String id) async
    test('test deleteExchange', () async {
      // TODO
    });

    // Get a single exchange based on the id supplied
    //
    // Get a single exchange based on the id supplied
    //
    //Future<Exchange> getExchangeById(String id) async
    test('test getExchangeById', () async {
      // TODO
    });

    // Get a single exchange based on the shortcode supplied
    //
    // Get a single exchange based on the shortcode supplied
    //
    //Future<Exchange> getExchangeByShortcode(String shortcode) async
    test('test getExchangeByShortcode', () async {
      // TODO
    });

    // Get a list of all exchanges
    //
    // Get a list of all exchanges
    //
    //Future<BuiltList<Exchange>> getExchanges() async
    test('test getExchanges', () async {
      // TODO
    });

    // Update an existing exchange based on the id supplied
    //
    // Update an existing exchange based on the id supplied
    //
    //Future updateExchange(String id, ExchangeNoPK exchangeNoPK) async
    test('test updateExchange', () async {
      // TODO
    });

  });
}
