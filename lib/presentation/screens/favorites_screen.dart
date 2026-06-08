import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/presentation/providers/favorites_provider.dart';
import 'package:weather_app/presentation/providers/weather_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProv = context.watch<FavoritesProvider>();
    final weatherProv = context.read<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Cities')),
      body: favProv.favorites.isEmpty
          ? const Center(child: Text('No bookmarked parameters saved yet.'))
          : ListView.builder(
        itemCount: favProv.favorites.length,
        itemBuilder: (context, index) {
          final city = favProv.favorites[index];
          return ListTile(
            title: Text(city.name),
            subtitle: Text(city.country),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => favProv.toggleFavorite(city),
            ),
            onTap: () {
              weatherProv.selectCity(city);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Switched to ${city.name}')),
              );
            },
          );
        },
      ),
    );
  }
}