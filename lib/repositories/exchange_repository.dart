import 'package:openapi/openapi.dart';

class ExchangeRepository {
  ExchangeRepository();

  final Openapi _api = Openapi();

  Future<List<ExchangeListItem>> fetchExchanges() async {
    final response = await _api.getExchangeApi().getExchanges();
    return response.data?.toList() ?? const <ExchangeListItem>[];
  }

  Future<void> createExchange(ExchangeNoPK exchange) async {
    await _api.getExchangeApi().createExchange(exchangeNoPK: exchange);
  }

  Future<void> updateExchange(String id, ExchangeNoPK exchange) async {
    await _api.getExchangeApi().updateExchange(id: id, exchangeNoPK: exchange);
  }

  Future<void> deleteExchange(String id) async {
    await _api.getExchangeApi().deleteExchange(id: id);
  }
}
