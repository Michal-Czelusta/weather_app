import 'package:hive/hive.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheWeather(String key, Map<String, dynamic> weatherJson);
  Map<String, dynamic>? getCachedWeather(String key);
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final Box _box = Hive.box('weather_cache');

  @override
  Future<void> cacheWeather(String key, Map<String, dynamic> weatherJson) async {
    await _box.put(key, weatherJson);
  }

  @override
  Map<String, dynamic>? getCachedWeather(String key) {
    final data = _box.get(key);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }
}