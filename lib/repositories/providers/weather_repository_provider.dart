import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/services/providers/weather_api_services_provider.dart';

part 'weather_repository_provider.g.dart';

@riverpod
WeatherRepository weatherRepository(Ref ref) {
  return WeatherRepository(
    weatherApiServices: ref.watch(weatherApiServicesProvider),
  );
}
