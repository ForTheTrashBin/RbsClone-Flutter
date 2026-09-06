import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

/// tests for CountryApi
void main() {
  final instance = Openapi().getCountryApi();

  group(CountryApi, () {
    // Create a new country
    //
    // Create a new country
    //
    //Future createCountry(CountryNoPK countryNoPK) async
    test('test createCountry', () async {
      // TODO
    });

    // Delete a single country based on the id supplied
    //
    // Delete a single country based on the id supplied
    //
    //Future deleteCountry(String id) async
    test('test deleteCountry', () async {
      // TODO
    });

    // Get a list of all countries
    //
    // Get a list of all countries
    //
    //Future<BuiltList<CountryListItem>> getCountries() async
    test('test getCountries', () async {
      // TODO
    });

    // Get a single country based on the id supplied
    //
    // Get a single country based on the id supplied
    //
    //Future<Country> getCountryById(String id) async
    test('test getCountryById', () async {
      // TODO
    });

    // Get a single country based on the shortcode supplied
    //
    // Get a single country based on the shortcode supplied
    //
    //Future<Country> getCountryByShortcode(String shortcode) async
    test('test getCountryByShortcode', () async {
      // TODO
    });

    // Update an existing country based on the id supplied
    //
    // Update an existing country based on the id supplied
    //
    //Future updateCountry(String id, CountryNoPK countryNoPK) async
    test('test updateCountry', () async {
      // TODO
    });
  });
}
