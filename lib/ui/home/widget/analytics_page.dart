import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smartlock/ui/home/widget/background_design.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  // Datos de ejemplo para los gráficos
  final Map<String, int> usageByUser = {
    'Laura M.': 5,
    'David G.': 8,
    'María L.': 3,
    'Sistema': 1,
  };

  final Map<int, int> usageByHour = {8: 1, 9: 2, 10: 1, 11: 1, 16: 1, 18: 1};

  final int successfulEvents = 15;
  final int deniedEvents = 4;

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
                      'Análisis de Uso',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido de la página
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSummaryCard(),
                    const SizedBox(height: 20),
                    _buildChartCard(
                      title: 'Actividad por Hora',
                      icon: Icons.bar_chart,
                      child: _buildBarChart(),
                    ),
                    const SizedBox(height: 20),
                    _buildChartCard(
                      title: 'Uso por Usuario',
                      icon: Icons.pie_chart,
                      child: _buildPieChart(),
                    ),
                    const SizedBox(height: 20),
                    _buildChartCard(
                      title: 'Accesos Exitosos vs. Fallidos',
                      icon: Icons.donut_large,
                      child: _buildDonutChart(),
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

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatCard(
            icon: Icons.person_pin,
            value: 'David G.',
            label: 'Más Activo',
            color: accentBlue,
          ),
          StatCard(
            icon: Icons.access_time_filled,
            value: '9 AM',
            label: 'Hora Pico',
            color: accentPink,
          ),
          StatCard(
            icon: Icons.lock_open,
            value: '23',
            label: 'Total Semana',
            color: accentRed,
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryBlue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(height: 200, child: child),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: usageByHour.values.reduce((a, b) => a > b ? a : b).toDouble() + 2,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '${value.toInt()}h',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(24, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: usageByHour[index]?.toDouble() ?? 0,
                color: accentBlue,
                width: 12,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPieChart() {
    final List<Color> colors = [
      accentBlue,
      accentPink,
      accentRed,
      Colors.orange,
      Colors.purple,
    ];
    int colorIndex = 0;

    return PieChart(
      PieChartData(
        sections: usageByUser.entries.map((entry) {
          final color = colors[colorIndex++ % colors.length];
          return PieChartSectionData(
            color: color,
            value: entry.value.toDouble(),
            title: '${entry.value}',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black, blurRadius: 2)],
            ),
          );
        }).toList(),
        sectionsSpace: 4,
        centerSpaceRadius: 40,
        pieTouchData: PieTouchData(
          touchCallback: (event, pieTouchResponse) {
            // Puedes añadir interactividad aquí
          },
        ),
      ),
    );
  }

  Widget _buildDonutChart() {
    final total = successfulEvents + deniedEvents;
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: Colors.green,
            value: successfulEvents.toDouble(),
            title: '${(successfulEvents / total * 100).toStringAsFixed(0)}%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Colors.red,
            value: deniedEvents.toDouble(),
            title: '${(deniedEvents / total * 100).toStringAsFixed(0)}%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 50,
        pieTouchData: PieTouchData(
          touchCallback: (event, pieTouchResponse) {
            // Puedes añadir interactividad aquí
          },
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.15),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
