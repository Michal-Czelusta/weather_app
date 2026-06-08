import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/network/dio_client.dart';
import 'core/services/firebase_service.dart';
import 'data/datasources/remote_data_source.dart';
import 'data/datasources/weather_local_data_source.dart';
import 'data/models/city_model.dart';
import 'data/repositories/weather_repository_impl.dart';
import 'presentation/providers/favorites_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/weather_provider.dart';
import 'presentation/screens/main_navigation_screen.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Firebase Initialization
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Local Storage System
    await Hive.initFlutter();
    Hive.registerAdapter(CityModelAdapter());
    await Hive.openBox('weather_cache');
    await Hive.openBox('settings');
    await Hive.openBox<CityModel>('favorites');

    // Architecture Engine Assembly
    final dioClient = DioClient();
    final remoteDS = WeatherRemoteDataSourceImpl(dioClient);
    final localDS = WeatherLocalDataSourceImpl();
    final repository = WeatherRepositoryImpl(remoteDataSource: remoteDS, localDataSource: localDS);
    final firebaseService = FirebaseService();

    runApp(
      MultiProvider(
        providers: [
          Provider<FirebaseService>.value(value: firebaseService),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider(firebaseService)),
          ChangeNotifierProvider(
            create: (_) => WeatherProvider(repository: repository, firebaseService: firebaseService),
          ),
        ],
        child: const WeatherApp(),
      ),
    );
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherApp',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
      ),
      home: const MainNavigationScreen(),
    );
  }
}