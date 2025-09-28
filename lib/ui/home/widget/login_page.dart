import 'package:flutter/material.dart';
import '../../../../controllers/auth_controller.dart';
import 'auth_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(text: "test@correo.com"); // Datos por defecto
  final passController = TextEditingController(text: "123456");
  final AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.lock, size: 50),
              ),
              const SizedBox(height: 20),
              const Text("Smart Lock",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration:
                    const InputDecoration(labelText: "Correo electrónico"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
              ),
              const SizedBox(height: 20),
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
                    minimumSize: const Size(double.infinity, 50)),
                child: const Text("Iniciar sesión"),
              ),
              const SizedBox(height: 10),
              const Text("¿Olvidaste tu contraseña?",
                  style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}

