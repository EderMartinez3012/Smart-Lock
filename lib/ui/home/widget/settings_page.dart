import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("Manage Users"),
            onTap: () {
              // Acción cuando se toca la opción
            },
          ),
          ListTile(
            leading: const Icon(Icons.vpn_key_outlined),
            title: const Text("Access Method"),
            onTap: () {
              // Acción
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_none),
            title: const Text("Notifications"),
            value: notificationsEnabled,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text("Lock Test"),
            onTap: () {
              // Acción
            },
          ),
        ],
      ),
    );
  }
}
