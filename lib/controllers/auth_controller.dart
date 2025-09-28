import '../models/user_model.dart';

class AuthController {
  UserModel? _user;

  // Usuario de prueba por defecto
  AuthController() {
    _user = UserModel(
      name: "Usuario de Prueba",
      email: "test@correo.com",
      password: "123456",
    );
  }

  void register(String name, String email, String password) {
    _user = UserModel(name: name, email: email, password: password);
    print("Usuario registrado: ${_user!.email}");
  }

  bool login(String email, String password) {
    if (_user != null && _user!.email == email && _user!.password == password) {
      print("Inicio de sesión exitoso");
      return true;
    }
    print("Error de inicio de sesión: credenciales incorrectas");
    return false;
  }
}

