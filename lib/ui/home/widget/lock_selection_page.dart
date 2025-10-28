import 'package:flutter/material.dart';
import 'package:smartlock/models/lock_model.dart';
import 'package:smartlock/ui/home/widget/background_design.dart';
import 'package:smartlock/ui/home/widget/unlock_page.dart';
import 'login_page.dart';

class LockSelectionPage extends StatefulWidget {
  const LockSelectionPage({super.key});

  @override
  State<LockSelectionPage> createState() => _LockSelectionPageState();
}

class _LockSelectionPageState extends State<LockSelectionPage> {
  // Lista de cerraduras de ejemplo. En una app real, esto vendría de una base de datos o API.
  final List<Lock> locks = [
    Lock(
      id: '1',
      name: 'Cerradura Principal',
      location: 'Puerta de Entrada',
      isConnected: true,
    ),
    Lock(
      id: '2',
      name: 'Oficina',
      location: 'Puerta del Despacho',
      isConnected: true,
    ),
    Lock(
      id: '3',
      name: 'Garaje',
      location: 'Puerta del Garaje',
      isConnected: false,
    ),
    Lock(
      id: '4',
      name: 'Patio Trasero',
      location: 'Puerta del Jardín',
      isConnected: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModernGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // AppBar personalizado
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Seleccionar Cerradura',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CircleIconButton(
                      icon: Icons.logout,
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Elige el dispositivo que quieres controlar.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: locks.length,
                  itemBuilder: (context, index) {
                    final lock = locks[index];
                    return _buildLockCard(lock);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockCard(Lock lock) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        leading: CircleAvatar(
          backgroundColor: lock.isConnected
              ? Colors.green.withOpacity(0.2)
              : Colors.red.withOpacity(0.2),
          child: Icon(
            Icons.lock_rounded,
            color: lock.isConnected ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          lock.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(lock.location),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              lock.isConnected ? 'Online' : 'Offline',
              style: TextStyle(
                color: lock.isConnected ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: () {
          if (lock.isConnected) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UnlockPage(lock: lock)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Esta cerradura no está conectada.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
      ),
    );
  }
}
