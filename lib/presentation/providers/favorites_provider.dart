import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/core/services/firebase_service.dart';
import 'package:weather_app/data/models/city_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final Box<CityModel> _box = Hive.box<CityModel>('favorites');
  final FirebaseService _firebaseService;

  FavoritesProvider(this._firebaseService);

  List<CityModel> get favorites => _box.values.toList();

  void toggleFavorite(CityModel city) {
    final key = city.name;
    if (_box.containsKey(key)) {
      _box.delete(key);
    } else {
      _box.put(key, city);
      _firebaseService.logAddFavorite(city.name);
    }
    notifyListeners();
  }

  bool isFavorite(String cityName) => _box.containsKey(cityName);
}