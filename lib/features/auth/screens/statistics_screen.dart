import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = {
      'May 3': 2,
      'May 4': 1,
      'May 5': 1,
      'May 6': 6,
      'May 7': 2,
      'May 8': 1,
      'May 9': 2,
      'May 11': 1,
      'May 12': 2,
      'May 15': 1,
    };

    final barGroups = <BarChartGroupData>[];
    int x = 0;
    data.forEach((date, count) {
      barGroups.add(
        BarChartGroupData(
          x: x++,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: const Color.fromARGB(255, 4, 26, 134),
              width: 16,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
      );
    });

    final labels = data.keys.toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: const Color.fromARGB(255, 4, 26, 134),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              'User Registrations by Date',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      barGroups: barGroups,
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              return index >= 0 && index < labels.length
                                  ? SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        labels[index],
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    )
                                  : const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            interval: 1,
                          ),
                        ),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: true),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
