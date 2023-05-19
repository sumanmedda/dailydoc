import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class API {
  final Dio _dio = Dio(); // _dio is used for fetching data from apis

  API() {
    _dio.options.baseUrl =
        'https://dd-chat-0.onrender.com/api/conversations'; // url used to fetch data
    _dio.interceptors.add(PrettyDioLogger()); // to print response of api on log
  }

  Dio get sendReq =>
      _dio; // _dio is set as getter to be used in the repositories
}
