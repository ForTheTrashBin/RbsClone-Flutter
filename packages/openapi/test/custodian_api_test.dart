import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

/// tests for CustodianApi
void main() {
  final instance = Openapi().getCustodianApi();

  group(CustodianApi, () {
    // Create a new custodian
    //
    // Create a new custodian
    //
    //Future createCustodian(CustodianNoPK custodianNoPK) async
    test('test createCustodian', () async {
      // TODO
    });

    // Delete a single custodian based on the id supplied
    //
    // Delete a single custodian based on the id supplied
    //
    //Future deleteCustodian(String id) async
    test('test deleteCustodian', () async {
      // TODO
    });

    // Get a single custodian based on the id supplied
    //
    // Get a single custodian based on the id supplied
    //
    //Future<Custodian> getCustodianById(String id) async
    test('test getCustodianById', () async {
      // TODO
    });

    // Get a single custodian based on the shortcode supplied
    //
    // Get a single custodian based on the shortcode supplied
    //
    //Future<Custodian> getCustodianByShortcode(String shortcode) async
    test('test getCustodianByShortcode', () async {
      // TODO
    });

    // Get a list of all custodians
    //
    // Get a list of all custodians
    //
    //Future<BuiltList<CustodianListItem>> getCustodians() async
    test('test getCustodians', () async {
      // TODO
    });

    // Update an existing custodian based on the id supplied
    //
    // Update an existing custodian based on the id supplied
    //
    //Future updateCustodian(String id, CustodianNoPK custodianNoPK) async
    test('test updateCustodian', () async {
      // TODO
    });
  });
}
