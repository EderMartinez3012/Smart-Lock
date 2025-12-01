import 'package:flutter/material.dart';
import 'package:smartlock/ui/widgets/gradient_button.dart';
import 'package:smartlock/ui/widgets/circle_icon_button.dart';
import 'package:smartlock/ui/home/widget/background_design.dart';

class TimeRange {
  TimeOfDay start;
  TimeOfDay end;

  TimeRange({required this.start, required this.end});
}

class ScheduledAccessPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const ScheduledAccessPage({super.key, required this.user});

  @override
  State<ScheduledAccessPage> createState() => _ScheduledAccessPageState();
}

class _ScheduledAccessPageState extends State<ScheduledAccessPage> {
  late bool _isScheduleEnabled;
  late Map<int, List<TimeRange>> _schedule;
  final List<String> _daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  @override
  void initState() {
    super.initState();
    // Inicializa el horario desde los datos del usuario o crea uno nuevo si no existe
    _isScheduleEnabled = widget.user['schedule_enabled'] ?? false;
    _schedule = Map<int, List<TimeRange>>.from(
      (widget.user['schedule'] as Map? ?? {}).map(
        (key, value) => MapEntry(
          int.parse(key.toString()),
          (value as List)
              .map(
                (e) => TimeRange(
                  start: TimeOfDay(
                    hour: e['start_hour'],
                    minute: e['start_minute'],
                  ),
                  end: TimeOfDay(hour: e['end_hour'], minute: e['end_minute']),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getRangesForDay(int day) {
    if (!_schedule.containsKey(day) || _schedule[day]!.isEmpty) {
      return 'Sin acceso';
    }
    return _schedule[day]!
        .map(
          (range) => '${_formatTime(range.start)} - ${_formatTime(range.end)}',
        )
        .join(', ');
  }

  Future<void> _editDaySchedule(int day) async {
    List<TimeRange> currentRanges = List<TimeRange>.from(_schedule[day] ?? []);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Horario para ${_daysOfWeek[day - 1]}'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ...currentRanges.map((range) {
                      return ListTile(
                        title: Text(
                          '${_formatTime(range.start)} - ${_formatTime(range.end)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setDialogState(() => currentRanges.remove(range));
                          },
                        ),
                      );
                    }).toList(),
                    TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Añadir franja horaria'),
                      onPressed: () async {
                        final TimeOfDay? start = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (start == null) return;
                        final TimeOfDay? end = await showTimePicker(
                          context: context,
                          initialTime: start,
                        );
                        if (end == null) return;
                        setDialogState(
                          () => currentRanges.add(
                            TimeRange(start: start, end: end),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _schedule[day] = currentRanges;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _applyToAll(int sourceDay) {
    final sourceRanges = _schedule[sourceDay] ?? [];
    setState(() {
      for (int i = 1; i <= 7; i++) {
        _schedule[i] = List<TimeRange>.from(sourceRanges);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Horario copiado a todos los días.')),
    );
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Horario de Acceso',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.user['name'],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
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
                            'Activar Horario Programado',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text(
                            'El usuario solo podrá acceder en las horas definidas.',
                          ),
                          value: _isScheduleEnabled,
                          activeColor: accentPink,
                          onChanged: (value) =>
                              setState(() => _isScheduleEnabled = value),
                        ),
                      ],
                    ),
                    if (_isScheduleEnabled)
                      _buildSettingsCard(
                        children: List.generate(7, (index) {
                          final day = index + 1;
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  _daysOfWeek[index],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  _getRangesForDay(day),
                                  style: TextStyle(
                                    color: _getRangesForDay(day) == 'Sin acceso'
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.copy_all,
                                        color: accentBlue,
                                        size: 20,
                                      ),
                                      tooltip: 'Aplicar a todos los días',
                                      onPressed: () => _applyToAll(day),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () => _editDaySchedule(day),
                                    ),
                                  ],
                                ),
                              ),
                              if (index < 6)
                                const Divider(
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                            ],
                          );
                        }),
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Aquí guardarías los cambios en tu base de datos
          widget.user['schedule_enabled'] = _isScheduleEnabled;
          widget.user['schedule'] = _schedule.map(
            (key, value) => MapEntry(
              key.toString(),
              value
                  .map(
                    (e) => {
                      'start_hour': e.start.hour,
                      'start_minute': e.start.minute,
                      'end_hour': e.end.hour,
                      'end_minute': e.end.minute,
                    },
                  )
                  .toList(),
            ),
          );
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Horario guardado correctamente.'),
              backgroundColor: Colors.green,
            ),
          );
        },
        icon: const Icon(Icons.save),
        label: const Text('Guardar Cambios'),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
