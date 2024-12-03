import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/models/current_weather/current_weather.dart';

part 'app_weather.freezed.dart';

@freezed
class AppWeather with _$AppWeather {
  const factory AppWeather({
    required String name,
    required String country,
    required double temp,
    required double tempMin,
    required double tempMax,
    required String description,
    required String icon,
  }) = _AppWeather;

  factory AppWeather.fromCurrentWeather(CurrentWeather currentWeather) {
    return AppWeather(
      name: currentWeather.name,
      country: currentWeather.sys.country,
      temp: currentWeather.main.temp,
      tempMin: currentWeather.main.tempMin,
      tempMax: currentWeather.main.tempMax,
      description: currentWeather.weather[0].description,
      icon: currentWeather.weather[0].icon,
    );
  }
}
