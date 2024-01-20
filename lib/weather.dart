
import 'dart:convert';

import 'db.dart';
import 'package:http/http.dart' as http;

Future<WeatherInfo> fetchWeather(String city) async {
  final response = await http.get(Uri.parse("https://goweather.herokuapp.com/weather/$city"));

  final w = WeatherInfo.fromJson(
      city, jsonDecode(response.body) as Map<String, dynamic>);

  await insertWeather(w);

  return w;

}


class WeatherInfo {

  final String id;
  final String temperature;
  final String wind;
  final String description;

  const WeatherInfo({
    required this.id,
    required this.temperature,
    required this.wind,
    required this.description,
  });

  factory WeatherInfo.fromJson(String id, Map<String, dynamic> json) {
    return switch(json) {
      {
      "temperature": String temperature,
      "wind": String wind,
      "description": String description
      } =>
          WeatherInfo(
            id: id,
            temperature: temperature,
            wind: wind,
            description: description,
          ),
      _ =>
      throw const FormatException(
          "Failed to load JSON response for WeatherInfo."),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'temperature': temperature,
      'wind': wind,
      'description': description
    };
  }

  @override
  String toString(){
    return "WeatherInfo(temperature: $temperature, wind: $wind)";
  }
}