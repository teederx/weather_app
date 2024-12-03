// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:weather_app/exceptions/weather_exception.dart';
import 'package:weather_app/models/current_weather/current_weather.dart';
import 'package:weather_app/models/custom_error/custom_error.dart';
import 'package:weather_app/models/direct_geocoding/direct_geocoding.dart';
import 'package:weather_app/services/weather_api_services.dart';

class WeatherRepository {
  final WeatherApiServices weatherApiServices;
  WeatherRepository({
    required this.weatherApiServices,
  });

  Future<CurrentWeather> fetchWeather({required String city}) async {
    try {
      final DirectGeocoding directGeocoding = await weatherApiServices.getDirectGeocoding(city);
      print('directGeocoding: $directGeocoding');
      final CurrentWeather tempWeather = await weatherApiServices.getWeather(directGeocoding);

      final CurrentWeather currentWeather = tempWeather.copyWith(
        name: directGeocoding.name,
        sys: tempWeather.sys.copyWith(country: directGeocoding.country),
      );
      // print('Current Weather: $currentWeather');

      return currentWeather;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(
        errMsg: e.toString(),
      );
    }
  }
}
