# openapi.api.CustodianApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://www.rbsclone.de:8443*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createCustodian**](CustodianApi.md#createcustodian) | **POST** /custodian | Create a new custodian
[**deleteCustodian**](CustodianApi.md#deletecustodian) | **DELETE** /custodian/{id} | Delete a single custodian based on the id supplied
[**getCustodianById**](CustodianApi.md#getcustodianbyid) | **GET** /custodian/id/{id} | Get a single custodian based on the id supplied
[**getCustodianByShortcode**](CustodianApi.md#getcustodianbyshortcode) | **GET** /custodian/shortcode/{shortcode} | Get a single custodian based on the shortcode supplied
[**getCustodians**](CustodianApi.md#getcustodians) | **GET** /custodian | Get a list of all custodians
[**updateCustodian**](CustodianApi.md#updatecustodian) | **PUT** /custodian/{id} | Update an existing custodian based on the id supplied


# **createCustodian**
> createCustodian(custodianNoPK)

Create a new custodian

Create a new custodian

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCustodianApi();
final CustodianNoPK custodianNoPK = ; // CustodianNoPK | 

try {
    api.createCustodian(custodianNoPK);
} on DioException catch (e) {
    print('Exception when calling CustodianApi->createCustodian: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **custodianNoPK** | [**CustodianNoPK**](CustodianNoPK.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteCustodian**
> deleteCustodian(id)

Delete a single custodian based on the id supplied

Delete a single custodian based on the id supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCustodianApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | This is the unique identifier a this data

try {
    api.deleteCustodian(id);
} on DioException catch (e) {
    print('Exception when calling CustodianApi->deleteCustodian: $e\n');
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

# **getCustodianById**
> Custodian getCustodianById(id)

Get a single custodian based on the id supplied

Get a single custodian based on the id supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCustodianApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | This is the unique identifier a this data

try {
    final response = api.getCustodianById(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CustodianApi->getCustodianById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| This is the unique identifier a this data | 

### Return type

[**Custodian**](Custodian.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCustodianByShortcode**
> Custodian getCustodianByShortcode(shortcode)

Get a single custodian based on the shortcode supplied

Get a single custodian based on the shortcode supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCustodianApi();
final String shortcode = shortcode_example; // String | This is the unique identifier a this data

try {
    final response = api.getCustodianByShortcode(shortcode);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CustodianApi->getCustodianByShortcode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **shortcode** | **String**| This is the unique identifier a this data | 

### Return type

[**Custodian**](Custodian.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCustodians**
> BuiltList<CustodianListItem> getCustodians()

Get a list of all custodians

Get a list of all custodians

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCustodianApi();

try {
    final response = api.getCustodians();
    print(response);
} on DioException catch (e) {
    print('Exception when calling CustodianApi->getCustodians: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;CustodianListItem&gt;**](CustodianListItem.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateCustodian**
> updateCustodian(id, custodianNoPK)

Update an existing custodian based on the id supplied

Update an existing custodian based on the id supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCustodianApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | This is the unique identifier a this data
final CustodianNoPK custodianNoPK = ; // CustodianNoPK | 

try {
    api.updateCustodian(id, custodianNoPK);
} on DioException catch (e) {
    print('Exception when calling CustodianApi->updateCustodian: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| This is the unique identifier a this data | 
 **custodianNoPK** | [**CustodianNoPK**](CustodianNoPK.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

