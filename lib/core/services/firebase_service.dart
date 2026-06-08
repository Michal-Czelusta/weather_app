import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logViewWeather(String cityName) async {
    await _analytics.logEvent(name: 'view_weather', parameters: {'city': cityName});
  }

  Future<void> logViewForecast(String cityName) async {
    await _analytics.logEvent(name: 'view_forecast', parameters: {'city': cityName});
  }

  Future<void> logAddFavorite(String cityName) async {
    await _analytics.logEvent(name: 'add_favorite_city', parameters: {'city': cityName});
  }

  void logCrash(dynamic exception, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(exception, stack, fatal: true);
  }
}