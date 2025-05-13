import 'package:dio/dio.dart';
import 'package:eiga/models/movie_model.dart';
import 'package:eiga/utils/error_handler.dart';
import 'package:logger/logger.dart';

Logger logger = Logger(printer: PrettyPrinter());

class MoviesService {
  final Dio _dio;

  MoviesService(this._dio);

  Future<MovieModel> getMovie(int id) async {
    try {
      final response = await _dio.get('/movies/$id');
      return MovieModel.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.getErrorMessage(e);
    }
  }

  Future<List<MovieModel>> getMoviesBySaga(int sagaId) async {
    try {
      final response = await _dio.get('/movies/saga/$sagaId');
      return (response.data as List).map((e) => MovieModel.fromJson(e)).toList();
    } catch (e) {
      throw ErrorHandler.getErrorMessage(e);
    }
  }
}
