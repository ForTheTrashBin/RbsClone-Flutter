import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for CustodianNoPK
void main() {
  final instance = CustodianNoPKBuilder();
  // TODO add properties to the builder and call build()

  group(CustodianNoPK, () {
    // This dopot numer assocciated with this custodian
    // String depotno
    test('to test the property `depotno`', () async {
      // TODO
    });

    // Some binary encoded flags for this data (see external documentation)
    // int flags
    test('to test the property `flags`', () async {
      // TODO
    });

    // A reference to a country, where the custodion is in
    // String idcountry
    test('to test the property `idcountry`', () async {
      // TODO
    });

    // A longer more descriptive description of this data
    // String name
    test('to test the property `name`', () async {
      // TODO
    });

    // A unique short name for this data
    // String shortcode
    test('to test the property `shortcode`', () async {
      // TODO
    });
  });
}
