import 'package:flutter/material.dart';
import 'package:smartlock/models/lock_model.dart';
import 'package:smartlock/ui/home/widget/background_design.dart';
import 'login_page.dart';
import 'history_page.dart';
import 'settings_page.dart';
import 'users_manager_page.dart';

class UnlockPage extends StatefulWidget {
  final Lock lock;
  const UnlockPage({super.key, required this.lock});

  @override
  State<UnlockPage> createState() => _UnlockPageState();
}

class _UnlockPageState extends State<UnlockPage>
    with SingleTickerProviderStateMixin {
  bool isLocked = true;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleLock() {
    setState(() {
      isLocked = !isLocked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isLocked ? Icons.lock : Icons.lock_open, color: Colors.white),
            SizedBox(width: 12),
            Text(
              isLocked ? 'Cerradura Bloqueada' : 'Cerradura Abierta',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        backgroundColor: isLocked ? Colors.red.shade400 : Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModernGradientBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // AppBar personalizado
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildIconButton(
                          icon: Icons.arrow_back,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.lock.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.lock.location,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            _buildIconButton(
                              icon: Icons.history,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HistoryPage(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 8),
                            _buildIconButton(
                              icon: Icons.settings,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SettingsPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Estado de conexión
                          const ConnectionStatus(isConnected: true),

                          const SizedBox(height: 60),

                          // Botón principal de bloqueo/desbloqueo con animación
                          ScaleTransition(
                            scale: _pulseAnimation,
                            child: GestureDetector(
                              onTap: _toggleLock,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: isLocked
                                        ? [Color(0xFFEF4444), Color(0xFFDC2626)]
                                        : [
                                            Color(0xFF10B981),
                                            Color(0xFF059669),
                                          ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          (isLocked ? Colors.red : Colors.green)
                                              .withOpacity(0.4),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    isLocked ? Icons.lock : Icons.lock_open,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Texto de estado
                          Text(
                            isLocked ? 'BLOQUEADO' : 'DESBLOQUEADO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            isLocked
                                ? 'Toca para desbloquear'
                                : 'Toca para bloquear',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),

                          const SizedBox(height: 60),

                          // Tarjeta de accesos rápidos
                          GlassCard(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildQuickAction(
                                  icon: Icons.access_time,
                                  label: 'Temporizador',
                                  onTap: _showTimerDialog,
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                _buildQuickAction(
                                  icon: Icons.notifications_active,
                                  label: 'Alertas',
                                  onTap: _showAlertsDialog,
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                _buildQuickAction(
                                  icon: Icons.people,
                                  label: 'Usuarios',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const UsersManagerPage(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Botón de cerrar sesión
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: TextButton.icon(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          "CERRAR SESIÓN",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 1.5,
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Row(
                                children: [
                                  Icon(Icons.logout, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text('Cerrar Sesión'),
                                ],
                              ),
                              content: Text(
                                '¿Estás seguro de que deseas cerrar sesión?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: Text('Cerrar Sesión'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.access_time),
            SizedBox(width: 10),
            Text('Temporizador'),
          ],
        ),
        content: Text(
          'Esta función te permitirá programar bloqueos y desbloqueos automáticos. Próximamente disponible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showAlertsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.notifications_active),
            SizedBox(width: 10),
            Text('Alertas'),
          ],
        ),
        content: Text(
          'Aquí podrás configurar y ver las alertas de seguridad, como intentos de acceso fallidos. Próximamente disponible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
