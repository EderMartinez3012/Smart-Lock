import 'package:flutter/material.dart';
import '../../../../controllers/auth_controller.dart';
import 'login_page.dart';

const Color primaryColor = Colors.white;
const Color accentColor = Color(0xFF1E88E5);
const Color textColor = Colors.black87;

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
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
        ), // Borde habilitado (para que se vea siempre el borde gris sutil)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passController = TextEditingController();
    final AuthController authController = AuthController();

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text("Registro", style: TextStyle(color: textColor)),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: textColor),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.shade50,
                child: Icon(Icons.person, size: 50, color: accentColor),
              ),
              const SizedBox(height: 20),
              Text(
                "Crear cuenta",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField(
                controller: nameController,
                labelText: "Nombre completo",
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: emailController,
                labelText: "Correo electrónico",
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: passController,
                labelText: "Contraseña",
                obscureText: true,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  authController.register(
                    nameController.text,
                    emailController.text,
                    passController.text,
                  );
                  Navigator.pushReplacement(
                    // Mejor usar Replacement aquí
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
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
                  "Registrarse",
                  style: TextStyle(
                    fontSize: 18,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "¿Ya tienes cuenta? Inicia sesión",
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
