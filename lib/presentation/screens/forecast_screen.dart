import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/core/services/firebase_service.dart';
import 'package:weather_app/presentation/providers/settings_provider.dart';
import 'package:weather_app/presentation/providers/weather_provider.dart';
import 'package:weather_app/presentation/widgets/forecast_chart.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wp = context.read<WeatherProvider>();
      context.read<FirebaseService>().logViewForecast(wp.selectedCity.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProv = context.watch<WeatherProvider>();
    final settingsProv = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('${weatherProv.selectedCity.name} - 7 Day Forecast')),
      body: weatherProv.state == WeatherState.success && weatherProv.weather != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ForecastChart(
              maxTemps: weatherProv.weather!.maxTemps,
              minTemps: weatherProv.weather!.minTemps,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: weatherProv.weather!.dates.length,
                itemBuilder: (context, idx) {
                  final date = weatherProv.weather!.dates[idx];
                  final maxT = settingsProv.convertTemp(weatherProv.weather!.maxTemps[idx]);
                  final minT = settingsProv.convertTemp(weatherProv.weather!.minTemps[idx]);

                  return ListTile(
                    leading: const Icon(Icons.calendar_today, size: 20),
                    title: Text(date),
                    trailing: Text(
                      '${maxT.toStringAsFixed(0)}° / ${minT.toStringAsFixed(0)}°${settingsProv.unitString}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
          : const Center(child: Text('Load weather context via the main hub.')),
    );
  }
}