import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/presentation/providers/favorites_provider.dart';
import 'package:weather_app/presentation/providers/settings_provider.dart';
import 'package:weather_app/presentation/providers/weather_provider.dart';
import 'package:weather_app/presentation/widgets/weather_error_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProv = context.watch<WeatherProvider>();
    final favProv = context.watch<FavoritesProvider>();
    final settingsProv = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(weatherProv.selectedCity.name),
        actions: [
          IconButton(
            icon: Icon(favProv.isFavorite(weatherProv.selectedCity.name) ? Icons.favorite : Icons.favorite_border, color: Colors.red),
            onPressed: () => favProv.toggleFavorite(weatherProv.selectedCity),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SearchBar(
              controller: _searchController,
              hintText: "Search cities...",
              leading: const Icon(Icons.search),
              onChanged: (val) => weatherProv.searchCities(val),
            ),
          ),
          if (weatherProv.searchResults.isNotEmpty)
            Container(
              height: 200,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: ListView.builder(
                itemCount: weatherProv.searchResults.length,
                itemBuilder: (context, idx) {
                  final city = weatherProv.searchResults[idx];
                  return ListTile(
                    title: Text('${city.name}, ${city.country}'),
                    onTap: () {
                      _searchController.clear();
                      weatherProv.selectCity(city);
                    },
                  );
                },
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => weatherProv.fetchWeather(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  if (weatherProv.state == WeatherState.loading)
                    const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()))
                  else if (weatherProv.state == WeatherState.error)
                    WeatherErrorWidget(message: weatherProv.errorMessage, onRetry: () => weatherProv.fetchWeather())
                  else if (weatherProv.state == WeatherState.success && weatherProv.weather != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${settingsProv.convertTemp(weatherProv.weather!.temperature).toStringAsFixed(1)}${settingsProv.unitString}',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 24),
                            Card(
                              elevation: 0,
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        const Icon(Icons.water_drop, color: Colors.blue),
                                        const SizedBox(height: 8),
                                        Text('Humidity', style: Theme.of(context).textTheme.bodySmall),
                                        Text('${weatherProv.weather!.humidity}%', style: Theme.of(context).textTheme.bodyLarge),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Icon(Icons.air, color: Colors.teal),
                                        const SizedBox(height: 8),
                                        Text('Wind', style: Theme.of(context).textTheme.bodySmall),
                                        Text('${weatherProv.weather!.windSpeed} km/h', style: Theme.of(context).textTheme.bodyLarge),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}