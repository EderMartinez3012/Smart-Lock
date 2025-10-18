import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedFilter = 'Todos';

  final Map<String, List<Map<String, dynamic>>> historyData = {
    "Hoy": [
      {
        'user': 'Laura Martínez',
        'action': 'Desbloqueo Manual',
        'time': '10:30 AM',
        'status': 'success',
        'method': 'Huella Digital',
        'avatar': 'L',
        'color': Colors.purple,
      },
      {
        'user': 'Acceso Denegado',
        'action': 'Intento Fallido',
        'time': '09:15 AM',
        'status': 'denied',
        'method': 'Huella No Reconocida',
        'avatar': '!',
        'color': Colors.red,
      },
      {
        'user': 'David García',
        'action': 'Desbloqueo Remoto',
        'time': '08:45 AM',
        'status': 'success',
        'method': 'App Móvil',
        'avatar': 'D',
        'color': Colors.blue,
      },
    ],
    "Ayer": [
      {
        'user': 'David García',
        'action': 'Desbloqueo Remoto',
        'time': '4:20 PM',
        'status': 'success',
        'method': 'App Móvil',
        'avatar': 'D',
        'color': Colors.blue,
      },
      {
        'user': 'Sistema Automático',
        'action': 'Auto-Bloqueo',
        'time': '11:45 AM',
        'status': 'locked',
        'method': 'Temporizador',
        'avatar': 'S',
        'color': Colors.orange,
      },
      {
        'user': 'María López',
        'action': 'Desbloqueo Manual',
        'time': '09:30 AM',
        'status': 'success',
        'method': 'PIN',
        'avatar': 'M',
        'color': Colors.green,
      },
    ],
    "23 Abril": [
      {
        'user': 'Laura Martínez',
        'action': 'Desbloqueo Manual',
        'time': '6:15 PM',
        'status': 'success',
        'method': 'Huella Digital',
        'avatar': 'L',
        'color': Colors.purple,
      },
      {
        'user': 'Acceso Denegado',
        'action': 'Intento Fallido',
        'time': '2:30 PM',
        'status': 'denied',
        'method': 'PIN Incorrecto',
        'avatar': '!',
        'color': Colors.red,
      },
    ],
  };

  List<MapEntry<String, List<Map<String, dynamic>>>> get filteredHistory {
    if (_selectedFilter == 'Todos') {
      return historyData.entries.toList();
    }

    var filtered = <String, List<Map<String, dynamic>>>{};
    historyData.forEach((date, events) {
      var filteredEvents = events.where((event) {
        if (_selectedFilter == 'Éxitos') return event['status'] == 'success';
        if (_selectedFilter == 'Denegados') return event['status'] == 'denied';
        if (_selectedFilter == 'Bloqueados') return event['status'] == 'locked';
        return true;
      }).toList();

      if (filteredEvents.isNotEmpty) {
        filtered[date] = filteredEvents;
      }
    });

    return filtered.entries.toList();
  }

  int get totalEvents {
    return historyData.values.fold(0, (sum, list) => sum + list.length);
  }

  int get successfulEvents {
    return historyData.values.fold(
      0,
      (sum, list) => sum + list.where((e) => e['status'] == 'success').length,
    );
  }

  int get deniedEvents {
    return historyData.values.fold(
      0,
      (sum, list) => sum + list.where((e) => e['status'] == 'denied').length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A8A), Color(0xFFF8FAFC)],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar personalizado
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Historial de Accesos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Estadísticas
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.event_note,
                      value: totalEvents.toString(),
                      label: 'Total',
                      color: Color(0xFF3B82F6),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
                    _buildStatItem(
                      icon: Icons.check_circle,
                      value: successfulEvents.toString(),
                      label: 'Éxitos',
                      color: Colors.green,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
                    _buildStatItem(
                      icon: Icons.cancel,
                      value: deniedEvents.toString(),
                      label: 'Denegados',
                      color: Colors.red,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Filtros
              Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFilterChip('Todos'),
                    SizedBox(width: 8),
                    _buildFilterChip('Éxitos'),
                    SizedBox(width: 8),
                    _buildFilterChip('Denegados'),
                    SizedBox(width: 8),
                    _buildFilterChip('Bloqueados'),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Lista de historial
              Expanded(
                child: filteredHistory.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No hay eventos con este filtro',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredHistory.length,
                        itemBuilder: (context, index) {
                          var entry = filteredHistory[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Encabezado de fecha
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  top: 8,
                                  bottom: 12,
                                ),
                                child: Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                              // Eventos
                              ...entry.value.map((item) {
                                return _buildHistoryCard(item);
                              }),
                              SizedBox(height: 16),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.download, color: Color(0xFF3B82F6)),
                  SizedBox(width: 10),
                  Text('Exportar Historial'),
                ],
              ),
              content: Text(
                '¿Deseas exportar el historial completo en formato PDF?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 12),
                            Text('Historial exportado exitosamente'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  child: Text('Exportar'),
                ),
              ],
            ),
          );
        },
        backgroundColor: Color(0xFF3B82F6),
        icon: Icon(Icons.download),
        label: Text('Exportar'),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: Color(0xFF3B82F6),
      checkmarkColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    IconData iconData;
    Color iconColor;
    Color bgColor;

    switch (item['status']) {
      case 'success':
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.1);
        break;
      case 'denied':
        iconData = Icons.cancel;
        iconColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.1);
        break;
      case 'locked':
        iconData = Icons.lock;
        iconColor = Colors.orange;
        bgColor = Colors.orange.withOpacity(0.1);
        break;
      default:
        iconData = Icons.lock_open;
        iconColor = Colors.blue;
        bgColor = Colors.blue.withOpacity(0.1);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: item['color'],
              radius: 26,
              child: Text(
                item['avatar'],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(iconData, color: iconColor, size: 14),
              ),
            ),
          ],
        ),
        title: Text(
          item['user'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey.shade800,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              item['action'],
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.verified_user,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                SizedBox(width: 4),
                Text(
                  item['method'],
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
            SizedBox(height: 4),
            Text(
              item['time'],
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        onTap: () {
          _showEventDetails(item);
        },
      ),
    );
  }

  void _showEventDetails(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: item['color'],
                  radius: 30,
                  child: Text(
                    item['avatar'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['user'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item['action'],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 16),
            _buildDetailRow(Icons.access_time, 'Hora', item['time']),
            SizedBox(height: 12),
            _buildDetailRow(Icons.verified_user, 'Método', item['method']),
            SizedBox(height: 12),
            _buildDetailRow(
              Icons.info_outline,
              'Estado',
              item['status'] == 'success'
                  ? 'Acceso Exitoso'
                  : item['status'] == 'denied'
                  ? 'Acceso Denegado'
                  : 'Bloqueado',
            ),
            SizedBox(height: 12),
            _buildDetailRow(Icons.location_on, 'Ubicación', 'Puerta Principal'),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.share),
                    label: Text('Compartir'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Evento compartido'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.description),
                    label: Text('Reporte'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3B82F6),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Generando reporte...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
