import 'package:weather_app/domain/entities/weather.dart';

class WeatherModel extends Weather {
  WeatherModel({
    required super.temperature,
    required super.humidity,
    required super.windSpeed,
    required super.dates,
    required super.maxTemps,
    required super.minTemps,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] ?? {};
    final daily = json['daily'] ?? {};
    return WeatherModel(
      temperature: (current['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      humidity: (current['relative_humidity_2m'] as num?)?.toDouble() ?? 0.0,
      windSpeed: (current['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      dates: List<String>.from(daily['time'] ?? []),
      maxTemps: List<double>.from((daily['temperature_2m_max'] as List?)?.map((e) => (e as num).toDouble()) ?? []),
      minTemps: List<double>.from((daily['temperature_2m_min'] as List?)?.map((e) => (e as num).toDouble()) ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'current': {
      'temperature_2m': temperature,
      'relative_humidity_2m': humidity,
      'wind_speed_10m': windSpeed,
    },
    'daily': {
      'time': dates,
      'temperature_2m_max': maxTemps,
      'temperature_2m_min': minTemps,
    }
  };
}