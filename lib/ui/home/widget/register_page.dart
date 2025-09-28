import 'package:flutter/material.dart';
import '../../../../controllers/auth_controller.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passController = TextEditingController();
    final AuthController authController = AuthController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 20),
              const Text("Crear cuenta",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nombre completo")),
              const SizedBox(height: 10),
              TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Correo electrónico")),
              const SizedBox(height: 10),
              TextField(
                  controller: passController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Contraseña")),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  authController.register(
                    nameController.text,
                    emailController.text,
                    passController.text,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50)),
                child: const Text("Registrarse"),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: const Text("¿Ya tienes cuenta? Inicia sesión",
                    style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
