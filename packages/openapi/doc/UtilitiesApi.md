# openapi.api.UtilitiesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://www.rbsclone.de:8443*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getHealth**](UtilitiesApi.md#gethealth) | **GET** /health | State of services and components (Health)
[**getPing**](UtilitiesApi.md#getping) | **GET** /ping | Connection-Test


# **getHealth**
> getHealth()

State of services and components (Health)

Check the state of services and components

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUtilitiesApi();

try {
    api.getHealth();
} on DioException catch (e) {
    print('Exception when calling UtilitiesApi->getHealth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPing**
> getPing()

Connection-Test

Test of the connection to this server

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUtilitiesApi();

try {
    api.getPing();
} on DioException catch (e) {
    print('Exception when calling UtilitiesApi->getPing: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

