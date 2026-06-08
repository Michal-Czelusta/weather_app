import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsProvider extends ChangeNotifier {
  final Box _box = Hive.box('settings');
  bool _isCelsius = true;

  bool get isCelsius => _isCelsius;

  SettingsProvider() {
    _isCelsius = _box.get('isCelsius', defaultValue: true);
  }

  void toggleTemperatureUnit() {
    _isCelsius = !_isCelsius;
    _box.put('isCelsius', _isCelsius);
    notifyListeners();
  }

  double convertTemp(double celsius) {
    if (_isCelsius) return celsius;
    return (celsius * 9 / 5) + 32;
  }

  String get unitString => _isCelsius ? "°C" : "°F";
}