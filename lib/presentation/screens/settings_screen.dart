import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/presentation/providers/settings_provider.dart';
import 'package:weather_app/presentation/providers/weather_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProv = context.watch<SettingsProvider>();
    final weatherProv = context.read<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Temperature Imperial (Fahrenheit)'),
            subtitle: const Text('Toggle between Metric (°C) and Imperial (°F) views'),
            value: !settingsProv.isCelsius,
            onChanged: (_) => settingsProv.toggleTemperatureUnit(),
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Force Global Invalidation'),
            subtitle: const Text('Evict matching caches and refresh endpoints'),
            onTap: () async {
              await weatherProv.fetchWeather();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Database invalidated and refreshed.')));
              }
            },
          )
        ],
      ),
    );
  }
}