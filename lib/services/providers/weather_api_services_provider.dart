import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app/services/providers/dio_provider.dart';

import '../weather_api_services.dart';

part 'weather_api_services_provider.g.dart';

@riverpod
WeatherApiServices weatherApiServices(Ref ref) {
  return WeatherApiServices(
    dio: ref.watch(dioProvider),
  );
}
