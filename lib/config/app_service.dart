import 'package:dio/dio.dart';
import 'package:flutter_webviewku/config/dio_config.dart';

class AppService {
  String? baseUrl;
  AppService(this.baseUrl);

  Future<Response>? login({FormData? data}) {
    if (data != null) {
      return DioConfig.addInterceptor(
              dio: DioConfig.createDio(baseUrl: baseUrl), isRequireAuth: false)
          ?.post("login", data: data);
    }
  }
}
