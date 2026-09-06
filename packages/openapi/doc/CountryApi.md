# openapi.api.CountryApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://www.rbsclone.de:8443*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createCountry**](CountryApi.md#createcountry) | **POST** /country | Create a new country
[**deleteCountry**](CountryApi.md#deletecountry) | **DELETE** /country/{id} | Delete a single country based on the id supplied
[**getCountries**](CountryApi.md#getcountries) | **GET** /country | Get a list of all countries
[**getCountryById**](CountryApi.md#getcountrybyid) | **GET** /country/id/{id} | Get a single country based on the id supplied
[**getCountryByShortcode**](CountryApi.md#getcountrybyshortcode) | **GET** /country/shortcode/{shortcode} | Get a single country based on the shortcode supplied
[**updateCountry**](CountryApi.md#updatecountry) | **PUT** /country/{id} | Update an existing country based on the id supplied


# **createCountry**
> createCountry(countryNoPK)

Create a new country

Create a new country

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCountryApi();
final CountryNoPK countryNoPK = ; // CountryNoPK | 

try {
    api.createCountry(countryNoPK);
} on DioException catch (e) {
    print('Exception when calling CountryApi->createCountry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **countryNoPK** | [**CountryNoPK**](CountryNoPK.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteCountry**
> deleteCountry(id)

Delete a single country based on the id supplied

Delete a single country based on the id supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCountryApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | This is the unique identifier a this data

try {
    api.deleteCountry(id);
} on DioException catch (e) {
    print('Exception when calling CountryApi->deleteCountry: $e\n');
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

# **getCountries**
> BuiltList<CountryListItem> getCountries()

Get a list of all countries

Get a list of all countries

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCountryApi();

try {
    final response = api.getCountries();
    print(response);
} on DioException catch (e) {
    print('Exception when calling CountryApi->getCountries: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;CountryListItem&gt;**](CountryListItem.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCountryById**
> Country getCountryById(id)

Get a single country based on the id supplied

Get a single country based on the id supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCountryApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | This is the unique identifier a this data

try {
    final response = api.getCountryById(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CountryApi->getCountryById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| This is the unique identifier a this data | 

### Return type

[**Country**](Country.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCountryByShortcode**
> Country getCountryByShortcode(shortcode)

Get a single country based on the shortcode supplied

Get a single country based on the shortcode supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCountryApi();
final String shortcode = shortcode_example; // String | This is the unique identifier a this data

try {
    final response = api.getCountryByShortcode(shortcode);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CountryApi->getCountryByShortcode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **shortcode** | **String**| This is the unique identifier a this data | 

### Return type

[**Country**](Country.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateCountry**
> updateCountry(id, countryNoPK)

Update an existing country based on the id supplied

Update an existing country based on the id supplied

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCountryApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | This is the unique identifier a this data
final CountryNoPK countryNoPK = ; // CountryNoPK | 

try {
    api.updateCountry(id, countryNoPK);
} on DioException catch (e) {
    print('Exception when calling CountryApi->updateCountry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| This is the unique identifier a this data | 
 **countryNoPK** | [**CountryNoPK**](CountryNoPK.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

