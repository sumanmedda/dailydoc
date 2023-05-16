import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class API {
  final Dio _dio = Dio();

  API() {
    _dio.options.baseUrl = 'https://dd-chat-0.onrender.com/api/conversations';
    _dio.interceptors.add(PrettyDioLogger());
  }

  Dio get sendReq => _dio;
}
