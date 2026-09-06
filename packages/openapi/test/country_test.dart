import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for Country
void main() {
  final instance = CountryBuilder();
  // TODO add properties to the builder and call build()

  group(Country, () {
    // Some binary encoded flags for this data (see external documentation)
    // int flags
    test('to test the property `flags`', () async {
      // TODO
    });

    // The exact length of the IBAN required in that country
    // int ibanlenth
    test('to test the property `ibanlenth`', () async {
      // TODO
    });

    // This is the unique identifier a this data
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // A longer more descriptive description of this data
    // String name
    test('to test the property `name`', () async {
      // TODO
    });

    // This risk profile of this country
    // int risktype
    test('to test the property `risktype`', () async {
      // TODO
    });

    // A unique short name for this data
    // String shortcode
    test('to test the property `shortcode`', () async {
      // TODO
    });
  });
}
