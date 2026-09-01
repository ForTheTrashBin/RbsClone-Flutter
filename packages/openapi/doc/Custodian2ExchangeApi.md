# openapi.api.Custodian2ExchangeApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://www.rbsclone.de:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getCustodian2ExchangeByIdCustodian**](Custodian2ExchangeApi.md#getcustodian2exchangebyidcustodian) | **GET** /custodian2exchange/idcustodian/{idcustodian} | Get a list of all mappings by idcustodian supplied
[**getCustodian2ExchangeByIdExchange**](Custodian2ExchangeApi.md#getcustodian2exchangebyidexchange) | **GET** /custodian2exchange/idexchange/{idexchange} | Get a list of mappings by idexchange supplied
[**mapCustodians2Exchange**](Custodian2ExchangeApi.md#mapcustodians2exchange) | **POST** /custodian2exchange/{idexchange} | Modify the mapping of multiple custodians to a single exchange
[**mapExchanges2Custodian**](Custodian2ExchangeApi.md#mapexchanges2custodian) | **POST** /exchange2custodian/{idcustodian} | Modify the mapping of multiple exchanges to a single custodian


# **getCustodian2ExchangeByIdCustodian**
> BuiltList<Custodian2Exchange> getCustodian2ExchangeByIdCustodian(idcustodian)

Get a list of all mappings by idcustodian supplied

Get a list of all mappings by idcustodian supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCustodian2ExchangeApi();
final String idcustodian = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | This is one of the two parts of the unique identifier of this data

try {
    final response = api.getCustodian2ExchangeByIdCustodian(idcustodian);
    print(response);
} on DioException catch (e) {
    print('Exception when calling Custodian2ExchangeApi->getCustodian2ExchangeByIdCustodian: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idcustodian** | **String**| This is one of the two parts of the unique identifier of this data | 

### Return type

[**BuiltList&lt;Custodian2Exchange&gt;**](Custodian2Exchange.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCustodian2ExchangeByIdExchange**
> BuiltList<Custodian2Exchange> getCustodian2ExchangeByIdExchange(idexchange)

Get a list of mappings by idexchange supplied

Get a list of mappings by idexchange supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCustodian2ExchangeApi();
final String idexchange = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | This is one of the two parts of the unique identifier of this data

try {
    final response = api.getCustodian2ExchangeByIdExchange(idexchange);
    print(response);
} on DioException catch (e) {
    print('Exception when calling Custodian2ExchangeApi->getCustodian2ExchangeByIdExchange: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idexchange** | **String**| This is one of the two parts of the unique identifier of this data | 

### Return type

[**BuiltList&lt;Custodian2Exchange&gt;**](Custodian2Exchange.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mapCustodians2Exchange**
> mapCustodians2Exchange(idexchange, mapCustodian2Exchange)

Modify the mapping of multiple custodians to a single exchange

Modify the mapping of multiple custodians to a single exchange

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCustodian2ExchangeApi();
final String idexchange = idexchange_example; // String | This is one of the two parts of the unique identifier of this data
final BuiltList<MapCustodian2Exchange> mapCustodian2Exchange = ; // BuiltList<MapCustodian2Exchange> | 

try {
    api.mapCustodians2Exchange(idexchange, mapCustodian2Exchange);
} on DioException catch (e) {
    print('Exception when calling Custodian2ExchangeApi->mapCustodians2Exchange: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idexchange** | **String**| This is one of the two parts of the unique identifier of this data | 
 **mapCustodian2Exchange** | [**BuiltList&lt;MapCustodian2Exchange&gt;**](MapCustodian2Exchange.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mapExchanges2Custodian**
> mapExchanges2Custodian(idcustodian, mapExchange2Custodian)

Modify the mapping of multiple exchanges to a single custodian

Modify the mapping of multiple exchanges to a single custodian

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCustodian2ExchangeApi();
final String idcustodian = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | This is one of the two parts of the unique identifier of this data
final BuiltList<MapExchange2Custodian> mapExchange2Custodian = ; // BuiltList<MapExchange2Custodian> | 

try {
    api.mapExchanges2Custodian(idcustodian, mapExchange2Custodian);
} on DioException catch (e) {
    print('Exception when calling Custodian2ExchangeApi->mapExchanges2Custodian: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idcustodian** | **String**| This is one of the two parts of the unique identifier of this data | 
 **mapExchange2Custodian** | [**BuiltList&lt;MapExchange2Custodian&gt;**](MapExchange2Custodian.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

