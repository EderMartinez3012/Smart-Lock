import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smartlock/models/guest_pass_model.dart';
import 'package:smartlock/ui/home/widget/background_design.dart';

class GuestAccessPage extends StatefulWidget {
  const GuestAccessPage({super.key});

  @override
  State<GuestAccessPage> createState() => _GuestAccessPageState();
}

class _GuestAccessPageState extends State<GuestAccessPage> {
  final List<GuestPass> _guestPasses = [
    GuestPass(
      id: '1',
      guestName: 'Servicio de Limpieza',
      code: '123456',
      expiryDate: DateTime.now().add(const Duration(hours: 3)),
    ),
    GuestPass(
      id: '2',
      guestName: 'Familiar Visitante',
      code: '987654',
      expiryDate: DateTime.now().add(const Duration(days: 2)),
    ),
  ];

  void _addGuestPass(String guestName, Duration validity) {
    final random = Random();
    final pin = (100000 + random.nextInt(900000)).toString();
    final newPass = GuestPass(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      guestName: guestName,
      code: pin,
      expiryDate: DateTime.now().add(validity),
    );

    setState(() {
      _guestPasses.add(newPass);
    });

    _showGeneratedPassDialog(newPass);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModernGradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Pases de Invitado',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  'Genera y gestiona accesos temporales para tus invitados.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),

              // Lista de pases
              Expanded(
                child: _guestPasses.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay pases de invitado activos.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _guestPasses.length,
                        itemBuilder: (context, index) {
                          final pass = _guestPasses[index];
                          return _buildGuestPassCard(pass);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showGeneratePassDialog,
        backgroundColor: accentPink,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Pase'),
      ),
    );
  }

  Widget _buildGuestPassCard(GuestPass pass) {
    final remaining = pass.expiryDate.difference(DateTime.now());
    final isExpired = remaining.isNegative;

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
          backgroundColor: isExpired
              ? Colors.grey.withOpacity(0.2)
              : accentPink.withOpacity(0.2),
          child: Icon(
            Icons.qr_code_scanner,
            color: isExpired ? Colors.grey : accentPink,
          ),
        ),
        title: Text(
          pass.guestName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          isExpired
              ? 'Expirado'
              : 'Expira en ${remaining.inHours}h ${remaining.inMinutes.remainder(60)}m',
          style: TextStyle(color: isExpired ? Colors.red : Colors.green),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            setState(() {
              _guestPasses.removeWhere((p) => p.id == pass.id);
            });
          },
        ),
      ),
    );
  }

  void _showGeneratePassDialog() {
    final guestNameController = TextEditingController();
    Duration selectedDuration = const Duration(hours: 1);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Generar Pase de Invitado'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: guestNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Invitado',
                      icon: Icon(Icons.person),
                    ),
                    onChanged: (value) => setDialogState(
                      () {},
                    ), // Actualiza el estado del diálogo para habilitar/deshabilitar el botón
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<Duration>(
                    value: selectedDuration,
                    decoration: const InputDecoration(
                      labelText: 'Validez del Pase',
                      icon: Icon(Icons.timer),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: Duration(hours: 1),
                        child: Text('1 Hora'),
                      ),
                      DropdownMenuItem(
                        value: Duration(hours: 8),
                        child: Text('8 Horas'),
                      ),
                      DropdownMenuItem(
                        value: Duration(days: 1),
                        child: Text('1 Día'),
                      ),
                      DropdownMenuItem(
                        value: Duration(days: 7),
                        child: Text('7 Días'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        selectedDuration = value;
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: guestNameController.text.trim().isEmpty
                      ? null
                      : () {
                          Navigator.pop(context);
                          _addGuestPass(
                            guestNameController.text,
                            selectedDuration,
                          );
                        },
                  child: const Text('Generar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showGeneratedPassDialog(GuestPass pass) {
    final qrData =
        'SMARTLOCK_GUEST_PASS_V1;${pass.code};${pass.expiryDate.toIso8601String()}';
    final shareText =
        '¡Hola ${pass.guestName}!\n\nAquí tienes tu acceso temporal para la cerradura inteligente:\n\n'
        'PIN: ${pass.code}\n'
        'Expira en: ${pass.expiryDate.day}/${pass.expiryDate.month}/${pass.expiryDate.year} a las ${pass.expiryDate.hour}:${pass.expiryDate.minute}\n\n'
        'También puedes usar el código QR adjunto.';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Pase para ${pass.guestName}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Usa el PIN o escanea el código QR para acceder.'),
              const SizedBox(height: 20),
              Center(
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'PIN: ${pass.code}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('Compartir'),
            onPressed: () {
              Share.share(shareText);
            },
          ),
        ],
      ),
    );
  }
}
