import 'package:eiga/models/category_model.dart';
import 'package:eiga/services/categories_service.dart';
import 'package:flutter/material.dart';

class CategoriesProvider extends ChangeNotifier {
  final CategoriesService _categoriesService;

  CategoriesProvider(this._categoriesService);

  bool _isLoading = false;
  String? _error;
  List<CategoryModel> _categories = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<CategoryModel> get categories => _categories;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _categories = await _categoriesService.getCategories();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
