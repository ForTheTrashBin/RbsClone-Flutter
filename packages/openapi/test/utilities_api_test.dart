import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

/// tests for UtilitiesApi
void main() {
  final instance = Openapi().getUtilitiesApi();

  group(UtilitiesApi, () {
    // State of services and components (Health)
    //
    // Check the state of services and components
    //
    //Future getHealth() async
    test('test getHealth', () async {
      // TODO
    });

    // Connection-Test
    //
    // Test of the connection to this server
    //
    //Future getPing() async
    test('test getPing', () async {
      // TODO
    });
  });
}
