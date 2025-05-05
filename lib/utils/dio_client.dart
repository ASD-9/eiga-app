import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  static Dio get dio => _dio;
}
