import 'package:dio/dio.dart';

import '../util/Constants.dart';


Dio dio() {
  Dio dio = new Dio();

  dio.options.baseUrl = Constants.BASE_URL;

  dio.options.headers['accept'] = "applications/json";

  return dio;
}