import 'package:weather_app/core/errors/failures.dart';
import 'package:weather_app/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/data/datasources/weather_local_data_source.dart';
import 'package:weather_app/data/models/city_model.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/domain/entities/city.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Weather> getWeather(double lat, double lon) async {
    final cacheKey = '${lat}_${lon}';
    try {
      final remoteWeather = await remoteDataSource.fetchWeather(lat, lon);
      await localDataSource.cacheWeather(cacheKey, remoteWeather.toJson());
      return remoteWeather;
    } catch (e) {
      final cachedData = localDataSource.getCachedWeather(cacheKey);
      if (cachedData != null) {
        return WeatherModel.fromJson(cachedData);
      }
      throw ServerFailure("Network execution failed and no offline cached assets match.");
    }
  }

  @override
  Future<List<City>> searchCities(String query) async {
    try {
      return await remoteDataSource.searchCity(query);
    } catch (e) {
      throw ServerFailure("Unable to parse remote address results.");
    }
  }
}