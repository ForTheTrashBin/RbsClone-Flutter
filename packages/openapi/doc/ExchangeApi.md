# openapi.api.ExchangeApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://www.rbsclone.de:8443*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createExchange**](ExchangeApi.md#createexchange) | **POST** /exchange | Create a new exchange
[**deleteExchange**](ExchangeApi.md#deleteexchange) | **DELETE** /exchange/{id} | Delete a single exchange based on the id supplied
[**getExchangeById**](ExchangeApi.md#getexchangebyid) | **GET** /exchange/id/{id} | Get a single exchange based on the id supplied
[**getExchangeByShortcode**](ExchangeApi.md#getexchangebyshortcode) | **GET** /exchange/shortcode/{shortcode} | Get a single exchange based on the shortcode supplied
[**getExchanges**](ExchangeApi.md#getexchanges) | **GET** /exchange | Get a list of all exchanges
[**updateExchange**](ExchangeApi.md#updateexchange) | **PUT** /exchange/{id} | Update an existing exchange based on the id supplied


# **createExchange**
> createExchange(exchangeNoPK)

Create a new exchange

Create a new exchange

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getExchangeApi();
final ExchangeNoPK exchangeNoPK = ; // ExchangeNoPK | 

try {
    api.createExchange(exchangeNoPK);
} on DioException catch (e) {
    print('Exception when calling ExchangeApi->createExchange: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **exchangeNoPK** | [**ExchangeNoPK**](ExchangeNoPK.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteExchange**
> deleteExchange(id)

Delete a single exchange based on the id supplied

Delete a single exchange based on the id supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getExchangeApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | This is the unique identifier a this data

try {
    api.deleteExchange(id);
} on DioException catch (e) {
    print('Exception when calling ExchangeApi->deleteExchange: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| This is the unique identifier a this data | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getExchangeById**
> Exchange getExchangeById(id)

Get a single exchange based on the id supplied

Get a single exchange based on the id supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getExchangeApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | This is the unique identifier a this data

try {
    final response = api.getExchangeById(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ExchangeApi->getExchangeById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| This is the unique identifier a this data | 

### Return type

[**Exchange**](Exchange.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getExchangeByShortcode**
> Exchange getExchangeByShortcode(shortcode)

Get a single exchange based on the shortcode supplied

Get a single exchange based on the shortcode supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getExchangeApi();
final String shortcode = shortcode_example; // String | This is the unique identifier a this data

try {
    final response = api.getExchangeByShortcode(shortcode);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ExchangeApi->getExchangeByShortcode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **shortcode** | **String**| This is the unique identifier a this data | 

### Return type

[**Exchange**](Exchange.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getExchanges**
> BuiltList<ExchangeListItem> getExchanges()

Get a list of all exchanges

Get a list of all exchanges

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getExchangeApi();

try {
    final response = api.getExchanges();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ExchangeApi->getExchanges: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;ExchangeListItem&gt;**](ExchangeListItem.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateExchange**
> updateExchange(id, exchangeNoPK)

Update an existing exchange based on the id supplied

Update an existing exchange based on the id supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getExchangeApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | This is the unique identifier a this data
final ExchangeNoPK exchangeNoPK = ; // ExchangeNoPK | 

try {
    api.updateExchange(id, exchangeNoPK);
} on DioException catch (e) {
    print('Exception when calling ExchangeApi->updateExchange: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| This is the unique identifier a this data | 
 **exchangeNoPK** | [**ExchangeNoPK**](ExchangeNoPK.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

