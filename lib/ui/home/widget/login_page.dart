import 'package:flutter/material.dart';
import '../../../../controllers/auth_controller.dart';
import 'auth_page.dart';
import 'register_page.dart';

const Color primaryColor = Colors.white;
const Color accentColor = Color(0xFF1E88E5);
const Color textColor = Colors.black87;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(text: "test@correo.com");
  final passController = TextEditingController(text: "123456");
  final AuthController authController = AuthController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        filled: true, // Fondo muy sutil para el campo
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ), // Borde enfocado (azul para cuando el usuario está escribiendo)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: accentColor, width: 2.0),
        ), // Borde habilitado
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Smart Lock",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 50),
              _buildTextField(
                controller: emailController,
                labelText: "Correo electrónico",
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: passController,
                labelText: "Contraseña",
                obscureText: true,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  bool success = authController.login(
                    emailController.text,
                    passController.text,
                  );
                  if (success) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Credenciales incorrectas"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 55),
                ),
                child: const Text(
                  "Iniciar sesión",
                  style: TextStyle(
                    fontSize: 18,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "¿Olvidaste tu contraseña?",
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: Text(
                  "Crear cuenta",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
