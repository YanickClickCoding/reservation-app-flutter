import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialiser l'authentification au démarrage de l'application
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      
      if (userJson != null) {
        _user = User.fromJson(userJson as Map<String, dynamic>);
        _isAuthenticated = true;
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation de l\'authentification: $e');
      _error = 'Impossible de charger les informations de l\'utilisateur';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Se connecter avec email et mot de passe
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulation d'une requête API
      await Future.delayed(const Duration(seconds: 1));
      
      // En production, remplacez ceci par un appel API réel
      if (email == 'test@example.com' && password == 'password') {
        final user = User(
          id: '1',
          name: 'Utilisateur Test',
          email: email,
          phone: '+33 6 12 34 56 78',
          memberSince: DateTime.now(),
        );
        
        await _saveUser(user);
        _user = user;
        _isAuthenticated = true;
        _error = null;
        return true;
      } else {
        _error = 'Email ou mot de passe incorrect';
        return false;
      }
    } catch (e) {
      _error = 'Une erreur est survenue lors de la connexion';
      debugPrint('Erreur de connexion: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // S'inscrire avec email et mot de passe
  Future<bool> register(String name, String email, String password, String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulation d'une requête API
      await Future.delayed(const Duration(seconds: 1));
      
      // En production, vérifiez si l'email est déjà utilisé via une API
      
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
        memberSince: DateTime.now(),
      );
      
      await _saveUser(user);
      _user = user;
      _isAuthenticated = true;
      _error = null;
      return true;
    } catch (e) {
      _error = 'Une erreur est survenue lors de l\'inscription';
      debugPrint('Erreur d\'inscription: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Se déconnecter
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      
      _user = null;
      _isAuthenticated = false;
      _error = null;
    } catch (e) {
      _error = 'Une erreur est survenue lors de la déconnexion';
      debugPrint('Erreur de déconnexion: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mettre à jour le profil utilisateur
  Future<bool> updateProfile(User updatedUser) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulation d'une requête API
      await Future.delayed(const Duration(seconds: 1));
      
      await _saveUser(updatedUser);
      _user = updatedUser;
      return true;
    } catch (e) {
      _error = 'Impossible de mettre à jour le profil';
      debugPrint('Erreur de mise à jour du profil: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode utilitaire pour enregistrer l'utilisateur dans le stockage local
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user.toJson().toString());
  }

  // Effacer les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
