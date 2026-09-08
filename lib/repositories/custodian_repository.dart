import 'package:openapi/openapi.dart';

class CustodianRepository {
  CustodianRepository();

  final Openapi _api = Openapi();

  Future<List<CustodianListItem>> fetchCustodians() async {
    final response = await _api.getCustodianApi().getCustodians();
    return response.data?.toList() ?? const <CustodianListItem>[];
  }

  Future<void> createCustodian(CustodianNoPK custodian) async {
    await _api.getCustodianApi().createCustodian(custodianNoPK: custodian);
  }

  Future<void> updateCustodian(String id, CustodianNoPK custodian) async {
    await _api.getCustodianApi().updateCustodian(
      id: id,
      custodianNoPK: custodian,
    );
  }

  Future<void> deleteCustodian(String id) async {
    await _api.getCustodianApi().deleteCustodian(id: id);
  }
}
