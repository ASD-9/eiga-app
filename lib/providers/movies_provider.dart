import 'package:eiga/models/movie_model.dart';
import 'package:eiga/services/movies_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Logger logger = Logger(printer: PrettyPrinter());

class MoviesProvider extends ChangeNotifier {
  final MoviesService _moviesService;

  MoviesProvider(this._moviesService);

  bool _isLoading = false;
  String? _error;
  bool _sagaIsLoading = false;
  String? _sagaError;
  bool _favoritesIsLoading = false;
  String? _favoritesError;
  bool _randomIsLoading = false;
  String? _randomError;

  final Map<int, MovieModel> _movies = {};
  final List<int> _favoriteMovies = [];
  final List<int> _sagasMovies = [];
  final List<int> _randomMovies = [];

  int? _selectedMovie;
  final List<int> _selectedMoviesHistory = [];
  int? _focusedMovie;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get sagaIsLoading => _sagaIsLoading;
  String? get sagaError => _sagaError;
  bool get favoritesIsLoading => _favoritesIsLoading;
  String? get favoritesError => _favoritesError;
  bool get randomIsLoading => _randomIsLoading;
  String? get randomError => _randomError;

  List<MovieModel> get sagasMovies =>
      _sagasMovies.map((id) => _movies[id]!).toList();
  List<MovieModel> get favoriteMovies =>
      _favoriteMovies.map((id) => _movies[id]!).toList();
  List<MovieModel> get randomMovies =>
      _randomMovies.map((id) => _movies[id]!).toList();

  MovieModel? get selectedMovie => _movies[_selectedMovie];
  List<int> get selectedMoviesHistory => _selectedMoviesHistory;
  MovieModel? get focusedMovie => _movies[_focusedMovie];

  bool isInFavorites(int id) => _favoriteMovies.contains(id);

  void setFocusedMovie(int? id) {
    _focusedMovie = id;
    notifyListeners();
  }

  void clearSelectedMovie({bool mustAddToHistory = false}) {
    if (mustAddToHistory) _selectedMoviesHistory.add(_selectedMovie!);
    _selectedMovie = null;
    _sagasMovies.clear();
    _focusedMovie = null;
    _isLoading = false;
    _error = null;
    _sagaIsLoading = false;
    _sagaError = null;
    notifyListeners();
  }

  Future<void> fetchMovie(int id) async {
    _isLoading = true;
    _error = null;
    _focusedMovie = null;
    _selectedMovie = id;
    notifyListeners();
    if (_movies.containsKey(id) && _movies[id]!.isComplete) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    try {
      final MovieModel movie = await _moviesService.getMovie(id);
      _movies[id] = movie;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoviesBySaga() async {
    _sagaIsLoading = true;
    _sagaError = null;
    notifyListeners();
    if (_sagasMovies.isNotEmpty) {
      _sagaIsLoading = false;
      notifyListeners();
      return;
    }
    try {
      final List<MovieModel> movies = await _moviesService.getMoviesBySaga(
        selectedMovie!.saga!.id,
      );
      for (var movie in movies) {
        if (!_movies.containsKey(movie.id)) _movies[movie.id] = movie;
        if (movie.id != _selectedMovie) _sagasMovies.add(movie.id);
      }
    } catch (e) {
      _sagaError = e.toString();
    } finally {
      _sagaIsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFavorites(int profilId) async {
    _favoritesIsLoading = true;
    _favoritesError = null;
    notifyListeners();
    try {
      final List<MovieModel> movies = await _moviesService.getMoviesByProfil(
        profilId,
      );
      for (var movie in movies) {
        if (!_movies.containsKey(movie.id)) _movies[movie.id] = movie;
        _favoriteMovies.add(movie.id);
      }
    } catch (e) {
      _favoritesError = e.toString();
    } finally {
      _favoritesIsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRandomMovies() async {
    _randomIsLoading = true;
    _randomError = null;
    notifyListeners();
    if (_randomMovies.isNotEmpty) {
      _randomIsLoading = false;
      notifyListeners();
      return;
    }
    try {
      final List<MovieModel> movies = await _moviesService.getRandomMovies();
      for (var movie in movies) {
        if (!_movies.containsKey(movie.id)) _movies[movie.id] = movie;
        _randomMovies.add(movie.id);
      }
    } catch (e) {
      _randomError = e.toString();
    } finally {
      _randomIsLoading = false;
      notifyListeners();
    }
  }
}
