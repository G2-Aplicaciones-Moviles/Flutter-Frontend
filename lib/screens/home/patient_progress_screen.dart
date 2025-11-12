import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PatientProgressScreen extends StatelessWidget {
  final String name;
  const PatientProgressScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final weeklyProgress = [70.0, 55.0, 40.0, 60.0, 50.0, 65.0, 45.0];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Progreso'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: .5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 24, backgroundColor: Colors.grey),
                const SizedBox(width: 12),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              'Estadísticas de Alimentación',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const Text('Promedio de rendimiento de esta semana',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statCard('Calorías Cons.', '1500', '+200'),
                _statCard('Proteínas', '80g', '+10g'),
                _statCard('Grasas', '50g', '-5g'),
              ],
            ),

            const SizedBox(height: 24),
            const Text('Progreso Semanal',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),

            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  barGroups: weeklyProgress
                      .map(
                        (v) => BarChartGroupData(
                      x: weeklyProgress.indexOf(v),
                      barRods: [
                        BarChartRodData(toY: v, color: Colors.green, width: 14),
                      ],
                    ),
                  )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Días sin Registro',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _missingDay('Lunes', 'No se registró consumo.'),
            _missingDay('Miércoles', 'No se registró consumo.'),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, String diff) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 2),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 2),
          Text(diff, style: const TextStyle(color: Colors.green, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _missingDay(String day, String message) {
    return ListTile(
      leading: const Icon(Icons.close, color: Colors.red),
      title: Text(day),
      subtitle: Text(message),
    );
  }
}
