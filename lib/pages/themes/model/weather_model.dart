// To parse this JSON data, do
//
//     final weatherModel = weatherModelFromJson(jsonString);

import 'dart:convert';

WeatherModel weatherModelFromJson(String str) =>
    WeatherModel.fromJson(json.decode(str));

String weatherModelToJson(WeatherModel data) => json.encode(data.toJson());

class WeatherModel {
  WeatherModel({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.timezone,
    this.timezoneAbbreviation,
    this.currentWeatherUnits,
    this.currentWeather,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        generationtimeMs: json["generationtime_ms"]?.toDouble(),
        timezone: json["timezone"],
        timezoneAbbreviation: json["timezone_abbreviation"],
        currentWeatherUnits: json["current_weather_units"] == null
            ? null
            : CurrentWeatherUnits.fromJson(json["current_weather_units"]),
        currentWeather: json["current_weather"] == null
            ? null
            : CurrentWeather.fromJson(json["current_weather"]),
      );
  double? latitude;
  double? longitude;
  double? generationtimeMs;
  String? timezone;
  String? timezoneAbbreviation;
  CurrentWeatherUnits? currentWeatherUnits;
  CurrentWeather? currentWeather;

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "generationtime_ms": generationtimeMs,
        "timezone": timezone,
        "timezone_abbreviation": timezoneAbbreviation,
        "current_weather_units": currentWeatherUnits?.toJson(),
        "current_weather": currentWeather?.toJson(),
      };
}

class CurrentWeather {
  CurrentWeather({
    this.time,
    this.interval,
    this.temperature,
    this.windspeed,
    this.winddirection,
    this.isDay,
    this.weathercode,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
        time: json["time"],
        interval: json["interval"],
        temperature: json["temperature"]?.toDouble(),
        windspeed: json["windspeed"]?.toDouble(),
        winddirection: json["winddirection"],
        isDay: json["is_day"],
        weathercode: json["weathercode"],
      );
  String? time;
  int? interval;
  double? temperature;
  double? windspeed;
  int? winddirection;
  int? isDay;
  int? weathercode;

  Map<String, dynamic> toJson() => {
        "time": time,
        "interval": interval,
        "temperature": temperature,
        "windspeed": windspeed,
        "winddirection": winddirection,
        "is_day": isDay,
        "weathercode": weathercode,
      };
}

class CurrentWeatherUnits {
  CurrentWeatherUnits({
    this.time,
    this.interval,
    this.temperature,
    this.windspeed,
    this.winddirection,
    this.isDay,
    this.weathercode,
  });

  factory CurrentWeatherUnits.fromJson(Map<String, dynamic> json) =>
      CurrentWeatherUnits(
        time: json["time"],
        interval: json["interval"],
        temperature: json["temperature"],
        windspeed: json["windspeed"],
        winddirection: json["winddirection"],
        isDay: json["is_day"],
        weathercode: json["weathercode"],
      );
  String? time;
  String? interval;
  String? temperature;
  String? windspeed;
  String? winddirection;
  String? isDay;
  String? weathercode;

  Map<String, dynamic> toJson() => {
        "time": time,
        "interval": interval,
        "temperature": temperature,
        "windspeed": windspeed,
        "winddirection": winddirection,
        "is_day": isDay,
        "weathercode": weathercode,
      };
}
