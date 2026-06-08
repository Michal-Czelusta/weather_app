import 'package:weather_app/core/errors/failures.dart';
import 'package:weather_app/domain/entities/city.dart';
import 'package:weather_app/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getWeather(double lat, double lon);
  Future<List<City>> searchCities(String query);
}