import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class DioConfig {
  static Dio createDio({String? baseUrl}) {
    Dio dio = Dio(BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000,
      baseUrl: baseUrl ?? "",
    ));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Accept'] = 'Application/json';
    return dio;
  }

  static Dio? addInterceptor({
    Dio? dio,
    bool? isRequireAuth,
  }) {
    if (dio != null) {
      return dio
        ..interceptors.add(InterceptorsWrapper(
            onError: (DioError dioError, handler) => errorInterceptor(dioError),
            onRequest: (RequestOptions options, handler) =>
                requestInterceptor(options, handler, isRequireAuth),
            onResponse: (Response response, handler) =>
                responseInterceptor(response)));
    }
  }

  static dynamic requestInterceptor(RequestOptions? options,
      RequestInterceptorHandler? handler, bool? isRequireAuth) async {
    options?.responseType = ResponseType.json;

    if (isRequireAuth ?? false) {
      // options.headers['Authorization'] = "key=${AppConfig.fcmKey}";
      // options.headers['Content-Type'] = "application/json";
    }
    return options;
    // return requestInterceptor(options, handler, isRequireAuth);
  }

  static dynamic responseInterceptor(Response response) async {
    if (response.headers.value("verifyToken") != null) {
      // SharedPreferences pref = await SharedPreferences.getInstance();
      // var verifyToken = pref.get("verifyToken");

      // if (response.headers.value("verifyToken") == verifyToken) {
        return response;
      // }
    }
    // return responseInterceptor(response);
  }

  static dynamic errorInterceptor(DioError? error) async {
    var message = error?.message;
    if (error?.response != null) {
      if (error?.response?.statusCode == 401) {
        message = "Session Expired";
        // RoutesConfig.goOffAll(page: LoginPage());
        // PrefHelper.logout();
      } else {
        message = error?.response?.statusMessage;
      }
    } else {
      if (error != null) {
        if (error.message.toLowerCase().contains("failed host lookup")) {
          message = "No Internet Connection";
        } else {
          message = "Connection server error, please try again";
        }
      }
    }
    return message;
  }
}
