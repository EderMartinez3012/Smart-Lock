import 'package:flutter/material.dart';
import 'users_manager_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool autoLockEnabled = true;
  bool soundEnabled = true;
  String selectedAccessMethod = 'Huella Digital';
  int autoLockDuration = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Configuración',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A8A), Color(0xFFF8FAFC)],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSettingsCard(
                title: 'Usuarios y Acceso',
                children: [
                  _buildListTile(
                    icon: Icons.person_outline,
                    title: 'Gestionar Usuarios',
                    subtitle: 'Agregar o eliminar usuarios autorizados',
                    onTap: _showManageUsersDialog,
                  ),
                  _buildListTile(
                    icon: Icons.fingerprint,
                    title: 'Configuración de Huella',
                    subtitle: 'Configurar acceso biométrico',
                    onTap: _showFingerprintDialog,
                  ),
                  _buildListTile(
                    icon: Icons.vpn_key_outlined,
                    title: 'Método de Acceso',
                    subtitle: selectedAccessMethod,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: _showAccessMethodDialog,
                  ),
                ],
              ),

              _buildSettingsCard(
                title: 'Notificaciones y Sonidos',
                children: [
                  _buildSwitchTile(
                    icon: Icons.notifications_none,
                    title: 'Notificaciones',
                    subtitle: 'Recibir alertas de acceso',
                    value: notificationsEnabled,
                    onChanged: (value) {
                      setState(() => notificationsEnabled = value);
                      _showSnackBar(
                        'Notificaciones ${value ? 'activadas' : 'desactivadas'}',
                      );
                    },
                  ),
                  _buildSwitchTile(
                    icon: Icons.volume_up_outlined,
                    title: 'Efectos de Sonido',
                    subtitle: 'Reproducir sonidos al bloquear/desbloquear',
                    value: soundEnabled,
                    onChanged: (value) => setState(() => soundEnabled = value),
                  ),
                ],
              ),

              _buildSettingsCard(
                title: 'Seguridad',
                children: [
                  _buildSwitchTile(
                    icon: Icons.lock_clock,
                    title: 'Auto-Bloqueo',
                    subtitle: 'Después de $autoLockDuration segundos',
                    value: autoLockEnabled,
                    onChanged: (value) =>
                        setState(() => autoLockEnabled = value),
                  ),
                  if (autoLockEnabled)
                    Slider(
                      value: autoLockDuration.toDouble(),
                      min: 10,
                      max: 120,
                      divisions: 11,
                      label: '$autoLockDuration s',
                      activeColor: const Color(0xFF3B82F6),
                      onChanged: (value) =>
                          setState(() => autoLockDuration = value.round()),
                    ),
                  _buildListTile(
                    icon: Icons.lock_outline,
                    title: 'Probar Cerradura',
                    subtitle: 'Verificar tu conexión Smart Lock',
                    onTap: _testLockConnection,
                  ),
                  _buildListTile(
                    icon: Icons.security,
                    title: 'Cambiar PIN',
                    subtitle: 'Actualizar tu código PIN de respaldo',
                    onTap: _showChangePINDialog,
                  ),
                ],
              ),

              _buildSettingsCard(
                title: 'General',
                children: [
                  _buildListTile(
                    icon: Icons.wifi,
                    title: 'Configuración de Red',
                    subtitle: 'Configurar conexión WiFi',
                    onTap: _showNetworkDialog,
                  ),
                  _buildListTile(
                    icon: Icons.info_outline,
                    title: 'Acerca de',
                    subtitle: 'Versión 1.0.0',
                    onTap: _showAboutDialog,
                  ),
                  _buildListTile(
                    icon: Icons.help_outline,
                    title: 'Ayuda y Soporte',
                    subtitle: 'Obtén ayuda con tu Smart Lock',
                    onTap: _showHelpDialog,
                  ),
                ],
              ),

              const SizedBox(height: 20),
              OutlinedButton.icon(
                icon: const Icon(Icons.restore, color: Colors.red),
                label: const Text(
                  'Restablecer Configuración',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _showResetDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.withOpacity(0.1),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Colors.grey.shade600))
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: CircleAvatar(
        backgroundColor: Colors.blue.withOpacity(0.1),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Colors.grey.shade600))
          : null,
      activeColor: const Color(0xFF3B82F6),
      value: value,
      onChanged: onChanged,
    );
  }

  // Métodos funcionales (igual que en tu versión previa)
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _showManageUsersDialog() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const UsersManagerPage()),
  );
  void _showAccessMethodDialog() {}
  void _showFingerprintDialog() {}
  void _testLockConnection() {}
  void _showChangePINDialog() {}
  void _showNetworkDialog() {}
  void _showAboutDialog() {}
  void _showHelpDialog() {}
  void _showResetDialog() {}
}
