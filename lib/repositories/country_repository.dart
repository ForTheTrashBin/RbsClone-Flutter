import 'package:openapi/openapi.dart';

class CountryRepository {
  CountryRepository();

  final Openapi _api = Openapi();

  Future<List<CountryListItem>> fetchCountries() async {
    final response = await _api.getCountryApi().getCountries();
    return response.data?.toList() ?? const <CountryListItem>[];
  }

  Future<void> createCountry(CountryNoPK country) async {
    await _api.getCountryApi().createCountry(countryNoPK: country);
  }

  Future<void> updateCountry(String id, CountryNoPK country) async {
    await _api.getCountryApi().updateCountry(id: id, countryNoPK: country);
  }

  Future<void> deleteCountry(String id) async {
    await _api.getCountryApi().deleteCountry(id: id);
  }
}
