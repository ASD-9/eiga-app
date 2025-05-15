import 'package:dio/dio.dart';
import 'package:eiga/models/category_model.dart';
import 'package:eiga/utils/error_handler.dart';

class CategoriesService {
  final Dio _dio;

  CategoriesService(this._dio);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      return (response.data as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ErrorHandler.getErrorMessage(e);
    }
  }
}
