import 'package:flutter/material.dart';
import 'package:smartlock/ui/widgets/gradient_button.dart';
import 'package:smartlock/ui/widgets/circle_icon_button.dart';
import 'package:smartlock/ui/widgets/section_header.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartlock/ui/home/widget/background_design.dart';
import 'package:flutter_tts/flutter_tts.dart';

class GeofencePage extends StatefulWidget {
  const GeofencePage({super.key});

  @override
  State<GeofencePage> createState() => _GeofencePageState();
}

class _GeofencePageState extends State<GeofencePage> {
  bool _isGeofenceEnabled = false;
  double _radius = 200.0;
  bool _autoUnlock = true;
  bool _autoLock = false;
  LatLng _homeLocation = const LatLng(
    37.422,
    -122.084,
  ); // Ubicación por defecto
  GoogleMapController? _mapController;
  Set<Circle> _circles = {};
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _updateCircle();
    _initTts();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void _initTts() {
    _flutterTts.setLanguage("es-ES");
    _flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _updateCircle() {
    _circles = {
      Circle(
        circleId: const CircleId('geofence_radius'),
        center: _homeLocation,
        radius: _radius,
        fillColor: accentBlue.withOpacity(0.2),
        strokeColor: accentBlue,
        strokeWidth: 2,
      ),
    };
  }

  Future<void> _setHomeToCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Los servicios de ubicación están desactivados.'),
        ),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Los permisos de ubicación fueron denegados.'),
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Los permisos de ubicación están permanentemente denegados, no podemos solicitar permisos.',
          ),
        ),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _homeLocation = LatLng(position.latitude, position.longitude);
      _updateCircle();
      _mapController?.animateCamera(CameraUpdate.newLatLng(_homeLocation));
      _speak('Ubicación del hogar actualizada a tu posición actual.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModernGradientBackground(
        child: SafeArea(
          child: Column(
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
                      'Geofencing',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSettingsCard(
                      children: [
                        SwitchListTile(
                          title: const Text(
                            'Activar Geofencing',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text(
                            'Activa el bloqueo y desbloqueo automático por ubicación.',
                          ),
                          value: _isGeofenceEnabled,
                          activeColor: accentPink,
                          onChanged: (value) {
                            setState(() => _isGeofenceEnabled = value);
                            _speak(
                              'Geofencing ${value ? "activado" : "desactivado"}',
                            );
                          },
                        ),
                      ],
                    ),
                    if (_isGeofenceEnabled) ...[
                      _buildSettingsCard(
                        children: [
                          const SectionHeader(title: 'Ubicación del Hogar'),
                          SizedBox(
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: _homeLocation,
                                  zoom: 15.0,
                                ),
                                circles: _circles,
                                myLocationButtonEnabled: false,
                                myLocationEnabled: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GradientButton(
                            text: 'Establecer Ubicación Actual',
                            icon: Icons.my_location,
                            onPressed: _setHomeToCurrentLocation,
                          ),
                        ],
                      ),
                      _buildSettingsCard(
                        children: [
                          const SectionHeader(
                            title: 'Configuración de Acciones',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'Radio de acción: ${_radius.toInt()} metros',
                            ),
                          ),
                          Slider(
                            value: _radius,
                            min: 50,
                            max: 500,
                            divisions: 9,
                            label: '${_radius.toInt()} m',
                            activeColor: accentPink,
                            onChanged: (value) {
                              setState(() => _radius = value);
                            },
                            onChangeEnd: (value) {
                              _updateCircle();
                              _speak(
                                'Radio de acción ajustado a ${value.toInt()} metros',
                              );
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Auto-Desbloqueo al llegar'),
                            value: _autoUnlock,
                            onChanged: (value) {
                              setState(() => _autoUnlock = value);
                              _speak(
                                'Auto desbloqueo al llegar ${value ? "activado" : "desactivado"}',
                              );
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Auto-Bloqueo al salir'),
                            value: _autoLock,
                            onChanged: (value) {
                              setState(() => _autoLock = value);
                              _speak(
                                'Auto bloqueo al salir ${value ? "activado" : "desactivado"}',
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar Cambios'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        _speak('Configuración guardada');
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Configuración de Geofencing guardada.',
                            ),
                            backgroundColor: Colors.green,
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
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
