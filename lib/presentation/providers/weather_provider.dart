import 'package:flutter/material.dart';
import 'package:weather_app/core/services/firebase_service.dart';
import 'package:weather_app/data/models/city_model.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';

enum WeatherState { initial, loading, success, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository repository;
  final FirebaseService firebaseService;

  WeatherProvider({required this.repository, required this.firebaseService});

  WeatherState _state = WeatherState.initial;
  WeatherState get state => _state;

  Weather? _weather;
  Weather? get weather => _weather;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  CityModel _selectedCity = CityModel(name: 'London', latitude: 51.5085, longitude: -0.1257, country: 'GB');
  CityModel get selectedCity => _selectedCity;

  List<CityModel> _searchResults = [];
  List<CityModel> get searchResults => _searchResults;

  Future<void> fetchWeather() async {
    _state = WeatherState.loading;
    notifyListeners();
    try {
      _weather = await repository.getWeather(_selectedCity.latitude, _selectedCity.longitude);
      _state = WeatherState.success;
      firebaseService.logViewWeather(_selectedCity.name);
    } catch (e, stack) {
      _state = WeatherState.error;
      _errorMessage = e.toString();
      firebaseService.logCrash(e, stack);
    }
    notifyListeners();
  }

  Future<void> searchCities(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    try {
      final cities = await repository.searchCities(query);
      _searchResults = cities.map((c) => c as CityModel).toList();
      notifyListeners();
    } catch (_) {}
  }

  void selectCity(CityModel city) {
    _selectedCity = city;
    _searchResults = [];
    fetchWeather();
  }
}