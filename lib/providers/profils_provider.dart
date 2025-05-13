import 'package:eiga/models/profil_model.dart';
import 'package:eiga/services/profils_service.dart';
import 'package:flutter/material.dart';

class ProfilsProvider extends ChangeNotifier {
  final ProfilsService _profilsService;

  ProfilsProvider(this._profilsService);

  bool _isLoading = false;
  String? _error;

  int? _selectedProfilId;
  List<ProfilModel> _profils = [];

  bool get isLoading => _isLoading;
  String? get error => _error;

  int? get selectedProfilId => _selectedProfilId;
  ProfilModel? get selectedProfil =>
      _profils.firstWhere((e) => e.id == _selectedProfilId);
  List<ProfilModel> get profils => _profils;

  set selectedProfilId(int? profilId) {
    _selectedProfilId = profilId;
    notifyListeners();
  }

  Future<void> fetchProfils(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _profils = await _profilsService.getProfils(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
