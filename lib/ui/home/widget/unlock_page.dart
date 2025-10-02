import 'package:flutter/material.dart';
import 'login_page.dart';
import 'history_page.dart';
import 'settings_page.dart';

class UnlockPage extends StatelessWidget {
  const UnlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black54),
            tooltip: 'Historial',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54),
            tooltip: 'Configuración',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Smart Lock",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[400],
              child: const Icon(Icons.lock_open, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(minimumSize: const Size(150, 50)),
              child: const Text("Open"),
            ),
            const SizedBox(height: 50),
            const Text("🔗 Connected"),
            const SizedBox(height: 20),
            TextButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Cerrar Sesión"),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
