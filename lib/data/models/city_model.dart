import 'package:hive/hive.dart';
import 'package:weather_app/domain/entities/city.dart';

class CityModel extends City {
  CityModel({required super.name, required super.latitude, required super.longitude, required super.country});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'country': country,
  };
}

// Manual Hive Adapter to guarantee error-free step-by-step compilation without build_runner dependencies
class CityModelAdapter extends TypeAdapter<CityModel> {
  @override
  final int typeId = 0;

  @override
  CityModel read(BinaryReader reader) {
    return CityModel(
      name: reader.readString(),
      latitude: reader.readDouble(),
      longitude: reader.readDouble(),
      country: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, CityModel obj) {
    writer.writeString(obj.name);
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longitude);
    writer.writeString(obj.country);
  }
}