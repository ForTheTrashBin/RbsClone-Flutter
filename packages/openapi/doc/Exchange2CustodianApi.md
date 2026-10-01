# openapi.api.Exchange2CustodianApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://www.rbsclone.de:8443*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getExchange2CustodianByIdcustodian**](Exchange2CustodianApi.md#getexchange2custodianbyidcustodian) | **GET** /exchange2custodian/idcustodian/{idcustodian} | Get a list of all mappings by idcustodian supplied


# **getExchange2CustodianByIdcustodian**
> BuiltList<Exchange2Custodian> getExchange2CustodianByIdcustodian(idcustodian)

Get a list of all mappings by idcustodian supplied

Get a list of all mappings by idcustodian supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getExchange2CustodianApi();
final String idcustodian = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | This is one of the two parts of the unique identifier of this data

try {
    final response = api.getExchange2CustodianByIdcustodian(idcustodian);
    print(response);
} on DioException catch (e) {
    print('Exception when calling Exchange2CustodianApi->getExchange2CustodianByIdcustodian: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idcustodian** | **String**| This is one of the two parts of the unique identifier of this data | 

### Return type

[**BuiltList&lt;Exchange2Custodian&gt;**](Exchange2Custodian.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

