import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/presentation/providers/settings_provider.dart';

class ForecastChart extends StatelessWidget {
  final List<double> maxTemps;
  final List<double> minTemps;

  const ForecastChart({super.key, required this.maxTemps, required this.minTemps});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    List<FlSpot> maxSpots = [];
    List<FlSpot> minSpots = [];

    for (int i = 0; i < maxTemps.length; i++) {
      maxSpots.add(FlSpot(i.toDouble(), settings.convertTemp(maxTemps[i])));
      minSpots.add(FlSpot(i.toDouble(), settings.convertTemp(minTemps[i])));
    }

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(spots: maxSpots, isCurved: true, color: Colors.orange, barWidth: 3, dotData: const FlDotData(show: true)),
            LineChartBarData(spots: minSpots, isCurved: true, color: Colors.blue, barWidth: 3, dotData: const FlDotData(show: true)),
          ],
        ),
      ),
    );
  }
}