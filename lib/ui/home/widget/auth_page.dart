import 'package:flutter/material.dart';
import 'unlock_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Authenticate", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Icon(Icons.fingerprint, size: 100, color: Colors.blue[400]),
            const SizedBox(height: 10),
            const Text("Touch the fingerprint sensor"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UnlockPage()));
              },
              child: const Text("Simular Huella"),
            ),
            const SizedBox(height: 50),
            const Text("🔗 Connected"),
          ],
        ),
      ),
    );
  }
}
