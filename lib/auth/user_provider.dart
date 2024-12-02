import 'package:flutter/material.dart';

class UserModel {
  String email;
  String token;

  UserModel({required this.email, required this.token});
}

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  // Establecer el usuario
  void setUser(UserModel user) {
    _user = user;
    notifyListeners(); // Notifica a los widgets escuchando este cambio
  }

  // Limpiar el usuario (para cerrar sesión)
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
