import 'package:dio/dio.dart';
import 'package:eiga/models/profil_model.dart';
import 'package:eiga/utils/error_handler.dart';

class ProfilsService {
  final Dio _dio;

  ProfilsService(this._dio);

  Future<List<ProfilModel>> getProfils(int userId) async {
    try {
      final response = await _dio.get('/profils/user/$userId');
      return (response.data as List)
          .map((e) => ProfilModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ErrorHandler.getErrorMessage(e);
    }
  }
}
