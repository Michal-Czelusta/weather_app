import 'package:weather_app/core/network/dio_client.dart';
import 'package:weather_app/data/models/city_model.dart';
import 'package:weather_app/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> fetchWeather(double lat, double lon);
  Future<List<CityModel>> searchCity(String query);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final DioClient client;
  WeatherRemoteDataSourceImpl(this.client);

  @override
  Future<WeatherModel> fetchWeather(double lat, double lon) async {
    final response = await client.dio.get(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: {
        'latitude': lat,
        'longitude': lon,
        'current': 'temperature_2m,relative_humidity_2m,wind_speed_10m',
        'daily': 'temperature_2m_max,temperature_2m_min',
        'timezone': 'auto'
      },
    );
    return WeatherModel.fromJson(response.data);
  }

  @override
  Future<List<CityModel>> searchCity(String query) async {
    final response = await client.dio.get(
      'https://geocoding-api.open-meteo.com/v1/search',
      queryParameters: {'name': query, 'count': 5, 'format': 'json'},
    );
    final data = response.data['results'] as List?;
    if (data == null) return [];
    return data.map((json) => CityModel.fromJson(json)).toList();
  }
}