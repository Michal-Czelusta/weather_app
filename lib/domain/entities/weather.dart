class Weather {
  final double temperature;
  final double humidity;
  final double windSpeed;
  final List<String> dates;
  final List<double> maxTemps;
  final List<double> minTemps;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.dates,
    required this.maxTemps,
    required this.minTemps,
  });
}