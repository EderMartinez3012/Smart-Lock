import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo
    final Map<String, List<Map<String, String>>> historyData = {
      "Hoy": [
        {
          'user': 'Laura',
          'action': 'Manual',
          'time': '10:30 AM',
          'status': 'success',
        },
        {'user': 'Access denied', 'action': '', 'time': '', 'status': 'denied'},
      ],
      "Abril 23": [
        {
          'user': 'David',
          'action': 'Remote',
          'time': '4:20 PM',
          'status': 'success',
        },
        {
          'user': 'Automatic',
          'action': '',
          'time': '11:45 AM',
          'status': 'success',
        },
      ],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Access History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: historyData.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...entry.value.map((item) {
                IconData iconData;
                Color iconColor;

                switch (item['status']) {
                  case 'success':
                    iconData = Icons.check_circle;
                    iconColor = Colors.green;
                    break;
                  case 'denied':
                    iconData = Icons.cancel;
                    iconColor = Colors.red;
                    break;
                  default:
                    iconData = Icons.lock_open;
                    iconColor = Colors.orange;
                }

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: iconColor.withOpacity(0.15),
                      child: Icon(iconData, color: iconColor),
                    ),
                    title: Text(
                      item['user']!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: item['action']!.isNotEmpty
                        ? Text(item['action']!)
                        : null,
                    trailing: Text(
                      item['time']!,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}
