import 'package:flutter/foundation.dart';

class FirebaseService {
  // Puste metody, które nie wywołają błędów kompilacji ani awarii przy braku Firebase
  Future<void> logViewWeather(String cityName) async {
    debugPrint('Firebase mock: Wyświetlono pogodę dla $cityName');
  }

  Future<void> logViewForecast(String cityName) async {
    debugPrint('Firebase mock: Wyświetlono prognozę dla $cityName');
  }

  Future<void> logAddFavorite(String cityName) async {
    debugPrint('Firebase mock: Dodano do ulubionych: $cityName');
  }

  void logCrash(dynamic exception, StackTrace stack) {
    debugPrint('Firebase mock zrzut błędu: $exception');
  }
}